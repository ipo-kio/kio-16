/**
 * Класс содержит возможные типы рельсов
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model.types {

public final class RailType {

    public static const ROUND_TOP_RIGHT:RailType = new RailType(4, "round-top-right");

    public static const ROUND_TOP_LEFT:RailType = new RailType(4, "round-top-left");

    public static const ROUND_BOTTOM_RIGHT:RailType = new RailType(4, "round-bottom-right");

    public static const ROUND_BOTTOM_LEFT:RailType = new RailType(4, "round-bottom-left");

    public static const SEMI_ROUND_TOP:RailType = new RailType(2, "semi-round-top");

    public static const SEMI_ROUND_BOTTOM:RailType = new RailType(2, "semi-round-bottom");

    public static const SEMI_ROUND_RIGHT:RailType = new RailType(2, "semi-round-right");

    public static const SEMI_ROUND_LEFT:RailType = new RailType(2, "semi-round-left");

    public static const VERTICAL:RailType = new RailType(1, "vertical");

    public static const HORIZONTAL:RailType = new RailType(1, "horizontal");

    private var _length:int;
    
    private var _name:String;

    public function RailType(length:int, name:String) {
        _length = length;
        _name = name;
    }

    public function get length():int {
        return _length;
    }

    public function toString():String {
        return "RailType{_length=" + String(_length) + ",_name=" + String(_name) + "}";
    }

    public function getConnector(arrow:ArrowStateType, first:Boolean):RailConnectorType{
        if(arrow == ArrowStateType.DIRECT){
            if(this==HORIZONTAL ||
               this==SEMI_ROUND_LEFT||
               this==SEMI_ROUND_RIGHT||
               (this==ROUND_TOP_LEFT && first)||
               (this==ROUND_TOP_RIGHT && !first)||
               (this==ROUND_BOTTOM_RIGHT && first)||
               (this==ROUND_BOTTOM_LEFT && !first)){
                return RailConnectorType.HORIZONTAL;
            }else{
                return RailConnectorType.VERTICAL;
            }
        }else if(arrow == ArrowStateType.RIGHT){
            if(this==HORIZONTAL && first)
                return RailConnectorType.BOTTOM_LEFT;
            else if(this==HORIZONTAL && !first)
                return RailConnectorType.TOP_RIGHT;
            else if(this==VERTICAL && first)
                return RailConnectorType.TOP_LEFT;
            else if(this==VERTICAL && !first)
                return RailConnectorType.BOTTOM_RIGHT;
            else if(this==SEMI_ROUND_TOP || (this==ROUND_TOP_LEFT && !first)|| (this==ROUND_BOTTOM_RIGHT && !first))
                return RailConnectorType.BOTTOM_RIGHT;
            else if(this==SEMI_ROUND_BOTTOM || (this==ROUND_BOTTOM_LEFT && !first))
                return RailConnectorType.TOP_RIGHT;
            else if(this==SEMI_ROUND_LEFT)
                return RailConnectorType.TOP_RIGHT;
            else if(this==SEMI_ROUND_RIGHT || (this==ROUND_TOP_RIGHT && !first))
                return RailConnectorType.BOTTOM_LEFT;
        } else if(arrow == ArrowStateType.LEFT){
            if(this==HORIZONTAL && first)
                return RailConnectorType.TOP_LEFT;
            else if(this==HORIZONTAL && !first)
                return RailConnectorType.BOTTOM_RIGHT;
            else if(this==VERTICAL && first)
                return RailConnectorType.TOP_RIGHT;
            else if(this==VERTICAL && !first)
                return RailConnectorType.BOTTOM_LEFT;
            else if(this==SEMI_ROUND_TOP  || (this==ROUND_TOP_LEFT && !first))
                return RailConnectorType.BOTTOM_LEFT;
            else if(this==SEMI_ROUND_BOTTOM || (this==ROUND_BOTTOM_LEFT && !first))
                return RailConnectorType.TOP_RIGHT;
            else if(this==SEMI_ROUND_LEFT)
                return RailConnectorType.BOTTOM_RIGHT;
            else if(this==SEMI_ROUND_RIGHT || (this==ROUND_TOP_RIGHT && !first) || (this==ROUND_BOTTOM_RIGHT && !first))
                return RailConnectorType.TOP_LEFT;

        }
        throw new Error("Can't get connector... ");

    }

    public function get name():String {
        return _name;
    }
}
}
