/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 21.02.11
 * Time: 2:13
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.digit {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class Connector extends Sprite {

    [Embed(source="resources/Connector_01.png")]
    public static const OFF_IMAGE:Class;
    public static const OffImage:BitmapData = new OFF_IMAGE().bitmapData;

    [Embed(source="resources/Connector_02.png")]
    public static const ON_IMAGE:Class;
    public static const OnImage:BitmapData = new ON_IMAGE().bitmapData;

    [Embed(source="resources/Connector_03.png")]
    public static const OFF_CON_IMAGE:Class;
    public static const OffConImage:BitmapData = new OFF_CON_IMAGE().bitmapData;

    [Embed(source="resources/Connector_04.png")]
    public static const ON_CON_IMAGE:Class;
    public static const OnConImage:BitmapData = new ON_CON_IMAGE().bitmapData;

    private var _on:Boolean;
    private var _dest:Out;
    private var _wire:Wire;
    private var w:int;
    private var w2:int;
    private var h:int;
    private var h2:int;
    private var translateMatrix:Matrix;
    private var _movable:Boolean = true;

    public static const BASE_LENGTH:int = 26;

    public function get on():Boolean {
        return _on;
    }

    public function set on(value:Boolean):void {
        if (_on == value)
            return;
        _on = value;
        redraw();
    }

    public function Connector(wire:Wire) {
        _wire = wire;
        wire.connector = this;

        addEventListener(MouseEvent.ROLL_OVER, mouseRollOver);
        addEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);

        w = OnImage.width;
        h = OnImage.height;
        w2 = - Math.floor(w / 2);
        h2 = - Math.floor(h / 2);
        translateMatrix = new Matrix();
        translateMatrix.translate(w2, h2);

        redraw();
    }

    private function redraw():void {
        graphics.clear();
        var bitmap:BitmapData;
        if (_on) {
            if (_dest) {
                bitmap = OnConImage;
            } else {
                bitmap = OnImage;
            }
        } else {
            if (_dest) {
                bitmap = OffConImage;
            } else {
                bitmap = OffImage;
            }
        }
        graphics.beginBitmapFill(bitmap, translateMatrix);
        //graphics.lineStyle(0, 0, 0);
        graphics.drawRect(w2, h2, w, h);
        graphics.endFill();
    }

    private function mouseRollOver(event:Event):void {
        on = true;
    }

    private function mouseRollOut(event:Event):void {
        on = false;
    }

    private function mouseDown(event:Event):void {
        var connector_to_move:Connector = this;

        if (dest) {
            for each (var con:Connector in dest.connectors)
                if (con.wire.selected) {
                    connector_to_move = con;
                    break;
                }
        }

        if (!connector_to_move.movable)
            return;
        Globals.instance.drag_type = Globals.DRAG_TYPE_CONNECTOR;
        Globals.instance.drag_object = connector_to_move;
        connector_to_move.startDrag(false, new Rectangle(0, 0, Field.WIDTH, Field.HEIGHT));
        connector_to_move.on = false;
        connector_to_move.dest = null;
    }

    public function get dest():Out {
        return _dest;
    }

    public function set dest(value:Out):void {
        if (_dest == value)
            return;

        if (_dest)
            {
                var ind:int = dest.connectors.indexOf(this);
                if (ind >= 0)
                    _dest.connectors.splice(ind, 1);
            }
        _dest = value;
        if (_dest)
            _dest.connectors.push(this);
        Field.instance.evaluate();
        redraw();
    }

    public function moveToBasePosition():void {
        dest = null;

        var p:Point = _wire.finish.clone();
        p.offset(- BASE_LENGTH, 0);

        _wire.start = p;

        x = p.x;
        y = p.y;
    }

    public function positionSubElements():void {
        _wire.start = new Point(x, y);
    }

    public function get wire():Wire {
        return _wire;
    }

    public function get movable():Boolean {
        return _movable;
    }

    public function set movable(value:Boolean):void {
        _movable = value;
    }
}
}
