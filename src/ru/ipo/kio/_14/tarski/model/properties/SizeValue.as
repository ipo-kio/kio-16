/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.properties {
public class SizeValue {

    public static const BIG:String = "big";
    public static const SMALL:String = "small";

    private var _code:String;
    private var _name:String;


    public function SizeValue(code:String, name:String) {
        _code = code;
        _name = name;
    }

    public function get code():String {
        return _code;
    }

    public function get name():String {
        return _name;
    }
}
}
