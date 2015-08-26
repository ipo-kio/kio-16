package kio.checker;

import kio.Attempt;

public class ProblemResult implements Comparable<ProblemResult> {

    private boolean believeUnchecked;
    private Attempt attempt;
    private Attempt uncheckedAttempt;
    private int scores;
    private int rank;

    public ProblemResult(Attempt attempt, Attempt uncheckedAttempt, boolean believeUnchecked) {
        this.attempt = attempt;
        this.uncheckedAttempt = uncheckedAttempt;
        this.believeUnchecked = believeUnchecked;
    }

    public boolean isUncheckedBetter() {
        return uncheckedAttempt.compareTo(attempt) > 0;
    }

    public int getScores() {
        return scores;
    }

    public Attempt getAttempt() {
        return attempt;
    }

    public Attempt getUncheckedAttempt() {
        return uncheckedAttempt;
    }

    public Attempt getBelievedAttempt() {
        return believeUnchecked ? uncheckedAttempt : attempt;
    }

    public int getRank() {
        return rank;
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public void setScores(int scores) {
        this.scores = scores;
    }

    @Override
    public int compareTo(ProblemResult pr) {
        //comparing unchecked attempts
        Attempt a = believeUnchecked ? uncheckedAttempt : attempt;
        Attempt a2 = believeUnchecked ? pr.uncheckedAttempt : pr.attempt;

        if (a == null && a2 == null)
            return 0;
        if (a == null)
            return -1;
        if (a2 == null)
            return 1;

        return a.compareTo(a2);
    }
}
