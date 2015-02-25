/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.utils.Dictionary;

public class SettingsManager {

    private static var _instance:SettingsManager = new SettingsManager();

    public static function get instance():SettingsManager {
        return _instance;
    }

    private var _level:int=0;

    private var _areaWidth = 780;

    private var _areaHeight = 600;

    private var _tileAmount = 16;

    private var _tileWidth = 47;

    private var _tileHeight = 81;

    private var _ridgeHeight = 90;


    public function set level(value:int):void {
        _level = value;
    }

    public function SettingsManager() {
    }


    public function get ridgeHeight():int {
        return _ridgeHeight;
    }

    public function get ridgeWidth():int {
        return _areaWidth;
    }


    public function get tileWidth():* {
        if(RuleManager.instance.level==2){
            return 35;
        }


        if(_level==0) {
            return 47;
        }
        else{
            return 44;
        }
    }

    public function get tileHeight():* {
        if(RuleManager.instance.level==2){
            return 48;
        }

        if(RuleManager.instance.level==1){
            return 60;
        }

        return _tileHeight;
    }

    public function get tileAmount():int {
        return _tileAmount;
    }


    public function set tileAmount(value:int):void {
        _tileAmount = value;
    }

    public function get areaWidth():* {
        return _areaWidth;
    }

    public function get areaHeight():* {
        return _areaHeight;
    }

    public function get space():int {
        return 5;
    }

    public function get smallSpace():int {
        return 2;
    }

    public function get ruleWidth():int {
        if(RuleManager.instance.level==1 || RuleManager.instance.level==0){
            return _areaWidth - tileWidth - 16;
        }else {
            return _areaWidth - tileWidth - 26;
        }
    }

    public function get ruleHeight():int {

        if(RuleManager.instance.level==1){
            return 400;
        }else if(RuleManager.instance.level==2){
            return (tileHeight+smallSpace)*7;
        }else {
            return (tileHeight+smallSpace)*4;
        }


    }

    public static function countKeys(myDictionary:flash.utils.Dictionary):int
    {
        var n:int = 0;
        for (var key:* in myDictionary) {
            n++;
        }
        return n;
    }


}
}
