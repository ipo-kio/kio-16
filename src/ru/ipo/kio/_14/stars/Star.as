/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
    public class Star {

        private var _x:Number;
        private var _y:Number;
        private var _radius:int;

        private var _index:int;

        public function Star(x:Number, y:Number, radius:int) {
            this._x = x;
            this._y = y;
            this._radius = radius;
        }

        public function get x():Number {
            return _x;
        }

        public function set x(value:Number):void {
            _x = value;
        }

        public function get y():Number {
            return _y;
        }

        public function set y(value:Number):void {
            _y = value;
        }

        public function get radius():int {
            return _radius;
        }
        public function get index():int {
            return _index;
        }

        public function set index(value:int):void {
            _index = value;
        }
    }
}
