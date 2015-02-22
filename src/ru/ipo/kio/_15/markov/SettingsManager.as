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

    private var _areaWidth = 780;

    private var _areaHeight = 600;

    private var _tileAmount = 16;

    private var _tileWidth = 47;

    private var _tileHeight = 81;

    private var _ridgeHeight = 90;


    public function SettingsManager() {
    }


    public function get ridgeHeight():int {
        return _ridgeHeight;
    }

    public function get ridgeWidth():int {
        return _areaWidth;
    }


    public function get tileWidth():* {
        return _tileWidth;
    }

    public function get tileHeight():* {
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
        return _areaWidth - tileWidth;
    }

    public function get ruleHeight():int {
        return (tileHeight+smallSpace)*countKeys(Symbol.dictionary);
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
