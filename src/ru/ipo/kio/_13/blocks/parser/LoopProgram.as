/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 20:18
 */
package ru.ipo.kio._13.blocks.parser {

public class LoopProgram implements Program {

    private var _program:Program;
    private var _count:int;

    public function LoopProgram(program:Program, count:int) {
        _program = program;
        _count = count;
    }

    public function execute(executor:Executor):void {
        for (var i:int = 0; i < _count; i++)
            _program.execute(executor);
    }
}
}
