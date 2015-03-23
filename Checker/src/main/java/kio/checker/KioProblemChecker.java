package kio.checker;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.*;

import java.util.HashMap;
import java.util.Map;

public abstract class KioProblemChecker {

    public static final int NOT_EXTERNAL_CHECKER = 0;
    public static final int EXTERNAL_CHECKER_SAVE_ALL = 1;
    public static final int EXTERNAL_CHECKER_SAVE_BEST = 1;

    private Map<String, JsonNode> kids;
    private final JsonNodeFactory factory = JsonNodeFactory.instance;
    protected final int level;

    public KioProblemChecker(int level) {
        this.level = level;
    }

    protected abstract void run(JsonNode solution);

    public abstract boolean getBelieveUnchecked();

    public int getExternalCheckerType() {
        return NOT_EXTERNAL_CHECKER;
    }

    public void saveForExternalCheck(JsonNode solution, boolean best) {
        //do nothing, overridden in external Checker
    }

    public void finalizeSavingForExternalCheck() {
        //do nothing, overridden in external checker
    }

    public ObjectNode check(JsonNode solution) {
        kids = new HashMap<>();
        run(solution);
        return new ObjectNode(JsonNodeFactory.instance, kids);
    }

    protected void set(String id, int value) {
        kids.put(id, factory.numberNode(value));
    }

    protected void set(String id, long value) {
        kids.put(id, factory.numberNode(value));
    }

    protected void set(String id, double value) {
        kids.put(id, factory.numberNode(value));
    }

}
