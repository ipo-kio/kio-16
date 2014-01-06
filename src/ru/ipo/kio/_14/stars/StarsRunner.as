/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;

    public class StarsRunner extends Sprite {
        public function StarsRunner() {
            var stars:Array = [new Star(13, 25, 1), new Star(33, 55, 3), new Star(64, 105, 2),
                new Star(10, 145, 2), new Star(173, 65, 1), new Star(163, 60, 3), new Star(103, 98, 1)];
            var sky:StarrySkyView = new StarrySkyView(stars);
            addChild(sky);
        }
    }
}
