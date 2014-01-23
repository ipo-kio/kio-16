/**
 * Created by user on 22.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.events.Event;
import flash.events.EventDispatcher;

    public class StarrySky extends EventDispatcher {

        private var starsView:Array;
        private var starsLines:Array;

        private var _sumOfLines:Number;

        public function StarrySky(starsView:Array) {
            this.starsView = starsView;
            starsLines = [];
            _sumOfLines = 0;
        }

        public function addLine(a:int, b:int):void {
            for (var i:int = 0; i < starsView.length; i++) {
                if (starsView[i].index == a) {
                    for (var j:int = 0; j < starsView.length; j++) {
                        if (starsView[j].index == b) {
                            _sumOfLines += Math.sqrt(Math.pow((starsView[j].x - starsView[i].x), 2) + Math.pow((starsView[j].y - starsView[i].y), 2));
                            starsLines.push([starsView[i], starsView[j]]);

                            dispatchEvent(new Event("add_new_line"));
                        }
                    }
                }
            }
        }

        public function deleteLine(a:int, b:int):void {
            for (var i:int = 0; i < starsLines.length; i++) {
                if (starsLines[i][0].index == a) {
                    if (starsLines[i][1].index == b) {
                        _sumOfLines = _sumOfLines - Math.sqrt(Math.pow((starsLines[i][1].x - starsLines[i][0].x), 2) + Math.pow((starsLines[i][1].y - starsLines[i][0].y), 2));
                        starsLines.splice(i, i);

                        dispatchEvent(new Event("del_line"));
                    }
                }
            }
        }


        public function get sumOfLines():Number {
            return _sumOfLines;
        }

        public function set sumOfLines(value:Number):void {
            _sumOfLines = value;
        }
    }
}
