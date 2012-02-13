/**
 * Класс содержит возможные типы рельсов
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model.types {

public final class RailType {

    public static const ROUND_TOP_RIGHT:RailType = new RailType(2);

    public static const ROUND_TOP_LEFT:RailType = new RailType(2);

    public static const ROUND_BOTTOM_RIGHT:RailType = new RailType(2);

    public static const ROUND_BOTTOM_LEFT:RailType = new RailType(2);

    public static const SEMI_ROUND_TOP:RailType = new RailType(2);

    public static const SEMI_ROUND_BOTTOM:RailType = new RailType(2);

    public static const SEMI_ROUND_RIGHT:RailType = new RailType(2);

    public static const SEMI_ROUND_LEFT:RailType = new RailType(2);

    public static const VERTICAL:RailType = new RailType(1);

    public static const HORIZONTAL:RailType = new RailType(1);

    private var _length:int;

    public function RailType(length:int) {
        _length = length;
    }

    public function get length():int {
        return _length;
    }

}
}
