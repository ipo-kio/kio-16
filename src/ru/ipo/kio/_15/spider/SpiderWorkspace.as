/**
 * Created by ilya on 15.02.15.
 */
package ru.ipo.kio._15.spider {

import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import ru.ipo.kio.api.controls.GraphicsButton;

import ru.ipo.kio.base.GlobalMetrics;

public class SpiderWorkspace extends Sprite {

    [Embed(source="resources/btn.png")]
    public static const USE_SETTING_BUTTON:Class;
    public static const USE_SETTING_BUTTON_IMG:BitmapData = (new USE_SETTING_BUTTON).bitmapData;

    private var s:Spider;
    private var f:Floor;
    private var m:SpiderMotion;

    public function SpiderWorkspace() {
        var mask:Sprite = new Sprite();
        mask.graphics.beginFill(0);
        mask.graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT);
        mask.graphics.endFill();
        addChild(mask);
        mask.visible = false;
        this.mask = mask;

        graphics.beginFill(0xF0F4C3);
        graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT);
        graphics.endFill();

        s = new Spider();
        f = new Floor();
        m = new SpiderMotion(s, f);

        addChild(m);
        m.x = 0;
        m.y = 500;

        addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void {
            stage.addEventListener(KeyboardEvent.KEY_UP, enterFrameHandler);
        });

        addEventListener(Event.ENTER_FRAME, enterFrameHandler);

        var tuned_mechanism:Mechanism = new Mechanism();
        tuned_mechanism.angle = 0;
        var mt:MechanismTuner = new MechanismTuner(tuned_mechanism);
        addChild(mt);

        var useSettingButton:GraphicsButton = new GraphicsButton('Использовать', USE_SETTING_BUTTON_IMG, USE_SETTING_BUTTON_IMG, USE_SETTING_BUTTON_IMG, 'KioTahoma', 12, 12);
        addChild(useSettingButton);
        useSettingButton.x = 30;
        useSettingButton.y = 550;
        useSettingButton.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            if (tuned_mechanism.broken)
                return; //TODO disable if broken
            m.ls = tuned_mechanism.ls;
            m.reset();
        });
    }

    private function enterFrameHandler(event:Event):void {
        m.add_delta();
    }
}
}
