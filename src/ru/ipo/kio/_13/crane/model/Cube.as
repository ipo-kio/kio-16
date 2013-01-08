/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 14.11.12
 * Time: 0:52
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.model {
public class Cube {
    public var _color:int;
    public static const RED = 0xFF0000;
    public static const GREEN = 0x003300;
    public static const YELLOW = 0xFFFF00;
    public static const BLUE = 0x0000FF;


    public function Cube(color:int) {
        _color = color;

    }
    public function getColor(): int{
        return _color;}

    public function toString():String {
        switch (_color){
            case RED:
                return "к";
                break;
            case GREEN:
                return "з";
                break;
            case YELLOW:
                return "ж";
                break;
            case BLUE:
                return "г";
                break;
         //   case "": return "no";
         //   default: return "no";

        }
        return  String(_color);
    }

    public function get color():int {
        return _color;
    }

    public function set color(value:int):void {
        _color = value;
    }

}
}
