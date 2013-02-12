/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 12.02.13
 * Time: 20:44
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.blocks.view {
import flash.display.Sprite;

import ru.ipo.kio._13.blocks.model.BlocksDebugger;

public class DebuggerView extends Sprite {

    private var _debugger:BlocksDebugger;

    public function DebuggerView(dbg:BlocksDebugger) {
        _debugger = dbg;
    }


}
}
