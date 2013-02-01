/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 25.01.13
 * Time: 21:24
 */
package ru.ipo.kio._13.cut.view {
import flash.display.Graphics;
import flash.geom.Point;

import pl.bmnet.gpcas.geometry.Poly;


public class OutlineView {

    private var _fx:Function;
    private var _fy:Function;

    public function OutlineView(fx:Function, fy:Function) {
        _fx = fx;
        _fy = fy;
    }

    public function drawOutline(g:Graphics, outline:Array, thickness:Number, color:uint, alpha:Number = 1, x:Number = 0, y:Number = 0):void {
        if (outline.length == 0)
            return;

        g.lineStyle(thickness, color, alpha);

        g.moveTo(_fx(x + outline[0].x), _fy(y + outline[0].y));

        for (var i:int = 1; i < outline.length; i ++)
            g.lineTo(_fx(x + outline[i].x), _fy(y + outline[i].y));
    }

    public function drawPoly(g:Graphics, outline:Poly, thickness:Number, color:uint, alpha:Number = 1, x:Number = 0, y:Number = 0):void {
        g.lineStyle(thickness, color, alpha);

        var numPoints:int = outline.getNumPoints();
        var first:Point = outline.getPoint(numPoints - 1);
        g.moveTo(_fx(x + first.x), _fy(y + first.y));

        for (var i:int = 0; i < numPoints; i ++) {
            var next:Point = outline.getPoint(i);
            g.lineTo(_fx(x + next.x), _fy(y + next.y));
        }
    }

}
}
