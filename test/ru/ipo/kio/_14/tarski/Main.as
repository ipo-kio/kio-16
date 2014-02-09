/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski {
import asunit.textui.TestRunner;

import flash.display.Sprite;

public class Main extends Sprite
{

    public function Main()
    {
        var unittests:TestRunner = new TestRunner();
        stage.addChild(unittests);
        unittests.start(TarskiTestSuite, null, TestRunner.SHOW_TRACE);
    }
}
}
