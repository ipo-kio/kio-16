/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

    public class StarrySkyView extends Sprite {

        private var starViews:Array;

        private var panel:InfoPanel;

        private var currentStar:int = -1;
        private var saveCurrentStar;
        private var lines:Array;

        public function StarrySkyView(stars:Array) {

            panel = new InfoPanel(this);
            starViews = [];
            lines = [];

            for (var i:int = 0; i < stars.length; i++) {
                starViews[i] = new StarView(stars[i]);
                starViews[i].index = i;
            }

            drawSky();

            for (var k:int = 0; k < starViews.length; k++) {
                starViews[k].addEventListener(MouseEvent.ROLL_OVER, createRollOverListener(k));
            }

            for (var t:int = 0; t < starViews.length; t++) {
                starViews[t].addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void {
                    currentStar = -1;
                });
            }

            addEventListener(MouseEvent.MOUSE_MOVE, function (e:Event):void {
                panel.text = "X coordinates: " + mouseX + ",\n" + "Y coordinates: " + mouseY + ",\n" + "currentStar: " + currentStar;
            });

            addEventListener("add_new_line", function(e:Event):void {
                drawSky();
            });

            addEventListener("del_line", function(e:Event):void {
                drawSky();
            });


            panel.x = 0;
            panel.y = this.height;
            addChild(panel);
        }

        private function createRollOverListener(k:int):Function {
            return function(event:MouseEvent):void {
                 currentStar = starViews[k].index;
            }
        }

        private function drawSky():void {

            graphics.clear();
            graphics.beginFill(0x0047ab);
            graphics.drawRect(0, 0, 500, 300);
            graphics.endFill();

            for (var i:int = 0; i < starViews.length; i++) {
                addChild(starViews[i]);
            }
        }
    }
}
