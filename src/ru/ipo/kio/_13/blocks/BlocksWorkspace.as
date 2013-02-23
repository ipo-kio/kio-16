/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 12:52
 */
package ru.ipo.kio._13.blocks {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._13.blocks.model.Block;

import ru.ipo.kio._13.blocks.model.BlocksDebugger;
import ru.ipo.kio._13.blocks.model.BlocksField;
import ru.ipo.kio._13.blocks.view.BlocksSelector;

import ru.ipo.kio._13.blocks.view.DebuggerControls;
import ru.ipo.kio._13.blocks.view.DebuggerView;

import ru.ipo.kio._13.blocks.view.Editor;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;

public class BlocksWorkspace extends Sprite {

    [Embed(source="resources/bg.png")]
    public static const BG_CLS:Class;

    public static const MANUAL_REGIME_EVENT:String = 'manual regime';

    private static var _instance:BlocksWorkspace = null;
    private var _editor:Editor;
    private var _debuggerControls:DebuggerControls;

    private const api:KioApi = KioApi.instance(BlocksProblem.ID);

    private var _manualRegime:Boolean = false;

    public function BlocksWorkspace() {
        if (_instance == null)
            _instance = this;
        else
            throw new Error('Could not create the second instance of the Blocks Field');

        TextUtils.embedFonts();

        addChild(new BG_CLS);

        _editor = new Editor(552, 100);
        addChild(_editor);

        switch(api.problem.level) {
            case 0:
                var field:BlocksField = new BlocksField(4, 10, [
                    [new Block(1), new Block(2), new Block(3), new Block(4)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2), new Block(3), new Block(4)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2)],
                    [new Block(3), new Block(4)]
                ], 5, 0);
                break;
            case 1:
                field = new BlocksField(4, 10, [
                    [new Block(1), new Block(2), new Block(3), new Block(4)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2), new Block(3), new Block(4)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2)],
                    [new Block(3), new Block(4)]
                ], 5, 0);
                break;
            case 2:
                field = new BlocksField(4, 10, [
                    [new Block(1), new Block(2), new Block(3), new Block(4)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2), new Block(3), new Block(4)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2)],
                    [new Block(3), new Block(4)],
                    [new Block(1), new Block(2)],
                    [new Block(3), new Block(4)]
                ], 5, 0);
                break;
        }

        var blocksDebugger:BlocksDebugger = new BlocksDebugger(field);
        _debuggerControls = new DebuggerControls(blocksDebugger);
        addChild(_debuggerControls);

        var dbgView:DebuggerView = new DebuggerView(blocksDebugger);
        addChild(dbgView);

        _debuggerControls.x = 0;
        _debuggerControls.y = 254;

        _editor.x = 4;
        _editor.y = _debuggerControls.y + _debuggerControls.height + 6;

        var blocksSelector:BlocksSelector = new BlocksSelector(field.lines, field.cols, field.boundary, 4);
        blocksSelector.field = field;
        blocksSelector.x = 4;
        blocksSelector.y = 104 + _editor.y;

        addChild(blocksSelector);

        blocksSelector.addEventListener(Event.CHANGE, function(event:Event):void {
            blocksDebugger.initialField = blocksSelector.field.clone();
        })
    }

    public static function get instance():BlocksWorkspace {
        return _instance;
    }

    public function get editor():Editor {
        return _editor;
    }

    public function currentResult():Object {  //TODO report does no error is reported if there is no return
        //TODO implement
        return null;
    }

    public function get manualRegime():Boolean {
        return _manualRegime;
    }

    public function set manualRegime(manualRegime:Boolean):void {
        _manualRegime = manualRegime;

        _debuggerControls.manualRegime = !_manualRegime;
        _editor.enabled = !_manualRegime;

        dispatchEvent(new Event(MANUAL_REGIME_EVENT));
    }
}
}