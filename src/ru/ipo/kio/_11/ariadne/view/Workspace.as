/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 26.02.11
 * Time: 18:57
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.ariadne.view {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;

import ru.ipo.kio._11.ariadne.AriadneProblem;
import ru.ipo.kio._11.ariadne.model.AriadneData;
import ru.ipo.kio._11.ariadne.model.Terra;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.api.controls.GraphicsButton;

public class Workspace extends Sprite {

    [Embed(source='../resources/Bg_All.jpg')]
    private static const BG:Class;

    [Embed(
            source='../resources/ds_greece.ttf',
            embedAsCFF = "false",
            fontName="KioGreece",
            mimeType="application/x-font-truetype",
            unicodeRange = "U+0000-U+FFFF"
            )]
    private static var EGYPT_FONT:Class;

    private var _land:Land = new Land(11);

    private var rp_results:ResultsPanel;
    private var rp_record:ResultsPanel;

    private var loc:Object = KioApi.getLocalization(AriadneProblem.ID);

    // 20, 636
    //111, 636
    //202, 636
    //294, 636
    //386, 636
    //477, 636 - 768

    [Embed(source="../resources/Button_01.png")]
    private static const BUTTON_1:Class;
    private static const BUTTON_1_BMP:BitmapData = new BUTTON_1().bitmapData;

    [Embed(source="../resources/Button_02.png")]
    private static const BUTTON_2:Class;
    private static const BUTTON_2_BMP:BitmapData = new BUTTON_2().bitmapData;

    [Embed(source="../resources/Button_03.png")]
    private static const BUTTON_3:Class;
    private static const BUTTON_3_BMP:BitmapData = new BUTTON_3().bitmapData;

    private var showTicksButton:GraphicsButton = null;
    private var showHeroButton:GraphicsButton = null;
    public static const FONT_HEIGHT:int = 15;

    private var typeInfo:TextField;

    public function Workspace() {

        addChild(new BG);

        _land.x = 25;
        _land.y = 20;
        addChild(_land);

        AriadneData.instance.addEventListener(AriadneData.POINT_MOVED, refreshResults);
        AriadneData.instance.addEventListener(AriadneData.PATH_CHANGED, refreshResults);

        rp_results = new ResultsPanel(768 - 636, loc.results.current_results_header);
        rp_record = new ResultsPanel(768 - 636, loc.results.record_header);

        rp_results.x = 636;
        rp_results.y = 20;
        rp_record.x = 636;
        rp_record.y = 111;

        addChild(rp_results);
        addChild(rp_record);

        var removePointButton:GraphicsButton = new GraphicsButton(
                loc.buttons.remove_dot,
                BUTTON_1_BMP,
                BUTTON_2_BMP,
                BUTTON_3_BMP,
                'KioGreece',
                FONT_HEIGHT, FONT_HEIGHT, 2, 2
                );
        removePointButton.addEventListener(MouseEvent.CLICK, removeClick);

        removePointButton.x = 636;
        removePointButton.y = 477;

        addChild(removePointButton);

        setButton(false, loc.buttons.show_ticks);
        setButton(true, loc.buttons.show_hero);

        _land.addEventListener(MouseEvent.MOUSE_MOVE, mouseOverLand);
        _land.addEventListener(MouseEvent.ROLL_OUT, mouseOutLand);

        typeInfo = TextUtils.createTextFieldWithFont('KioGreece', FONT_HEIGHT, false);
        addChild(typeInfo);
        typeInfo.visible = false;

        addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);

        /*//DEBUG
        var tf_velocities:TextField = new TextField;
        tf_velocities.defaultTextFormat = new TextFormat(null, 14);
        tf_velocities.autoSize = TextFieldAutoSize.LEFT;
//        tf_velocities.text = '90, 70, 50, 10, 1';
        tf_velocities.text = '80, 65, 55, 20, 1';
        tf_velocities.x = 646;
        tf_velocities.y = 463 - tf_velocities.textHeight;
        addChild(tf_velocities);
        tf_velocities.type = TextFieldType.INPUT;
        tf_velocities.addEventListener(Event.CHANGE, function(event:Event):void {
            var num:int = 5;
            var split:Array = tf_velocities.text.split(/\s*,\s*//*);
            var ar:Array;

            if (split.length != num)
                ar = null;
            else {
                ar = new Array(num);
                for (var i:int = 0; i < num; i++) {
                    ar[i] = int(split[i]);
                    if (ar[i] <= 0) {
                        ar = null;
                        break;
                    }
                }
            }

            AriadneData.instance.velocity_info = ar;

            refreshResults(event);
        });*/
    }

    private function removedHandler(event:Event):void {
        _land.show_hero = false;
        setButton(true, loc.buttons.show_hero);
    }

    private function mouseOutLand(event:Event):void {
        typeInfo.visible = false;
    }

    private function mouseOverLand(event:Event):void {
        var logical:Point = _land.screenToLogicalFloat(new Point(_land.mouseX, _land.mouseY));
        var x0:int = Math.floor(logical.x);
        //noinspection JSSuspiciousNameCombinationInspection
        var y0:int = Math.floor(logical.y);

        var terra:Terra = AriadneData.instance.terra;
        if (x0 < 0)
            x0 = 0;
        if (x0 >= terra.width)
            x0 = terra.width - 1;
        if (y0 < 0)
            y0 = 0;
        if (y0 >= terra.height)
            y0 = terra.height - 1;

        var type:int = terra.squareType(x0, y0);
        typeInfo.text = terra.description(type) + ' ' + terra.velocity(type) + ' ' + loc.hover.speed;
        typeInfo.x = (636 + 768 - typeInfo.textWidth) / 2;
        typeInfo.y = (386 + 477 - 10 - typeInfo.textHeight) / 2;
        typeInfo.visible = true;
    }

    private function setButton(is_hero:Boolean, title:String):void {
        var oldButton:GraphicsButton = is_hero ? showHeroButton : showTicksButton;
        if (oldButton)
            removeChild(oldButton);

        var newButton:GraphicsButton = new GraphicsButton(
                title,
                BUTTON_1_BMP,
                BUTTON_2_BMP,
                BUTTON_3_BMP,
                'KioGreece',
                FONT_HEIGHT, FONT_HEIGHT, 2, 2
                );
        newButton.addEventListener(MouseEvent.CLICK, is_hero ? showHeroClick : showTicksClick);

        newButton.x = 636;
        newButton.y = is_hero ? 294 : 202;

        addChild(newButton);
    }

    private function removeClick(event:Event):void {
        AriadneData.instance.removePoint();
    }

    private function showTicksClick(event:Event):void {
        setButton(false, _land.show_ticks ? loc.buttons.show_ticks : loc.buttons.hide_ticks);
        _land.show_ticks = !_land.show_ticks;
    }

    private function showHeroClick(event:Event):void {
        setButton(true, _land.show_hero ? loc.buttons.show_hero : loc.buttons.hide_hero);
        _land.show_hero = !_land.show_hero;
    }

    private function refreshResults(event:Event):void {
        var time:Number = 0;
        var length:Number = 0;
        for each (var s:PathSegment in _land.segments) {
            time += s.time;
            length += s.length;
        }
        AriadneProblem(KioApi.instance(AriadneProblem.ID).problem).submitSolution(time, length);
    }

    public function updateResults(isRecord:Boolean, time:Number, length:Number):void {
        var rp:ResultsPanel = isRecord ? rp_record : rp_results;
        rp.time = time;
        rp.length = length;
    }
}
}
