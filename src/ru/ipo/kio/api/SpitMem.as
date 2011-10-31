/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 17.02.11
 * Time: 19:58
 */
package ru.ipo.kio.api {
import flash.events.Event;
import flash.system.System;
import flash.utils.Timer;

public class SpitMem {
    private var t:Timer = new Timer(100);
    private var n:int, lastN:int;

    public function SpitMem():void {
        t.addEventListener("timer", spit2, false, 0, true);
        t.start();
    }

    private function spit2(event:Event):void {
        n = System.totalMemory;
        if (n != lastN)
            trace(n);
        lastN = n;
    }
}
}
