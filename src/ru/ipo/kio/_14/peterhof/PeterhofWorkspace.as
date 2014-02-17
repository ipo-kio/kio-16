/**
 * Created by ilya on 11.01.14.
 */
package ru.ipo.kio._14.peterhof {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;

import ru.ipo.kio._14.peterhof.model.FountainEvent;
import ru.ipo.kio._14.peterhof.model.Hill;
import ru.ipo.kio._14.peterhof.view.Fountains3DView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.controls.InfoPanel;

public class PeterhofWorkspace extends Sprite {

    public static const _3D_WIDTH:int = 780;
    public static const _3D_HEIGHT:int = 480;

    private var _fountainsView:Fountains3DView;
    private var _problem:KioProblem;
    private var _fountainPanel:FountainPanel;
    private var _resultInfo:InfoPanel;
    private var _recordInfo:InfoPanel;

    private var _api:KioApi;

    public function PeterhofWorkspace(problem:KioProblem) {
        _api = KioApi.instance(problem);

        _problem = problem;
        _fountainsView = new Fountains3DView();
        _fountainsView.hillView.addEventListener(FountainEvent.SELECTION_CHANGED, hillView_selection_changedHandler);
        _fountainsView.antiAlias = 0;

        var bottomPanel:BottomPanel = new BottomPanel();
        addChild(_fountainsView);
        addChild(bottomPanel);
        bottomPanel.y = _3D_HEIGHT;

        _fountainPanel = new FountainPanel(100);

        fillBottomPanel(bottomPanel);

        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

        _fountainsView.hill.addEventListener(FountainEvent.CHANGED, hill_changedHandler);

        var physicsPanel:PhysicsPanel = new PhysicsPanel(_fountainsView.hill);
        addChild(physicsPanel);
        physicsPanel.x = 400;
        physicsPanel.y = 4;
    }

    public function get currentResult():Object {
        var hill:Hill = _fountainsView.hill;
        return {
            'total_length': hill.total_stream_length
        };
    }

    private var start_time:Number = 0;
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
    }

    private function hill_changedHandler(event:FountainEvent):void {
        start_timing();
        var currentResult:Object = currentResult;
        cur_time('eval current result');
        _api.submitResult(currentResult);
        cur_time('submit result');
//        _api.autoSaveSolution();
//        cur_time('save solution');
        _resultInfo.setValue(0, currentResult.total_length.toFixed(3));
        cur_time('set value');
    }

    private function fillBottomPanel(bottomPanel:BottomPanel):void {
        bottomPanel.addChild(_fountainPanel);
        _fountainPanel.x = 10;

        _resultInfo = new InfoPanel("KioArial", true, 14, 0xFFFFFF, 0xFFFFFF, 0xFF8888, 1.2, "Результат", [
            "Общая длина"
        ], 200);
        _recordInfo = new InfoPanel("KioArial", true, 14, 0xFFFFFF, 0xFFFFFF, 0xFF8888, 1.2, "Рекорд", [
            "Общая длина"
        ], 200);

        bottomPanel.addChild(_resultInfo);
        bottomPanel.addChild(_recordInfo);

        _resultInfo.x = 500;
        _resultInfo.y = 0;
        _recordInfo.x = 500;
        _recordInfo.y = 60;
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
}
}
