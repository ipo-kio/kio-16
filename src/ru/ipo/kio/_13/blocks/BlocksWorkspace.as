/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 12:52
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.blocks {
import flash.display.Sprite;

import ru.ipo.kio._13.blocks.parser.Parser;

public class BlocksWorkspace extends Sprite {
    public function BlocksWorkspace() {
        var p:Parser = new Parser("L2R3(TP)");
        p.program.execute(new TestExecutor())
    }

    public function currentResult():Object {  //TODO report does no error is reported if there is no return
        //TODO implement
        return null;
    }
}
}

import ru.ipo.kio._13.blocks.parser.Executor;

class TestExecutor implements Executor {

    public function left():String {
        trace('move left');
        return null;
    }

    public function right():String {
        trace('move right');
        return null;
    }

    public function take():String {
        trace('take');
        return null;
    }

    public function put():String {
        trace('put');
        return null;
    }
}
