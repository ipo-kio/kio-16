/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.MouseEvent;

    public class StarView extends Sprite {

        private var _star:Star;
        private var _isSelected:Boolean;

        public function StarView(star:Star) {
            this._star = star;
//            _isSelected = (mouseX >= (star.x - star.radius) && mouseX <= (star.x + star.radius)) && (mouseY >= (star.y - star.radius) && mouseY <= (star.y + star.radius));
            drawDefaultStar();

            addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void {
                drawSelectedStar();
                _isSelected = true;
            });

            addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void {
                drawDefaultStar();
                _isSelected = false;
            });
        }

        private function drawDefaultStar():void {
            graphics.clear();
            graphics.beginFill(0xfcdd76);
            graphics.drawCircle(_star.x, _star.y, _star.radius);
            graphics.endFill();
        }

        private function drawSelectedStar():void {
            graphics.clear();
            graphics.beginFill(0xffcc00);
            graphics.drawCircle(_star.x, _star.y, _star.radius);
            graphics.endFill();
        }

        public function get isSelected():Boolean {
            return _isSelected;
        }
    }
}
