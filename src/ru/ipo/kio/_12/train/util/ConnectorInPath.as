/**
 *
 * @author: Vasily Akimushkin
 * @since: 23.02.12
 */
package ru.ipo.kio._12.train.util {
import ru.ipo.kio._12.train.model.types.RailConnectorType;
import ru.ipo.kio._12.train.model.types.RailStationType;

public class ConnectorInPath {

    private var _type:RailConnectorType;

    private var _index:int;

    private var _time:int;
    
    private var _color:int;

    private var _active:Boolean;


    public function ConnectorInPath(type:RailConnectorType, index:int, time:int, color:int, active:Boolean) {
        _type = type;
        _index = index;
        _time = time;
        _color = color;
        _active = active;
    }

    public function get type():RailConnectorType {
        return _type;
    }

    public function set type(value:RailConnectorType):void {
        _type = value;
    }

    public function get time():int {
        return _time;
    }

    public function set time(value:int):void {
        _time = value;
    }


    public function get index():int {
        return _index;
    }

    public function set index(value:int):void {
        _index = value;
    }

    public function get color():int {
        return _color;
    }

    public function set color(value:int):void {
        _color = value;
    }

    public function get active():Boolean {
        return _active;
    }

    public function set active(value:Boolean):void {
        _active = value;
    }
}
}
