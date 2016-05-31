package kio;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import kio.logs.KioLogReader;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class SolutionsFile {

    private KioProblemSet problemSet;
    private int level;
    private JsonNode root;
    private int year;

    public SolutionsFile(File file, KioProblemSet problemSet) throws IOException {
        this.problemSet = problemSet;

        ObjectMapper mapper = new ObjectMapper();
        JsonFactory factory = mapper.getFactory();
        try (JsonParser p = factory.createParser(file)) {
            root = p.readValueAsTree();
        } catch (IOException e) {
            throw new IOException("Failed to read JSON in file", e);
        }

        int realLevel = root.get("kio_base").get("level").asInt();
        if (!file.getName().contains("kio-" + realLevel))
            System.out.println("Real level of file " + file.getName() + " is " + realLevel);
        this.level = realLevel;

        //TODO get year in normal way
        int wrongYearDetection = root.get("mower") == null ? 2015 : 2016;
        int correctYearDetection =
                root.get("mower") != null ||
                root.get("rockgarden") != null ||
                root.get("mars") != null ? 2016 : 2015;
        if (wrongYearDetection != correctYearDetection)
            System.out.println("Wrongly detected year previously");
        this.year = correctYearDetection;
    }

    public Map<String, Attempt> getProblemsAttempts() {
        Map<String, Attempt> res = new HashMap<>();

        List<String> problemIds = problemSet.getProblemIds(level);
        for (String problemId : problemIds) {
            JsonNode problemNode = root.get(problemId);
            if (problemNode == null)
                continue;
            JsonNode bestSolutionNode = problemNode.get("best");
            JsonNode bestResultNode = problemNode.get("best_result");
            if (bestSolutionNode == null && bestResultNode == null)
                continue;

            res.put(problemId, new Attempt(problemId, level, problemSet, bestSolutionNode, bestResultNode));
        }

        return res;
    }

    public Map<String, List<Attempt>> getAllLogAttempts() {
        final Map<String, List<Attempt>> res = new HashMap<>();

        new KioLogReader(root).go((problemId, solution, result) -> {
            List<Attempt> attempts = res.get(problemId);
            if (attempts == null) {
                attempts = new ArrayList<>();
                res.put(problemId, attempts);
            }

            attempts.add(new Attempt(problemId, level, problemSet, solution, result));
        });

        return res;
    }

    public Map<String, Attempt> getBestLogAttempts() {
        Map<String, Attempt> res = new HashMap<>();
        for (Map.Entry<String, List<Attempt>> entry : getAllLogAttempts().entrySet()) {
            String problemId = entry.getKey();
            List<Attempt> allAttemptsForProblem = entry.getValue();
            res.put(problemId, Collections.max(allAttemptsForProblem));
        }
        return res;
    }

    public Map<String, Attempt> checkProblemsSolutions() {
        Map<String, Attempt> problemsSolutions = getProblemsAttempts();
        problemsSolutions.values().forEach(Attempt::recheck);
        return problemsSolutions;
    }

    public Map<String, Attempt> checkLogSolutions() {
        Map<String, List<Attempt>> allLogAttempts = getAllLogAttempts();
        allLogAttempts.values().forEach(attempts -> attempts.forEach(Attempt::recheck));
        return allLogAttempts.entrySet().stream().collect(
                Collectors.toMap(Map.Entry::getKey, e -> Collections.max(e.getValue()))
        );
    }

    public Map<String, Attempt> uniteLogAndProblemAttempts() {
        return unite(getBestLogAttempts(), getProblemsAttempts());
    }

    public Map<String, Attempt> unite(Map<String, Attempt> m1, Map<String, Attempt                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                > m2) {
        Set<String> keys = new HashSet<>(m1.keySet());
        keys.addAll(m2.keySet());

        Map<String, Attempt> res = new HashMap<>();

        for (String key : keys) {
            Attempt a1 = m1.get(key);
            Attempt a2 = m2.get(key);
            if (a1 == null) {
                res.put(key, a2);
                continue;
            }
            if (a2 == null) {
                res.put(key, a1);
                continue;
            }

            res.put(key, a1.compareTo(a2) >= 0 ? a1 : a2);
        }

        return res;
    }

    public int getLevel() {
        return level;
    }

    public int getYear() {
        return year;
    }
}
