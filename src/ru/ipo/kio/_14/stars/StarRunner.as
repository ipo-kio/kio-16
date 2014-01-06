/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;

    public class StarRunner extends Sprite {
        public function StarRunner() {
            var sky:StarrySkyView = new StarrySkyView();

            var panel:InfoPanel = new InfoPanel();
            panel.x = 0;
            panel.y = sky.height;

            addChild(sky);
            addChild(panel);
        }
    }
}
