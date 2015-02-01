/**
 * Created by ilya on 29.01.15.
 */
package ru.ipo.kio._15.traincars {
import ru.ipo.kio._15.traincars.RailsSet;

public class RailWay {
    private var _railsSet:RailsSet;
    private var _indices:Array;
    public function RailWay(railsSet:RailsSet, indices:Array) {
        _railsSet = railsSet;
        _indices = indices;

        for each (var ind:int in indices)
            if (ind >= railsSet.size)
                throw new Error("index " + ind + " in rails set");
    }

    public function drawDebug():void {
        for each (var i:int in _indices)
            _railsSet.rail(i).drawDebug();
    }

    public function get size():int {
        return _indices.length;
    }

    public function rail(i:int):CurveRail {
        return _railsSet.rail(_indices[i]);
    }
}
}
