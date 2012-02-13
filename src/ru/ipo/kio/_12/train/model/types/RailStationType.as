/**
 * Класс содержит возможные типы вокзалов
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model.types {

public final class RailStationType {

    public static const FIRST:RailStationType = new RailStationType(0xcd5c5c);

    public static const SECOND:RailStationType = new RailStationType(0x4682b4);

    public static const THIRD:RailStationType = new RailStationType(0x00ff00);

    public static const FOURTH:RailStationType = new RailStationType(0xffff00);
    
    private var _color:int;

    public function RailStationType(color:int) {
        _color = color;
    }

    public function get color():int {
        return _color;
    }

    public function set color(value:int):void {
        _color = value;
    }
}
}
