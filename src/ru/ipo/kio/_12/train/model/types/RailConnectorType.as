/**
 * Класс содержит возможные типы соединений
 *
 * (Левый нижний имеет вид |_)
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model.types {
public class RailConnectorType {

    public static const HORIZONTAL:RailConnectorType = new RailConnectorType("horizontal");

    public static const VERTICAL:RailConnectorType = new RailConnectorType("vertical");

    public static const TOP_LEFT:RailConnectorType = new RailConnectorType("top-left");

    public static const TOP_RIGHT:RailConnectorType = new RailConnectorType("top-right");

    public static const BOTTOM_LEFT:RailConnectorType = new RailConnectorType("bottom-left");

    public static const BOTTOM_RIGHT:RailConnectorType = new RailConnectorType("bottom-right");

    private var _name:String;

    public function RailConnectorType(name:String) {
        this._name = name;
    }

    public function get name():String {
        return _name;
    }

    public function toString():String {
        return "RailConnectorType{_name=" + String(_name) + "}";
    }
}
}
