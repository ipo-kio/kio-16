/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.FileFilter;
import flash.net.FileReference;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.controls.InfoPanel;

public class StarsWorkspace extends Sprite {

    private var api:KioApi;
    private var level:int;

    private var sky:StarrySky;
    private var skyView:StarrySkyView;

    private var infoPanel:InfoPanel;
    private var infoPanelRecord:InfoPanel;

    private var _panel:SkyInfoPanel;

    private static var fileReference:FileReference;

    [Embed(source='resources/EskizOne-Regular.ttf', embedAsCFF="false", fontName="EskizOne-Regular", mimeType='application/x-font-truetype')]
    private static var MyFont:Class;

//    [Embed(source="resources/stars_load_example.png")]
//    [Embed(source="resources/example_loading.png")]
//    private static const STARS_LOADING:Class;
//    private static const STARS_LOADING_BMP:BitmapData = new STARS_LOADING().bitmapData;

    public function StarsWorkspace(problem:StarsProblem) {

        graphics.beginFill(0, 1);
        graphics.drawRect(0, 0, 780, 600);
        graphics.endFill();

        //получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
        api = KioApi.instance(problem);
        level = problem.level;

//        trace(api.localization.statement0);

        loadStars();

        /*var stars:Array = [new Star(43, 45, 1), new Star(63, 55, 3), new Star(64, 105, 2),
            new Star(70, 145, 2), new Star(238, 55, 1), new Star(163, 60, 3), new Star(103, 98, 1),
            new Star(203, 98, 3), new Star(211, 160, 2), new Star(277, 226, 1), new Star(274, 95, 2),
            new Star(333, 145, 1), new Star(463, 255, 3), new Star(304, 305, 2),
            new Star(390, 245, 2), new Star(443, 65, 1), new Star(593, 60, 3), new Star(143, 148, 1),
            new Star(503, 98, 3), new Star(411, 160, 2), new Star(357, 66, 1), new Star(574, 145, 2),
            new Star(70, 245, 2), new Star(93, 315, 1), new Star(128, 380, 3), new Star(193, 398, 1),
            new Star(93, 198, 3), new Star(171, 260, 2), new Star(197, 319, 1), new Star(374, 345, 2)
        ];*/

        //loadWorkspace()
    }

    public function loadWorkspace(stars:Array):void {
        sky = new StarrySky(level, stars);
        skyView = new StarrySkyView(sky, this);
        addChild(skyView);

        sky.addEventListener(Event.CHANGE, sky_changeHandler);
        api.addEventListener(KioApi.RECORD_EVENT, recordChanged);

        _panel = new SkyInfoPanel(skyView);

        infoPanel = new InfoPanel(
                /*"KioArial", true, //*/"EskizOne-Regular", true,
                18, 0x92000a, 0x08457e, 0x3b5998,
                1.2, api.localization.result/*"Текущий результат"*/,
                ["Пересечения", "Правильных созвездий",
                    "Различных созвездий", "Длина линий"], 250
        );

        infoPanelRecord = new InfoPanel(
                /*"KioArial", true, //*/"EskizOne-Regular", true,
                18, 0x92000a, 0x08457e, 0x3b5998,
                1.2, api.localization.record/*"Рекорд"*/,
                ["Пересечения", "Правильных созвездий",
                    "Различных созвездий", "Длина линий"], 250
        );

        infoPanel.setValue(0, "НЕТ");
        infoPanel.setValue(1, "" + 0);
        infoPanel.setValue(2, "" + 0);
        infoPanel.setValue(3, "" + 0);

        infoPanelRecord.setValue(0, "НЕТ");
        infoPanelRecord.setValue(1, "" + 0);
        infoPanelRecord.setValue(2, "" + 0);
        infoPanelRecord.setValue(3, "" + 0);

        _panel.x = 0;
        _panel.y = skyView.height - 20;
        addChild(_panel);

        addChild(infoPanel);
        addChild(infoPanelRecord);

        infoPanel.x = 0;
        infoPanel.y = 480;
        infoPanelRecord.x = 360;
        infoPanelRecord.y = 480;
    }

    private function loadStars():void {
        fileReference = new FileReference();

        fileReference.addEventListener(Event.SELECT, fileSelected);
        fileReference.browse([new FileFilter("PNG Files (*.png)","*.png"), new FileFilter("PNG Files (*.bmp)","*.bmp")]);
    }

    private function fileSelected(event:Event):void {
        fileReference.addEventListener(Event.COMPLETE, fileLoaded);
        fileReference.load();
    }

