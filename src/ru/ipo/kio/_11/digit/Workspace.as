/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 21.02.11
 * Time: 15:57
 */
package ru.ipo.kio._11.digit {
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.api.controls.GraphicsButton;
import ru.ipo.kio.base.KioBase;

public class Workspace extends Sprite {

    [Embed(source="resources/Background+Robot.jpg")]
    private static const BG:Class;

    [Embed(source="resources/buttons/Basket_01.png")]
    private static const TRASH_NORMAL:Class;
    private static const TRASH_NORMAL_IMG:DisplayObject = new TRASH_NORMAL;

    [Embed(source="resources/buttons/Basket_02.png")]
    private static const TRASH_OVER:Class;
    private static const TRASH_OVER_IMG:DisplayObject = new TRASH_OVER;

    [Embed(source="resources/buttons/Big_Button_01.jpg")]
    private static const BIG_BUTTON_NORMAL:Class;
    private static const BIG_BUTTON_NORMAL_IMG:BitmapData = new BIG_BUTTON_NORMAL().bitmapData;

    [Embed(source="resources/buttons/Big_Button_02.jpg")]
    private static const BIG_BUTTON_OVER:Class;
    private static const BIG_BUTTON_OVER_IMG:BitmapData = new BIG_BUTTON_OVER().bitmapData;

    [Embed(source="resources/buttons/Big_Button_03.jpg")]
    private static const BIG_BUTTON_DOWN:Class;
    private static const BIG_BUTTON_DOWN_IMG:BitmapData = new BIG_BUTTON_DOWN().bitmapData;

    [Embed(source="resources/buttons/Small_Button_01.jpg")]
    private static const SMALL_BUTTON_NORMAL:Class;
    private static const SMALL_BUTTON_NORMAL_IMG:BitmapData = new SMALL_BUTTON_NORMAL().bitmapData;

    [Embed(source="resources/buttons/Small_Button_02.jpg")]
    private static const SMALL_BUTTON_OVER:Class;
    private static const SMALL_BUTTON_OVER_IMG:BitmapData = new SMALL_BUTTON_OVER().bitmapData;

    [Embed(source="resources/buttons/Small_Button_03.jpg")]
    private static const SMALL_BUTTON_DOWN:Class;
    private static const SMALL_BUTTON_DOWN_IMG:BitmapData = new SMALL_BUTTON_DOWN().bitmapData;

    [Embed(source="resources/Wires_01.png")]
    private static const WIRES_1:Class;

    [Embed(source="resources/Wires_02.png")]
    private static const WIRES_2:Class;

    [Embed(source='resources/a_LCDNova.ttf', embedAsCFF = "false", fontName="KioDigits", mimeType="application/x-font-truetype", unicodeRange = "U+0000-U+FFFF")]
    private static var KIO_DIGITS_FONT:Class;

    private var _trash:DisplayObject;

    private static const TRASH_X:int = 671;
    private static const TRASH_Y:int = 410;

    private var _field:Field;

    private var _new_gate_or:Gate = GatesFactory.createGate(GatesFactory.TYPE_OR);
    private var _new_gate_and:Gate = GatesFactory.createGate(GatesFactory.TYPE_AND);
    private var _new_gate_not:Gate = GatesFactory.createGate(GatesFactory.TYPE_NOT);
    private var _new_gate_nop:Gate = GatesFactory.createGate(GatesFactory.TYPE_NOP);

    private var loc:Object = KioApi.getLocalization(DigitProblem.ID);
    private var _digit:Digit;

    private var _solutionState:SolutionState;

    private var _ipResults:ResultsInfoPanel = new ResultsInfoPanel(loc.results.result, 469, 421, 439, 453, 470);

    private var _ipRecord:ResultsInfoPanel = new ResultsInfoPanel(loc.results.record, 592, 421, 439, 453, 470);

    public function Workspace() {
        Globals.instance.workspace = this;

        addChild(new BG);

        addChild(_ipResults);
        addChild(_ipRecord);

        _trash = TRASH_NORMAL_IMG;
        _trash.x = TRASH_X;
        _trash.y = TRASH_Y;
        addChild(_trash);

        _solutionState = Globals.instance.level == 1 ? new SolutionState1 : new SolutionState2;
        addChild(Sprite(_solutionState));

        _digit = new Digit();
        addChild(_digit);

        var wires:DisplayObject = Globals.instance.level == 1 ? new WIRES_1 : new WIRES_2;
        wires.x = 44;
        wires.y = Globals.instance.level == 1 ? 74 : 29;
        addChild(wires);

        _field = new Field;

        addChild(_field);

        placeNewGates();

        placeWiresButtons();

        placeDigitButtons();

        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    public function init(event:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
    }

    //when mouse is up and there was constrained moving rectangle, up coordinates are irrelevant
    private var __last_mouse_move_x:Number;
    private var __last_mouse_move_y:Number;
    private var __gate_receiver:Out = null;

    private function stageMouseMove(event:Event):void {
        switch (Globals.instance.drag_type) {
            case Globals.DRAG_TYPE_GATE:
                var g:Gate = Gate(Globals.instance.drag_object);
                g.positionSubElements();
                __last_mouse_move_x = mouseX;
                __last_mouse_move_y = mouseY;
                updateTrashState(__last_mouse_move_x, __last_mouse_move_y);
                break;
            case Globals.DRAG_TYPE_CONNECTOR:
                var c:Connector = Connector(Globals.instance.drag_object);
                c.positionSubElements();
                //test c is over some gate
                var is_over:Boolean = false;
                var mx:Number = _field.mouseX;
                var my:Number = _field.mouseY;
                for each (var gt:Out in _field.outs)
                    if (hitTestGate(gt, mx, my)) {
                        is_over = true;
                        __gate_receiver = gt;
                        break;
                    }
                if (is_over) {
                    c.on = true;
                } else {
                    c.on = false;
                    __gate_receiver = null;
                }
                break;
            case Globals.DRAG_TYPE_NEW_GATE:
                var ng:Gate = Gate(Globals.instance.drag_object);
                ng.positionSubElements();
                break;
        }
    }

    private function hitTestGate(gt:Out, mx:Number, my:Number):Boolean {
        var g:Sprite = Sprite(gt);
        return g.x <= mx && mx <= g.x + g.width && g.y <= my && my <= g.y + g.height;
    }

    private function stageMouseUp(event:Event):void {
        /*if (KioBase.instance.currentProblem.id != DigitProblem.ID)
         return;*/

        switch (Globals.instance.drag_type) {
            case Globals.DRAG_TYPE_GATE:
                var g:Gate = Gate(Globals.instance.drag_object);
                g.stopDrag();
                updateTrashImage(TRASH_NORMAL_IMG);
                if (trashHitTest(__last_mouse_move_x, __last_mouse_move_y))
                    _field.removeGate(g);

                __last_mouse_move_x = -1;
                __last_mouse_move_y = -1;

                //position gate if outside field
                if (g.x < 0)
                    g.x = 0;
                if (g.y < 0)
                    g.y = 0;
                var fw:Number = Field.WIDTH - g.width;
                if (g.x >= fw)
                    g.x = fw;
                var fh:Number = Field.HEIGHT - g.height;
                if (g.y >= fh)
                    g.y = fh;
                g.positionSubElements();

                break;
            case Globals.DRAG_TYPE_CONNECTOR:
                var c:Connector = Connector(Globals.instance.drag_object);
                c.stopDrag();
                c.positionSubElements();
                //test connector is connected to its own gate
                if (__gate_receiver) {
                    var dont_bind:Boolean = false;
                    if (__gate_receiver is Gate) {
                        var gr:Gate = Gate(__gate_receiver); //may be 'as' would be better
                        if (gr.in_connectors.indexOf(c) >= 0) {
                            dont_bind = true;
                            c.moveToBasePosition();
                        }
                    }
                    if (!dont_bind)
                        __gate_receiver.bindConnector(c);
                }
                __gate_receiver = null;
                break;
            case Globals.DRAG_TYPE_NEW_GATE:
                var ng:Gate = Gate(Globals.instance.drag_object);
                if (
                        _field.mouseX >= 0 &&
                                _field.mouseX <= Field.WIDTH - ng.width &&
                                _field.mouseY >= 0 &&
                                _field.mouseY <= Field.HEIGHT - ng.height
                        ) {
                    _field.addGate(GatesFactory.createGate(ng.type), _field.mouseX - ng.mouseX, _field.mouseY - ng.mouseY);
                }
                ng.stopDrag();
                ng.moveBackThisNewGate();
                break;
        }
        Globals.instance.drag_type = Globals.DRAG_TYPE_NOTHING;

        submitSolution();
    }

    public function submitSolution():void {
        if (!KioBase.instance.currentProblem || KioBase.instance.currentProblem.id != DigitProblem.ID)
            return;

        //count all gates except empty
        var cnt:int = 0;
        for each (var g:Gate in field.gates) {
            if (g.type != GatesFactory.TYPE_NOP)
                cnt ++;
        }

        DigitProblem(KioApi.instance(DigitProblem.ID).problem)
                .submitSolution(
                Globals.instance.workspace.solutionState.recognized,
                cnt
                );

    }

    private function updateTrashState(x:Number, y:Number):void {
        var _new_trash:DisplayObject = trashHitTest(x, y) ? TRASH_OVER_IMG : TRASH_NORMAL_IMG;
        updateTrashImage(_new_trash);
    }

    private function trashHitTest(x:Number, y:Number):Boolean {
        var tx:Number = x - TRASH_X;
        var ty:Number = y - TRASH_Y;
        return tx >= 0 && tx <= _trash.width && ty >= 0 && ty <= _trash.height;
    }

    private function updateTrashImage(new_trash:DisplayObject):void {
        if (_trash != new_trash) {
            new_trash.x = TRASH_X;
            new_trash.y = TRASH_Y;
            removeChild(_trash);
            addChild(new_trash);
            _trash = new_trash;
        }
    }

    public function get field():Field {
        return _field;
    }

    public function placeNewGates():void {
        const v_shift:int = 16;

        var or_tf:TextField = TextUtils.createTextFieldWithFont("KioDigits", 12, false);
        var and_tf:TextField = TextUtils.createTextFieldWithFont("KioDigits", 12, false);
        var not_tf:TextField = TextUtils.createTextFieldWithFont("KioDigits", 12, false);
        var nop_tf:TextField = TextUtils.createTextFieldWithFont("KioDigits", 12, false);
        or_tf.text = loc.gates.or;
        and_tf.text = loc.gates.and;
        not_tf.text = loc.gates.not;
        nop_tf.text = loc.gates.nop;

        and_tf.x = 58 - and_tf.width / 2;
        and_tf.y = 326;
        addChild(and_tf);

        or_tf.x = 119 - or_tf.width / 2;
        or_tf.y = 326;
        addChild(or_tf);

        not_tf.x = 58 - not_tf.width / 2;
        not_tf.y = 367;
        addChild(not_tf);

        nop_tf.x = 119 - nop_tf.width / 2;
        nop_tf.y = 367;
        addChild(nop_tf);

        _new_gate_and.is_new = true;
        _new_gate_and.x = 58;
        _new_gate_and.y = 327 + v_shift;
        _new_gate_and.addTo(this, this, this);

        _new_gate_or.is_new = true;
        _new_gate_or.x = 119;
        _new_gate_or.y = 327 + v_shift;
        _new_gate_or.addTo(this, this, this);

        _new_gate_not.is_new = true;
        _new_gate_not.x = 58;
        _new_gate_not.y = 367 + v_shift;
        _new_gate_not.addTo(this, this, this);

        _new_gate_nop.is_new = true;
        _new_gate_nop.x = 119;
        _new_gate_nop.y = 367 + v_shift + 5;
        _new_gate_nop.addTo(this, this, this);
    }

    private function placeWiresButtons():void {
        var resetButton:GraphicsButton = new GraphicsButton(
                loc.buttons.reset,
                BIG_BUTTON_NORMAL_IMG,
                BIG_BUTTON_OVER_IMG,
                BIG_BUTTON_DOWN_IMG,
                "KioDigits",
                11,
                9
                );
        resetButton.x = 19;
        resetButton.y = 419;
        addChild(resetButton);

        resetButton.addEventListener(MouseEvent.CLICK, resetButtonClick);

        var splitButton:GraphicsButton = new GraphicsButton(
                loc.buttons.split,
                BIG_BUTTON_NORMAL_IMG,
                BIG_BUTTON_OVER_IMG,
                BIG_BUTTON_DOWN_IMG,
                "KioDigits",
                11,
                9
                );
        splitButton.x = 19;
        splitButton.y = 457;
        addChild(splitButton);

        splitButton.addEventListener(MouseEvent.CLICK, splitButtonClick);
    }

    private function resetButtonClick(event:Event):void {
        var wire:Wire = Globals.instance.selected_wire;
        if (wire)
            wire.connector.moveToBasePosition();
        submitSolution();
    }

    private function splitButtonClick(event:Event):void {
        var wire:Wire = Globals.instance.selected_wire;
        if (!wire)
            return;

        var con:Connector = wire.connector;

        //Out out -- connector con
        //  ==>
        //Out out -- NEW_ELEMENT -- connector con
        var out:Out = con.dest;
        var empty:Gate = GatesFactory.createGate(GatesFactory.TYPE_NOP);
        var sum:Point = wire.start.add(wire.finish);
        _field.addGate(empty, Math.floor(sum.x / 2), Math.floor(sum.y / 2));

        empty.in_connectors[0].x = con.x;
        empty.in_connectors[0].y = con.y;
        empty.in_connectors[0].positionSubElements();
        empty.in_connectors[0].dest = out;

        con.dest = empty;
        empty.positionSubElements();

        submitSolution();
    }

    private function placeDigitButtons():void {
        for (var d:int = 0; d < 10; d++) {
            var button:GraphicsButton = new GraphicsButton(
                    '' + d,
                    SMALL_BUTTON_NORMAL_IMG,
                    SMALL_BUTTON_OVER_IMG,
                    SMALL_BUTTON_DOWN_IMG,
                    "KioDigits",
                    14,
                    11
                    );
            //i, j - row and col for a button
            var i:int = 1;
            var j:int = 3;
            if (d != 0) {
                i = (d - 1) / 3;
                j = (d - 1) % 3;
            }
            button.x = 19 + 37 * j;
            button.y = 8 + 37 * i;
            addChild(button);

            button.addEventListener(MouseEvent.CLICK, getDigitButtonClickedHandler(d));
        }
    }

    private function getDigitButtonClickedHandler(d:int):Function {
        return function(event:Event):void {
            _digit.val = d;
        }
    }

    public function get digit():Digit {
        return _digit;
    }

    public function get solutionState():SolutionState {
        return _solutionState;
    }


    public function updateResultsInfo(is_record:Boolean, recognized:int, elements:int):void {
        var rip:ResultsInfoPanel = is_record ? _ipRecord : _ipResults;
        rip.recognized = recognized;
        rip.elements = elements;
    }
}
}
