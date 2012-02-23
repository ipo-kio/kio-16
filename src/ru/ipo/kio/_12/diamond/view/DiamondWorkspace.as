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
        d.addVertex(new Vertex2D(20, 10));
        d.addVertex(new Vertex2D(30, -15));
        d.addVertex(new Vertex2D(40, 5));
        d.addVertex(new Vertex2D(50, -10));

        var dv:Eye = new Eye(d);
        dv.x = 150;
        dv.y = 150;

        addChild(dv);
    }
}
}
