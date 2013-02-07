/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 20:18
 */
package ru.ipo.kio._13.blocks.parser {

public class SequenceProgram implements Program {

    private var _commands:Array = []; //array of Program

    public function execute(executor:Executor):void {
        for each (var program:Program in _commands)
            program.execute(executor);
    }

    public function add(program:Program):void {
        _commands.push(program);
    }
}
}
