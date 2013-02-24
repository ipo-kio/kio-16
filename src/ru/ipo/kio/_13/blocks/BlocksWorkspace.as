/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 12:52
 */
package ru.ipo.kio._13.blocks {
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextFieldType;

import ru.ipo.kio._13.blocks.model.Block;

import ru.ipo.kio._13.blocks.model.BlocksDebugger;
import ru.ipo.kio._13.blocks.model.BlocksField;
import ru.ipo.kio._13.blocks.view.BlocksSelector;

import ru.ipo.kio._13.blocks.view.DebuggerControls;
import ru.ipo.kio._13.blocks.view.DebuggerView;

import ru.ipo.kio._13.blocks.view.Editor;
import ru.ipo.kio._13.cut.view.InfoPanel;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;

public class BlocksWorkspace extends Sprite {

    [Embed(source="resources/bg.png")]
    public static const BG_CLS:Class;

    public static const MANUAL_REGIME_EVENT:String = 'manual regime';

    private static var _instance:BlocksWorkspace = null;
    private var _editor:Editor;
    private var _debuggerControls:DebuggerControls;
    private var _blocksDebugger:BlocksDebugger;
    private var _blocksSelector:BlocksSelector;

    private const api:KioApi = KioApi.instance(BlocksProblem.ID);

    private var _manualRegime:Boolean = false;

    private var _resultsInfo:InfoPanel;
    private var _recordInfo:InfoPanel;

    public function BlocksWorkspace() {
        if (_instance == null)
            _instance = this;
        else
            throw new Error('Could not create the second instance of the Blocks Field');

        TextUtils.embedFonts();

        addChild(new BG_CLS);

        initInfoFields();

        _editor = new Editor(552, 100, api.problem.level == 0);

        addChild(_editor);

        switch(api.problem.level) {
            case 0:
                var field:BlocksField = new BlocksField(4, 6, [
                    [],
                    [new Block(4), new Block(1)],
                    [new Block(4), new Block(1)],
                    [new Block(2), new Block(3)],
                    [new Block(2), new Block(3)],
                    []
                ], 3, 0);

                Block.registerForbiddenPair(3, 1); //nothing on blue
                Block.registerForbiddenPair(3, 2);
                Block.registerForbiddenPair(3, 4);

                Block.registerForbiddenPair(4, 2);

                Block.registerForbiddenPair(1, 2);
                Block.registerForbiddenPair(1, 4);
                break;
            case 1:
                field = new BlocksField(4, 10, [
                    [new Block(4), new Block(1)],
                    [new Block(4), new Block(1)],
                    [new Block(4), new Block(1)],
                    [new Block(4), new Block(1)],
                    [new Block(4), new Block(1)],
                    [new Block(2), new Block(3)],
                    [new Block(2), new Block(3)],
                    [new Block(2), new Block(3)],
                    [new Block(2), new Block(3)],
                    [new Block(2), new Block(3)]
                ], 5, 0);
                break;
            case 2:
                field = new BlocksField(4, 10, [
                    [new Block(4), new Block(1)],
                    [new Block(4), new Block(1)],
                    [new Block(4), new Block(1)],
                    [new Block(4), new Block(1)],
                    [new Block(4), new Block(1)],
                    [new Block(2), new Block(3)],
                    [new Block(2), new Block(3)],
                    [new Block(2), new Block(3)],
                    [new Block(2), new Block(3)],
                    [new Block(2), new Block(3)]
                ], 5, 0);
                break;
        }

        _blocksSelector = new BlocksSelector(field.lines, field.cols, field.boundary, 4);
        _blocksSelector.field = field;

        _blocksDebugger = new BlocksDebugger(field);
        _debuggerControls = new DebuggerControls(_blocksDebugger);
        addChild(_debuggerControls);

        var dbgView:DebuggerView = new DebuggerView(_blocksDebugger);
        addChild(dbgView);

        _debuggerControls.x = 0;
        _debuggerControls.y = 254;

        _editor.x = 4;
        _editor.y = _debuggerControls.y + _debuggerControls.height + 6;

        if (api.problem.level == 0) {
            _editor.editorField.type = TextFieldType.DYNAMIC;
            _editor.editorField.selectable = false;
        }

        _blocksSelector.x = 4;
        _blocksSelector.y = 104 + _editor.y;

        addChild(_blocksSelector);

        _blocksSelector.addEventListener(Event.CHANGE, blocksChangeHandler);

        api.addEventListener(KioApi.RECORD_EVENT, apiRecordHandler);
    }

    private function initInfoFields():void {
        var loc:Object = api.localization;
        var labels:Array = api.problem.level == 0 ?
                [loc.labels.in_place, loc.labels.penalty, loc.labels.steps] :
                [loc.labels.in_place, loc.labels.prg_len, loc.labels.steps];
        _resultsInfo = new InfoPanel('KioArial', true, 16, 0x000000, 0x000000, 0x000000, 1.2, loc.labels.result, labels, 300);

        _recordInfo = new InfoPanel('KioArial', true, 16, 0x000000, 0x000000, 0x000000, 1.2, loc.labels.record, labels, 300);

        _resultsInfo.x = 10;
        _resultsInfo.y = 510;
        addChild(_resultsInfo);

        _recordInfo.x = 400;
        _recordInfo.y = 510;
        addChild(_recordInfo);
    }

    private function blocksChangeHandler(event:Event):void {
        _blocksDebugger.initialField = _blocksSelector.field.clone();
//        _debuggerControls.enabled = _blocksDebugger.validateFieldBlocks() == null;
    }

    public static function get instance():BlocksWorkspace {
        return _instance;
    }

    public function get editor():Editor {
        return _editor;
    }

    //public function currentResult():Object {}  //TODO report does no error is reported if there is no return

    public function get manualRegime():Boolean {
        return _manualRegime;
    }

    public function set manualRegime(manualRegime:Boolean):void {
        _manualRegime = manualRegime;

        _debuggerControls.manualRegime = _manualRegime;
        _editor.enabled = !_manualRegime;

        dispatchEvent(new Event(MANUAL_REGIME_EVENT));
    }

    public function displayResult(result:Object, isRecord:Boolean = false):void {
        var panel:InfoPanel = isRecord ? _recordInfo : _resultsInfo;
        panel.setValue(0, result.in_place);
        if (api.problem.level == 0)
            panel.setValue(1, result.penalty);
        else
            panel.setValue(1, result.prg_len);
        panel.setValue(2, result.steps);
    }

    public function get blocksDebugger():BlocksDebugger {
        return _blocksDebugger;
    }

    public function get blocksSelector():BlocksSelector {
        return _blocksSelector;
    }

    private function apiRecordHandler(event:Event):void {
        var result:Object = _blocksDebugger.getResult();
        displayResult(result, true); //TODO implement passing this result in API
        if (api.problem.level == 0)
            api.log('new record @BSSt', result.in_place, result.penalty, result.steps, _editor.editorField.text);
        else
            api.log('new record @BSSt', result.in_place, result.prg_len, result.steps, _editor.editorField.text);
    }

}
}