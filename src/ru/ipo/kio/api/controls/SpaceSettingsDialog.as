/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.11
 * Time: 15:26
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api.controls {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BevelFilter;
import flash.text.TextFieldAutoSize;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.GlobalMetrics;
import ru.ipo.kio.base.KioBase;
import ru.ipo.kio.base.displays.DisplayUtils;
import ru.ipo.kio.base.displays.ShellButton;

public class SpaceSettingsDialog extends Sprite {

    private static const ALPHA:Number = 0.5;
    private static const COLOR_BG:uint = 0x979797;
    private static const COLOR:uint = 0xbfdbff;
//    private static const COLOR_BORDER:uint = 0x880022;
    private static const WIDTH:int = 560;
    private static const HEIGHT:int = 420;

    private static const BORDER_SIZE:int = 40;

    public function SpaceSettingsDialog() {
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event):void {

        var loc:Object = KioApi.getLocalization(KioBase.BASE_API_ID);

        x = 0;
        y = 0;

        graphics.beginFill(COLOR_BG, ALPHA);
        graphics.drawRect(0, 0, GlobalMetrics.STAGE_WIDTH, GlobalMetrics.STAGE_HEIGHT);
        graphics.endFill();

        //center panel

        var centerPanel:Sprite = new Sprite();

        centerPanel.x = (GlobalMetrics.STAGE_WIDTH - WIDTH) / 2;
        centerPanel.y = (GlobalMetrics.STAGE_HEIGHT - HEIGHT) / 2;

        centerPanel.graphics.beginFill(COLOR);
        centerPanel.graphics.drawRect(0, 0, WIDTH, HEIGHT);
        centerPanel.filters = [new BevelFilter(1.0/*, -30, COLOR_BORDER*/)];
        centerPanel.graphics.endFill();

        addChild(centerPanel);

        //set text
        TextUtils.moveTo(centerPanel, BORDER_SIZE, BORDER_SIZE / 2, 16);
        TextUtils.output(
                centerPanel,
                TextUtils.drawText(
                        loc.screen.space_settings.warning, 16, TextFieldAutoSize.LEFT, 0x660000, 1)
                );
        TextUtils.output(
                centerPanel,
                TextUtils.drawTextWidth(loc.screen.space_settings.action,
                        WIDTH - 2 * BORDER_SIZE, 16, TextFieldAutoSize.LEFT, 0, 1)
                );
        TextUtils.output(
                centerPanel,
                DisplayUtils.getSettingsSprite()
                );
        TextUtils.output(
                centerPanel,
                TextUtils.drawTextWidth(loc.screen.space_settings.after,
                        WIDTH - 2 * BORDER_SIZE, 16, TextFieldAutoSize.LEFT, 0, 1)
                );

        /*
        var openSettingButton:TextButton = new TextButton("Открыть окно настроек", WIDTH / 3);
        openSettingButton.x = BORDER_SIZE;
        openSettingButton.y = HEIGHT - BORDER_SIZE - openSettingButton.height;
        centerPanel.addChild(openSettingButton);
        openSettingButton.addEventListener(MouseEvent.CLICK, openSettingButtonClicked);
        */

        //TODO create its own button caption in localization
        var closeButton:SimpleButton = new ShellButton(loc.contest_panel.buttons.back);
        closeButton.x = WIDTH - 10 - closeButton.width;
        closeButton.y = HEIGHT - 10 - closeButton.height;
        centerPanel.addChild(closeButton);
        closeButton.addEventListener(MouseEvent.CLICK, closeButtonClicked);

        //todo make it modal
        stage.focus = this;
    }

    private function closeButtonClicked(event:Event):void {
        KioBase.instance.LSOConcernResolved();
        KioBase.instance.lsoProxy.flush();
    }

}
}
