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
import flash.text.TextFormat;
import flash.text.TextFormat;

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
     * @param move_x сдвиг текста на кнопке при нажатии по x
     * @param move_y сдвиг текста на кнопке при нажатии по y
     * @param dx общий сдвиг текста на кнопке относительно центра по x
     * @param dy общий сдвиг текста на кнопке относительно центра по y
     */
    public function GraphicsButton(title:String, up:*, over:*, down:*, fontName:String, up_size:int, down_size:int, move_x:int = 0, move_y:int = 0, dx:int = 0, dy:int = 0, noCenter:Boolean = false, fontColor:uint = 0x000000, bold:Boolean = false) {
        var size_inc_res:Array = getSizeInc(title);
        title = size_inc_res[0];
        up_size += size_inc_res[1];
        down_size += size_inc_res[1];

        var up_sprite:Sprite = createSprite(title, up, fontName, up_size, dx + (move_x < 0 ? move_x : 0), dy + (move_y < 0 ? move_y : 0), noCenter, fontColor, bold);
        super(
                up_sprite,
                createSprite(title, over, fontName, up_size, dx + (move_x < 0 ? move_x : 0), dy + (move_y < 0 ? move_y : 0), noCenter, fontColor, bold),
                createSprite(title, down, fontName, down_size, dx + (move_x > 0 ? move_x : 0), dy + (move_y > 0 ? move_y : 0), noCenter, fontColor, bold),
                up_sprite
        );
    }

    private static function getSizeInc(title:String):Array { //[new title, inc]
        if (title == null)
            return [title, 0];
        var at_pos:int = title.lastIndexOf('@@');
        if (at_pos < 0)
            return [title, 0];
        var res:int = int(title.substr(at_pos + 2));
        title = title.substr(0, at_pos);
        return [title, res];
    }

    private static function createSprite(title:String, bmp:*, fontName:String, size:int, dx:int = 0, dy:int = 0, noCenter:Boolean = false, fontColor:uint = 0x000000, bold:Boolean = false):Sprite {
        var sprite:Sprite = new Sprite;

        if (bmp is BitmapData) {
            var width:Number = bmp.width;
            var height:Number = bmp.height;
            sprite.graphics.beginBitmapFill(bmp);
            sprite.graphics.drawRect(0, 0, width, height);
            sprite.graphics.endFill();
        } else {
            for each (var b:BitmapData in bmp) {
                width = b.width;
                height = b.height;
                sprite.graphics.beginBitmapFill(b);
                sprite.graphics.drawRect(0, 0, width, height);
                sprite.graphics.endFill();
            }
        }

        var textField:TextField = TextUtils.createTextFieldWithFont(fontName, size, false, true, bold);
        textField.textColor = fontColor;
        textField.text = title;
        textField.mouseEnabled = false;
        if (noCenter) {
            textField.x = dx;
            textField.y = dy;
        } else {
            textField.x = dx + (width - textField.width) / 2;
            textField.y = dy + (height - textField.height) / 2;
        }
        sprite.addChild(textField);

        return sprite;
    }

}
}
