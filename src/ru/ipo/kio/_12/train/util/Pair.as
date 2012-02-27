/**
 *
 * @author: Vasily Akimushkin
 * @since: 12.02.12
 */
package ru.ipo.kio._12.train.util {
import ru.ipo.kio._12.train.model.Train;

public class Pair {
    
    private var _train:Train;
    
    private var _count1:int;

    private var _count2:int;


    public function Pair(train:Train, count1:int, count2:int) {
        _train = train;
        _count1 = count1;
        _count2 = count2;
    }

    public function get count1():int {
        return _count1;
    }

    public function set count1(value:int):void {
        _count1 = value;
    }

    public function get count2():int {
        return _count2;
    }

    public function set count2(value:int):void {
        _count2 = value;
    }

    public function get train():Train {
        return _train;
    }

    public function set train(value:Train):void {
        _train = value;
    }
}
}
