/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;

public class StarView extends Sprite {

        [Embed(source="resources/default_star.png")]
        private static const DEFAULT_STAR_RADIUS_2:Class;
        private static const DEFAULT_STAR_RADIUS_3_BMP:BitmapData = new DEFAULT_STAR_RADIUS_2().bitmapData;
        [Embed(source="resources/selected_star.png")]
        private static const SELECTED_STAR_RADIUS_2:Class;
        private static const SELECTED_STAR_RADIUS_3_BMP:BitmapData = new SELECTED_STAR_RADIUS_2().bitmapData;


        private static const SELECTED_COLOR:uint = 0xffcc00;
        private static const DEFAULT_COLOR:uint = 0xfcdd76;

        private var _star:Star;
        private var _isSelected:Boolean;

        private var _index:int;

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

            //make big radius for star to interact with mouse
            addHitArea();
        }

        private function addHitArea():void {
            var hit:Sprite = new Sprite();
            hit.graphics.beginFill(0);
            hit.graphics.drawCircle(_star.x, _star.y, 5);
            hit.graphics.endFill();

            addChild(hit);
            hit.visible = false;

            this.hitArea = hit;
        }

        private function drawDefaultStar():void {
            switch (_star.radius) {
                case 1:
                    graphics.clear();
                    graphics.beginFill(DEFAULT_COLOR);
                    graphics.drawCircle(_star.x, _star.y, _star.radius);
                    graphics.endFill();
                    break;
                case 2:
                    graphics.clear();
                    graphics.beginFill(DEFAULT_COLOR);
                    graphics.drawCircle(_star.x, _star.y, _star.radius);
                    graphics.endFill();
                    break;
                case 3:
                    graphics.clear();

                    var dx:Number = _star.x - (DEFAULT_STAR_RADIUS_3_BMP.width*0.5);
                    var dy:Number = _star.y - (DEFAULT_STAR_RADIUS_3_BMP.height*0.5);

                    var matrix:Matrix = new Matrix();
                    matrix.translate(dx, dy);

                    graphics.beginBitmapFill(DEFAULT_STAR_RADIUS_3_BMP, matrix);
                    graphics.drawRect(dx, dy, DEFAULT_STAR_RADIUS_3_BMP.width, DEFAULT_STAR_RADIUS_3_BMP.height
                    );
//                    graphics.beginFill(DEFAULT_COLOR);
//                    graphics.drawCircle(_star.x, _star.y, _star.radius);
                    graphics.endFill();
                    break;
            }
        }

        private function drawSelectedStar():void {
            switch (_star.radius) {
                case 1:
                    graphics.clear();
                    graphics.beginFill(SELECTED_COLOR);
                    graphics.drawCircle(_star.x, _star.y, _star.radius);
                    graphics.endFill();
                    break;
                case 2:
                    graphics.clear();
                    graphics.beginFill(SELECTED_COLOR);
                    graphics.drawCircle(_star.x, _star.y, _star.radius);
                    graphics.endFill();
                    break;
                case 3:
                    graphics.clear();

                    var dx:Number = _star.x - (SELECTED_STAR_RADIUS_3_BMP.width*0.5);
                    var dy:Number = _star.y - (SELECTED_STAR_RADIUS_3_BMP.height*0.5);

                    var matrix:Matrix = new Matrix();
                    matrix.translate(dx, dy);

                    graphics.beginBitmapFill(SELECTED_STAR_RADIUS_3_BMP, matrix);
                    graphics.drawRect(dx, dy, SELECTED_STAR_RADIUS_3_BMP.width, SELECTED_STAR_RADIUS_3_BMP.height);
//                    graphics.beginFill(SELECTED_COLOR);
//                    graphics.drawCircle(_star.x, _star.y, _star.radius);
                    graphics.endFill();
                    break;
            }
        }

        public function get index():int {
            return _index;
        }

        public function set index(value:int):void {
            _index = value;
        }

        public function get isSelected():Boolean {
            return _isSelected;
        }
    }
}
