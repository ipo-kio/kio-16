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
import ru.ipo.kio.api.controls.InfoPanel;

public class PeterhofWorkspace extends Sprite {

    [Embed(source="resources/plus.png")]
    public static const NUM_PL_CLS:Class;
    public static const NUM_PL_CLS_IMG:BitmapData = (new NUM_PL_CLS).bitmapData;

    [Embed(source="resources/plus_down.png")]
    public static const NUM_PL_D_CLS:Class;
    public static const NUM_PL_CLS_D_IMG:BitmapData = (new NUM_PL_D_CLS).bitmapData;

    [Embed(source="resources/plus_over.png")]
    public static const NUM_PL_O_CLS:Class;
    public static const NUM_PL_CLS_O_IMG:BitmapData = (new NUM_PL_O_CLS).bitmapData;

    [Embed(source="resources/num_mn.png")]
    public static const NUM_MN_CLS:Class;
    public static const NUM_MN_CLS_IMG:BitmapData = (new NUM_MN_CLS).bitmapData;

    [Embed(source="resources/num_mn_d.png")]
    public static const NUM_MN_D_CLS:Class;
    public static const NUM_MN_CLS_D_IMG:BitmapData = (new NUM_MN_D_CLS).bitmapData;

    [Embed(source="resources/num_mn_o.png")]
    public static const NUM_MN_O_CLS:Class;
    public static const NUM_MN_CLS_O_IMG:BitmapData = (new NUM_MN_O_CLS).bitmapData;

    [Embed(source="resources/border.png")]
    public static const BORDER:Class;

    public static const _3D_WIDTH:int = 780;
    public static const _3D_HEIGHT:int = 450;

    private var _fountainsView:Fountains3DView;
    private var _fountainPanel:FountainPanel;
    private var _resultInfo:InfoPanel;
    private var _recordInfo:InfoPanel;

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
        _resultInfo.setValue(0, currentResult.total_length.toFixed(3));
    }

    private function fillBottomPanel(bottomPanel:BottomPanel):void {
        bottomPanel.addChild(_fountainPanel);
        _fountainPanel.x = 10;
        _fountainPanel.y = -15;

        _resultInfo = new InfoPanel("KioArial", true, 14, 0xFFFFFF, 0xFFFFFF, 0xFF8888, 1.2, "Результат", [
            "Общая длина"
        ], 200);
        _recordInfo = new InfoPanel("KioArial", true, 14, 0xFFFFFF, 0xFFFFFF, 0xFF8888, 1.2, "Рекорд", [
            "Общая длина"
        ], 200);

        bottomPanel.addChild(_resultInfo);
        bottomPanel.addChild(_recordInfo);

        _resultInfo.x = 500;
        _resultInfo.y = 25;
        _recordInfo.x = 500;
        _recordInfo.y = 60;

        //add zoom buttons
        var zoom_in:GraphicsButton = new GraphicsButton("", NUM_PL_CLS_IMG, NUM_PL_CLS_O_IMG, NUM_PL_CLS_D_IMG, "KioTahoma", 12, 12);
        var zoom_out:GraphicsButton = new GraphicsButton("", NUM_MN_CLS_IMG, NUM_MN_CLS_O_IMG, NUM_MN_CLS_D_IMG, "KioTahoma", 12, 12);
        zoom_in.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            _fountainsView.scale -= 0.5;
        });
        zoom_out.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            _fountainsView.scale += 0.5;
        });
        zoom_in.x = 700;
        zoom_in.y = 100;
        bottomPanel.addChild(zoom_in);
        zoom_out.x = 720;
        zoom_out.y = 100;
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
        _recordInfo.setValue(0, currentResult.total_length.toFixed(3));
    }

    override public function get width():Number {
        return 780;
    }

    override public function get height():Number {
        return 600;
    }
}
}
