/**
 * Класс содержит возможные типы вокзалов
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model.types {

public final class ArrowStateType {

    public static const DIRECT:ArrowStateType = new ArrowStateType("direct");

    public static const LEFT:ArrowStateType = new ArrowStateType("left");

    public static const RIGHT:ArrowStateType = new ArrowStateType("right");

    private var _name:String;

    public function ArrowStateType(name:String) {
        _name = name;
    }

    public function get name():String {
        return _name;
    }
    
    public function next():ArrowStateType{
        if(this==DIRECT){
            return RIGHT;
        }else if(this==RIGHT){
            return LEFT;
        }else{
            return DIRECT;
        }
    }

    public function getString():String {
        if(this==DIRECT){
            return "|";
        }else if(this==RIGHT){
            return ">";
        }else{
            return "<";
        }
    }
}
}
