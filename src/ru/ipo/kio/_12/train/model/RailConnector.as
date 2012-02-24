/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model {
import ru.ipo.kio._12.train.model.types.RailConnectorType;

public class RailConnector extends VisibleEntity {
    
    private var _type:RailConnectorType;

    private var _firstEnd:RailEnd;

    private var _secondEnd:RailEnd;
    
    public function RailConnector(type:RailConnectorType,  firstEnd:RailEnd, secondEnd:RailEnd) {
        this._type = type;
        this._firstEnd=firstEnd;
        this._secondEnd=secondEnd;
        firstEnd.addConnector(this);
        secondEnd.addConnector(this);
    }
    
    public function getAnotherRail(rail:Rail):Rail{
        if(_firstEnd.rail == rail){
            return _secondEnd.rail;
        }else if(_secondEnd.rail == rail){
            return _firstEnd.rail;
        }else{
            throw new Error("There is no such rail in connector");
        }
    }

    public function getAnotherEnd(end:RailEnd):RailEnd{
        if(_firstEnd==end){
            return _secondEnd;
        }else if(_secondEnd==end){
            return _firstEnd;
        }else{
            return null;
        }
    
    }

    public function get type():RailConnectorType {
        return _type;
    }

    public function set type(value:RailConnectorType):void {
        _type = value;
    }


    public function toString():String {
        return "[type: "+_type.name+"]";
    }


    public function get firstEnd():RailEnd {
        return _firstEnd;
    }

    public function get secondEnd():RailEnd {
        return _secondEnd;
    }
}
}
