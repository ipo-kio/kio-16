/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

    public class StarrySkyView extends Sprite {

        private var stars:Array;

        private var panel:InfoPanel;

        public function StarrySkyView(stars:Array) {

            this.stars = stars;
            panel = new InfoPanel(this);

            drawSky();
            addEventListener(MouseEvent.MOUSE_MOVE, function (e:Event):void {
                panel.text = "X coordinates: " + mouseX + ",\n" + "Y coordinates: " + mouseY;
            });
            panel.x = 0;
            panel.y = this.height;
            addChild(panel);
        }

        private function drawSky():void {

            graphics.clear();
            graphics.beginFill(0x0047ab);
            graphics.drawRect(0, 0, 500, 300);
            graphics.endFill();

            for (var i:int = 0; i < stars.length; i++) {
                var starView:StarView = new StarView(stars[i]);
                addChild(starView);
            }
        }
    }
}
