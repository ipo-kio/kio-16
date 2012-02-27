/**
 * Класс содержит возможные типы вокзалов
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model.types {

public final class RegimeType {

    public static const EDIT:RegimeType = new RegimeType("edit");

    public static const STEP:RegimeType = new RegimeType("step");

    public static const PLAY:RegimeType = new RegimeType("play");

    public static const CALCULATE:RegimeType = new RegimeType("calculate");
    
    private var _name:String;

    public function RegimeType(name:String) {
        _name = name;
    }

    public function get name():String {
        return _name;
    }

}
}
