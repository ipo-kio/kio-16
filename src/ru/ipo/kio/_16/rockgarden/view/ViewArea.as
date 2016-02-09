package ru.ipo.kio._16.rockgarden.view {
import flash.geom.Point;

import ru.ipo.kio._16.rockgarden.model.Garden;

public class ViewArea {

    private var _location:Point;
    private var _g:Garden;
    private var _side:int; //Garden.SIDE_*

    public function ViewArea(location:Point, g:Garden) {
        _location = location;
        _g = g;
        _side = _g.location2side(_g.point2location(_location));
    }

}
}
