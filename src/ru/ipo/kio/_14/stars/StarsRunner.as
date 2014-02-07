/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio.api.controls.InfoPanel;

[SWF(width=900, height=600)]
public class StarsRunner extends Sprite {

    private var sky:StarrySky;

    private var infoPanel:InfoPanel;
    private var infoPanelRecord:InfoPanel;

    public function StarsRunner() {
        var stars:Array = [new Star(13, 25, 1), new Star(33, 55, 3), new Star(64, 105, 2),
            new Star(10, 145, 2), new Star(173, 65, 1), new Star(163, 60, 3), new Star(103, 98, 1)];

        sky = new StarrySky(stars);
        var skyView:StarrySkyView = new StarrySkyView(sky);
        addChild(skyView);

        sky.addEventListener(Event.CHANGE, sky_changeHandler);

        infoPanel = new InfoPanel(
            /*"KioArial", true, //*/"Arial", false,
            20, 0xFF0000, 0x00FF00, 0x0000FF,
            3, "Текущий результат",
            ["Сумма длинн линий", "Количество линий"], 300
        );

        infoPanelRecord = new InfoPanel(
            /*"KioArial", true, //*/"Arial", false,
            20, 0xFF0000, 0x00FF00, 0x0000FF,
            3, "Рекорд",
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
        infoPanelRecord.y = 200;
    }

    private function sky_changeHandler(event:Event):void {
        trace(sky.sumOfLines.toFixed(3));

        infoPanel.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanel.setValue(1, "" + sky.starsLines.length);

        infoPanelRecord.setValue(0, "" + sky.sumOfLines.toFixed(3));
        infoPanelRecord.setValue(1, "" + sky.starsLines.length);
    }
}
}
