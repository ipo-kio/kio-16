package ru.ipo.kio._16.mower.view {
import flash.events.MouseEvent;

import ru.ipo.kio._16.mower.model.Field;

import ru.ipo.kio._16.mower.model.Position;

import ru.ipo.kio._16.mower.model.Program;

public class ProgramView {

    private var _view:FieldView;
    private var _program:Program;

    public function ProgramView(program:Program) {
        _program = program;
        _view = new FieldView(CellsDrawer.SIZE_BIG, program.commands);

        _view.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        _view.addEventListener(MouseEvent.CLICK, view_clickHandler);
    }

    //0       н х
    //1       р г
    //2       д й
    //3       т з
    //4       ч к
    //5       п б
    //6       ш ж щ
    //7       с ц
    //8       в ф
    //9       м л
    //б- г- ж- з- й к- л- ф- х ц щ-

    /*
     3.
     1415926535 8979323846 2643383279 5028841971 6939937510
     5820974944 5923078164 0628620899 8628034825 3421170679
     8214808651 3282306647 0938446095 5058223172 5359408128
     */

    private function filterCell(i:int, j:int):Boolean {
        return (i >= 1 && i < _program.commands.m && j >= 1 && j < _program.commands.n);
    }

    private function filterPosition(p:Position):Boolean {
        return filterCell(p.i, p.j);
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        var position:Position = _view.position2cell(event.localX, event.localY);
        if (filterPosition(position))
            _view.setHighlight(position.i, position.j);
        else
            _view.removeHighlight();
    }

    private function view_clickHandler(event:MouseEvent):void {
        var position:Position = _view.position2cell(event.localX, event.localY);
        if (filterPosition(position)) {
            var new_action:int = Field.FIELD_NOP;
            switch (_program.commands.getAt(position.i, position.j)) {
                case Field.FIELD_FORWARD:
                    new_action = Field.FIELD_TURN_LEFT;
                    break;
                case Field.FIELD_TURN_LEFT:
                    new_action = Field.FIELD_TURN_RIGHT;
                    break;
                case Field.FIELD_TURN_RIGHT:
                    new_action = Field.FIELD_NOP;
                    break;
                case Field.FIELD_NOP:
                    new_action = Field.FIELD_FORWARD;
                    break;
            }
            _program.commands.setAt(position.i, position.j, new_action);
            _view.redrawView();
        }
    }
}
}
