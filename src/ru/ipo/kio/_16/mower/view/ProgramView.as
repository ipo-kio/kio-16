package ru.ipo.kio._16.mower.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio._16.mower.model.Field;

import ru.ipo.kio._16.mower.model.Position;

import ru.ipo.kio._16.mower.model.Program;

public class ProgramView extends Sprite {

    private var _views:Vector.<FieldView>;
    private var _program:Program;
    public static const PROGRAM_CHANGED:String = 'program changed';

    private var _current_highlight:HighlightedCell = null;

    public function ProgramView(program:Program) {
        _program = program;
        _views = new <FieldView>[];

        for (var state:int = 0; state < program.states_num; state++) {
            var view:FieldView = new FieldView(
                    CellsDrawer.SIZE_BIG,
                    program.commands[state],
                    program.states_num > 1 ? program.states[state] : null
            );

            view.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            view.addEventListener(MouseEvent.ROLL_OUT, view_rollOutHandler);
            view.addEventListener(MouseEvent.CLICK, view_clickHandler);

            var hit_area:Sprite = new Sprite();
            hit_area.mouseEnabled = false;
            view.addChild(hit_area);
            hit_area.visible = false;
            hit_area.graphics.beginFill(0xFF0000);
            hit_area.graphics.drawRect(view.len, view.len, view.len * (program.commands[state].m - 1), view.len * (program.commands[state].n - 1));
            view.hitArea = hit_area;
            view.mouseChildren = false;

            _views.push(view);
        }

        var x0:Number = 0;
        var y0:Number = 0;
        for each (view in _views) {
            addChild(view);
            view.x = x0;
            view.y = y0;

            y0 += view.height + 10;
        }
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
        return (i >= 1 && i < _program.commands[0].m && j >= 1 && j < _program.commands[0].n);
    }

    private function filterPosition(p:Position):Boolean {
        return filterCell(p.i, p.j);
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        var view:FieldView = event.target as FieldView;
        if (view == null)
            return;

//        for (var state:int = 0; state < _views.length; state++)
//            if (_views[state] == view)
//                break;
//        if (state == _views.length)
//            return;

        var cell:Position = view.position2cell(event.localX, event.localY);
        if (filterPosition(cell)) {
            var cellPos:Point = view.cell2position(cell.i, cell.j);
            var smallSelection:Boolean = program.states_num > 1 && event.localX - cellPos.x <= CellsDrawer.SIGN_SELECTION_SIZE && event.localY - cellPos.y <= CellsDrawer.SIGN_SELECTION_SIZE;

            var newHighlight:HighlightedCell = new HighlightedCell(cell.i, cell.j, 0xFFFF00, smallSelection);
            if (!newHighlight.equals(_current_highlight)) {
                if (_current_highlight != null)
                    view.removeHighlight(_current_highlight);
                _current_highlight = newHighlight;
                view.setHighlight(_current_highlight);
            }
        } else
            view.removeHighlight(_current_highlight);
    }

    private function view_clickHandler(event:MouseEvent):void {
        var view:FieldView = event.target as FieldView;
        if (view == null)
            return;

        for (var state:int = 0; state < _views.length; state++)
            if (_views[state] == view)
                break;
        if (state == _views.length)
            return;

        var position:Position = view.position2cell(event.localX, event.localY);
        if (filterPosition(position)) {
            if (!_current_highlight.small) {
                var new_action:int = Field.FIELD_FORWARD;
                switch (_program.commands[state].getAt(position.i, position.j)) {
                    case Field.FIELD_FORWARD:
                        new_action = Field.FIELD_TURN_LEFT;
                        break;
                    case Field.FIELD_TURN_LEFT:
                        new_action = Field.FIELD_TURN_RIGHT;
                        break;
                    case Field.FIELD_TURN_RIGHT:
                        new_action = Field.FIELD_FORWARD;
                        break;
                    case Field.FIELD_NOP:
                        new_action = Field.FIELD_FORWARD;
                        break;
                }
                _program.commands[state].setAt(position.i, position.j, new_action);
            } else {
                var new_state:int = 1 + _program.states[state].getAt(position.i, position.j);
                if (new_state > _program.states_num)
                    new_state = 1;
                _program.states[state].setAt(position.i, position.j, new_state);
            }

            view.redrawView();

            dispatchEvent(new Event(PROGRAM_CHANGED));
        }
    }

    public function redrawViews():void {
        for each (var view:FieldView in _views)
            view.redrawView();
    }

    private function view_rollOutHandler(event:MouseEvent):void {
        for (var state:int = 0; state < _program.states_num; state++)
            _views[state].removeHighlight(_current_highlight);
    }

    public function get program():Program {
        return _program;
    }
}
}
