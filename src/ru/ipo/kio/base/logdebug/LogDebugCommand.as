/**
 *
 * @author: Vasiliy
 * @date: 05.05.13
 */
package ru.ipo.kio.base.logdebug {
public class LogDebugCommand {
    private var _text:String;
    private var _time:String;
    private var _humanTime:String;

    public function LogDebugCommand(text:String) {
        var items:Array = text.split(";");
        if(items.length>=3){
            _time = items[0];
            _humanTime = items[1];
            _text="";
            for(var i:int= 2; i<items.length; i++){
                _text += items[i];
            }
        }else{
            _text=text;
        }
    }

    public function get text():String {
        return _text;
    }
}
}
