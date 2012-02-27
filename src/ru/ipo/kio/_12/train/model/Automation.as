/**
 *
 * @author: Vasily Akimushkin
 * @since: 26.02.12
 */
package ru.ipo.kio._12.train.model {
import ru.ipo.kio._12.train.model.types.ArrowStateType;
import ru.ipo.kio._12.train.util.StatePair;

public class Automation {

    private static var _instance:Automation;

    public static function get instance():Automation {
        if(Automation._instance == null)
            Automation._instance=new Automation(new PrivateClass( ));
        return _instance;
    }

    private var _states:Vector.<AutomationStep> = new Vector.<AutomationStep>();

    public function Automation(privateClass:PrivateClass) {
    }

    public function get states():Vector.<AutomationStep> {
        return _states;
    }

    public function set states(value:Vector.<AutomationStep>):void {
        _states = value;
    }

    public function removeStep(step:AutomationStep):void {
        for(var i:int = 0; i<states.length; i++){
            if(states[i]==step){
                states.splice(i,1);
                return;
            }
        }
    }

    public function getStep(state:int, crossType:ArrowStateType):StatePair {
        for(var i:int = 0; i<states.length; i++){
            if(states[i].number==state){
                if(crossType == ArrowStateType.DIRECT){
                    return new StatePair(states[i].directStep, states[i].directArrowState);
                }else if(crossType == ArrowStateType.LEFT){
                    return new StatePair(states[i].leftStep, states[i].leftArrowState);
                }else if(crossType == ArrowStateType.RIGHT){
                    return new StatePair(states[i].rightStep, states[i].rightArrowState);
                }
            }
        }
        throw new Error("can't find step for "+state);
    }
}
}

class PrivateClass{
    public function PrivateClass(){

    }
}
