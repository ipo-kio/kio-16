/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 05.01.13
 * Time: 1:55
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.controller {

public class Loop extends Commands {
    var _count:int;
    var _program: Programm;
    public function Loop(count:int, programm:Programm) {
        _count = count;
        _program = programm;
    }
    public override function exec(controller: MovingModel):void {
        for (var i:int = 0; i < _count; i++)
            _program.exec(controller);
    }
}
}
