package kio.checker;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.*;
import java.util.*;

public class KioExternalProblemChecker extends KioProblemChecker {

    public static final ObjectMapper mapper = new ObjectMapper();
    public static final JsonFactory factory = mapper.getFactory();

    private String problemId;
    private Map<JsonNode, JsonNode> solution2result = null;
    private Set<JsonNode> solutionsToCheck = new LinkedHashSet<>();

    public KioExternalProblemChecker(int level, String problemId) {
        super(level);
        this.problemId = problemId;

        loadSolution2result();
    }

    @Override
    protected void run(JsonNode solution) {
        if (solution2result == null)
            return;

        JsonNode result = solution2result.get(solution);
        if (result == null)
            return;

        saveForExternalCheck(solution, false);

        Iterator<Map.Entry<String, JsonNode>> fields = result.fields();
        while (fields.hasNext()) {
            Map.Entry<String, JsonNode> next = fields.next();

            JsonNode value = next.getValue();
            String field = next.getKey();
            if (value.isInt())
                set(field, value.asInt());
            else if (value.isLong())
                set(field, value.asLong());
            else if (value.isDouble())
                set(field, value.asDouble());
        }
    }

    @Override
    public boolean getBelieveUnchecked() {
        return true;
    }

    public void saveForExternalCheck(JsonNode solution, boolean best) {
        if (getExternalCheckerType() == EXTERNAL_CHECKER_SAVE_BEST && !best)
            return;

        solutionsToCheck.add(solution);
    }

    public void finalizeSavingForExternalCheck() {
        File file = getFileWithSolutionsForExternalCheck();
        try (PrintStream out = new PrintStream(file, "UTF-8")) {
            solutionsToCheck.forEach(out::println);
        } catch (IOException e) {
            System.out.printf("Failed to save solutions for external check. Problem %s, level %d\n", problemId, level);
            e.printStackTrace();
        }
    }

    private void loadSolution2result() {
        solution2result = new HashMap<>();

        File file = getFileWithSolutionsCheckedExternally();
        try (BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"))) {
            while (true) {
                String solutionAsString = in.readLine();
                String resultAsString = in.readLine();
                if (solutionAsString == null || resultAsString == null)
                    return;

                ObjectNode solution = factory.createParser(solutionAsString).readValueAsTree();
                ObjectNode result = factory.createParser(resultAsString).readValueAsTree();

                solution2result.put(solution, result);
            }
        } catch (Exception e) {
            System.out.println("Failed to read tested solutions");
            solution2result = null;
        }
    }

    private File getFileWithSolutionsForExternalCheck() {
        return new File(String.format("check-externally-%d-%s.txt", level, problemId));
    }

    private File getFileWithSolutionsCheckedExternally() {
        return new File(String.format("checked-externally-%d-%s.txt", level, problemId));
    }
}
