/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 25.01.13
 * Time: 21:24
 */
package ru.ipo.kio._13.cut.view {
import flash.display.Graphics;


public class OutlineView {

    private var _fieldView:PiecesFieldView;

    public function OutlineView(fieldView:PiecesFieldView) {
        _fieldView = fieldView;
    }

    public function drawOutline(g:Graphics, outline:Array, thickness:Number,  color:uint, alpha:Number = 1, x:Number = 0, y:Number = 0):void {
        g.lineStyle(thickness, color, alpha);

        var fx:Function = _fieldView.logic2screenX;
        var fy:Function = _fieldView.logic2screenY;

        for (var i:int = 0; i < outline.length - 1; i ++) {
            g.moveTo(fx(x + outline[i].x), fy(y + outline[i].y));
            g.lineTo(fx(x + outline[i + 1].x), fy(y + outline[i + 1].y));
        }
    }

}
}
