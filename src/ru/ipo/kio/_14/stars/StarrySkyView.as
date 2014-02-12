/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class StarrySkyView extends Sprite {

        [Embed(source="resources/Nature-clouds-above-night-resolution-wallpaper-500x400.jpg")]
        private static const BACKGROUND:Class;
        private static const BACKGROUND_BMP:BitmapData = new BACKGROUND().bitmapData;

        private var starViews:Array/*<StarView>*/;
        private var lines:Array/*<LineView>*/;

//        private var panel:SkyInfoPanel;

        private var currentStar:int = -1;
        private var saveCurrentStar:int = -1;
        private var pressed:Boolean;
        private var currentLineView:LineView = null;

        private var sky:StarrySky;

        private var drawingLinesLayer:Sprite = new Sprite();

        public function StarrySkyView(starrySky:StarrySky) {

            addChild(drawingLinesLayer);

//            panel = new SkyInfoPanel(this);
            starViews = [];
            lines = [];

            for (var i:int = 0; i < starrySky.stars.length; i++)
                starViews[i] = new StarView(starrySky.stars[i]);

            sky = starrySky;

            drawSky();

            for (var k:int = 0; k < starViews.length; k++) {
                starViews[k].addEventListener(MouseEvent.ROLL_OVER, createRollOverListener(k));
            }

            for (var t:int = 0; t < starViews.length; t++) {
                starViews[t].addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void {
                    currentStar = -1;
                });
            }

            //draw line
            addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
                if (currentStar != -1) {
                    pressed = true;
                    saveCurrentStar = currentStar;
                    var star:Star = getStarByIndex(currentStar);

                    createLineView(star.x, star.y);
                    /*var lineView:LineView = new LineView(star.x, star.y);
                    drawingLinesLayer.addChild(lineView);
                    currentLineView = lineView;*/
                }
            });

            addEventListener(MouseEvent.MOUSE_MOVE, function(event:MouseEvent):void {
                if (pressed)
                    drawLineView(event.localX, event.localY);
//                    currentLineView.drawNewLine(event.localX, event.localY);
            });

            addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void {
                if (pressed && currentStar != -1 && currentStar != saveCurrentStar) {
                    var lineInd:int = sky.addLine(starrySky.stars[saveCurrentStar], starrySky.stars[currentStar]);
                    if (lineInd >= 0) {
                        var star1:Star = getStarByIndex(saveCurrentStar);
                        var star2:Star = getStarByIndex(currentStar);
                        fixLineView(star1, star2);
                        /*currentLineView.fixNewLine(new Line(star1, star2));
                        currentLineView.addEventListener(MouseEvent.CLICK, lineView_clickHandler);*/
                    }
                } else if (pressed)
                    drawingLinesLayer.removeChild(currentLineView);

                pressed = false;
                saveCurrentStar = -1;
            });

            /*addEventListener(MouseEvent.MOUSE_MOVE, function (e:Event):void {
                panel.text = "X coordinates: " + mouseX + ",\n" + "Y coordinates: " + mouseY + ",\n" +
                        "current_Star: " + currentStar + ",\n" + "save_current_Star: " + saveCurrentStar + ",\n" +
                        "pressed: " + pressed;
            });

            panel.x = 0;
            panel.y = this.height;
            addChild(panel);*/
        }

        private function createRollOverListener(k:int):Function {
            return function(event:MouseEvent):void {
                currentStar = starViews[k].index;
            }
        }

        private function getStarByIndex(ind:int):Star {
            return sky.stars[ind];
        }

        private function drawSky():void {
            graphics.clear();
//            graphics.beginFill(0x0047ab);
            graphics.beginBitmapFill(BACKGROUND_BMP);
            graphics.drawRect(0, 0, 500, 400);
            graphics.endFill();

            for (var i:int = 0; i < starViews.length; i++) {
                addChild(starViews[i]);
            }
        }

        public function createLineView(startX:Number, startY:Number):void {
            var lineView:LineView = new LineView(startX, startY);
            drawingLinesLayer.addChild(lineView);
            currentLineView = lineView;
        }

        public function drawLineView(localX:Number, localY:Number):void {
            currentLineView.drawNewLine(localX, localY);
        }

        public function fixLineView(star1:Star, star2:Star):void {
            lines.push(currentLineView);
            currentLineView.fixNewLine(new Line(star1, star2));
            currentLineView.addEventListener(MouseEvent.CLICK, lineView_clickHandler);
        }

        private function lineView_clickHandler(event:MouseEvent):void {
            var lineView:LineView = event.target as LineView;
            if (lineView != null) {
//                var line:Line = lineView.line;
                //remove line from sky._starsLines and from _lines
                for (var lineViewInd:int = 0; lineViewInd < lines.length; lineViewInd++)
                    if (lines[lineViewInd] == lineView) {
                        removeLine(lineViewInd);
                        return;
                    }
                trace("ERROR!! failed to find lineView to remove");
                throw new Error("ERROR!! failed to find lineView to remove");
            }
        }

    private function removeLine(lineViewInd:int):void {
        var lineView:LineView = lines[lineViewInd];

        lines.splice(lineViewInd, 1);
        sky.removeLineWithIndex(lineViewInd);

        drawingLinesLayer.removeChild(lineView);
        lineView.dispose();
    }

    public function clearLines():void {
        for (var i:int = lines.length - 1; i >= 0; i--)
            removeLine(i);
    }
}
}
