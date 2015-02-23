/**
 * Created by ilya on 15.02.15.
 */
package ru.ipo.kio._15.spider {

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.controls.GraphicsButton;

import ru.ipo.kio.api.controls.InfoPanel;

import ru.ipo.kio.base.GlobalMetrics;

public class SpiderWorkspace extends Sprite {

    [Embed(source="resources/btn.png")]
    public static const HELP_BUTTON_ON:Class;
    public static const HELP_BUTTON_ON_IMG:BitmapData = (new HELP_BUTTON_ON).bitmapData;

    [Embed(source="resources/btn.png")]
    public static const USE_SETTING_BUTTON:Class;
    public static const USE_SETTING_BUTTON_IMG:BitmapData = (new USE_SETTING_BUTTON).bitmapData;

    private var s:Spider;
    private var f:Floor;
    private var m:SpiderMotion;

    private var bigSpider:Spider;

    private var current_info:InfoPanel;
    private var record_info:InfoPanel;

    private var api:KioApi;
    private var problem:KioProblem;

    public function SpiderWorkspace(problem:KioProblem) {
        api = KioApi.instance(problem);
        this.problem = problem;

        var mask:Sprite = new Sprite();
        mask.graphics.beginFill(0);
        mask.graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT);
        mask.graphics.endFill();
        addChild(mask);
        mask.visible = false;
        this.mask = mask;

        init_info_panels();

        bigSpider = new Spider(5);
        bigSpider.x = GlobalMetrics.WORKSPACE_WIDTH / 2;
        bigSpider.y = 400;
        bigSpider.alpha = 0.2;
        bigSpider.mouseEnabled = false;
        addChild(bigSpider);

        bigSpider.visible = false;

        graphics.beginFill(0xF0F4C3);
        graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT);
        graphics.endFill();

        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        s = new Spider();
        f = new Floor();
        m = new SpiderMotion(this, problem, s, f, bigSpider);

        addChild(m);
        m.x = 0;
        m.y = 500;

        var tuned_mechanism:Mechanism = new Mechanism();
        tuned_mechanism.angle = 0;
        var mt:MechanismTuner = new MechanismTuner(tuned_mechanism, m);
        addChild(mt);

        //buttons

        var bigSpiderButton:GraphicsButton = new GraphicsButton('?', HELP_BUTTON_ON_IMG, HELP_BUTTON_ON_IMG, HELP_BUTTON_ON_IMG, 'KioArial', 12, 12);
        addChild(bigSpiderButton);
        bigSpiderButton.x = 80;
        bigSpiderButton.y = 550;
        bigSpiderButton.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            bigSpider.visible = !bigSpider.visible;
        });

        var currentSettingsButton:GraphicsButton = new GraphicsButton('Взять текущий', USE_SETTING_BUTTON_IMG, USE_SETTING_BUTTON_IMG, USE_SETTING_BUTTON_IMG, 'KioTahoma', 12, 12);
        addChild(currentSettingsButton);
        currentSettingsButton.x = 680;
        currentSettingsButton.y = 550;
        currentSettingsButton.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            mt.ls = m.ls;
        });
        currentSettingsButton.visible = false;
    }

    private function init_info_panels():void {
        current_info = new InfoPanel(
                'KioArial', true, 16, 0x727272, 0x212121, 0x03A9F4, 1.5, 'Решение', [
                    'Финиш',
                    'Время',
                    'Материал'
                ],
                200
        );
        addChild(current_info);
        current_info.x = 20;
        current_info.y = 30;

        record_info = new InfoPanel(
                'KioArial', true, 16, 0x727272, 0x212121, 0x03A9F4, 1.5, 'Рекорд', [
                    'Финиш',
                    'Время',
                    'Материал'
                ],
                200
        );
        addChild(record_info);
        record_info.x = 20;
        record_info.y = 140;

        current_info.setValue(0, '-');
        current_info.setValue(1, '-');
        current_info.setValue(2, '-');
        record_info.setValue(0, '-');
        record_info.setValue(1, '-');
        record_info.setValue(2, '-');
    }

    public function setCurrentResult(result:Object):void {
        setResult(current_info, result);
    }

    public function setRecordResult(result:Object):void {
        setResult(record_info, result);
    }

    public function setResult(info:InfoPanel, result:Object):void {
        function timeToString(t:Number):String {
            if (problem.level == 0)
                return Math.round(t * 10).toFixed(0);
            else
                return t.toFixed(1);
        }

        if (!result.ok) {
            info.setValue(0, 'нет');
            info.setValue(1, result.t == 0 ? '-' : 'дольше ' + timeToString(result.t) + ' с');
        } else {
            info.setValue(0, 'да');
            info.setValue(1, timeToString(result.t) + ' с');
        }

        info.setValue(2, result.m + ' см');
    }

    public function get solution():Object {
        return {
            ls: m.ls
        };
    }

    public function get result():Object {
        return m.result;
    }
}
}
