/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 25.02.11
 * Time: 5:22
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api.controls {
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class RecordBlinkEffect {

    private static const colors:Array = [0x000000, 0xFFFFFF];

    public static var _instance:RecordBlinkEffect = null;

    public static function blink(stage:DisplayObjectContainer, x:int, y:int, width:int, height:int):void {
        if (_instance) {
            _instance.stop();
        }
        _instance = new RecordBlinkEffect(stage, x, y, width, height);
    }

    private var stage:DisplayObjectContainer;
    private var r:Shape;
    private var t:Timer;

    public function RecordBlinkEffect(stage:DisplayObjectContainer, x:int, y:int, width:int, height:int) {
        this.stage = stage;

        r = new Shape;
        t = new Timer(1000/20, 20);

        r.x = x;
        r.y = y;

        t.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
            draw(r.graphics, width, height, colors[t.currentCount % 2], 0.7);
        });

        t.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent):void {
            if (stage.contains(r))
                stage.removeChild(r);
            _instance = null;
        });

        stage.addChild(r);
        t.start();
    }

    private function draw(g:Graphics, width:int, height:int, color:uint, alpha:Number):void {
        g.lineStyle(3, color, alpha);
        g.drawRect(0, 0, width, height);
    }

    private function stop():void {
        t.stop();
        if (stage.contains(r))
            stage.removeChild(r);
    }
}
}
