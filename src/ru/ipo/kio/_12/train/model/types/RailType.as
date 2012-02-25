/**
 * Класс содержит возможные типы рельсов
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model.types {

public final class RailType {

    public static const ROUND_TOP_RIGHT:RailType = new RailType(2, "round-top-right");

    public static const ROUND_TOP_LEFT:RailType = new RailType(2, "round-top-left");

    public static const ROUND_BOTTOM_RIGHT:RailType = new RailType(2, "round-bottom-right");

    public static const ROUND_BOTTOM_LEFT:RailType = new RailType(2, "round-bottom-left");

    public static const SEMI_ROUND_TOP:RailType = new RailType(2, "semi-round-top");

    public static const SEMI_ROUND_BOTTOM:RailType = new RailType(2, "semi-round-bottom");

    public static const SEMI_ROUND_RIGHT:RailType = new RailType(2, "semi-round-right");

    public static const SEMI_ROUND_LEFT:RailType = new RailType(2, "semi-round-left");

    public static const VERTICAL:RailType = new RailType(1, "vertical");

    public static const HORIZONTAL:RailType = new RailType(1, "vertical");

    private var _length:int;
    
    private var _name:String;

    public function RailType(length:int, name:String) {
        _length = length;
        _name = name;
    }

    public function get length():int {
        return _length;
    }

    public function toString():String {
        return "RailType{_length=" + String(_length) + ",_name=" + String(_name) + "}";
    }
}
}