    private function fileLoaded(event:Event):void {

        fileReference.removeEventListener(Event.COMPLETE, fileLoaded);

        var loader:Loader = new Loader();

        // ... display the progress bar for converting the image data to a display object ...

        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
        loader.loadBytes(fileReference.data);
    }

    private function loadBytesHandler(event:Event):void {
        var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
        loaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);

        var BMP:BitmapData = Bitmap(loaderInfo.content).bitmapData;

        var starsArr:Array = [];
        for (var i:int = 0; i < BMP.width; i++) {
            for (var j:int = 0; j < BMP.height; j++) {
                var pixel:uint = BMP.getPixel(i, j);
                switch (pixel) {
                    case 0x00FF0000:
                        var star:Star = new Star(i, j, 3);
                        var len:Boolean = true;

                        for each (var s:Star in starsArr) {
                            var dx:Number = star.x - s.x;
                            var dy:Number = star.y - s.y;
                            if (Math.sqrt(dx * dx + dy * dy) <= 15) {
                                len = false;
                                break;
                            } else
                                len = true;
                        }

                        if (len)
                            starsArr.push(star);
                        break;
                    case 0x0000FF00:
                        var star1:Star = new Star(i, j, 1);
                        var len1:Boolean = false;
                        for each (var s1:Star in starsArr) {
                            var dx1:Number = star1.x - s1.x;
                            var dy1:Number = star1.y - s1.y;
                            if (Math.sqrt(dx1 * dx1 + dy1 * dy1) <= 5) {
                                len1 = false;
                                break;
                            } else
                                len1 = true;
                        }
                        if (len1)
                            starsArr.push(star1);
                        break;
                    case 0x000000FF:
                        var star2:Star = new Star(i, j, 2);
                        var len2:Boolean = false;
                        for each (var s2:Star in starsArr) {
                            var dx2:Number = star2.x - s2.x;
                            var dy2:Number = star2.y - s2.y;
                            if (Math.sqrt(dx2 * dx2 + dy2 * dy2) <= 5) {
                                len2 = false;
                                break;
                            } else
                                len2 = true;
                        }
                        if (len2)
                            starsArr.push(star2);
                        break;
                }
            }
        }

        loadWorkspace(starsArr);
    }

    private function recordChanged(event:Event):void {
        infoPanelRecord.setValue(0, "" + sky.hasIntersectedAnswer());
        infoPanelRecord.setValue(1, "" + sky.countOfRightGraphs(level));
        infoPanelRecord.setValue(2, "" + sky.countDifferentGraphs());
        infoPanelRecord.setValue(3, "" + sky.sumOfLines.toFixed(3));
    }

    private function sky_changeHandler(event:Event):void {
        infoPanel.setValue(0, "" + sky.hasIntersectedAnswer());
        if (sky.hasIntersectedLines()) {
            infoPanel.setValue(1, "-");
            infoPanel.setValue(2, "-");
            infoPanel.setValue(3, "-");
        } else {
            infoPanel.setValue(1, "" + sky.countOfRightGraphs(level));
            infoPanel.setValue(2, "" + sky.countDifferentGraphs());
            infoPanel.setValue(3, "" + sky.sumOfLines.toFixed(3));
        }


        api.autoSaveSolution();
        api.submitResult(currentResult());
    }

    public function get solution():Object {
        return {
            lines : sky.serialize()
        }
    }

    public function currentResult():Object {
        return {
            has_intersected_lines : sky.hasIntersected(),
            total_number_of_right_graphs : sky.countOfRightGraphs(level),
            total_number_of_difference_graphs : 0,
            sum_of_lines : sky.sumOfLines.toFixed(3)
        }
    }

    public function load(solution:Object):Boolean {
        var starsIndexLines:Array = solution.lines;

        skyView.clearLines();

        for (var i:int = 0; i < starsIndexLines.length; i++) {
            var s1:Star = sky.getStarByIndex(starsIndexLines[i][0]);
            var s2:Star = sky.getStarByIndex(starsIndexLines[i][1]);
            var lineIndex:int = sky.addLine(s1, s2);

            skyView.createLineView(s1.x, s1.y);
            skyView.drawLineView(s2.x, s2.y);
            skyView.fixLineView(sky.starsLines[lineIndex]);
        }
        skyView.starrySky_changeHandler(null); //TODO get rid of this call
        return true;
    }


    public function get panel():SkyInfoPanel {
        return _panel;
    }
}
}
