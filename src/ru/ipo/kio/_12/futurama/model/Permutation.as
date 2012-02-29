/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 25.02.12
 * Time: 10:03
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.futurama.model {
import flash.events.Event;
import flash.events.EventDispatcher;

public class Permutation extends EventDispatcher {
    
    public static const PERMUTATION_CHANGED:String = 'permutation changed';
    private static const PERMUTATION_CHANGED_EVENT:Event = new Event(PERMUTATION_CHANGED);

    public static const STATUS_OK:int = 0;
    public static const STATUS_BASE_COLLISION:int = 1;
    public static const STATUS_VALUE_COLLISION:int = 2;
    public static const STATUS_INVALID_TRANSPOSITION:int = 3; //negative or equal elements

    private var _base_transpositions:Array/*Transposition*/ = [];
    private var _value_transpositions:Array/*Transposition*/ = [];
    private var _base_transpositions_redo_history:Array/*Transposition*/ = [];
    private var _value_transpositions_redo_history:Array/*Transposition*/ = [];
    
    private var _permutation:Array;
    private var _inv_permutation:Array;
    private var _n:int;
    
    public function Permutation(n:int) {
        _n = n;
        init_permutation();
    }

    public function permute_values(value1:int, value2:int, just_test:Boolean = false):int {
        return permute(inv_permutation[value1], inv_permutation[value2], just_test);
    }

    /**
     * Transpose elements
     * @param base1 first index
     * @param base2 second index
     * @param just_test true if no permutation needed
     * @return status: STATUS_OK, STATUS_BASE_COLLISION, STATUS_VALUE_COLLISION
     */
    public function permute(base1:int, base2:int, just_test:Boolean = false):int {
        if (base1 == base2)
            return STATUS_INVALID_TRANSPOSITION;
        
        var base_tr:Transposition = new Transposition(base1, base2);
        var value_tr:Transposition = new Transposition(_permutation[base1], _permutation[base2]);
        
        //test for base collision
        for (var i:int = 0; i < _base_transpositions.length; i++)
            if (base_tr.equals(_base_transpositions[i]))
                return STATUS_BASE_COLLISION;

        //test for value collision
        for (i = 0; i < _value_transpositions.length; i++)
            if (value_tr.equals(_value_transpositions[i]))
                return STATUS_VALUE_COLLISION;

        if (! just_test) {
            base_tr.apply(_permutation);
            value_tr.apply(_inv_permutation);

            _base_transpositions.push(base_tr);
            _value_transpositions.push(value_tr);

            dispatchEvent(PERMUTATION_CHANGED_EVENT);
        }

        _base_transpositions_redo_history = [];
        _value_transpositions_redo_history = [];
        
        return STATUS_OK;
    }
    
    public function serialize():Object {
        var o:Object = {length: _base_transpositions.length};
        for (var i:int = 0; i < _base_transpositions.length; i++)
            o[i] = {a: _base_transpositions[i].e1, b: _base_transpositions[i].e2};
        return o;
    }
    
    public function unseriazlize(o:Object) : void {
        _base_transpositions = [];
        _value_transpositions = [];
        _base_transpositions_redo_history = [];
        _value_transpositions_redo_history = [];
        init_permutation();
        
        for (var i:int = 0; i < o.length; i++)
            permute(o[i].a, o[i].b);

        dispatchEvent(PERMUTATION_CHANGED_EVENT);
    }
    
    public function canUndo():Boolean {
        return _base_transpositions.length > 0;
    }
    
    public function canRedo():Boolean {
        return _base_transpositions_redo_history.length > 0;
    }
    
    public function undo():void {
        if (!canUndo())
            return;
        
        var tr_b:Transposition = _base_transpositions.pop();
        var tr_v:Transposition = _value_transpositions.pop();
        _base_transpositions_redo_history.push(tr_b);
        _value_transpositions_redo_history.push(tr_v);
        tr_b.apply(_permutation);
        tr_v.apply(_inv_permutation);

        dispatchEvent(PERMUTATION_CHANGED_EVENT);
    }
    
    public function redo():void {
        if (!canRedo())
            return;

        var tr_b:Transposition = _base_transpositions_redo_history.pop();
        var tr_v:Transposition = _value_transpositions_redo_history.pop();
        _base_transpositions.push(tr_b);
        _value_transpositions.push(tr_v);
        tr_b.apply(_permutation);
        tr_v.apply(_inv_permutation);

        dispatchEvent(PERMUTATION_CHANGED_EVENT);
    }

    private function init_permutation():void {
        _permutation = [];
        _inv_permutation = [];
        for (var i:int = 0; i < _n; i++) {
            _permutation[i] = i;
            _inv_permutation[i] = i;
        }
    }

    public function get n():int {
        return _n;
    }

    public function get base_transpositions():Array {
        return _base_transpositions;
    }

    public function get value_transpositions():Array {
        return _value_transpositions;
    }

    public function get permutation():Array {
        return _permutation;
    }

    public function get inv_permutation():Array {
        return _inv_permutation;
    }

    public function get base_transpositions_redo_history():Array {
        return _base_transpositions_redo_history;
    }

    public function get value_transpositions_redo_history():Array {
        return _value_transpositions_redo_history;
    }
}
}
