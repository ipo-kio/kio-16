/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 08.02.13
 * Time: 15:13
 */
package ru.ipo.kio._13.blocks.view {
import flash.display.Shape;
import flash.events.Event;
import flash.geom.Rectangle;

public class SymbolSelector extends Shape {

    private var _editor:EditorField;
    private var _index:int;
    private var _thickness:Number;
    private var _color:uint;
    private var _alpha:Number;

    public function SymbolSelector(editor:EditorField, index:int, thickness:Number, color:uint, alpha:Number = 1) {
        _editor = editor;
        _index = index;
        _thickness = thickness;
        _color = color;
        _alpha = alpha;

        _editor.addEventListener(Event.SCROLL, editor_scrollHandler);

        display();
    }

    public function scrollVisible():void {
        var line:int = 1 + _editor.getLineIndexOfChar(_index);

        var scrollV:int = _editor.scrollV;
        var bottomScrollV:int = _editor.bottomScrollV;
        var lines:int = bottomScrollV - scrollV + 1;

        if (scrollV <= line && bottomScrollV >= line)
            return;

        var linesHalf:int = lines / 2;
        var sv:int = lines - linesHalf;
        if (sv < 0)
            sv = 0;
        _editor.scrollV = sv;
    }

    public function destroy():void {
        _editor.removeEventListener(Event.SCROLL, editor_scrollHandler);
        parent.removeChild(this);
    }

    public function hide():void {
        index = -1;
    }


    public function get index():int {
        return _index;
    }

    public function set index(value:int):void {
        _index = value;
        display();
    }

    private function editor_scrollHandler(event:Event):void {
        display();
    }

    private function display():void {
        graphics.clear();

        if (index < 0)
            return;

        var line:int = 1 + _editor.getLineIndexOfChar(_index);

        var scrollV:int = _editor.scrollV;
        var bottomScrollV:int = _editor.bottomScrollV;

        if (scrollV > line && bottomScrollV < line)
            return;

        var boundaries:Rectangle = _editor.getCharBoundaries(_index);

        if (boundaries == null)
            return;

        if (boundaries.y < 0 || boundaries.bottom > _editor.height)
            return;

        if (_alpha == 1) {
            graphics.lineStyle(_thickness, _color);
            graphics.drawRect(boundaries.x - 2, boundaries.y, boundaries.width, boundaries.height);
        } else {
            graphics.beginFill(_color, _alpha);
            graphics.drawRect(boundaries.x - 2, boundaries.y, boundaries.width + 2, boundaries.height);
            graphics.endFill();
        }
    }
}
}
