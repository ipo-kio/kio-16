package kio._2016;

import kio.KioParameter;
import kio.KioProblemSet;
import kio.checker.KioExternalProblemChecker;
import kio.checker.KioProblemChecker;

import java.util.Arrays;
import java.util.List;

public class KioProblemsSet2016 extends KioProblemSet {

    public List<String> getProblemIds(int level) {
        return Arrays.asList("rockgarden", "mower", "mars");
    }

    public String getProblemName(int level, String id) {
        switch (id) {
            case "rockgarden":
                return "Сад камней";
            case "mower":
                return "Стая коси-роботов";
            case "mars":
                return level == 2 ? "Полет на Марс" : "Солнечная система";
        }
        return "???";
    }

    protected KioProblemChecker getCheckerRaw(int level, String id) {
        return new KioExternalProblemChecker2016(level, id);
    }

    public List<KioParameter> getParamsRaw(int level, String id) {
        switch (id) {
            case "rockgarden":
                switch (level) {
                    case 0:
                        return kioParameters(
                                "r+i:площадок с четырьмя камнями",
                                "d+i:различных площадок",
                                "s+i:размер камней"
                        );
                    case 1:
                        return kioParameters(
                                "r+i:площадок с пятью камнями",
                                "d+i:различных площадок",
                                "s+i:размер камней"
                        );
                    case 2:
                        return kioParameters("p+i:пар невидимых~%", "v-d:равномерность");
                }
            case "mower":
                return kioParameters("m+i:скошено", "s-i:шагов");
            case "mars":
                switch (level) {
                    case 0:
                    case 1:
                        return kioParameters("o+i:на обрите", "s-i:ошибка положения");
                    case 2:
                        return kioParameters("md-d:982:расстояние~тыс.км", "ms-d:3450:скорость~км/ч", "f-d:топливо");
                }
        }
        return null;
    }

    public String getCertificatePattern(int level, String id) {
        switch (id) {
            case "rockgarden":
                switch (level) {
                    case 0:
                        return "площадок с четырьми камнями: %s,\nразличных площадок: %s,\nразмер камней: %s";
                    case 1:
                        return "площадок с пятью камнями: %s,\nразличных площадок: %s,\nразмер камней: %s";
                    case 2:
                        return "пар невидимых: %s, равномерность: %s";
                }
            case "mower":
               return "скошено: %s, шагов %s";
            case "mars":
                switch (level) {
                    case 0:
                    case 1:
                        return "на орбите: %s,\n ошибка положения: %s";
                    case 2:
                        return "расстояние: %s,\nскорость: %s, топливо: %s";
                }
        }
        return null;
    }
}
