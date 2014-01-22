/**
 * Created by user on 22.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.MouseEvent;

    public class LineView extends Sprite {

        private var x1:Number;
        private var y1:Number;
        private var x2:Number;
        private var y2:Number;

        private var _isSelected:Boolean;
        private var _lineIndex:int;


        public function LineView(x1:Number, y1:Number, x2:Number, y2:Number) {
            this.x1 = x1;
            this.y1 = y1;
            this.x2 = x2;
            this.y2 = y2;

            drawDefaultLine();

            addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void {
                drawSelectedLine();
                _isSelected = true;
            });

            addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void {
                drawDefaultLine();
                _isSelected = false;
            });
        }

        public function get lineIndex():int {
            return _lineIndex;
        }

        public function set lineIndex(value:int):void {
            _lineIndex = value;
        }

        public function registerNewLine(x1:Number, y1:Number, x2:Number, y2:Number):void {
            _lineIndex = ((x1 + y1) * (x2 + y2)) * 150;
        }

        public function deleteLine():void {
            if (_isSelected)
                graphics.clear();
        }

        private function drawDefaultLine():void {
            graphics.clear();
            graphics.lineStyle(2, 0xffffff, 0.7);
            graphics.moveTo(x1, y1);
            graphics.lineTo(x2, y2);
        }

        private function drawSelectedLine():void {
            graphics.clear();
            graphics.lineStyle(3, 0xffffff, 1);
            graphics.moveTo(x1, y1);
            graphics.lineTo(x2, y2);
        }
    }
}
