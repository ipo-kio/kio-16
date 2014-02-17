/**
 * Created by ilya on 31.01.14.
 */
package ru.ipo.kio._14.peterhof {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class TitledObject extends Sprite {

    public function TitledObject(title:String, size:int, color:uint, sprite:Sprite, skip:Number = 0) {
        var tf:TextField = new TextField();
        tf.selectable = false;
        tf.embedFonts = true;
        tf.defaultTextFormat = new TextFormat("KioTahoma", size, color);
        tf.autoSize = TextFieldAutoSize.LEFT;
        addChild(tf);
        tf.text = title;

        sprite.x = skip == 0 ? tf.width : skip;
        sprite.y = 2 * size - sprite.height;
        addChild(sprite);
    }
}
}
