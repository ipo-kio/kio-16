package ru.ipo.kio._16.mower.view {
import fl.controls.listClasses.CellRenderer;

import flash.display.Graphics;

import flash.display.Sprite;

import ru.ipo.kio._16.mower.model.Mower;

import ru.ipo.kio._16.mower.model.State;

public class StateView extends Sprite {
    private var _state:State;

    public function StateView(state:State) {
        _state = state;

        var field_view:FieldView = new FieldView(CellsDrawer.SIZE_SMALL, state.field);
        addChild(field_view);

        var mowers_view:Sprite = new Sprite();
        addChild(mowers_view);

        for each (var mower:Mower in state.mowers) {
            CellsDrawer.drawMower(mowers_view.graphics, mower, CellsDrawer.SIZE_SMALL);
        }
    }

    public function get state():State {
        return _state;
    }
}
}
