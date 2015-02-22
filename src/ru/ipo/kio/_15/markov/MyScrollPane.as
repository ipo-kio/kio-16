/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 26.02.14
 */
package ru.ipo.kio._15.markov {
import fl.containers.ScrollPane;

import flash.events.MouseEvent;

public class MyScrollPane extends ScrollPane{

    protected override function endDrag(event:MouseEvent):void {
        if (stage) {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, doDrag);
        }
    }
}
}


