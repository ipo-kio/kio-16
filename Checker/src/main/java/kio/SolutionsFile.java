package kio;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import kio.checker.KioProblemChecker;
import kio.logs.KioLogReader;

import java.io.File;
import java.io.IOException;
import java.util.*;

public class SolutionsFile {

    private KioProblemSet problemSet;
    private int level;
    private JsonNode root;

    private final Map<String, JsonObjectsComparator> id2comp = new HashMap<>();
    private final Map<String, KioProblemChecker> id2checker = new HashMap<>();

    public SolutionsFile(File file, int level, KioProblemSet problemSet) throws IOException {
        this.problemSet = problemSet;

        this.level = level;

        ObjectMapper mapper = new ObjectMapper();
        JsonFactory factory = mapper.getFactory();
        try (JsonParser p = factory.createParser(file)) {
            root = p.readValueAsTree();

            //fill id2comp
            List<String> problemIds = problemSet.getProblemIds(level);

            for (String pid : problemIds)
                id2comp.put(pid, problemSet.getComparator(level, pid));

            for (String pid : problemIds)
                id2checker.put(pid, problemSet.getChecker(level, pid));
        } catch (IOException e) {
            throw new IOException("Failed to read JSON in file", e);
        }
    }

    public Map<String, JsonNode> getProblemsSolutions() {
        return getProblemsNodes("best");
    }

    public Map<String, JsonNode> getProblemsResults() {
        return getProblemsNodes("best_result");
    }

    public Map<String, List<JsonNode>> getLogSolutions() {
        final Map<String, List<JsonNode>> res = new HashMap<>();

        new KioLogReader(root).go((problemID, solution, result) -> {
            List<JsonNode> nodes = res.get(problemID);
            if (nodes == null) {
                nodes = new ArrayList<>();
                res.put(problemID, nodes);
            }

            nodes.add(solution);
        });

        return res;
    }

    public Map<String, JsonNode> getLogResults() {
        final Map<String, JsonNode> res = new HashMap<>();

        new KioLogReader(root).go((problemId, solution, result) -> {
            JsonObjectsComparator comparator = id2comp.get(problemId);
            if (comparator == null)
                return;

            JsonNode oldResult = res.get(problemId);
            if (oldResult == null || comparator.compare(oldResult, result) < 0)
                res.put(problemId, result);
        });

        return res;
    }

    public Map<String, JsonNode> checkProblemsSolutions() {
        Map<String, JsonNode> res = new HashMap<>();

        Map<String, JsonNode> problemsSolutions = getProblemsSolutions();

        for (Map.Entry<String, JsonNode> entry : problemsSolutions.entrySet()) {
            String pid = entry.getKey();
            JsonNode solution = entry.getValue();
            KioProblemChecker checker = id2checker.get(pid);
            if (checker == null)
                continue;
            ObjectNode check = checker.check(solution);
            if (check != null)
                res.put(pid, check);
        }

        return res;
    }

    public Map<String, JsonNode> checkLogSolutions() {
        final Map<String, JsonNode> res = new HashMap<>();

        new KioLogReader(root).go((problemId, solution, result) -> {
            JsonObjectsComparator comparator = id2comp.get(problemId);
            if (comparator == null)
                return;
            KioProblemChecker checker = id2checker.get(problemId);
            if (checker == null)
                return;

            JsonNode oldResult = res.get(problemId);
            JsonNode newResult = checker.check(solution);
            if (oldResult == null || comparator.compare(oldResult, newResult) < 0)
                res.put(problemId, newResult);
        });

        return res;
    }

    public Map<String, JsonNode> uniteLogAndProblemResults() {
        return unite(getLogResults(), getProblemsResults());
    }

    public Map<String, JsonNode> unite(Map<String, JsonNode> m1, Map<String, JsonNode> m2) {
        Set<String> keys = new HashSet<>(m1.keySet());
        keys.addAll(m2.keySet());

        Map<String, JsonNode> res = new HashMap<>();

        for (String key : keys) {
            JsonNode n1 = m1.get(key);
            JsonNode n2 = m2.get(key);
            if (n1 == null) {
                res.put(key, n2);
                continue;
            }
            if (n2 == null) {
                res.put(key, n1);
                continue;
            }

            JsonObjectsComparator comparator = id2comp.get(key);
            if (comparator == null)
                continue;

            res.put(key, comparator.compare(n1, n2) >= 0 ? n1 : n2);
        }

        return res;
    }

    private Map<String, JsonNode> getProblemsNodes(String node) {
        Map<String, JsonNode> res = new HashMap<>();

        List<String> problemIds = problemSet.getProblemIds(level);
        for (String problemId : problemIds) {
            JsonNode problemNode = root.get(problemId);
            if (problemNode == null)
                continue;
            JsonNode bestResultNode = problemNode.get(node);
            if (bestResultNode == null)
                continue;

            res.put(problemId, bestResultNode);
        }

        return res;
    }

}
