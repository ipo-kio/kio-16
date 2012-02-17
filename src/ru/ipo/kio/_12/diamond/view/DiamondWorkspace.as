/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 11.02.12
 * Time: 23:52
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import ru.ipo.kio._12.diamond.*;

import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._12.diamond.model.Diamond;

public class DiamondWorkspace extends Sprite {
    public function DiamondWorkspace() {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
        var d:Diamond = new Diamond();
        d.addVertex(new Vertex2D(10, 20));
        d.addVertex(new Vertex2D(100, 300));
        d.addVertex(new Vertex2D(400, 500));
        d.addVertex(new Vertex2D(200, 50));

        var dv:DiamondView = new DiamondView(d, 0, 0, 600, 600);

        addChild(dv);
    }
}
}
