/**
 * Класс содержит возможные типы вокзалов
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model.types {

public final class StationType {

    public static const FIRST:StationType = new StationType(0, "first", 0xcd5c5c);

    public static const SECOND:StationType = new StationType(2, "second", 0x4682b4);

    public static const THIRD:StationType = new StationType(1, "third", 0x00ff00);

    public static const FOURTH:StationType = new StationType(3, "fourth", 0xffff00);

    private static var values:Array;
    
    private var _number:int;
    
    private var _color:int;
    
    private var _name:String;

    public function StationType(number:int, name:String, color:int) {
        _number = number;
        _name = name;
        _color = color;
        if(values == null){
            values = new Array();
        }
        values.push(this);
    }

    public function get color():int {
        return _color;
    }

    public function get name():String {
        return _name;
    }

    public function toString():String {
        return "StationType{_name=" + String(_name) + "}";
    }

    public static function getByNumber(number:int):StationType {
        for(var i:int = 0; i<values.length; i++){
            if(values[i]._number==number){
                return values[i];
            }
        }
        throw new Error("Can't find type by number "+number);
    }

    public function get number():int {
        return _number;
    }
}
}
