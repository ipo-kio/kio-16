package ru.ipo.kio._16.mower.model {
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

import ru.ipo.kio._16.mower.view.CellsDrawer;

public class MowerView extends Sprite {

    public static const ANIMATE_NO:int = -1;
    public static const ANIMATE_FORWARD:int = 0;
    public static const ANIMATE_TURN_LEFT:int = 1;
    public static const ANIMATE_TURN_RIGHT:int = 2;

    public static const ANIMATION_STEPS:int = 20;

    private var _mower:Mower;
    private var _angle:Number;

    private var _animation:int = ANIMATE_NO;
    private var _animation_step:int = 0;

    public function MowerView(mower:Mower) {
        this.mower = mower;
    }

    private function updateAngle():void {
        if (_mower.di == 1) //down
            angle = Math.PI;
        else if (_mower.di == -1) // up
            angle = 0;
        else if (_mower.dj == 1) // left
            angle = Math.PI / 2;
        else //if (mower.dj == -1) // right
            angle = -Math.PI / 2;
    }

    private function redraw():void {
        var len:Number = CellsDrawer.size2length(CellsDrawer.SIZE_SMALL);
        var p:Point = CellsDrawer.position2point(_mower.i, _mower.j);

        graphics.clear();

        graphics.lineStyle(1, 0x000000);
        graphics.drawCircle(p.x + len / 2, p.y + len / 2, 3);
        graphics.drawCircle(p.x + len / 2, p.y + len / 2, 5);
        graphics.moveTo(p.x + len / 2, p.y + len / 2);
        graphics.lineTo(p.x + len / 2, p.y + 2);
    }

    public function set animation(value:int):void {
        if (value == _animation)
            return;
        _animation = value;
//        if (value == ANIMATE_NO)
//            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
//        else
//            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    public function animationPlus():void {
        if (_animation_step == ANIMATION_STEPS) {
            animation = ANIMATE_NO;
            return;
        }

        switch (_animation) {
            case ANIMATE_TURN_LEFT:
                angle += /*_animation_step **/ Math.PI / 2 / ANIMATION_STEPS;
                break;
            case ANIMATE_TURN_RIGHT:
                angle -= /*_animation_step **/ Math.PI / 2 / ANIMATION_STEPS;
                break;
            case ANIMATE_FORWARD:
                var len:Number = CellsDrawer.size2length(CellsDrawer.SIZE_SMALL);
                var m:Matrix = transform.matrix;
                var d:Number = /*_animation_step **/ len / ANIMATION_STEPS;
                m.translate(d * _mower.dj, d * _mower.di);
                transform.matrix = m;
        }

        _animation_step++;
    }

    public function get angle():Number {
        return _angle;
    }

    public function set angle(value:Number):void {
        _angle = value;

        var m:Matrix = new Matrix();
        var initialPosition:Point = CellsDrawer.position2point(_mower.i + 0.5, _mower.j + 0.5);

        m.translate(-initialPosition.x, -initialPosition.y);
        m.rotate(value);
        m.translate(initialPosition.x, initialPosition.y);

        transform.matrix = m;
    }

    public function set mower(value:Mower):void {
        animation = ANIMATE_NO;
        _mower = value;

        redraw();
        updateAngle();
    }

    public function get mower():Mower {
        return _mower;
    }
}
}
