/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 01.02.13
 * Time: 13:30
 */
package ru.ipo.kio._13.cut {
import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio.api.controls.TextButton;

public class CutControls extends Sprite {

    private var _w:int;
    private var _h:int;
    private var _switchFieldsButton:SimpleButton;
    private var _numTextField:TextField = new TextField();

    public function CutControls(w:int, h:int) {
        _w = w;
        _h = h;

        drawBackground();

        _switchFieldsButton = new TextButton("переключить");

        putSprite(_switchFieldsButton, 10);

        _numTextField.defaultTextFormat = new TextFormat('Times new Roman', 18);
        _numTextField.autoSize = TextFieldAutoSize.CENTER;
        putSprite(_numTextField, 40);
    }

    private function putSprite(s:DisplayObject, y:int):void {
        s.x = (_w - s.width) / 2;
        s.y = y;
        addChild(s);
    }

    private function drawBackground():void {
        graphics.beginFill(0x008800);
        graphics.drawRect(0, 0, _w, _h);
        graphics.endFill();
    }

    public function get switchFieldsButton():SimpleButton {
        return _switchFieldsButton;
    }

    public function set numPolys(polys:int):void {
        _numTextField.text = "Многоугольников: " + polys;
    }
}
}
