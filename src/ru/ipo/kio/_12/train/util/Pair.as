/**
 *
 * @author: Vasily Akimushkin
 * @since: 12.02.12
 */
package ru.ipo.kio._12.train.util {
import ru.ipo.kio._12.train.model.Train;

public class Pair {
    
    private var _train:Train;
    
    private var _count:int;


    public function Pair(train:Train, count:int) {
        _train = train;
        _count = count;
    }

    public function get count():int {
        return _count;
    }

    public function set count(value:int):void {
        _count = value;
    }

    public function get train():Train {
        return _train;
    }

    public function set train(value:Train):void {
        _train = value;
    }
}
}
