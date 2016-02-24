package ru.ipo.kio._16.mower.view {
import flash.display.Graphics;
import flash.display.Sprite;

import ru.ipo.kio._16.mower.model.Field;
import ru.ipo.kio._16.mower.model.Position;

public class FieldView extends Sprite {

    private var _field:Field;
    private var _size:int;

    private var _highlight_i:int = -1;
    private var _highlight_j:int = -1;

    private var view_layer:Sprite = new Sprite();
    private var highlight_layer:Sprite = new Sprite();

    public function FieldView(size:int, field:Field = null) {
        _size = size;
        _field = field;

        addChild(highlight_layer);
        addChild(view_layer);

        redrawView();
    }

    private function redrawHighlight():void {
        var g:Graphics = highlight_layer.graphics;
        g.clear();

        var len:Number = CellsDrawer.size2length(_size);
        var x0:Number = _highlight_j * len;
        var y0:Number = _highlight_i * len;

        g.beginFill(0xFF0000);
        g.drawRect(x0, y0, len, len);
        g.endFill();
    }

    private function redrawView():void {
        var g:Graphics = view_layer.graphics;
        g.clear();

        for (var i:int = 0; i < _field.m; i++)
            for (var j:int = 0; j < _field.n; j++)
                CellsDrawer.drawCell(g, i, j, _size, _field.getAt(i, j));
    }

    public function get field():Field {
        return _field;
    }

    public function set field(value:Field):void {
        if (_field != value) {
            _field = value;
            redrawView();
        }
    }

    public function setHighlight(i:int, j:int):void {
        _highlight_i = i;
        _highlight_j = j;
        redrawHighlight();
    }

    public function position2cell(x0:Number, y0:Number):Position {
        var i:int = Math.floor(y0 / _size);
        if (i < 0)
            i = 0;
        if (i >= _field.m)
            i = _field.m;

        var j:int = Math.floor(x0 / _size);
        if (j < 0)
            j = 0;
        if (j >= _field.m)
            j = _field.m;

        return new Position(i, j);
    }
}
}
