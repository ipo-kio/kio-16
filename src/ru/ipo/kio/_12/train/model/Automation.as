/**
 *
 * @author: Vasily Akimushkin
 * @since: 26.02.12
 */
package ru.ipo.kio._12.train.model {
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
}
}

class PrivateClass{
    public function PrivateClass(){

    }
}
