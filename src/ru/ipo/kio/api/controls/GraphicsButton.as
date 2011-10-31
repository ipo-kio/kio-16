/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.02.11
 * Time: 12:00
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api.controls {
import flash.display.BitmapData;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;

import ru.ipo.kio.api.TextUtils;

public class GraphicsButton extends SimpleButton {

    /**
     * Creates a graphical button. see http://code.google.com/p/ipo-issues/wiki/ActionScriptAddImage
     * on how to obtain BitmapData from embedded image.
     * ru.ipo.kio._11.digit.Workspace has an example on how to embed fonts.
     * (search ttf, change font path and name in your code)
     * @param title button text
     * @param up BitmapData - normal state
     * @param over BitmapData - mouse over state
     * @param down BitmapData - mouse down state
     * @param fontName Font name.
     * @param up_size font size in normal and mouse over states
     * @param down_size font size in down state
     */
    public function GraphicsButton(title:String, up:BitmapData, over:BitmapData, down:BitmapData, fontName:String, up_size:int, down_size:int, move_x:int = 0, move_y:int = 0) {
        var up_sprite:Sprite = createSprite(title, up, fontName, up_size, move_x < 0 ? move_x : 0, move_y < 0 ? move_y : 0);
        super(
                up_sprite,
                createSprite(title, over, fontName, up_size, move_x < 0 ? move_x : 0, move_y < 0 ? move_y : 0),
                createSprite(title, down, fontName, down_size, move_x > 0 ? move_x : 0, move_y > 0 ? move_y : 0),
                up_sprite
                );
    }

    private function createSprite(title:String, bmp:BitmapData, fontName:String, size:int, dx:int = 0, dy:int = 0):Sprite {
        var sprite:Sprite = new Sprite;

        sprite.graphics.beginBitmapFill(bmp);
        sprite.graphics.drawRect(0, 0, bmp.width, bmp.height);
        sprite.graphics.endFill();

        var textField:TextField = TextUtils.createTextFieldWithFont(fontName, size, false, true);
//        TextUtils.setTextForTextField(textField, title, fontName, size);
        //textField.htmlText = "<p>" + title + "</p>";
        textField.text = title;
        textField.x = dx + (bmp.width - textField.width) / 2;
        textField.y = dy + (bmp.height - textField.height) / 2;
        sprite.addChild(textField);

        return sprite;
    }

}
}
