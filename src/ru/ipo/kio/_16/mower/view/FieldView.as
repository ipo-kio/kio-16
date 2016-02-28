package ru.ipo.kio._16.mower.view {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.Dictionary;

import ru.ipo.kio._16.mower.model.Field;
import ru.ipo.kio._16.mower.model.Position;

public class FieldView extends Sprite {

    private var _field:Field;
    private var _size:int;

    private var _len:Number;

    private var view_layer:Sprite = new Sprite();
    private var highlight_layer:Sprite = new Sprite();

    private var _highlights:Dictionary = new Dictionary(); // HighlightedCell -> Boolean

    private var _additional_field:Field;

    public function FieldView(size:int, field:Field = null, additional_field:Field = null) {
        _size = size;
        _field = field;
        _additional_field = additional_field;

        _len = CellsDrawer.size2length(_size);

        addChild(highlight_layer);
        addChild(view_layer);

        redrawView();

        var hit:Sprite = new Sprite();
        addChild(hit);
        hit.visible = false;
        hit.mouseEnabled = false;
        hit.graphics.beginFill(0xFF0000);
        hit.graphics.drawRect(0, 0, _len * field.m, _len * field.n);
        hit.graphics.endFill();
        hitArea = hit;
    }

    public function redrawHighlight():void {
        var g:Graphics = highlight_layer.graphics;
        g.clear();

        for (var hCell:Object in _highlights) {
            var x0:Number = hCell.j * _len;
            var y0:Number = hCell.i * _len;

            g.beginFill(hCell.c, hCell.alpha);

            var s:Number = hCell.small ? CellsDrawer.SIGN_SELECTION_SIZE : _len;

            g.drawRect(x0, y0, s, s);
            g.endFill();
        }
    }

    public function redrawView():void {
        var g:Graphics = view_layer.graphics;
        g.clear();

        for (var i:int = 0; i < _field.m; i++)
            for (var j:int = 0; j < _field.n; j++) {
                CellsDrawer.drawCell(g, i, j, _field.getAt(i, j), _size);

                if (_additional_field) {
                    var ii:Number = i;
                    var jj:Number = j;

                    if (i == 0 && j == 0) {
                        ii = 8 / 25;
                        jj = 8 / 25;
                    }

                    CellsDrawer.drawSymbol(g, ii, jj, _additional_field.getAt(i, j));
                }
            }
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

    public function setHighlight(hCell:HighlightedCell):void {
        _highlights[hCell] = true;
        redrawHighlight();
    }

    public function removeHighlight(hCell:HighlightedCell):void {
        if (hCell != null)
            delete _highlights[hCell];
        redrawHighlight()
    }

    public function position2cell(x0:Number, y0:Number):Position {
        var i:int = Math.floor(y0 / _len);
        if (i < 0)
            i = 0;
        if (i >= _field.m)
            i = _field.m;

        var j:int = Math.floor(x0 / _len);
        if (j < 0)
            j = 0;
        if (j >= _field.m)
            j = _field.m;

        return new Position(i, j);
    }

    public function cell2position(i:int, j:int):Point {
        return new Point(j * _len, i * _len);
    }

    public function get len():Number {
        return _len;
    }
}
}
