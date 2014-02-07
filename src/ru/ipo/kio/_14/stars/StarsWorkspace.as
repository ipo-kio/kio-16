/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._14.stars.StarsProblem;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.controls.InfoPanel;

[SWF(width=900, height=600)]
public class StarsWorkspace extends Sprite {

    private var api:KioApi;
    private var sky:StarrySky;

    private var infoPanel:InfoPanel;
    private var infoPanelRecord:InfoPanel;

    [Embed(source='resources/EskizOne-Regular.ttf', embedAsCFF="false", fontName="EskizOne-Regular", mimeType='application/x-font-truetype')]
    private static var MyFont:Class;

    public function StarsWorkspace(problem:StarsProblem) {
        //получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
        api = KioApi.instance(problem);

        var stars:Array = [new Star(13, 25, 1), new Star(33, 55, 3), new Star(64, 105, 2),
            new Star(10, 145, 2), new Star(243, 65, 1), new Star(163, 60, 3), new Star(103, 98, 1),
            new Star(203, 98, 3), new Star(211, 160, 2), new Star(277, 66, 1), new Star(274, 95, 2)
        ];

        sky = new StarrySky(stars);
        var skyView:StarrySkyView = new StarrySkyView(sky);
        addChild(skyView);

        sky.addEventListener(Event.CHANGE, sky_changeHandler);

        infoPanel = new InfoPanel(
            /*"KioArial", true, //*/"EskizOne-Regular", true,
            22, 0x92000a, 0x08457e, 0x3b5998,
            2, "Текущий результат",
            ["Сумма длинн линий", "Количество линий"], 300
        );

        infoPanelRecord = new InfoPanel(
            /*"KioArial", true, //*/"EskizOne-Regular", true,
            22, 0x92000a, 0x08457e, 0x3b5998,
            2, "Рекорд",
            ["Сумма длинн линий", "Количество линий"], 300
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

        infoPanel.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanel.setValue(1, "" + sky.starsLines.length);

        infoPanelRecord.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanelRecord.setValue(1, "" + sky.starsLines.length);
    }
}
}
