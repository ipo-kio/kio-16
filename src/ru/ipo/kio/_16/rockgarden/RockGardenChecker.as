/**
 * Created by ilya on 09.04.16.
 */
package ru.ipo.kio._16.rockgarden {
import ru.ipo.kio.base.ExternalProblemChecker;

public class RockGardenChecker implements ExternalProblemChecker {
    private var w:RockGardenWorkspace;

    public function RockGardenChecker(level:int) {
        this.w = RockGardenWorkspace(new RockGardenProblem(level).display);
    }

    public function set solution(solution:Object):void {
        if (solution == null)
            w.circles = w.empty_solution.c;
        w.circles = solution.c;
    }

    public function get result():Object {
        return w.result;
    }
}
}
