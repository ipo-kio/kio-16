/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.GraphicsPathCommand;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import ru.ipo.kio._14.stars.graphs.Graph;
import ru.ipo.kio._14.stars.graphs.IsomorphismChecker;

public class StarrySkyView extends Sprite {

        [Embed(source="resources/Nature-clouds-above-night-resolution-wallpaper-500x400.jpg")]
        private static const BACKGROUND:Class;
        private static const BACKGROUND_BMP:BitmapData = new BACKGROUND().bitmapData;

        private var starViews:Array/*<StarView>*/;
        private var lines:Array/*<LineView>*/;

        private var _workspace:StarsWorkspace;

        private var currentStar:int = -1;
        private var saveCurrentStar:int = -1;
        private var pressed:Boolean;
        private var currentLineView:LineView = null;

        private var sky:StarrySky;

        private var constellationsLayer:Sprite = new Sprite();
        private var drawingLinesLayer:Sprite = new Sprite();
        private var g:Graphics = constellationsLayer.graphics;

        public function StarrySkyView(starrySky:StarrySky, workspace:StarsWorkspace) {

            _workspace = workspace;
            addChild(constellationsLayer);
            constellationsLayer.alpha = 0.2;
            addChild(drawingLinesLayer);

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

                    g.clear();

                    var correctGraphs:Vector.<Graph> = new Vector.<Graph>();
                    for each (var graph:Graph in sky.connectedComponents)
                        if (graph.isCorrect(sky.level)) {
                            correctGraphs.push(graph);
                            redrawConstellations(graph, 0xffffffff);
                            drawIsomorphicGraphs(correctGraphs);
                        }
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
                if (pressed) {
                    drawLineView(event.localX, event.localY);
                    workspace.panel.text = "Length of the moved line: " + currentLineView.computeDistance(event.localX, event.localY);
                } //else
//                    workspace.panel.text = "X coordinates: " + mouseX + "\n" + "Y coordinates: " + mouseY;
            });

            addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void {
                if (pressed && currentStar != -1 && currentStar != saveCurrentStar) {
                    var star1:Star = getStarByIndex(saveCurrentStar);
                    var star2:Star = getStarByIndex(currentStar);
                    var lineInd:int = sky.addLine(star1, star2); //TODO sky changed handler called, but we still don't have a line
                    if (lineInd >= 0)
                        fixLineView(sky.starsLines[lineInd]);
                    else
                        drawingLinesLayer.removeChild(currentLineView);
                } else if (pressed)
                    drawingLinesLayer.removeChild(currentLineView);
//                workspace.panel.text = "X coordinates: " + mouseX + "\n" + "Y coordinates: " + mouseY;
                workspace.panel.text = "";

                pressed = false;
                saveCurrentStar = -1;

                starrySky_changeHandler(null); //TODO get rid of this call
            });

            starrySky.addEventListener(Event.CHANGE, starrySky_changeHandler);
        }

        private function createRollOverListener(k:int):Function {
            return function(event:MouseEvent):void {
                currentStar = starViews[k].index;

                g.clear();

                for each (var graph:Graph in sky.connectedComponents) {
                    for (var s:* in graph.graph)
                        if (starViews[k].index == s.index)
                            redrawConstellations(graph, 0xffffcc00);
                    redrawConstellations(graph, 0xffffffff);
                }
            }
        }

        private function getStarByIndex(ind:int):Star {
            return sky.stars[ind];
        }

        private function drawSky():void {
            graphics.clear();
//            graphics.beginFill(0x0047ab);
            var m:Matrix = new Matrix();
            m.scale(2, 2);
            graphics.beginBitmapFill(BACKGROUND_BMP, m);
//            graphics.beginFill(0);
            graphics.drawRect(0, 0, 780, 480);
            graphics.endFill();

            for (var i:int = 0; i < starViews.length; i++) {
                addChild(starViews[i]);
            }
        }

        public function createLineView(startX:Number, startY:Number):void {
            var lineView:LineView = new LineView(startX, startY, _workspace);
            drawingLinesLayer.addChild(lineView);
            currentLineView = lineView;
        }

        public function drawLineView(localX:Number, localY:Number):void {
            currentLineView.drawNewLine(localX, localY);
        }

        public function fixLineView(line:Line):void {
            lines.push(currentLineView);
            currentLineView.fixNewLine(line);
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

    public function starrySky_changeHandler(event:Event):void {
        for each (var lineView:LineView in lines)
            lineView.error = sky.isLineIntersected(lineView.line);

        g.clear();

        var correctGraphs:Vector.<Graph> = new Vector.<Graph>();
        for each (var graph:Graph in sky.connectedComponents)
            if (graph.isCorrect(sky.level)) {
                correctGraphs.push(graph);
                redrawConstellations(graph, 0xffffffff);
                drawIsomorphicGraphs(correctGraphs);
            }
    }

    private function drawIsomorphicGraphs(correctGraphs:Vector.<Graph>):void {
        for (var g1:int = 1; g1 < correctGraphs.length; g1++) {
            var graph1:Graph = correctGraphs[g1];
            for (var g2:int = 0; g2 <= g1 - 1; g2++) {
                var graph2:Graph = correctGraphs[g2];
                if (IsomorphismChecker.areIsomorphic(graph1, graph2)) {
                    redrawConstellations(graph1, 0xffff0000/*0xffffcc00*/);
                    redrawConstellations(graph2, 0xffff0000/*0xffffcc00*/);
                }
            }
        }

    }

    public function redrawConstellations(graph0:Graph, colour:uint):void {

//        var g:Graphics = constellationsLayer.graphics;
//        g.clear();

//        for each (var graph:Graph in sky.connectedComponents) {
//            if (graph.isCorrect(sky.level)) {

                var commands:Vector.<int> = new <int>[];
                var data:Vector.<Number> = new <Number>[];
                g.lineStyle(60, colour);

                for (var s1:* in graph0.graph) {
                    for each (var s2:Star in graph0.graph[s1]) {
                        commands.push(GraphicsPathCommand.MOVE_TO);
                        data.push(s1.x, s1.y);
                        commands.push(GraphicsPathCommand.LINE_TO);
                        data.push(s2.x, s2.y);
                    }
                }

                g.drawPath(commands, data);
//            }
//        }
    }
}
}
