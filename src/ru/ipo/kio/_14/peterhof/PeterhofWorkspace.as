/**
 * Created by ilya on 11.01.14.
 */
package ru.ipo.kio._14.peterhof {

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import ru.ipo.kio._14.peterhof.model.FountainEvent;
import ru.ipo.kio._14.peterhof.model.Hill;
import ru.ipo.kio._14.peterhof.view.Fountains3DView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.controls.GraphicsButton;

public class PeterhofWorkspace extends Sprite {

    [Embed(source="resources/zoom_in.png")]
    public static const ZOOM_IN_CLS:Class;
    public static const ZOOM_IN_CLS_IMG:BitmapData = (new ZOOM_IN_CLS).bitmapData;

    [Embed(source="resources/zoom_out.png")]
    public static const ZOOM_OUT_CLS:Class;
    public static const ZOOM_OUT_CLS_IMG:BitmapData = (new ZOOM_OUT_CLS).bitmapData;

    [Embed(source="resources/border.png")]
    public static const BORDER:Class;

    public static const _3D_WIDTH:int = 780;
    public static const _3D_HEIGHT:int = 450;

    private var _fountainsView:Fountains3DView;
    private var _fountainPanel:FountainPanel;
    private var _resultInfo:FountainsInfoPanel;
    private var _recordInfo:FountainsInfoPanel;

    private var _api:KioApi;

    public function PeterhofWorkspace(problem:KioProblem) {
        _api = KioApi.instance(problem);

        _fountainsView = new Fountains3DView(problem);
        _fountainsView.hillView.addEventListener(FountainEvent.SELECTION_CHANGED, hillView_selection_changedHandler);
        _fountainsView.antiAlias = 0;

        var bottomPanel:BottomPanel = new BottomPanel();
        addChild(_fountainsView);
        addChild(bottomPanel);
        bottomPanel.y = _3D_HEIGHT;

        _fountainPanel = new FountainPanel(123, _api, problem.level == 2);

        fillBottomPanel(bottomPanel);

        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

        _fountainsView.hill.addEventListener(FountainEvent.CHANGED, hill_changedHandler);

//        var physicsPanel:PhysicsPanel = new PhysicsPanel(_fountainsView.hill);
//        addChild(physicsPanel);
//        physicsPanel.x = 400;
//        physicsPanel.y = 4;

        _api.addEventListener(KioApi.RECORD_EVENT, api_recordHandler);

        addChild(new BORDER);
    }

    public function get currentResult():Object {
        var hill:Hill = _fountainsView.hill;
        return {
            'total_length': hill.total_stream_length
        };
    }

    /*private var start_time:Number = 0;
    private var last_time:Number = 0;
    private function start_timing():void {
        var d:Date = new Date();
        var t:Number = d.time;
        start_time = t;
        last_time = t;
    }

    private function cur_time(msg:String):void {
        var d:Date = new Date();
        var t:Number = d.time;
//        trace(msg, t - last_time, t - start_time);
        last_time = t;
    }*/

    private function hill_changedHandler(event:FountainEvent):void {
        var currentResult:Object = currentResult;
        _api.submitResult(currentResult);
        _resultInfo.setValue(0, currentResult.total_length.toFixed(3) + ' м');
    }

    private function fillBottomPanel(bottomPanel:BottomPanel):void {
        bottomPanel.addChild(_fountainPanel);
        _fountainPanel.x = 10;
        _fountainPanel.y = -15;

        _resultInfo = new FountainsInfoPanel(0, 0x000000, 0x000000, 0x000000, "Результат", [
            "Общая длина"
        ], 220);
        _recordInfo = new FountainsInfoPanel(30, 0x000000, 0x000000, 0x000000, "Рекорд", [
            "Общая длина"
        ], 220);

        bottomPanel.addChild(_resultInfo);
        bottomPanel.addChild(_recordInfo);

        _resultInfo.x = 480;
        _resultInfo.y = -10;
        _recordInfo.x = 480;
        _recordInfo.y = 55;

        //add zoom buttons
        var zoom_in:GraphicsButton = new GraphicsButton("", ZOOM_IN_CLS_IMG, ZOOM_IN_CLS_IMG, ZOOM_IN_CLS_IMG, "KioTahoma", 12, 12);
        var zoom_out:GraphicsButton = new GraphicsButton("", ZOOM_OUT_CLS_IMG, ZOOM_OUT_CLS_IMG, ZOOM_OUT_CLS_IMG, "KioTahoma", 12, 12);
        zoom_in.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            _fountainsView.scale -= 0.5;
        });
        zoom_out.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            _fountainsView.scale += 0.5;
        });
        zoom_in.x = 694;
        zoom_in.y = 6;
        bottomPanel.addChild(zoom_in);
        zoom_out.x = 734;
        zoom_out.y = 6;
        bottomPanel.addChild(zoom_out);
    }

    private function addedToStageHandler(event:Event):void {
        //add listeners
        stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
    }

    private function removedFromStageHandler(event:Event):void {
        //remove listeners
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
    }

    private function keyDownHandler(event:KeyboardEvent):void {
        _fountainsView.processKeyPress(event);
    }

    private function hillView_selection_changedHandler(event:FountainEvent):void {
        _fountainPanel.fountain = event.fountain;
    }

    public function load(solution:Object):Boolean {
        _fountainsView.hill.deserialize(solution);
        return true;
    }

    public function get currentSolution():Object {
        return _fountainsView.hill.serialize();
    }

    private function api_recordHandler(event:Event):void {
        _recordInfo.animateChange();
        _recordInfo.setValue(0, currentResult.total_length.toFixed(3) + ' м');
    }

    override public function get width():Number {
        return 780;
    }

    override public function get height():Number {
        return 600;
    }
}
}
