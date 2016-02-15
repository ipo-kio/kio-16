package ru.ipo.kio._16.rockgarden {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._16.rockgarden.model.Segment;

import ru.ipo.kio._16.rockgarden.model.SegmentsList;
import ru.ipo.kio._16.rockgarden.model.Circle;
import ru.ipo.kio._16.rockgarden.model.Garden;
import ru.ipo.kio._16.rockgarden.view.GardenView;
import ru.ipo.kio._16.rockgarden.view.RocksSideView;
import ru.ipo.kio._16.rockgarden.view.ViewArea;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;

public class RockGardenWorkspace extends Sprite {

    public static const TOTAL_CIRCLES:int = 7;

    private var background:Sprite = new Sprite();
    private var g:Garden;
    private var gardenView:GardenView;

    private var _problem:KioProblem;
    private var _api:KioApi;

    public function RockGardenWorkspace(problem:KioProblem) {
        _problem = problem;
        _api = KioApi.instance(problem);

        background.graphics.beginFill(0xFFFFFF);
        background.graphics.drawRect(0, 0, 780, 600);
        background.graphics.endFill();

        addChild(background);

//        background.graphics.lineStyle(1, 0xFF0000);
//        background.graphics.drawCircle(200, 200, 100);

        /*var sl:SegmentsList = new SegmentsList(10, "");

         var union:Function = function (a:String, b:String):String {
         return a + b;
         };

         sl.addSegment(new Segment(1, 5, "a"), union);
         trace(sl.toString());

         sl.addSegment(new Segment(6, 9, "b"), union);
         trace(sl.toString());

         sl.addSegment(new Segment(2, 8, "c"), union);
         trace(sl.toString());

         sl.addSegment(new Segment(9, 2, "r"), union);
         trace(sl.toString());*/

        var _override:Function = function (a:String, b:String):String {
            return b;
        };

        /** ====-=======
         var sl:SegmentsList = new SegmentsList(10, "");
         sl.addSegment(new Segment(3, 4, "a"), _override);
         trace(sl.toString());
         sl.addSegment(new Segment(2, 5, "b"), _override);
         trace(sl.toString());
         */

        /** ====-=======*/
        var sl:SegmentsList = new SegmentsList(10, "");
        sl.addSegment(new Segment(2, 5, "a"), _override);
        trace(sl.toString());
        sl.addSegment(new Segment(3, 4, "b"), _override);
        trace(sl.toString());

        var circles:Vector.<Circle> = new <Circle>[];
        for (var i:int = 0; i < TOTAL_CIRCLES; i++) {
            var xx:int = i % 5;
            var yy:int = i / 5;
            var c:Circle = new Circle(2 + xx * 4, 2.4 + yy * 2.5, 1, i + 1);
            circles.push(c);
            c.addEventListener(Event.CHANGE, circle_changed);
        }

        g = new Garden(20, 10, circles);

        var areas:Vector.<ViewArea> = new <ViewArea>[
            new ViewArea(g.location2point(g.H / 2), g),
            new ViewArea(g.location2point(g.H + g.W / 2), g),
            new ViewArea(g.location2point(g.H + g.W + g.H / 2), g),
            new ViewArea(g.location2point(g.H + g.W + g.H + g.W / 2), g)
        ];

        var sideView:RocksSideView = new RocksSideView(g, 400, 30);

        gardenView = new GardenView(g, 35, 1 / 8, sideView, areas);
        gardenView.x = 40;
        gardenView.y = 50;
        addChild(gardenView);

        sideView.x = gardenView.x;
        sideView.y = gardenView.y + gardenView.height + 10;
        addChild(sideView);
    }

    private var _loading:Boolean = false;

    public function get circles():Array {
        var r:Array = [];
        for each (var c:Circle in g.circles)
            r.push(c.x, c.y, c.r);
        return r;
    }

    public function set circles(r:Array):void {
        _loading = true;

        var i:int = 0;
        for each (var c:Circle in g.circles) {
            if (i >= r.length)
                break;
            c.x = r[i++];
            c.y = r[i++];
            c.r = r[i++];
        }

        gardenView.refresh();
        gardenView.redraw_all_circles();

        _loading = false;
    }

    private function circle_changed(event:Event):void {
        if (_loading)
            return;
        _api.autoSaveSolution();
    }

    //  ----1----2----5----6----8----9----
    //         a    a
    //         a    a        b     b
    //         a   ac   c    bc
    //   r    ar   ac   c    bc    b   r
}
}
