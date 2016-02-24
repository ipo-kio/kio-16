package ru.ipo.kio._16.mower.view {
import flash.display.Sprite;
import flash.events.MouseEvent;

import ru.ipo.kio._16.mower.model.Program;

public class ProgramView extends Sprite {

    private var _program:Program;

    public function ProgramView(program:Program) {
        _program = program;

        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
    }

    private function rollOverHandler(event:MouseEvent):void {

    }

    private function rollOutHandler(event:MouseEvent):void {
    }
}
}
