package kio._2015;

import kio.KioParameter;
import kio.KioProblemSet;
import kio.checker.KioProblemChecker;

import java.util.Arrays;
import java.util.List;

public class KioProblemsSet2015en extends KioProblemSet {

    public List<String> getProblemIds(int level) {
        return Arrays.asList("traincars", "markov", "spider");
    }

    public String getProblemName(int level, String id) {
        switch (id) {
            case "markov":
                switch (level) {
                    case 0:
                        return "Weeding";
                    case 1:
                    case 2:
                        return "Calculator";
                }
            case "spider":
                return "Spider";
            case "traincars":
                return "Cars sorting";
        }
        return "???";
    }

    protected KioProblemChecker getCheckerRaw(int level, String id) {
        switch (id) {
            case "markov":
                return new MarkovChecker2015(level);
            case "spider":
                return new SpiderChecker2015(level);
            case "traincars":
                return new TrainCarsChecker2015(level);
        }
        return null;
    }

    protected List<KioParameter> getParamsRaw(int level, String id) {
        switch (id) {
            case "markov":
                switch (level) {
                    case 0: return kioParameters("ridgeDiff-i:различий", "ruleAmount-i:указаний", "applyOperations-i:замен");
                    case 1:
                    case 2: return kioParameters("correctAmount+i:верно~ из 300", "ruleAmount-i:правил");
                }
            case "spider":
                switch (level) {
                    case 0: return kioParameters("t-d:время~0 с", "m-d:материал~ см");
                    case 1:
                    case 2: return kioParameters("t-d:время~ с", "m-d:материал~ см");
                }
            case "traincars":
                switch (level) {
                    case 0: return kioParameters("c+i:верно", "t-i:беспорядок", "h-i:действий");
                    case 1: return kioParameters("c+i:верно", "t-i:беспорядок", "uh-i:подъемов", "dh-i:спусков");
                    case 2: return kioParameters("c+i:верно", "t-i:транспозиций", "uh-i:подъемов", "dh-i:спусков");
                }
        }
        return null;
    }

    public String getCertificatePattern(int level, String id) {
        switch (id) {
            case "markov":
                switch (level) {
                    case 0:
                        return "differences: %s,\nrules: %s, operations: %s";
                    case 1:
                    case 2:
                        return "correct: %s%%, rules: %s";
                }
            case "spider":
                switch (level) {
                    case 0:
                        return "time: %s0, material %s";
                    case 1:
                    case 2:
                        return "time: %s, material %s";
                }
            case "traincars":
                switch (level) {
                    case 0:
                        return "correct: %s,\\nmess: %s, actions: %s";
                    case 1:
                        return "correct: %s,\nmess: %s, actions: %s+%s";
                    case 2:
                        return "correct: %s,\ntranspositions: %s, actions: %s+%s";
                }
        }
        return null;
    }
}
