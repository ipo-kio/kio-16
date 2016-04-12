package ru.ipo.kio._16.mars {
import ru.ipo.kio._16.mars.model.Consts;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.base.ExternalProblemChecker;

public class MarsChecker implements ExternalProblemChecker {
    private var p:KioProblem;
    private var workspace:*;
    private var level:int;
    private var sol:Array;
    private static const right_orbits:Array = [2, 4, 7, 11, 17, 24, 32, 41];

    public function MarsChecker(level:int) {
        this.p = new MarsProblem(level);
        workspace = p.display;
        this.level = level
    }

    public function set solution(solution:Object):void {
        if (level < 2)
            sol = solution.s;
        else
            p.loadSolution(solution);
    }

    public function get result():Object {
        if (level == 2) {
            var o:Object = workspace.result;
            o.md = o.md / 1000000;
            o.ms = o.ms * 3.6;
            return o;
        } else
            return get01result();
    }

    private function get01result():Object {
        //[2,163,4,160,7,162,11,161,17,178,24,172,32,179,41,180]
        var right_orbit:int = 0;
        var time_shift:int = 0;
        for (var i:int = 0; i < right_orbits.length; i++) {
            if (sol[2 * i] == right_orbits[i])
                right_orbit++;
        }

        for (i = 0; i < Consts.planets_phis.length; i++) {
            var shift:int = normalize_phi(sol[2 * i + 1]) - normalize_phi(sol[5]);
            var needShift:int = normalize_phi(Consts.planets_phis[i]) - normalize_phi(Consts.planets_phis[2]);
            var d:int = Math.abs(shift - needShift);
            time_shift += d;
        }

        return {
            'o': right_orbit,
            's': time_shift
        };
    }

    private static function normalize_phi(phi:Number):Number {
        var phiR:Number = phi * Math.PI / 180;
        return Math.round(180 * Math.atan2(Math.sin(phiR), Math.cos(phiR)) / Math.PI);
    }
}
}
