/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 23.01.13
 * Time: 12:31
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio.api.controls.TextButton;

public class MoveExample extends Sprite {

    public function MoveExample() {
        var m:MyModel = new MyModel(0);
        var v:MyModelView = new MyModelView(m);

        var f:Field = new Field();
        addChild(f);

        f.addChild(v);

        m.addEventListener('x changed', function (e:MyEvent):void {
//            trace("x = ", m.x);
//            trace("x = ", e.target.x);
//            trace("x old = ", e.x_old);
        });

        var forwardButton:TextButton = new TextButton("+2");
        addChild(forwardButton);
        forwardButton.y = 300;
        forwardButton.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            m.x += 2;
        });

        var backButton:TextButton = new TextButton("-3");
        addChild(backButton);
        backButton.y = 350;
        backButton.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            m.x -= 3;
        });

        var stopButton:TextButton = new TextButton("stop");
        addChild(stopButton);
        stopButton.y = 400;
        stopButton.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            v.stop();
        });
    }

}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;

class Field extends Sprite {

    public function Field() {
        graphics.beginFill(0xCCCCCC);
        graphics.drawRect(0, 0, 500, 500);
        graphics.endFill();

        addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            trace('field clicked: ', event.target, event.target == event.currentTarget);
            if (event.target == event.currentTarget ){
                var x:int = MyModelView.screen2logical(event.localX);
                trace("create cube at", x);
            }
        })
    }
}

class MyModel extends EventDispatcher {
    private var _x:int;

    public function MyModel(x:int) {
        this._x = x;
    }

    public function get x():int {
        return _x;
    }

    public function set x(value:int):void {
        var xold:int = _x;
        _x = value;
        dispatchEvent(new MyEvent('x changed', xold));
    }
}

class MyEvent extends Event {

    private var _x_old:int;

    public function MyEvent(type:String, x_old:int) {
        super(type);
        _x_old = x_old;
    }

    public function get x_old():int {
        return _x_old;
    }
}

class MyModelView extends Sprite {

    private var _m:MyModel;

    private var _itenerary:Array = new Array(); //list of x
    private var _currentFrame:int = 0;
    private var _moveFrom:int = -1;

    private static const FRAMES_TO_MOVE:int = 40;

    public function MyModelView(m:MyModel) {
        _m = m;
        _m.addEventListener('x changed', startMoveAnimated);

        graphics.beginFill(0xFF0000);
        graphics.drawRect(0, 0, 50, 30);
        graphics.endFill();

        move();

        addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            trace('change color');
        });
    }

    private function startMoveAnimated(event:MyEvent):void {
        if (_moveFrom < 0) {
            _moveFrom = event.x_old;
            _currentFrame = 0;
        }

        _itenerary.push(_m.x);
        addEventListener(Event.ENTER_FRAME, moveAnimated);
    }

    private function moveAnimated(event:Event):void {
        if (_itenerary.length == 0) {
            stop();
            return;
        }

        var moveTo:int = _itenerary[0];

        trace('moving from to', _moveFrom, moveTo);

        _currentFrame ++;

        //50 * _moveFrom --------------> 50 * moveTo   by FRAMES_TO_MOVE * Math.abs(moveTo - _moveFrom)
        var moveFromScreen:Number = logical2screen(_moveFrom);
        var moveToScreen:int = logical2screen(moveTo);
        x = moveFromScreen + _currentFrame * (moveToScreen - moveFromScreen)
                / (FRAMES_TO_MOVE * Math.abs(moveTo - _moveFrom));

        if (_currentFrame == FRAMES_TO_MOVE * Math.abs(moveTo - _moveFrom)) {
            _currentFrame = 0;
            _moveFrom = moveTo;
            _itenerary.shift();
        }
    }

    public function stop():void {
        removeEventListener(Event.ENTER_FRAME, moveAnimated);
        _moveFrom = -1;
        _currentFrame = 0;
        _itenerary = [];

        move();
    }

    private function move():void {
        x = _m.x * 50;
    }

    public function get m():MyModel {
        return _m;
    }

    public static function logical2screen(x:int):Number {
        return x * 50;
    }

    public static function screen2logical(x:Number):int {
        return Math.floor(x / 50);
    }

}