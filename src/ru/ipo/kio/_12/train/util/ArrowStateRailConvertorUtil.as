/**
 * Created by IntelliJ IDEA.
 * User: vakimushkin
 * Date: 27.02.12
 * Time: 9:03
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.train.util {
import ru.ipo.kio._12.train.model.RailEnd;
import ru.ipo.kio._12.train.model.types.ArrowStateType;
import ru.ipo.kio._12.train.model.types.RailType;

public class ArrowStateRailConvertorUtil {
    public function ArrowStateRailConvertorUtil() {
    }
    
    public static function getStateByEnd(end:RailEnd,  type:ArrowStateType):ArrowStateType{
        if(type == ArrowStateType.DIRECT){
            return ArrowStateType.DIRECT;
        }else if(end.rail.type==RailType.HORIZONTAL ||
                end.rail.type==RailType.SEMI_ROUND_LEFT ||
                end.rail.type==RailType.SEMI_ROUND_RIGHT ||
                (end.rail.type==RailType.ROUND_TOP_LEFT && end.isFirst())||
                (end.rail.type==RailType.ROUND_TOP_RIGHT && !end.isFirst())||
                (end.rail.type==RailType.ROUND_BOTTOM_RIGHT && end.isFirst())||
                (end.rail.type==RailType.ROUND_BOTTOM_LEFT && !end.isFirst())){
            if(type == ArrowStateType.LEFT){
                return ArrowStateType.RIGHT;
            }else{
                return ArrowStateType.LEFT;
            }
        }else{
            return type;
        }
    }

    public static function getStateByEndToNormal(end:RailEnd, type:ArrowStateType):ArrowStateType {
        if(type == ArrowStateType.DIRECT){
            return ArrowStateType.DIRECT;
        }else if(end.rail.type==RailType.HORIZONTAL ||
                end.rail.type==RailType.SEMI_ROUND_LEFT ||
                end.rail.type==RailType.SEMI_ROUND_RIGHT ||
                (end.rail.type==RailType.ROUND_TOP_LEFT && end.isFirst())||
                (end.rail.type==RailType.ROUND_TOP_RIGHT && !end.isFirst())||
                (end.rail.type==RailType.ROUND_BOTTOM_RIGHT && end.isFirst())||
                (end.rail.type==RailType.ROUND_BOTTOM_LEFT && !end.isFirst())){
            if(type == ArrowStateType.LEFT){
                return ArrowStateType.RIGHT;
            }else{
                return ArrowStateType.LEFT;
            }
        }else{
            return type;
        }
    }
}
}
