/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.controls.InfoPanel;

public class StarsWorkspace extends Sprite {

    private var api:KioApi;
    private var sky:StarrySky;
    private var skyView:StarrySkyView;

    private var infoPanel:InfoPanel;
    private var infoPanelRecord:InfoPanel;

    private var _panel:SkyInfoPanel;

    [Embed(source='resources/EskizOne-Regular.ttf', embedAsCFF="false", fontName="EskizOne-Regular", mimeType='application/x-font-truetype')]
    private static var MyFont:Class;

    public function StarsWorkspace(problem:StarsProblem) {

        graphics.beginFill(0, 1);
        graphics.drawRect(0, 0, 780, 600);
        graphics.endFill();

        //получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
        api = KioApi.instance(problem);

        var stars:Array = [new Star(43, 45, 1), new Star(63, 55, 3), new Star(64, 105, 2),
            new Star(70, 145, 2), new Star(243, 65, 1), new Star(163, 60, 3), new Star(103, 98, 1),
            new Star(203, 98, 3), new Star(211, 160, 2), new Star(277, 66, 1), new Star(274, 95, 2)
        ];

        sky = new StarrySky(stars);
        skyView = new StarrySkyView(sky, this);
        addChild(skyView);

        sky.addEventListener(Event.CHANGE, sky_changeHandler);

        _panel = new SkyInfoPanel(skyView);

        infoPanel = new InfoPanel(
            /*"KioArial", true, //*/"EskizOne-Regular", true,
            18, 0x92000a, 0x08457e, 0x3b5998,
            1.5, "Текущий результат",
            ["Сумма длинн линий", "Количество линий"], 220
        );

        infoPanelRecord = new InfoPanel(
            /*"KioArial", true, //*/"EskizOne-Regular", true,
            18, 0x92000a, 0x08457e, 0x3b5998,
            1.5, "Рекорд",
            ["Сумма длинн линий", "Количество линий"], 220
        );

        infoPanel.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanel.setValue(1, "" + sky.starsLines.length);

        infoPanelRecord.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanelRecord.setValue(1, "" + sky.starsLines.length);

        _panel.x = 0;
        _panel.y = skyView.height + 10;
        addChild(_panel);

        addChild(infoPanel);
        addChild(infoPanelRecord);
        infoPanel.x = 510;
        infoPanelRecord.x = 510;
        infoPanelRecord.y = 150;
    }

    private function sky_changeHandler(event:Event):void {
//        trace(sky.sumOfLines.toFixed(3));

        infoPanel.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanel.setValue(1, "" + sky.starsLines.length);

        infoPanelRecord.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanelRecord.setValue(1, "" + sky.starsLines.length);

        api.autoSaveSolution();
        api.submitResult(currentResult());
    }

    public function get solution():Object {
        return {
            lines : sky.serialize()
        }
    }

    public function currentResult():Object {
        return {
            sum_of_lines : sky.sumOfLines.toFixed(3),
            total_count_of_lines : sky.starsLines.length
        }
    }

    public function load(solution:Object):Boolean {
        var starsIndexLines:Array = solution.lines;

        skyView.clearLines();

        for (var i:int = 0; i < starsIndexLines.length; i++) {
            var s1:Star = sky.getStarByIndex(starsIndexLines[i][0]);
            var s2:Star = sky.getStarByIndex(starsIndexLines[i][1]);
            var lineIndex:int = sky.addLine(s1, s2);

            skyView.createLineView(s1.x, s1.y);
            skyView.drawLineView(s2.x, s2.y);
            skyView.fixLineView(sky.starsLines[lineIndex]);
        }
        return true;
    }


    public function get panel():SkyInfoPanel {
        return _panel;
    }
}
}
