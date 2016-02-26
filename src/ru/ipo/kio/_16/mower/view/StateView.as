package ru.ipo.kio._16.mower.view {

import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._16.mower.model.Field;

import ru.ipo.kio._16.mower.model.Mower;
import ru.ipo.kio._16.mower.model.MowerView;
import ru.ipo.kio._16.mower.model.Program;

import ru.ipo.kio._16.mower.model.State;

public class StateView extends Sprite {
    public static const ANIMATION_FINISHED:String = 'animation finished';

    private var _state:State;
    private var _mower_views:Vector.<MowerView>;
    private var _field_view:FieldView;

    private var _animating_step:int = 0;

    public function StateView(state:State) {
        _state = state;

        _field_view = new FieldView(CellsDrawer.SIZE_SMALL, state.field);
        addChild(_field_view);

        var mowers_view:Sprite = new Sprite();
        addChild(mowers_view);

        _mower_views = new <MowerView>[];
        for each (var mower:Mower in state.mowers) {
            var mv:MowerView = new MowerView(mower);
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

            var c:int = state.getCommand(program, view.mower);
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
}
}
