/**
 * Created by ilya on 25.01.15.
 */
package ru.ipo.kio._15.traincars {
import flash.display.Sprite;
import flash.geom.Point;

import ru.ipo.kio._15.traincars.loc.RailsSet;

public class TrainCarsWorkspace extends Sprite {
    public function TrainCarsWorkspace() {
        draw();
    }

    private function draw():void {
        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0, 0, 780, 600);
        graphics.endFill();

        var rSet:RailsSet = new RailsSet();
        var r0:int = rSet.add(new Point(100, -100), new Point(100, -50), new Point(100, 0));
        var r1:int = rSet.add(new Point(100, 0), new Point(80, 80), new Point(0, 100));
        var r2:int = rSet.add(new Point(100, 0), new Point(120, 80), new Point(200, 100));
        var r3:int = rSet.add(new Point(200, 100), new Point(280, 120), new Point(300, 200));

        addChild(rSet);
        rSet.x = 200;
        rSet.y = 200;
    }
}
}
