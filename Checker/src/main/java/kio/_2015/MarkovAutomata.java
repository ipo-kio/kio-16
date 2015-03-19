package kio._2015;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class MarkovAutomata {

    public static final int MAX_ITERATIONS = 20000;

    private final List<MarkovRule> rules;

    public MarkovAutomata(List<String> rules) {
        this.rules = new ArrayList<>(rules.size());
        this.rules.addAll(rules.stream().map(MarkovRule::new).collect(Collectors.toList()));
    }

    public int go(MarkovString line) {
        int cnt = 0;
        iteration:
        for (int iteration = 1; iteration <= MAX_ITERATIONS; iteration++) {
            for (MarkovRule rule : rules)
                if (rule.apply(line)) {
                    cnt++;
                    continue iteration;
                }
            return cnt;
        }

        throw new IllegalStateException("Automata reached max iterations");
    }

    public int getRulesCount() {
        return rules.size();
    }
}
