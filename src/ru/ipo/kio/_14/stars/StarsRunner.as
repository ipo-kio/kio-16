/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.Event;

public class StarsRunner extends Sprite {
    private var sky:StarrySky;

    public function StarsRunner() {
        var stars:Array = [new Star(13, 25, 1), new Star(33, 55, 3), new Star(64, 105, 2),
            new Star(10, 145, 2), new Star(173, 65, 1), new Star(163, 60, 3), new Star(103, 98, 1)];

        sky = new StarrySky(stars);
        var skyView:StarrySkyView = new StarrySkyView(sky);
        addChild(skyView);

        sky.addEventListener(Event.CHANGE, sky_changeHandler);
    }

    private function sky_changeHandler(event:Event):void {
        trace(sky.sumOfLines.toFixed(3));
    }
}
}
