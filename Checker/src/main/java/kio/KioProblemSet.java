package kio;

import kio._2015.KioProblemsSet2015;
import kio.checker.KioProblemChecker;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public abstract class KioProblemSet {

    public static Map<Integer, KioProblemSet> instances = new HashMap<>();

    static {
        instances.put(2015, new KioProblemsSet2015());
    }

    public static KioProblemSet getInstance(int year) {
        return instances.get(year);
    }

    public abstract List<String> getProblemIds(int level);
    
    public abstract String getProblemName(int level, String id);
    
    public abstract KioProblemChecker getChecker(int level, String id);

    public abstract List<KioParameter> getParams(int level, String id);

    public JsonObjectsComparator getComparator(int level, String id) {
        return new JsonObjectsComparator(getParams(level, id));
    }

    protected List<KioParameter> kioParameters(String... args) {
        List<KioParameter> params = new ArrayList<>();
        for (String arg : args)
            params.add(new KioParameter(arg));

        return params;
    }
}
