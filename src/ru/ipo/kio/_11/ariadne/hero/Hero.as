/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 01.03.11
 * Time: 20:49
 */
package ru.ipo.kio._11.ariadne.hero {
import flash.display.BitmapData;
import flash.display.Shape;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.utils.Timer;

import ru.ipo.kio._11.ariadne.model.AriadneData;

public class Hero extends Shape {

    public static const HERO_FINISHED:String = 'hero finished';

    protected var sprites:Array; //Array of BitmapData
    protected var ms:int; //frame rate in milliseconds
    protected var phi0:Number = 0;
    protected var terra_type:int;

    private var pixels_in_sec:Number;
    private var steps:int;

    private var from:Point;
    private var to:Point;

    private var timer:Timer;

    private var image_matrix:Matrix;

    public function go(from:Point, to:Point):void {
        var length:Number = from.subtract(to).length;

        this.from = from;
        this.to = to;

        pixels_in_sec = 5 * Math.log(3 + AriadneData.instance.terra.velocity(terra_type));

        var max_time:Number = length / pixels_in_sec;
        steps = Math.round(max_time * 1000 / ms);

        var tr:Matrix = new Matrix();
        tr.scale(1 / 3, 1 / 3);
        tr.rotate(phi0 + Math.atan2(to.y - from.y, to.x - from.x));
//        tr.translate(-sprites[0].width / 2, -sprites[0].height / 2);
        transform.matrix = tr;

        image_matrix = new Matrix();
        image_matrix.translate(-sprites[0].width / 2, -sprites[0].height / 2);

        positionSprite(0);
        updateSprite(0);

        timer = new Timer(ms, Math.max(1, steps - 1));
        timer.addEventListener(TimerEvent.TIMER, move_hero);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, complete);
        timer.start();
    }

    private function positionSprite(step:int):void {
        if (steps == 0) {
            x = from.x;
            y = from.y;
        } else {
            var vec:Point = to.subtract(from);
            x = from.x + step * vec.x / steps;
            y = from.y + step * vec.y / steps;
        }
    }

    private function updateSprite(ind:int):void {
        var s:BitmapData = sprites[ind];
        graphics.clear();
        graphics.beginBitmapFill(s, image_matrix);
        graphics.drawRect(-sprites[0].width / 2, -sprites[0].height / 2, s.width, s.height);
    }

    private function move_hero(event:Event = null):void {
        positionSprite(timer.currentCount);
        updateSprite(timer.currentCount % sprites.length);
    }

    private function complete(event:Event):void {
        dispatchEvent(new Event(HERO_FINISHED));
    }

    public function stop():void {
        timer.stop();
    }
}
}
