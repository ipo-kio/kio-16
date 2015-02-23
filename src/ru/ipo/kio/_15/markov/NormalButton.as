/**
 * Created by Vasiliy on 23.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.display.DisplayObject;
import flash.display.SimpleButton;

public class NormalButton extends SimpleButton {

    private var oldUpState:DisplayObject;

    public function NormalButton(upState:flash.display.DisplayObject = null,overState:flash.display.DisplayObject = null,downState:flash.display.DisplayObject = null,hitTestState:flash.display.DisplayObject = null):*{
        super(upState, overState, downState, hitTestState);
        oldUpState = upState;
    }


    public function enable(enable:Boolean){
        mouseEnabled = enable;
        enabled = enable;
        if(enable) {
            upState = oldUpState;
        }else{
            upState = hitTestState;
        }
    }

}
}
