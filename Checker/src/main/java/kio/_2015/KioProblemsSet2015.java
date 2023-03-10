package kio._2015;

import kio.KioParameter;
import kio.KioProblemSet;
import kio.checker.KioProblemChecker;

import java.util.Arrays;
import java.util.List;

public class KioProblemsSet2015 extends KioProblemSet {

    public List<String> getProblemIds(int level) {
        return Arrays.asList("traincars", "markov", "spider");
    }

    public String getProblemName(int level, String id) {
        switch (id) {
            case "markov":
                switch (level) {
                    case 0:
                        return "Прополка";
                    case 1:
                    case 2:
                        return "Калькулятор";
                }
            case "spider":
                return "Паук";
            case "traincars":
                return "Поезда";
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
                        return "различий: %s,\nправил: %s, операций: %s";
                    case 1:
                    case 2:
                        return "верно: %s%%, правил: %s";
                }
            case "spider":
                switch (level) {
                    case 0:
                        return "время: %s0, материал %s";
                    case 1:
                    case 2:
                        return "время: %s, материал %s";
                }
            case "traincars":
                switch (level) {
                    case 0:
                        return "верно: %s,\\nбеспорядок: %s, действий: %s";
                    case 1:
                        return "верно: %s,\nбеспорядок: %s, действий: %s+%s";
                    case 2:
                        return "верно: %s,\nтранспозиций: %s, действий: %s+%s";
                }
        }
        return null;
    }
}
