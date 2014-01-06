/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;

    public class StarRunner extends Sprite {
        public function StarRunner() {

            var sky:StarrySkyView = new StarrySkyView();
//            var panel:InfoPanel = new InfoPanel(sky);
//
//            addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void {
//                panel.text = "X coordinates: " + mouseX + "," + "Y coordinates: " + mouseY;
//            });

            addChild(sky);
//            addChild(panel);
        }
    }
}
