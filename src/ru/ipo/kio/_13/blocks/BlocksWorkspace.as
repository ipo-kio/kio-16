/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 12:52
 */
package ru.ipo.kio._13.blocks {
import flash.display.Sprite;

import ru.ipo.kio._13.blocks.model.Block;

import ru.ipo.kio._13.blocks.model.BlocksDebugger;
import ru.ipo.kio._13.blocks.model.BlocksField;

import ru.ipo.kio._13.blocks.view.DebuggerControls;
import ru.ipo.kio._13.blocks.view.DebuggerView;

import ru.ipo.kio._13.blocks.view.Editor;
import ru.ipo.kio.base.GlobalMetrics;

public class BlocksWorkspace extends Sprite {

    private static var _instance:BlocksWorkspace = null;
    private var _editor:Editor;
    private var _debuggerControls:DebuggerControls;

    public function BlocksWorkspace() {
        if (_instance == null)
            _instance = this;
        else
            throw new Error('Could not create the second instance of the Blocks Field');

        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT);
        graphics.endFill();

        _editor = new Editor(500, 90);
        addChild(_editor);

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
        ], 3, 0);
        var blocksDebugger:BlocksDebugger = new BlocksDebugger(field);
        _debuggerControls = new DebuggerControls(blocksDebugger);
        addChild(_debuggerControls);

        var dbgView:DebuggerView = new DebuggerView(blocksDebugger);
        addChild(dbgView);

        _debuggerControls.x = 0;
        _debuggerControls.y = dbgView.y + dbgView.height;

        _editor.x = 20;
        _editor.y = _debuggerControls.y + _debuggerControls.height;
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
}
}