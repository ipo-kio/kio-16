/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 19.02.12
 * Time: 15:37
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.geom.Point;

import ru.ipo.kio._12.diamond.Vertex2D;

public class LinearScaler implements Scaler {

    private var sx:Number;
    private var sy:Number;
    private var x0:Number;
    private var y0:Number;

    public function LinearScaler(sx:Number, sy:Number, x0:Number, y0:Number) {
        this.sx = sx;
        this.sy = sy;
        this.x0 = x0;
        this.y0 = y0;
    }

    public function point2vertex(point:Point):Vertex2D {
        return new Vertex2D((point.x - x0) / sx, (point.y - y0) / sy);
    }

    public function vertex2point(vertex:Vertex2D):Point {
        return new Point(x0 + sx * vertex.x, y0 + sy * vertex.y);
    }
}
}
