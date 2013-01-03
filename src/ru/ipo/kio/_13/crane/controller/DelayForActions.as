/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 03.01.13
 * Time: 15:50
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.controller {
import flash.utils.getTimer;

public class DelayForActions {
    var time: int;
    public function DelayForActions() {

    }
    public function start(delay: int){
        time = getTimer();
        while (getTimer() < time + delay){

        }
    }
}
}
