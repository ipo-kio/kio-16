package kio;

import com.fasterxml.jackson.databind.JsonNode;
import com.sun.istack.internal.NotNull;

public class Attempt implements Comparable<Attempt> {

    private final String problemId;
    private final int level;
    private final KioProblemSet problemSet;
    private final JsonNode solution;
    private JsonNode result;

    public Attempt(String problemId, int level, KioProblemSet problemSet, JsonNode solution) {
        this(problemId, level, problemSet, solution, null);
        recheck();
    }

    public Attempt(String problemId, int level, KioProblemSet problemSet, JsonNode solution, JsonNode result) {
        this.problemId = problemId;
        this.level = level;
        this.problemSet = problemSet;
        this.solution = solution;
        this.result = result;
    }

    public String getProblemId() {
        return problemId;
    }

    public JsonNode getSolution() {
        return solution;
    }

    public JsonNode getResult() {
        return result;
    }

    @Override
    public int compareTo(Attempt a) {
        if (a == null)
            return 1;

        JsonObjectsComparator comparator = problemSet.getComparator(level, problemId);
        return comparator.compare(result, a.result);
    }

    public void recheck() {
        result = problemSet.getChecker(level, problemId).check(solution);
    }
}
