package kio._2015.solver;

import java.util.HashSet;
import java.util.PriorityQueue;
import java.util.Set;

public class TrainsSolver {

    public static void main(String[] args) {
        TrainsPosition startPosition = getStartPosition(2);
        TrainsPosition.FULL_WAYS = 4;
        TrainsPosition.UH_MAX = 2;
        TrainsPosition.MAX_STEPS_CUT = 40;

        TrainsPosition f = new TrainsPosition(
                new Car[]{},
                new Car[][]{
                        {new Car(1, 1), new Car(1, 2), new Car(1, 3), new Car(1, 4), new Car(1, 5)},
                        {new Car(2, 1), new Car(2, 2), new Car(2, 3), new Car(2, 4), new Car(2, 5)},
                        {},
                        {}
                },
                0, 0, null
        );

        TrainsPosition f2 = new TrainsPosition(
                new Car[]{},
                new Car[][]{
                        {new Car(2, 1), new Car(2, 5), new Car(2, 4), new Car(2, 3), new Car(2, 2)},
                        {new Car(1, 1), new Car(1, 5), new Car(1, 4), new Car(1, 3), new Car(1, 2)},
                        {},
                        {}
                },
                0, 0, null
        );


        System.out.println(f.isFinal());
        System.out.println(startPosition.h());

        TrainsPosition answer = go(startPosition);

        if (answer == null)
            System.out.println("No answer");
        else
            answer.printOut();
    }

    public static TrainsPosition go(TrainsPosition startPosition) {
        PriorityQueue<TrainsPosition> positions = new PriorityQueue<>();
        Set<TrainsPosition> usedPositions = new HashSet<>();

        positions.offer(startPosition);
        usedPositions.add(startPosition);

        int maxSteps = 0;

        while (!positions.isEmpty()) {
            TrainsPosition tp = positions.poll();

            if (maxSteps < tp.getSteps()) {
                maxSteps = tp.getSteps();
                System.out.println("new steps: " + tp.getSteps());
            }

            if (tp.isFinal())
                return tp;

            for (int way = 1; way <= TrainsPosition.WAYS; way++) {
                TrainsPosition tp2 = tp.moveDown(way);
                insertPosition(positions, usedPositions, tp2);

                tp2 = tp.moveUp(way);
                insertPosition(positions, usedPositions, tp2);
            }
        }

        return null;
    }

    private static void insertPosition(PriorityQueue<TrainsPosition> positions, Set<TrainsPosition> usedPositions, TrainsPosition tp) {
        if (tp != null && tp.heur() <= TrainsPosition.MAX_STEPS_CUT && !usedPositions.contains(tp)) {
            usedPositions.add(tp);
            positions.offer(tp);
        }
    }

    private static TrainsPosition getStartPosition(int level) {
        switch (level) {
            case 2:
                return new TrainsPosition(new Car[]{
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
                });
            case 1:
                return new TrainsPosition(new Car[]{
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
                });
            case 0:
            default:
                return new TrainsPosition(new Car[]{
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
                });
        }
    }

}
