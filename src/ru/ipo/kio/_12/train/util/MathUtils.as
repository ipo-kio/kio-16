/**
 * Created by IntelliJ IDEA.
 * User: vakimushkin
 * Date: 24.02.12
 * Time: 13:43
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.train.util {
public class MathUtils {
    public function MathUtils(privateClass:PrivateClass) {
    }

    public static function splitInterval(topBound:int, amount:int):Vector.<int>{
        var intervals:Vector.<int> = new Vector.<int>();
        var currentTop:int = Math.round(Math.random()*topBound);
        intervals.push(currentTop);
        for(var i:int = 0; i<amount-1; i++){
            currentTop = Math.round(Math.random()*currentTop);
            intervals.push(currentTop);
        }
        return intervals.reverse();
    }
}
}
class PrivateClass {
    public function PrivateClass() {

    }
}

