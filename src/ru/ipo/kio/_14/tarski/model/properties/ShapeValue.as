/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.properties {
public class ShapeValue {

    public static const SPHERE:String = "sphere";
    public static const CUBE:String = "cube";


    private var _code:String;
    private var _name:String;

    public function ShapeValue(code:String, name:String) {
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
