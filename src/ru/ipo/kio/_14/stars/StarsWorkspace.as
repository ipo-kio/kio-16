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

    [Embed(source='resources/EskizOne-Regular.ttf', embedAsCFF="false", fontName="EskizOne-Regular", mimeType='application/x-font-truetype')]
    private static var MyFont:Class;

    public function StarsWorkspace(problem:StarsProblem) {

        graphics.beginFill(0, 1);
        graphics.drawRect(0, 0, 780, 600);
        graphics.endFill();

        //получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
        api = KioApi.instance(problem);

        var stars:Array = [new Star(13, 25, 1), new Star(33, 55, 3), new Star(64, 105, 2),
            new Star(10, 145, 2), new Star(243, 65, 1), new Star(163, 60, 3), new Star(103, 98, 1),
            new Star(203, 98, 3), new Star(211, 160, 2), new Star(277, 66, 1), new Star(274, 95, 2)
        ];

        sky = new StarrySky(stars);
        skyView = new StarrySkyView(sky);
        addChild(skyView);

        sky.addEventListener(Event.CHANGE, sky_changeHandler);

        infoPanel = new InfoPanel(
            /*"KioArial", true, //*/"EskizOne-Regular", true,
            22, 0x92000a, 0x08457e, 0x3b5998,
            2, "Текущий результат",
            ["Сумма длинн линий", "Количество линий"], 200
        );

        infoPanelRecord = new InfoPanel(
            /*"KioArial", true, //*/"EskizOne-Regular", true,
            22, 0x92000a, 0x08457e, 0x3b5998,
            2, "Рекорд",
            ["Сумма длинн линий", "Количество линий"], 200
        );

        infoPanel.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanel.setValue(1, "" + sky.starsLines.length);

        infoPanelRecord.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanelRecord.setValue(1, "" + sky.starsLines.length);

        addChild(infoPanel);
        addChild(infoPanelRecord);
        infoPanel.x = 520;
        infoPanelRecord.x = 520;
        infoPanelRecord.y = 150;
    }

    private function sky_changeHandler(event:Event):void {
//        trace(sky.sumOfLines.toFixed(3));
        api.autoSaveSolution();
        api.submitResult(currentResult());

        infoPanel.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanel.setValue(1, "" + sky.starsLines.length);

        infoPanelRecord.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanelRecord.setValue(1, "" + sky.starsLines.length);
    }

    public function get solution():Object {
        var solutionLines:Array = [];
        for each (var line:Line in sky.starsLines) {
            solutionLines.push([line.s1, line.s2]);
        }
        return {
            lines : solutionLines
        }
    }

    public function currentResult():Object {
        return {
            sum_of_lines : sky.sumOfLines.toFixed(3),
            total_count_of_lines : sky.starsLines.length
        }
    }

    public function load(solution:Object):Boolean {
        var starsLines:Array = solution.lines;
        for (var i:int = 0; i < starsLines.length; i++) {
            skyView.createLineView(starsLines[i][0].x, starsLines[i][0].y);
            skyView.drawLineView(starsLines[i][1].x, starsLines[i][1].y);
            skyView.fixLineView(starsLines[i][0], starsLines[i][1]);
            sky.addLine(starsLines[i][0], starsLines[i][1]);
        }
        return true;
    }
}
}
