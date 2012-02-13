/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 11.02.12
 * Time: 23:52
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond {
import flash.display.Sprite;
import flash.events.Event;

public class DiamondWorkspace extends Sprite {
    public function DiamondWorkspace() {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
        var ray_tests:Array = [
                [new Vertex2D(0, 0), new Vertex2D(1, 1), new Vertex2D(1, 0), new Vertex2D(0, 1)],
                [new Vertex2D(0, 0), new Vertex2D(1, 1), new Vertex2D(1, 1), new Vertex2D(2, 0)],
                [new Vertex2D(0, 0), new Vertex2D(1, 1), new Vertex2D(1.1, 0.9), new Vertex2D(2, 0)]
        ];
        
        for each (var p:Array in ray_tests) {
            trace('------');
            trace(p);
            trace(GeometryUtils.intersect_ray_and_segment(p[0], p[1], p[2], p[3]));
        }
    }
}
}
