/**
 * Created by ilya on 06.03.16.
 */
package ru.ipo.kio._16.mars.view {
import flash.geom.Point;

import ru.ipo.kio._16.mars.model.Vector2D;

public interface SpaceSystem {

    function position2point(position:Vector2D):Point;

}
}
