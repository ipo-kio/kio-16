/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.MouseEvent;

public class StarView extends Sprite {

        private var star:Star;
        private var _isSelected:Boolean;

        public function StarView(star:Star) {
            this.star = star;
            _isSelected = (mouseX >= (star.x - star.radius) && mouseX <= (star.x + star.radius)) && (mouseY >= (star.y - star.radius) && mouseY <= (star.y + star.radius));
            drawDefaultStar();

            addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void {
                drawSelectedStar();
            });

            addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void {
                drawDefaultStar();
            });
        }

        private function drawDefaultStar():void {
            graphics.clear();
            graphics.beginFill(0xfcdd76);
            graphics.drawCircle(star.x, star.y, star.radius);
            graphics.endFill();
        }

        private function drawSelectedStar():void {
            graphics.clear();
            graphics.beginFill(0xffcc00);
            graphics.drawCircle(star.x, star.y, star.radius);
            graphics.endFill();
        }


        public function get isSelected():Boolean {
            return _isSelected;
        }
    }
}
