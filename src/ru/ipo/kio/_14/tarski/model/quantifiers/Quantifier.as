/**
 * @author: Vasily Akimushkin
 * @since: 31.01.14
 */
package ru.ipo.kio._14.tarski.model.quantifiers {
public class Quantifier {

    public static const ALL = "all";
    public static const EXIST = "exist";

    private var code:String;


    public function Quantifier(code:String) {
        this.code = code;
    }

    /**
     * Формальный параметр (код)
     */
    private var _formalOperand:String;

    public function set operand(value:String):void {
        _formalOperand = value;
    }


    public function get formalOperand():String {
        return _formalOperand;
    }
}
}
