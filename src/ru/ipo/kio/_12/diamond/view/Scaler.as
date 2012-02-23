/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 19.02.12
 * Time: 15:25
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.geom.Point;

import ru.ipo.kio._12.diamond.Vertex2D;

public interface Scaler {

    function point2vertex(point:Point):Vertex2D;
    function vertex2point(vertex:Vertex2D):Point;

}
}
