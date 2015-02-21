/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.utils.Dictionary;

public class Symbol {

    private var _code:String;

    private static var _dictionary:Dictionary = new Dictionary();

    public function Symbol(code:String) {
        this._code = code;
    }

    public static function getSymbol(code):Symbol{
        if(_dictionary[code]==null){
            var symbol:Symbol = new Symbol(code);
            _dictionary[code]=symbol;
        }
        return _dictionary[code];
    }


    public static function get dictionary():Dictionary {
        return _dictionary;
    }

    public function get code():String {
        return _code;
    }
}
}
