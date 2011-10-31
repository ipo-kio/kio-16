/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 16.02.11
 * Time: 22:37
 */
package ru.ipo.kio._11.semiramida {
import flash.display.Sprite;
import flash.text.TextField;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;

public class ResultsPanel extends Sprite {

    private var _rooms:int;
    private var _pipesLength:int;

    private var ftRooms:TextField;
    private var ftLength:TextField;

    private var loc:Object = KioApi.getLocalization(SemiramidaProblem.ID);

    public static const LINE_SKIP:int = 0;
    public static const FONT_SIZE:int = 16;

    private var field_width:int;

    public function ResultsPanel(caption:String, width:int) {
        field_width = width;

        var api:KioApi = KioApi.instance(SemiramidaProblem.ID);

        var ftCaption:TextField = TextUtils.createTextFieldWithFont("KioBosano", FONT_SIZE, false);
        ftCaption.text = caption;
        ftCaption.x = (width - ftCaption.textWidth) / 2;
        ftCaption.y = 0;
        addChild(ftCaption);

        var ftRoomsLabel:TextField = TextUtils.createTextFieldWithFont("KioBosano", FONT_SIZE, false);
        ftRoomsLabel.y = ftCaption.y + ftCaption.textHeight + LINE_SKIP;
        ftRoomsLabel.text = api.localization.results.rooms;
        ftRoomsLabel.x = (width - ftRoomsLabel.textWidth) / 2;
        addChild(ftRoomsLabel);

        ftRooms = TextUtils.createTextFieldWithFont("KioBosano", FONT_SIZE, false);
        //ftRooms.x = (width - ftRooms.width) / 2;
        ftRooms.y = ftRoomsLabel.y + ftRoomsLabel.textHeight + LINE_SKIP;
        addChild(ftRooms);

        var ftLengthLabel:TextField = TextUtils.createTextFieldWithFont("KioBosano", FONT_SIZE, false);
//        ftLengthLabel.htmlText = '<p align="center">' + api.localization.results.length + '</p>';
        ftLengthLabel.text = api.localization.results.length;
        ftLengthLabel.x = (width - ftLengthLabel.textWidth) / 2;
        ftLengthLabel.y = ftRooms.y + ftRoomsLabel.textHeight + LINE_SKIP;
        addChild(ftLengthLabel);

        ftLength = TextUtils.createTextFieldWithFont("KioBosano", FONT_SIZE, false);
        ftLength.y = ftLengthLabel.y + ftLengthLabel.textHeight + LINE_SKIP;
        addChild(ftLength);
    }

    public function get rooms():int {
        return _rooms;
    }

    public function set rooms(value:int):void {
        _rooms = value;
        ftRooms.text = '' + value;
        ftRooms.x = (field_width - ftRooms.textWidth) / 2;
    }

    public function get pipesLength():int {
        return _pipesLength;
    }

    public function set pipesLength(value:int):void {
        _pipesLength = value;
        ftLength.text = '' +  value;
        ftLength.x = (field_width - ftLength.textWidth) / 2;
    }

}
}