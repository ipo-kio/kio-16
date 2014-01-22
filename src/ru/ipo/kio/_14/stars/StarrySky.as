/**
 * Created by user on 22.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.events.Event;
import flash.events.EventDispatcher;

    public class StarrySky extends EventDispatcher {

        private var starsView:Array;
        private var starsLines:Array;


        public function StarrySky(starsView:Array) {
            this.starsView = starsView;
            starsLines = [];
        }

        public function addLine(a:int, b:int):void {
            for (var i:int = 0; i < starsView.length; i++) {
                if (starsView[i].index == a) {
                    for (var j:int = 0; j < starsView.length; j++) {
                        if (starsView[j].index == b) {
                            starsView.push([starsView[i], starsView[j]]);
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
                        starsLines.splice(i, i);
                        dispatchEvent(new Event("del_line"));
                    }
                }
            }
        }
    }
}
