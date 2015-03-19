package kio.checker;

import com.fasterxml.jackson.databind.JsonNode;
import kio.KioParameter;
import kio.KioProblemSet;
import kio.SolutionsFile;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Checker {

    public static Map<String, List<Integer>> login2levels = new HashMap<>();

    public static Table logTable;
    public static Table problemTable;
    public static Table logAndProblemTable;
    public static Table logNoCheckTable;
    public static Table problemNoCheckTable;

    public static void main(String[] args) throws IOException {
        if (args.length != 3) {
            System.out.println("Parameters: year, directory, output");
            return;
        }

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
            
            for (File solution : solutions) {
                String fileName = solution.getName();
                Matcher m = namePattern.matcher(fileName);
                if (m.matches()) {
                    String login = m.group(1);
                    int fileLevel = Integer.parseInt(m.group(2));

                    if (fileLevel != level)
                        continue;

                    processSolutionFile(solution, login, level, year, solutions);
                }
            }

            String outputFileName = addLevelToFileName(args[2], level);

            Table.saveToFile(
                    new File(outputFileName),
                    problemTable,
                    logTable,
                    logAndProblemTable,
                    problemNoCheckTable,
                    logNoCheckTable
            );
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

    private static void initTables() {
        logTable = new Table("Logs and problems", "login");
        problemTable = new Table("Problems", "login");
        logAndProblemTable = new Table("Logs", "login");
        logNoCheckTable = new Table("Logs no check", "login");
        problemNoCheckTable = new Table("Problems no check", "login");
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
        System.out.println("Processing login " + login);

        List<Integer> levels = login2levels.get(login);
        if (levels == null) {
            levels = new ArrayList<>();
            login2levels.put(login, levels);
        }
        levels.add(level);

        try {
            KioProblemSet problemSet = KioProblemSet.getInstance(year);
            SolutionsFile file = new SolutionsFile(solution, level, problemSet);

            Map<String, JsonNode> log = file.checkLogSolutions();
            Map<String, JsonNode> problems = file.checkProblemsSolutions();
            Map<String, JsonNode> logNoCheck = file.getLogResults();
            Map<String, JsonNode> problemsNoCheck = file.getProblemsResults();
            Map<String, JsonNode> logAndProblems = file.unite(log, problems);

            for (File oldFile : solutions)
                if (oldFile.getName().startsWith(login + ".kio-" + level + ".old.")) {
                    System.out.println("additionally processing old file");
                    file = new SolutionsFile(oldFile, level, problemSet);

                    log = file.unite(log, file.checkLogSolutions());
                    problems = file.unite(problems, file.checkProblemsSolutions());
                    logNoCheck = file.unite(logNoCheck, file.getLogResults());
                    problemsNoCheck = file.unite(problemsNoCheck, file.getProblemsResults());
                    logAndProblems = file.unite(logAndProblems, file.unite(log, problems));
                }

            table(logTable, log, login, level, problemSet);
            table(problemTable, problems, login, level, problemSet);
            table(logAndProblemTable, logAndProblems, login, level, problemSet);
            table(problemNoCheckTable, problemsNoCheck, login, level, problemSet);
            table(logNoCheckTable, logNoCheck, login, level, problemSet);

        } catch (IOException e) {
            System.out.println("failed to read solutions file: " + solution);
        }
    }

    private static void table(Table table, Map<String, JsonNode> results, String login, int level, KioProblemSet problemSet) {
        for (Map.Entry<String, JsonNode> entry : results.entrySet()) {
            String pid = entry.getKey();
            JsonNode result = entry.getValue();

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

}
