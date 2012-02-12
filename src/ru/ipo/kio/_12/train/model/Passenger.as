/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model {
import ru.ipo.kio._12.train.model.types.RailStationType;
import ru.ipo.kio._12.train.view.PassengerView;

public class Passenger extends VisibleEntity {

    private var _destination:RailStationType;

    public function Passenger(destination:RailStationType) {
        this._destination=destination;
        this.view = new PassengerView(this);
    }


    public function get destination():RailStationType {
        return _destination;
    }

    public function set destination(value:RailStationType):void {
        _destination = value;
    }
}
}
