package kio.checker;

import com.fasterxml.jackson.databind.JsonNode;
import kio.Attempt;
import kio.KioParameter;
import kio.KioProblemSet;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class UserResults {

    private String login;
    private int level;
    private KioProblemSet problemSet;
    private Map<String, ProblemResult> problemResults = new HashMap<>();
    private int rank;

    public UserResults(String login, KioProblemSet problemSet, int level, Map<String, Attempt> attempts, Map<String, Attempt> uncheckedAttempts) {
        this.login = login;
        this.level = level;
        this.problemSet = problemSet;
        problemResults = problemSet.getProblemIds(level).stream().collect(
                Collectors.toMap(pid -> pid, pid -> new ProblemResult(
                        attempts.get(pid),
                        uncheckedAttempts.get(pid),
                        problemSet.getChecker(level, pid).getBelieveUnchecked()
                ))
        );
    }

    public String getLogin() {
        return login;
    }

    public int getLevel() {
        return level;
    }

    public int getScores() {
        return problemResults.values().stream().collect(Collectors.summingInt(ProblemResult::getScores));
    }

    public void setScores(String problemId, int scores) {
        problemResults.get(problemId).setScores(scores);
    }

    public void setRank(String problemId, int rank) {
        problemResults.get(problemId).setRank(rank);
    }

    public int getRank() {
        return rank;
    }

    public ProblemResult getProblemResult(String problemId) {
        return problemResults.get(problemId);
    }

    public void setRank(int rank) {
        this.rank = rank;
    }

    public void addToTable(Table table) {
        table.set(login, "kio_level", level);

        table.set(login, "kio_" + level + "_scores", getScores());
        table.set(login, "kio_" + level + "_rank", rank);

        List<String> problemIds = problemSet.getProblemIds(level);
        problemIds.forEach(pid -> {
            ProblemResult problemResult = problemResults.get(pid);
            if (problemResult == null)
                return;

            table.set(login, "kio_" + level + "_scores_" + pid, problemResult.getScores());
            table.set(login, "kio_" + level + "_rank_" + pid, problemResult.getRank());

            if (problemSet.getChecker(level, pid).getBelieveUnchecked()) {
                Attempt uncheckedAttempt = problemResult.getUncheckedAttempt();
                if (uncheckedAttempt == null)
                    return;

                addResultToTable(table, pid, uncheckedAttempt.getResult(), "");
                if (problemResult.isUncheckedBetter()) {
                    table.set(login, pid + "_unchecked_better", 1);
                    addResultToTable(table, pid, problemResult.getAttempt().getResult(), "chk");
                    table.set(login, "" + pid + "_unchecked_solution", uncheckedAttempt.getSolution().toString());
                }
            } else {
                Attempt attempt = problemResult.getAttempt();
                if (attempt == null)
                    return;

                addResultToTable(table, pid, attempt.getResult(), "");
            }
        });
    }

    public void addResultToTable(Table table, String pid, JsonNode result, String prefix) {
        if (result == null)
            return;

        List<KioParameter> params = problemSet.getParams(level, pid);
        for (KioParameter param : params) {
            String paramId = param.getId();
            JsonNode jsonNode = result.get(paramId);
            if (jsonNode == null)
                continue;

            Object value;
            if (jsonNode.isInt())
                value = jsonNode.asInt();
            else if (jsonNode.isLong())
                value = jsonNode.asLong();
            else if (jsonNode.isDouble())
                value = jsonNode.asDouble();
            else
                value = jsonNode.asText();

            table.set(
                    login,
                    "kio_" + prefix + level + "_" + pid + "_" + paramId,
                    value
            );
        }
    }
}
