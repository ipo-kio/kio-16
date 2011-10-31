/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 21.02.11
 * Time: 1:42
 */
package ru.ipo.kio._11.digit {
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class Gate extends Sprite implements Out {

    private var _wires:Array; //Wire
    private var _connectors:Array = []; //Connector
    private var _in_connectors:Array; //Connector
    private var _arity:int;
    private var _type:int;

    private var _mouse_over:Boolean;
    private var _on_bmp:BitmapData;
    private var _off_bmp:BitmapData;

    private var _function:Function;

    private static const VAL_0:int = 0;
    private static const VAL_1:int = 1;
    private static const VAL_UNCONNECTED:int = 2;
    private static const VAL_UNKNOWN:int = 3;
    private static const VAL_EVALUATING:int = 4;
    private static const VAL_CYCLE:int = 5;

    private var _value:int = VAL_UNKNOWN;

    //noinspection JSMismatchedCollectionQueryUpdateInspection
    private var _yOffset:Array;
    private static const X_INPUT_OFFSET:int = 5;
    private static const X_OUTPUT_OFFSET:int = 0;

    private var _is_new:Boolean = false;
    private var _movable:Boolean = true;
    private var _new_x0:Number;
    private var _new_y0:Number;
    private var _turned_on:Boolean = false;

    public function Gate(type:int, arity:int, f:Function, off:BitmapData, on:BitmapData, yOffsets:Array) {
        _type = type;
        _on_bmp = on;
        _off_bmp = off;
        _function = f;
        _arity = arity;
        _yOffset = yOffsets;

        addEventListener(MouseEvent.ROLL_OVER, mouseRollOver);
        addEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);

        _wires = new Array(arity);
        _in_connectors = new Array(arity);

        for (var i:int = 0; i < arity; i++) {
            _wires[i] = new Wire();
            _in_connectors[i] = new Connector(_wires[i]);
        }

        redraw();
    }

    private function mouseRollOver(event:Event):void {
        mouse_over = true;
    }

    private function mouseRollOut(event:Event):void {
        mouse_over = false;
    }

    private function mouseDown(event:Event):void {
        if (!_movable)
            return;

        Globals.instance.drag_object = this;

        if (_is_new) {
            _new_x0 = x;
            _new_y0 = y;
            Globals.instance.drag_type = Globals.DRAG_TYPE_NEW_GATE;
            startDrag();
        } else {
            Globals.instance.drag_type = Globals.DRAG_TYPE_GATE;
            startDrag(false/*, new Rectangle(0, 0, Field.WIDTH - width, Field.HEIGHT - height)*/);
        }
    }

    public function get mouse_over():Boolean {
        return _mouse_over;
    }

    public function set mouse_over(value:Boolean):void {
        if (_mouse_over == value)
            return;
        _mouse_over = value;
        redraw();
    }

    private function redraw():void {
        graphics.clear();
        var bitmap:BitmapData = _mouse_over && _movable || _turned_on ? _on_bmp : _off_bmp;
        graphics.beginBitmapFill(bitmap);
//        graphics.lineStyle(0, 0, 0);
        graphics.drawRect(0, 0, bitmap.width, bitmap.height);
        graphics.endFill();
    }

    public function get connectors():Array {
        return _connectors;
    }

    public function get value():int {
        if (_value != VAL_UNKNOWN)
            return _value;

        _value = VAL_EVALUATING;

        var vals:Array = new Array(_arity);

        for (var i:int = 0; i < _arity; i++) {
            var v:int = VAL_UNCONNECTED;
            var dest:Out = Connector(_in_connectors[i]).dest;
            if (dest)
                v = dest.value;
            if (v == VAL_EVALUATING || v == VAL_CYCLE) {
                _value = VAL_CYCLE;
                return _value;
            } else if (v == VAL_UNCONNECTED) {
                _value = VAL_UNCONNECTED;
                return _value;
            }

            vals[i] = v;
        }

        if (_arity == 1)
            _value = _function(vals[0]);
        else // if arity = 2
            _value = _function(vals[0], vals[1]);
        return _value;
    }


    public function resetValue():void {
        _value = VAL_UNKNOWN;
    }

    public function addTo(wires_layer:DisplayObjectContainer, gates_layer:Sprite, connections_layer:Sprite):void {
        for each (var wire:Wire in _wires)
            wire.addTo(wires_layer);

        for each (var con:Connector in _in_connectors)
            connections_layer.addChild(con);

        gates_layer.addChild(this);

        positionSubElements();
        for each (con in _in_connectors)
            con.moveToBasePosition();
    }

    public function removeFromDisplay():void {
        for each (var wire:Wire in _wires)
            wire.removeFromDisplay();

        for each (var con:Connector in _in_connectors)
            con.parent.removeChild(con);

        parent.removeChild(this);
    }

    public function positionSubElements(translate_wires:Boolean = true):void {

        for (var i:int = 0; i < _arity; i++) {
            var old_finish:Point = _wires[i].finish;
            var new_finish:Point = new Point(x + X_INPUT_OFFSET, y + _yOffset[i]);
            _wires[i].finish = new_finish;

            if (! _in_connectors[i].dest) {
                var nx:Number = _in_connectors[i].x + new_finish.x - old_finish.x;
                var ny:Number = _in_connectors[i].y + new_finish.y - old_finish.y;

                if (!translate_wires) {
                    nx = _in_connectors[i].x;
                    ny = _in_connectors[i].y;
                }

                if (!_is_new) {
                    if (nx < 0)
                        nx = 0;
                    if (ny < 0)
                        ny = 0;
                    if (nx >= Field.WIDTH)
                        nx = Field.WIDTH - 1;
                    if (ny >= Field.HEIGHT)
                        ny = Field.HEIGHT - 1;
                }

                _in_connectors[i].x = nx;
                _in_connectors[i].y = ny;
            }

            _in_connectors[i].positionSubElements();
        }

        for each (var con:Connector in _connectors) {
            con.x = x + _on_bmp.width + X_OUTPUT_OFFSET;
            con.y = y + Math.floor(_on_bmp.height / 2);
            con.positionSubElements();
        }

    }

    public function get is_new():Boolean {
        return _is_new;
    }

    public function set is_new(value:Boolean):void {
        _is_new = value;
        for each (var c:Connector in _in_connectors) {
            c.movable = !is_new;
            c.wire.selectable = !is_new;
        }
    }

    public function moveBackThisNewGate():void {
        x = _new_x0;
        y = _new_y0;
        positionSubElements();
    }


    public function get type():int {
        return _type;
    }

    public function bindConnector(c:Connector):void {
        c.dest = this;
        positionSubElements();
    }

    public function get in_connectors():Array {
        return _in_connectors;
    }

    public function get movable():Boolean {
        return _movable;
    }

    public function set movable(value:Boolean):void {
        _movable = value;
    }

    public function get serialization():Object {
        var o:Object = {
            x: x,
            y: y,
            con: new Array(_arity),
            type:type
        };

        for (var i:int = 0; i < _arity; i++) {
            var c:Connector = _in_connectors[i];
            o.con[i] = {
                x:c.x,
                y:c.y,
                g_dest: c.dest ? Globals.instance.workspace.field.gates.indexOf(c.dest) : -1,
                i_dest: c.dest ? Globals.instance.workspace.field.inputs.indexOf(c.dest) : -1
            }
        }

        return o;
    }

    public function set serialization(o:Object):void {
        x = o.x;
        y = o.y;
        for (var i:int = 0; i < _arity; i++) {
            var c:Connector = _in_connectors[i];
            var oc:Object = o.con[i];
            c.x = oc.x;
            c.y = oc.y;

            if (oc.g_dest >= 0)
                c.dest = Globals.instance.workspace.field.gates[oc.g_dest];
            else if (oc.i_dest >= 0)
                c.dest = Globals.instance.workspace.field.inputs[oc.i_dest];
            else
                c.dest = null;
        }

        positionSubElements(false);
    }

    public function get turned_on():Boolean {
        return _turned_on;
    }

    public function set turned_on(value:Boolean):void {
        if (value == _turned_on)
            return;
        _turned_on = value;
        redraw();
    }
}
}
