package kio.checker;

import com.fasterxml.jackson.databind.JsonNode;
import kio.Attempt;
import kio.KioParameter;
import kio.KioProblemSet;
import kio.SolutionsFile;
import kio.certificates.Generator;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

// 2015 "/home/ilya/programming/kio-15/Checker/solutions" "/home/ilya/programming/kio-15/Checker/res.ods"
public class Checker {

    public static Map<String, List<Integer>> login2levels = new HashMap<>();

    public static Table logTable;
    public static Table problemTable;
    public static Table logAndProblemTable;
    public static Table logNoCheckTable;
    public static Table problemNoCheckTable;
    public static Table logAndProblemsNoCheckTable;

    private static Map<String, Integer> login2forcedLevel = new HashMap<>();

    public static Map<String, UserResults> results = new HashMap<>();
    public static Table finalTable;

    public static void main(String[] args) throws IOException {
        if (args.length != 3) {
            System.out.println("Parameters: year, solutions directory, output");
            return;
        }

        loadLevels();

        Pattern namePattern = Pattern.compile("(.*)\\.kio-(\\d)");

        int year = Integer.parseInt(args[0]);
        File solutionsFolder = new File(args[1]);
        File[] solutions = solutionsFolder.listFiles();

        if (solutions == null) {
            System.out.println("Failed to read the directory " + solutionsFolder);
            return;
        }

        for (int level = 0; level <= 2; level++) {
            initTables();
            results.clear();

            for (File solution : solutions) {
                String fileName = solution.getName();
                Matcher m = namePattern.matcher(fileName);
                if (m.matches()) {
                    String login = m.group(1);

                    /*Set<String> loginsToCheckExternally = new HashSet<>();
                    loginsToCheckExternally.add("31937752.13");
                    loginsToCheckExternally.add("02643461.4");
                    loginsToCheckExternally.add("31931365.2");
                    loginsToCheckExternally.add("31931368.7");
                    loginsToCheckExternally.add("31931362.2");

                    if (!loginsToCheckExternally.contains(login))
                        continue;*/

                    processSolutionFile(solution, login, level, year, solutions);
                }
            }

            String outputFileName = addLevelToFileName(args[2], level);

            Table.saveToFile(
                    new File(outputFileName),
                    finalTable,
                    problemTable,
                    logTable,
                    logAndProblemTable,
                    problemNoCheckTable,
                    logNoCheckTable,
                    logAndProblemsNoCheckTable
            );

            finalizeExternalCheck(level, year);

            filterUsersWithWrongLevel(level);
            sortAllUsers(level, KioProblemSet.getInstance(year));
            outputFinalTable(level);

            try {
                new Generator("kio-th.csv").run("th-certificates/certificates-" + level + ".pdf", results.values().stream().collect(Collectors.toList()));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        System.out.println("Users with several levels:");
        int manyLevelsCount = 0;
        for (Map.Entry<String, List<Integer>> entry : login2levels.entrySet()) {
            List<Integer> levels = entry.getValue();
            if (levels.size() >= 2) {
                String login = entry.getKey();
                System.out.println(login + ": " + levels);
                manyLevelsCount++;
            }
        }
        System.out.println("total: " + manyLevelsCount);
    }

    private static void loadLevels() {
        try (Scanner in = new Scanner(new File("levels.csv"))) {
            while(in.hasNextLine()) {
                String line = in.nextLine();
                String[] nameAndLevel = line.split(",");
                String name = nameAndLevel[0];
                int level = Integer.parseInt(nameAndLevel[1]);
                login2forcedLevel.put(name, level);
            }
        } catch (Exception e) {
            System.out.println("Failed to load levels");
        }
    }

    private static void initTables() {
        logTable = new Table("Logs and problems", "login");
        problemTable = new Table("Problems", "login");
        logAndProblemTable = new Table("Logs", "login");
        logNoCheckTable = new Table("Logs no check", "login");
        problemNoCheckTable = new Table("Problems no check", "login");
        logAndProblemsNoCheckTable = new Table("Logs and problems no check", "login");
        finalTable = new Table("results", "login");
    }

    private static String addLevelToFileName(String arg, int level) {
        String outputFileName = arg;

        int pnt = outputFileName.lastIndexOf('.');
        if (pnt >= 0)
            outputFileName = outputFileName.substring(0, pnt) + "." + level + outputFileName.substring(pnt);
        else
            outputFileName = outputFileName + "." + level + ".ods";
        return outputFileName;
    }

    private static void processSolutionFile(File solution, String login, int level, int year, File[] solutions) {
        try {
            KioProblemSet problemSet = KioProblemSet.getInstance(year);
            SolutionsFile file = new SolutionsFile(solution, problemSet);

            if (file.getLevel() != level)
                return;
            System.out.println("Processing login " + login);

            List<Integer> levels = login2levels.get(login);
            if (levels == null) {
                levels = new ArrayList<>();
                login2levels.put(login, levels);
            }
            levels.add(level);

            Map<String, Attempt> log = file.checkLogSolutions();
            Map<String, Attempt> problems = file.checkProblemsSolutions();
            Map<String, Attempt> logAndProblems = file.unite(log, problems);

            Map<String, Attempt> logNoCheck = file.getBestLogAttempts();
            Map<String, Attempt> problemsNoCheck = file.getProblemsAttempts();
            Map<String, Attempt> logAndProblemsNoCheck = file.unite(logNoCheck, problemsNoCheck);

            for (File oldFile : solutions)
                if (oldFile.getName().startsWith(login + ".kio-")) {
                    System.out.println("additionally processing old file");
                    file = new SolutionsFile(oldFile, problemSet);

                    if (file.getLevel() != level)
                        continue;

                    log = file.unite(log, file.checkLogSolutions());
                    problems = file.unite(problems, file.checkProblemsSolutions());
                    logAndProblems = file.unite(logAndProblems, file.unite(log, problems));

                    logNoCheck = file.unite(logNoCheck, file.getBestLogAttempts());
                    problemsNoCheck = file.unite(problemsNoCheck, file.getProblemsAttempts());
                    logAndProblemsNoCheck = file.unite(logAndProblemsNoCheck, file.unite(logNoCheck, problemsNoCheck));
                }

            table(logTable, log, login, level, problemSet);
            table(problemTable, problems, login, level, problemSet);
            table(logAndProblemTable, logAndProblems, login, level, problemSet);
            table(problemNoCheckTable, problemsNoCheck, login, level, problemSet);
            table(logNoCheckTable, logNoCheck, login, level, problemSet);
            table(logAndProblemsNoCheckTable, logAndProblemsNoCheck, login, level, problemSet);

            UserResults result = new UserResults(login, problemSet, level, logAndProblems, logAndProblemsNoCheck);
            results.put(login, result);
        } catch (IOException e) {
            System.out.println("failed to read solutions file: " + solution);
        }
    }

    private static void saveForExternalCheck(Map<String, Attempt> attempts, KioProblemSet problemSet, int level) {
        attempts.forEach((pid, attempt) ->
                problemSet.getChecker(level, pid).saveForExternalCheck(attempt.getSolution(), true)
        );
    }

    private static void finalizeExternalCheck(int level, int year) {
        KioProblemSet problemSet = KioProblemSet.getInstance(year);
        problemSet.getProblemIds(level).forEach(pid ->
                problemSet.getChecker(level, pid).finalizeSavingForExternalCheck()
        );
    }

    //TODO this duplicates code from UserResults.addResultToTable
    private static void table(Table table, Map<String, Attempt> results, String login, int level, KioProblemSet problemSet) {
        for (Map.Entry<String, Attempt> entry : results.entrySet()) {
            String pid = entry.getKey();
            JsonNode result = entry.getValue().getResult();
            if (result == null)
                continue;

            List<KioParameter> params = problemSet.getParams(level, pid);
            for (KioParameter param : params) {
                String paramId = param.getId();
                JsonNode jsonNode = result.get(paramId);
                if (jsonNode == null)
                    continue;

                table.set(
                        login,
                        "(" + pid + ") " + param.getName(),
                        jsonNode.asText()
                );
            }
        }
    }

    private static void filterUsersWithWrongLevel(int level) {
        results = results.entrySet().stream().filter(e -> {
            UserResults result = e.getValue();
            Integer forcedLevel = login2forcedLevel.get(result.getLogin());
            return forcedLevel == null || forcedLevel == level;
        }).collect(Collectors.toMap(
                Map.Entry::getKey,
                Map.Entry::getValue
        ));
    }

    private static void sortAllUsers(int level, KioProblemSet problemSet) {
        List<UserResults> r = new ArrayList<>(results.values());
        List<String> pids = problemSet.getProblemIds(level);
        int n = r.size();

        for (String pid : pids) {

            Comparator<UserResults> problemResultsComparator = (r1, r2) -> r1.getProblemResult(pid).compareTo(r2.getProblemResult(pid));

            r.sort(problemResultsComparator);

            //r.stream().map(r -> {Attempt a = r.getProblemResult("markov").getAttempt(); if (a!=null) return a.getResult(); else return null;}).collect(Collectors.toList())
            int scores = 0;
            r.get(0).setScores(pid, scores);
            for (int i = 1; i < n; i++) {
                UserResults prevResult = r.get(i - 1);
                UserResults nextResult = r.get(i);

                if (problemResultsComparator.compare(prevResult, nextResult) != 0)
                    scores = i;

                nextResult.setScores(pid, scores);
            }

            int rank = 1;
            r.get(n - 1).setRank(pid, rank);
            for (int i = n - 2; i >= 0; i--) {
                UserResults prevResult = r.get(i + 1);
                UserResults nextResult = r.get(i);
                if (problemResultsComparator.compare(prevResult, nextResult) != 0)
                    rank++;
                nextResult.setRank(pid, rank);
            }
        }

        r.sort((r1, r2) -> r1.getScores() - r2.getScores());

        int rank = 1;
        r.get(n - 1).setRank(rank);
        for (int i = n - 2; i >= 0; i--) {
            UserResults prevResult = r.get(i + 1);
            UserResults nextResult = r.get(i);
            if (prevResult.getScores() != nextResult.getScores())
                rank++;
            nextResult.setRank(rank);
        }
    }

    private static void outputFinalTable(int level) throws IOException {
        results.values().forEach(result -> result.addToTable(finalTable));
        Table.saveToFile(new File("results." + level + ".ods"), finalTable);
    }
}
