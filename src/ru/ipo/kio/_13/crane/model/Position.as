/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 14.11.12
 * Time: 1:30
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.model {

    public class Position {
        private var _i: int;
        private var _j: int;

        public function Position(row: int, column: int){
            _i = row;
            _j = column;
        }
        public function get i(): int{
            return _i;
        }
        public function set i(value: int){
            _i = value;
        }
        public function get j(): int{
            return _j;
        }
        public function set j(value: int){
            _j = value;
        }


        public function toString():String {
            return "Position{_x=" + String(_i) + ",_y=" + String(_j) + "}";
        }
    }
}
