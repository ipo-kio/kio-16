/**
 * Created by Vasiliy on 23.02.2015.
 */
package ru.ipo.kio._15.markov {
public class Example extends BasicView {

    private var _str:String;

    private var _select:Boolean = false;

        private var _wrong:Boolean = false;

    public function Example(str:String) {
        this._str = str;
    }


    public function get wrong():Boolean {
        return _wrong;
    }

    public function set wrong(value:Boolean):void {
        _wrong = value;
    }

    public function get select():Boolean {
        return _select;
    }

    public function set select(value:Boolean):void {
        _select = value;
    }

    public function get str():String {
        return _str;
    }

    public function set str(value:String):void {
        _str = value;
    }

    public override function update():void {
        clear();
        addChildTo(createField(str, 20), 0, 0);
        if (wrong) {
            graphics.beginFill(0xFF0000);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
        }
    }





}
}
