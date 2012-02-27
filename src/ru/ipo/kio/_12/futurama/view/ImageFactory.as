/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 26.02.12
 * Time: 10:11
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.futurama.view {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import ru.ipo.kio.api.TextUtils;

public class ImageFactory {
    
    public static function getImage(base:int, value:int, small:Boolean = false):DisplayObject {
        var s:Sprite = new Sprite();

        if (small) {
            var w0:int = 30;
            var h0:int = 15;
            var ts:int = 20;
        } else {
            w0 = 60;
            h0 = 30;
            ts = 22;
        }
        
        s.graphics.beginFill(0x00FFFF, value < 0 ? 0.5 : 1);
        s.graphics.drawRect(0, 0, w0, h0);
        s.graphics.beginFill(0xFFFF00, base < 0 ? 0.5 : 1);
        s.graphics.drawRect(0, h0, w0, h0);
        
        if (base >= 0) {
            var tfBase:TextField = new TextField();
            tfBase.text = String.fromCharCode('a'.charCodeAt() + base);
            tfBase.autoSize = TextFieldAutoSize.LEFT;
            tfBase.x = 6;
            tfBase.y = h0 + 6;
            s.addChild(tfBase);
        }

        if (value >= 0) {
            var tfValue:TextField = new TextField();
            tfValue.selectable = false;
            tfValue.text = '' + (value + 1);
            tfValue.autoSize = TextFieldAutoSize.LEFT;
            tfValue.x = 6;
            tfValue.y = 6;
            s.addChild(tfValue);
        }

        return s;
    }
}
}
