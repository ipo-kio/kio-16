package ru.ipo.kio._16.mower.view {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._16.mower.model.Field;

import ru.ipo.kio._16.mower.model.Mower;
import ru.ipo.kio._16.mower.model.MowerView;
import ru.ipo.kio._16.mower.model.Position;
import ru.ipo.kio._16.mower.model.Program;

import ru.ipo.kio._16.mower.model.State;

public class StateView extends Sprite {
    public static const ANIMATION_FINISHED:String = 'animation finished';

    private var _state:State;
    private var _mower_views:Vector.<MowerView>;
    private var _field_view:FieldView;

    private var _animating_step:int = 0;

//    private var _program_view:ProgramView;

    public function StateView(state:State, show_state:Boolean) {
        _state = state;

        _field_view = new FieldView(CellsDrawer.SIZE_SMALL, state.field);
        addChild(_field_view);

        var mowers_view:Sprite = new Sprite();
        addChild(mowers_view);

        _mower_views = new <MowerView>[];
        for each (var mower:Mower in state.mowers) {
            var mv:MowerView = new MowerView(mower, show_state);
            _mower_views.push(mv);
            addChild(mv);
        }
    }

    public function beginAnimation(program:Program):void {
        _animating_step = 0;
        addEventListener(Event.ENTER_FRAME, enterFrameHandler);

        for each (var view:MowerView in _mower_views) {
            if (view.mower.broken)
                continue;

            var c:int = state.getCommand(program, view.mower).action;
            switch (c) {
                case Field.FIELD_FORWARD:
                    view.animation = MowerView.ANIMATE_FORWARD;
                    break;
                case Field.FIELD_TURN_LEFT:
                    view.animation = MowerView.ANIMATE_TURN_LEFT;
                    break;
                case Field.FIELD_TURN_RIGHT:
                    view.animation = MowerView.ANIMATE_TURN_RIGHT;
                    break;
                case Field.FIELD_NOP:
                    view.animation = MowerView.ANIMATE_NO;
                    break;
            }
        }
    }

    public function stopAnimation():void {
        if (_animating_step == 0)
            return;
        _animating_step = 0;
        removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        dispatchEvent(new Event(ANIMATION_FINISHED));
    }

    private function enterFrameHandler(event:Event):void {
        if (_animating_step >= MowerView.ANIMATION_STEPS) {
            stopAnimation();
            return;
        }

        for each (var view:MowerView in _mower_views)
            view.animationPlus();

        _animating_step++;
    }

    public function set state(value:State):void {
        stopAnimation();
        for (var i:int = 0; i < _mower_views.length; i++)
            _mower_views[i].mower = value.mowers[i];
        _state = value;

        _field_view.field = value.field;
    }

    public function get state():State {
        return _state;
    }

    // -------------------------------------------------------------------------------------
    /*var _highlighted_mower_cell:HighlightedCell = null;
    var _highlighted_mower:Mower = null;
    var _highlighted_new_mower_cell:HighlightedCell = null;
    var _mower_mover_regime:Boolean = false;

    public function set allow_replacing_mowers(allow:Boolean):void {
        if (allow) {
            _field_view.addEventListener(MouseEvent.CLICK, field_view_clickHandler);
            _field_view.addEventListener(MouseEvent.MOUSE_MOVE, field_view_mouseMoveHandler);
            _field_view.addEventListener(MouseEvent.ROLL_OUT, field_view_rollOutHandler);
        } else {
            _field_view.removeEventListener(MouseEvent.CLICK, field_view_clickHandler);
            _field_view.removeEventListener(MouseEvent.MOUSE_MOVE, field_view_mouseMoveHandler);
            _field_view.removeEventListener(MouseEvent.ROLL_OUT, field_view_rollOutHandler);
        }
    }

    private function field_view_clickHandler(event:MouseEvent):void {

    }

    private function field_view_mouseMoveHandler(event:MouseEvent):void {
        var position:Position = _field_view.position2cell(event.localX, event.localY);

        if (!_mower_mover_regime) { // if we select mower
            //find mower at position
            for each (var views:MowerView in _mower_views) {
                if (views.mower.isAt(position.i, position.j)) {
                    var new_highlighted_cell:HighlightedCell = new HighlightedCell(position.i, position.j, 0xBB6600);
                    if (!new_highlighted_cell.equals(_highlighted_mower_cell)) {
                        _highlighted_mower = views.mower;
                        _field_view.removeHighlight(_highlighted_mower_cell);
                        _highlighted_mower_cell = new_highlighted_cell;
                        _field_view.setHighlight(_highlighted_mower_cell);
                    }
                    break;
                }
            }
        } else { // if we select a new position for it

        }
    }

    private function field_view_rollOutHandler(event:MouseEvent):void {
    }*/
}
}
