package kio;

import kio._2015.KioProblemsSet2015;
import kio.checker.KioProblemChecker;
import org.apache.commons.collections.map.HashedMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public abstract class KioProblemSet {

    public static final int CHECK_LOGS_AND_PROBLEMS = 0; // do real check of problems results and logs results
    public static final int CHECK_PROBLEMS = 1; // check only problem results

    public static Map<Integer, KioProblemSet> instances = new HashMap<>();

    static {
        instances.put(2015, new KioProblemsSet2015());
    }

    public static KioProblemSet getInstance(int year) {
        return instances.get(year);
    }

    //delegate and cache in all abstract methods

    public abstract List<String> getProblemIds(int level);
    
    public abstract String getProblemName(int level, String id);
    
    protected abstract KioProblemChecker getCheckerRaw(int level, String id);

    protected abstract List<KioParameter> getParamsRaw(int level, String id);

    public abstract String getCertificatePattern(int level, String id);

    private Map<String, KioProblemChecker> cachedCheckers = new HashMap<>();
    public KioProblemChecker getChecker(int level, String id) {
        String key = String.format("%d %s", level, id);
        KioProblemChecker checker = cachedCheckers.get(key);
        if (checker != null)
            return checker;
        checker = getCheckerRaw(level, id);
        cachedCheckers.put(key, checker);
        return checker;
    }

    private Map<String, List<KioParameter>> cachedParams = new HashMap<>();
    public List<KioParameter> getParams(int level, String id) {
        String key = String.format("%d %s", level, id);
        List<KioParameter> params = cachedParams.get(key);
        if (params != null)
            return params;
        params = getParamsRaw(level, id);
        cachedParams.put(key, params);
        return params;
    }

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
