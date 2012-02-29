/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 23.02.12
 * Time: 21:28
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.display.Sprite;
import flash.text.TextField;

import ru.ipo.kio.api.TextUtils;

public class InfoField extends Sprite {

    private var  title_field:TextField;
    private var data_values_fields:Array/*TextField*/;

    public function InfoField(title:String, data_titles:Array/*String*/, skip:int) {
        skip = 0;
        title_field = TextUtils.createTextFieldWithFont('KioTahoma', 13, false);

        title_field.text = title;
        title_field.textColor = 0x000000;

        addChild(title_field);

        var data_fields:Array = [];

        var previous_field:TextField = title_field;
        var max_width:int = 0;

        for each (var data_title:String in data_titles) {
            var new_field:TextField = TextUtils.createTextFieldWithFont('KioTahoma', 13, false);
            new_field.textColor = 0x0000;
            new_field.y = previous_field.y + previous_field.textHeight + skip;
            data_fields.push(new_field);
            addChild(new_field);

            new_field.text = data_title;

            if (new_field.textWidth > max_width)
                max_width = new_field.textWidth;

            previous_field = new_field;
        }

        data_values_fields = [];

        for (var i:int = 0; i < data_fields.length; i++) {
            var data_field:TextField = data_fields[i];
            new_field = TextUtils.createTextFieldWithFont('KioTahoma', 13, false);
            new_field.textColor = 0x000000;
            new_field.x = max_width + 10;
            new_field.y = data_field.y;

            addChild(new_field);

            data_values_fields.push(new_field);
        }
    }

    public function set_values(values:Array):void {
        for (var i:int = 0; i < values.length; i++)
            data_values_fields[i].text = Math.round(values[i] * 1000000) / 1000000;
    }
}
}
