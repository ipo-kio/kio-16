/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

    public class StarrySkyView extends Sprite {

        public function StarrySkyView() {
            drawSky();
            addEventListener(MouseEvent.MOUSE_MOVE, function (e:Event):void {
                drawSky();
            });
        }

        private function drawSky():void {

            graphics.clear();
            graphics.beginFill(0x0047ab);
            graphics.drawRect(0, 0, 500, 300);
            graphics.endFill();

            var star1:Star = new Star(13, 25, 1);
            var star2:Star = new Star(33, 55, 3);
            var star3:Star = new Star(64, 105, 2);
            var star4:Star = new Star(10, 135, 2);
            var star5:Star = new Star(173, 65, 1);
            var star6:Star = new Star(53, 60, 3);
            var star7:Star = new Star(103, 98, 1);

            var starView1:StarView = new StarView(star1);
            var starView2:StarView = new StarView(star2);
            var starView3:StarView = new StarView(star3);
            var starView4:StarView = new StarView(star4);
            var starView5:StarView = new StarView(star5);
            var starView6:StarView = new StarView(star6);
            var starView7:StarView = new StarView(star7);

            addChild(starView1);
            addChild(starView2);
            addChild(starView3);
            addChild(starView4);
            addChild(starView5);
            addChild(starView6);
            addChild(starView7);
        }
    }
}
