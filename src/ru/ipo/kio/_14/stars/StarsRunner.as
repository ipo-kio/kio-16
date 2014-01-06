/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;

    public class StarsRunner extends Sprite {
        public function StarsRunner() {

            var sky:StarrySkyView = new StarrySkyView();
            addChild(sky);
        }
    }
}
