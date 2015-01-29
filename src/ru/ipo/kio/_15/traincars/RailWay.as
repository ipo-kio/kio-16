/**
 * Created by ilya on 29.01.15.
 */
package ru.ipo.kio._15.traincars {
import ru.ipo.kio._15.traincars.loc.RailsSet;

public class RailWay {
    private var _railsSet:RailsSet;
    private var _indices:Array;
    public function RailWay(railsSet:RailsSet, indices:Array) {
        _railsSet = railsSet;
        _indices = indices;
    }
}
}
