package kio._2016;

import kio.checker.KioExternalProblemChecker;

/**
 * Created by ilya on 08.04.16.
 */
public class KioExternalProblemChecker2016 extends KioExternalProblemChecker {
    public KioExternalProblemChecker2016(int level, String problemId) {
        super(level, problemId);
    }

    @Override
    public boolean getBelieveUnchecked() {
        return false;
    }
}
