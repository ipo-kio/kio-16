package kio._2015;

import com.fasterxml.jackson.databind.JsonNode;
import kio.checker.KioProblemChecker;

import java.util.*;

public class TrainCarsChecker2015 extends KioProblemChecker {

    private static class Car {
        public int station;
        public int number;

        public Car(int station, int number) {
            this.station = station;
            this.number = number;
        }
    }

    private final int level;

    public TrainCarsChecker2015(int level) {
        this.level = level;
    }

    @Override
    protected void run(JsonNode solution) {
        List<Car> topCars = getCarsForLevel();
        if (topCars == null)
            return;
        topCars = new LinkedList<>(topCars);

        JsonNode allActions = solution.get("a");
        if (allActions == null)
            return;

        if (!allActions.isArray())
            return;

        List<List<Car>> ways = new ArrayList<>(5);
        ways.add(topCars);
        ways.add(new LinkedList<>());
        ways.add(new LinkedList<>());
        ways.add(new LinkedList<>());
        ways.add(new LinkedList<>());

        int downHill = 0;
        int upHill = 0;

        for (int i = 0; i < allActions.size(); i++) {
            JsonNode actionNode = allActions.get(i);
            if (actionNode != null && actionNode.isInt()) {
                int action = actionNode.asInt();
                if (action > 0)
                    downHill++;
                else
                    upHill++;
                doAction(ways, action);
            }
        }

        evaluateResults(ways, downHill, upHill);
    }

    private void doAction(List<List<Car>> ways, int action) {
        List<Car> topWay = ways.get(0);
        int wayInd = Math.abs(action);
        if (action > 0) { //TODO check correctness of the action: wayInd is correct, the way has a car
            List<Car> way = ways.get(wayInd);
            Car c = topWay.get(0);
            topWay.remove(0);
            way.add(c);
        } else {
            List<Car> way = ways.get(wayInd);
            topWay.addAll(0, way);
            way.clear();
        }
    }

    private void evaluateResults(List<List<Car>> ways, int downHill, int upHill) {
        int disorder = 0;
        int transpositions = 0;
        int correct = 0;
        for (int i = 1; i <= 4; i++) {
            List<Car> way = ways.get(i);
            List<Integer> wayI = new ArrayList<>(way.size());
            for (Car car : way)
                if (car.station == i)
                    wayI.add(car.number);

            correct += wayI.size();
            if (level <= 1)
                disorder += disorder(wayI);
            else
                transpositions += transpositions(wayI);
        }

        switch (level) {
            case 0:
                set("c", correct);
                set("t", disorder);
                set("h", downHill + upHill);
                break;
            case 1:
            case 2:
                set("c", correct);
                set("t", transpositions);
                set("uh", upHill);
                set("dh", downHill);
                break;
        }
    }

    private int transpositions(List<Integer> way) {
        int cnt = 0;

        ArrayList<Integer> usedIndexes = new ArrayList<>(way.size());
        for (Integer a : way) {
            for (Integer usedIndex : usedIndexes)
                if (usedIndex > a)
                    cnt++;
            usedIndexes.add(a);
        }

        return cnt;
    }

    private int disorder(List<Integer> way) {
        List<Integer> waySorted = new ArrayList<>(way);
        Collections.sort(waySorted);

        int cnt = 0;

        for (int i = 0; i < way.size(); i++) {
            int a = way.get(i);
            int j = waySorted.indexOf(a);
            cnt += Math.abs(i - j);
        }

        return cnt;
    }

    private List<Car> getCarsForLevel() {
        switch (level) {
            case 2:
                return Arrays.asList(
                        new Car(1, 3),
                        new Car(1, 4),
                        new Car(2, 3),
                        new Car(2, 5),
                        new Car(1, 1),
                        new Car(1, 2),
                        new Car(1, 5),
                        new Car(2, 4),
                        new Car(2, 2),
                        new Car(2, 1),
                        new Car(3, 2),
                        new Car(4, 5),
                        new Car(4, 1),
                        new Car(3, 1),
                        new Car(3, 4),
                        new Car(4, 4),
                        new Car(4, 3),
                        new Car(4, 2),
                        new Car(3, 5),
                        new Car(3, 3)
                );
            case 1:
                return Arrays.asList(
                        new Car(1, 1),
                        new Car(1, 4),
                        new Car(1, 3),
                        new Car(1, 2),
                        new Car(3, 5),
                        new Car(2, 5),
                        new Car(3, 4),
                        new Car(3, 2),
                        new Car(3, 3),
                        new Car(2, 1),
                        new Car(3, 1),
                        new Car(2, 4),
                        new Car(2, 2),
                        new Car(1, 5),
                        new Car(2, 3)
                );
            case 0:
                return Arrays.asList(
                        new Car(1, 5),
                        new Car(1, 4),
                        new Car(1, 3),
                        new Car(2, 5),
                        new Car(1, 1),
                        new Car(1, 2),
                        new Car(2, 4),
                        new Car(2, 2),
                        new Car(2, 3),
                        new Car(2, 1)
                );
        }

        return null;
    }
}
