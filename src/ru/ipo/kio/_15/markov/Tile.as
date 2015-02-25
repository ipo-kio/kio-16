/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {

public class Tile extends BasicView{

    private var _symbol:Symbol;
    private var _select:Boolean;



    public function Tile(symbol:Symbol, select:Boolean=false) {
        super(true);
        this._symbol = symbol;
        this._select=select;
    }


    public function get symbol():Symbol {
        return _symbol;
    }


    public function get select():Boolean {
        return _select;
    }

    public function set select(value:Boolean):void {
        _select = value;
    }

    public override function update():void {
        clear();

        var bg = ImageHolder.getVegetable(symbol.code);

        if(RuleManager.instance.level==2){
            bg = ImageHolder.getVegetableOver(symbol.code);
        }

        if(_select) {
            var bg = ImageHolder.getVegetableSelected(symbol.code);
        }

        addChild(bg);
    }




}
}
