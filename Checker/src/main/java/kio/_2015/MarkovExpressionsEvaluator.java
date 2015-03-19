package kio._2015;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

public class MarkovExpressionsEvaluator {

    private ScriptEngineManager manager = new ScriptEngineManager();
    private ScriptEngine engine = manager.getEngineByName("js");

    public String eval(String example) {
        try {
            Object result = engine.eval(example);

            if (result instanceof Number) {
                int r = ((Number)result).intValue();
                switch (r) {
                    case -1: return "-1";
                    case 0: return "0";
                    case 1: return "1";
                }
            }

            throw new Exception(String.valueOf(result));
        } catch (Exception e) {
            throw new IllegalStateException("Could not parse example: " + example);
        }
    }

}
