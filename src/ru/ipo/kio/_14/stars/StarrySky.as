/**
 * Created by user on 22.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.events.Event;
import flash.events.EventDispatcher;

    public class StarrySky extends EventDispatcher {

        private var starsView:Array;
        private static var starsLines:Array;


        public function StarrySky(starsView:Array) {
            this.starsView = starsView;
            starsLines = [];
        }

        public static function addLine():void {

            dispatchEvent(new Event("add_new_line"));
        }

        public static function deleteLine():void {

            dispatchEvent(new Event("del_line"));
        }
    }
}
