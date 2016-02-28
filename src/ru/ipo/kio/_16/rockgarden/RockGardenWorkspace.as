package ru.ipo.kio._16.rockgarden {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._16.rockgarden.model.Circle;
import ru.ipo.kio._16.rockgarden.model.Garden;
import ru.ipo.kio._16.rockgarden.model.SegmentsList;
import ru.ipo.kio._16.rockgarden.view.GardenView;
import ru.ipo.kio._16.rockgarden.view.RocksSideView;
import ru.ipo.kio._16.rockgarden.view.ViewArea;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.controls.InfoPanel;

public class RockGardenWorkspace extends Sprite {

    [Embed(source="res/imgs/fon.png")]
    public static const FON_CLASS:Class;

    public static var TOTAL_CIRCLES:int = 7;

    private var background:Sprite = new Sprite();
    private var g:Garden;
    private var gardenView:GardenView;

    private var _problem:KioProblem;
    private var _api:KioApi;

    private var _info:InfoPanel, _record:InfoPanel;

    public function RockGardenWorkspace(problem:KioProblem) {
        _problem = problem;
        _api = KioApi.instance(problem);

        SegmentsList.__reset_timings();

        TOTAL_CIRCLES = 5 + problem.level; //5, 6, 7 circles

        background.graphics.beginBitmapFill((new FON_CLASS).bitmapData);
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
        /*var sl:SegmentsList = new SegmentsList(10, "");
         sl.addSegment(new Segment(2, 5, "a"), _override);
         trace(sl.toString());
         sl.addSegment(new Segment(3, 4, "b"), _override);
         trace(sl.toString());*/

        var circles:Vector.<Circle> = new <Circle>[];
        for (var i:int = 0; i < TOTAL_CIRCLES; i++) {
            var xx:int = i % 5;
            var yy:int = i / 5;
            var c:Circle = new Circle(2 + xx * 4, 2.4 + yy * 2.5, 1, i + 1);
            circles.push(c);
            c.addEventListener(Event.CHANGE, circle_changed);
        }

        g = new Garden(20, 10, circles);

        if (problem.level == 0)
            var areas:Vector.<ViewArea> = new <ViewArea>[
                new ViewArea(g.location2point(g.H / 2), g, "left"),
                new ViewArea(g.location2point(g.H + g.W / 2), g, "top"),
                new ViewArea(g.location2point(g.H + g.W + g.H / 2), g, "right"),
                new ViewArea(g.location2point(g.H + g.W + g.H + g.W / 2), g, "bottom")
            ];
        else if (problem.level == 1)
            areas = new <ViewArea>[
                new ViewArea(g.location2point(g.H / 2), g, "left"),
                new ViewArea(g.location2point(g.H + g.W / 3), g, "top left"),
                new ViewArea(g.location2point(g.H + 2 * g.W / 3), g, "top right"),
                new ViewArea(g.location2point(g.H + g.W + g.H / 2), g, "right"),
                new ViewArea(g.location2point(g.H + g.W + g.H + g.W / 3), g, "bottom right"),
                new ViewArea(g.location2point(g.H + g.W + g.H + 2 * g.W / 3), g, "bottom left")
            ];
        else
            areas = null;

        var sideView:RocksSideView = new RocksSideView(g, 580, 40);

        gardenView = new GardenView(g, 35, 1 / 8, sideView, _api.problem.level, problem, this, areas);
        gardenView.x = 40;
        gardenView.y = 36;
        addChild(gardenView);

        sideView.x = 194;
        sideView.y = gardenView.y + gardenView.height + 26;
        addChild(sideView);

        initInfos();

        _api.addEventListener(KioApi.RECORD_EVENT, function (event:Event):void {
            setInfos(_record, _api.record_result);
        });
    }

    private function initInfos():void {
        if (_problem.level == 0 || _problem.level == 1) {
            var labels:Array = [
                _problem.level == 0 ? "Площадок с четырьмя камнями" : "Площадок с пятью камнями",
                "Различных площадок",
                "Размер камней"
            ];
        } else
                /*
            labels = [
                "Невидимых камней",
                "Видно 6 камней"
            ];
            */
            labels = [
                "Пар невидимых",
                "Равномерность"
            ];

        _info = new InfoPanel('KioArial', true, 16, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 1.1, "Результат", labels, 240);
        _record = new InfoPanel('KioArial', true, 16, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 1.1, "Рекорд", labels, 240);

        addChild(_info);
        addChild(_record);
        _info.x = 230;
        _info.y = 516;
        _record.x = 516;
        _record.y = 520;
    }

    private function setInfos(info:InfoPanel, c:Object):void {
        if (c.err) {
            if (_problem.level == 0 || _problem.level == 1) {
                info.setValue(0, '-');
                info.setValue(1, '-');
                info.setValue(2, '-');
            } else {
                info.setValue(0, '-');
                info.setValue(1, '-');
            }
            return;
        }

        if (_problem.level == 0 || _problem.level == 1) {
            info.setValue(0, c.r);
            info.setValue(1, c.d);
            info.setValue(2, c.s);
        } else {
//            info.setValue(0, c.i);
//            info.setValue(1, Number(c.s).toFixed(2) + "%");
            info.setValue(0, c.p);
            info.setValue(1, Number(c.v).toFixed(2));
        }
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
    public function submitResult(result:Object):void {
        _api.submitResult(result);
        setInfos(_info, result);
    }
}
}
