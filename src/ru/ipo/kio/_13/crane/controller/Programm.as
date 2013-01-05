/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 03.01.13
 * Time: 14:27
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.controller {
import flash.utils.getTimer;

public class Programm{

    var commands: Array = new Array();  //of Command

    public function push(c:Commands):void {
        commands.push(c);
    }

    public function exec(controller: MovingModel):void {


        for each (var c: Commands in commands)     {
       //     delay.start(1000);
            c.exec(controller);

        //    trace(controller._crane.toString());
        }   /*
        while (commands.length > 0){
            commands.shift();
        }
              */
    }


    public function Programm() {
    }
}
}
