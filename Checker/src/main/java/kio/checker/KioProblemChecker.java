package kio.checker;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.*;

import java.util.HashMap;
import java.util.Map;

public abstract class KioProblemChecker {

    private Map<String, JsonNode> kids;
    private final JsonNodeFactory factory = JsonNodeFactory.instance;

    protected abstract void run(JsonNode solution);

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
