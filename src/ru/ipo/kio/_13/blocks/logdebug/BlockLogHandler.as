/**
 *
 * @author: Vasiliy
 * @date: 05.05.13
 */
package ru.ipo.kio._13.blocks.logdebug {
import mx.utils.StringUtil;

import ru.ipo.kio._13.blocks.BlocksProblem;
import ru.ipo.kio._13.blocks.BlocksWorkspace;
import ru.ipo.kio._13.blocks.view.BlocksSelector;
import ru.ipo.kio._13.blocks.view.DebuggerControls;
import ru.ipo.kio._13.blocks.view.Editor;
import ru.ipo.kio._13.blocks.view.SoftKeyboard;

import ru.ipo.kio.api.ILogDebuggerHandler;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;
import ru.ipo.kio.base.logdebug.LogDebugCommand;

public class BlockLogHandler implements ILogDebuggerHandler{
    private static const BLOCKS_PREFIX:String = "blocks: ";

    public static const SOFT_KEYBOARD_PREFIX:String = "button ";

    public static const DEBUG_CONTROLS_PREFIX:String = "debug controls ";

    public static const BLOCK_SELECTOR_PREFIX:String = "change block";


    public function execute(command:LogDebugCommand):Boolean {
        var cmd:String = command.text.substr(BLOCKS_PREFIX.length);
        var problem:BlocksProblem = BlocksProblem(KioBase.instance.problem(1));
        var workspace:BlocksWorkspace = BlocksWorkspace(problem.display);
        var editor:Editor = workspace.editor;
        if(cmd.substring(0,SOFT_KEYBOARD_PREFIX.length)==SOFT_KEYBOARD_PREFIX){
            var keyboard:SoftKeyboard = editor.keyboard;
            var manual:Boolean = cmd.indexOf("manual")!=-1;
            cmd = cmd.substr(SOFT_KEYBOARD_PREFIX.length);
            if(manual){
                cmd = cmd.substr(0,cmd.length-" manual".length);
            }
            keyboard.processAction(cmd, manual);
        }else if (cmd.substring(0,DEBUG_CONTROLS_PREFIX.length)==DEBUG_CONTROLS_PREFIX){
            var debuggerControls:DebuggerControls = workspace.debuggerControls;
            cmd = cmd.substr(DEBUG_CONTROLS_PREFIX.length);
            debuggerControls.processAction(cmd);
        }else if (cmd.substring(0,BLOCK_SELECTOR_PREFIX.length)==BLOCK_SELECTOR_PREFIX){
            cmd = cmd.substr(BLOCK_SELECTOR_PREFIX.length);
            var blockSelector:BlocksSelector = workspace.blocksSelector;
            blockSelector.processAction(new int(cmd.charAt(0)), new int(cmd.charAt(1)));
        }
        return true;
    }

    public function canExecute(command:LogDebugCommand):Boolean {
        return command.text.length>BLOCKS_PREFIX.length && command.text.substr(0,BLOCKS_PREFIX.length)==BLOCKS_PREFIX;
    }
}
}
