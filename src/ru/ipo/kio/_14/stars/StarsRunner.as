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

    public function StarsRunner() {
        var stars:Array = [new Star(13, 25, 1), new Star(33, 55, 3), new Star(64, 105, 2),
            new Star(10, 145, 2), new Star(173, 65, 1), new Star(163, 60, 3), new Star(103, 98, 1)];

        sky = new StarrySky(stars);
        var skyView:StarrySkyView = new StarrySkyView(sky);
        addChild(skyView);

        sky.addEventListener(Event.CHANGE, sky_changeHandler);

        var infoPanel:InfoPanel = new InfoPanel(
                /*"KioArial", true, //*/"Arial", false,
                20, 0xFF0000, 0x00FF00, 0x0000FF,
                3, "Информация",
                ["Рост", "Вес", "Пол"], 150
        );

        infoPanel.setValue(0, "123");
        infoPanel.setValue(1, "asdf");
        infoPanel.setValue(2, "ssdf ;sldfk");

        addChild(infoPanel);
        infoPanel.x = 520;
    }

    private function sky_changeHandler(event:Event):void {
        trace(sky.sumOfLines.toFixed(3));
    }
}
}
