/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 12:52
 */
package ru.ipo.kio._13.blocks {
import flash.display.Sprite;

import ru.ipo.kio._13.blocks.view.Editor;

public class BlocksWorkspace extends Sprite {
    public function BlocksWorkspace() {
        var editor:Editor = new Editor(500, 90);
        editor.x = 0;
        editor.y = 0;
        addChild(editor);

        graphics.lineStyle(1, 0xFFFFFF);
        graphics.drawRect(0, 0, width, height);
    }

    public function currentResult():Object {  //TODO report does no error is reported if there is no return
        //TODO implement
        return null;
    }
}
}