/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.properties {
public class ColorValue {

    public static const RED:String = "red";
    public static const BLUE:String = "blue";

    private var _code:String;
    private var _name:String;
    private var _color:uint;

    public function ColorValue(code:String, name:String, color:uint) {
        _code = code;
        _name = name;
        _color = color;
    }

    public function get code():String {
        return _code;
    }

    public function get name():String {
        return _name;
    }

    public function get color():uint {
        return _color;
    }


}
}
