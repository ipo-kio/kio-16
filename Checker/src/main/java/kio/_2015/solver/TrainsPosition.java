package kio._2015.solver;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

public class TrainsPosition implements Comparable<TrainsPosition> {

    public static final int WAYS = 4;
    public static final int ON_WAY = 5;

    public static int FULL_WAYS = 2;
    public static int UH_MAX = 2;
    public static int MAX_STEPS_CUT = 27;

    public static final Car[] EMPTY_WAY = new Car[0];

    private Car[] top;
    private Car[][] ways;
    private int steps;
    private int uh;
    private TrainsPosition cameFrom;

    private int hCache = -1;

    public TrainsPosition(Car[] top) {
        this(top, new Car[WAYS][0], 0, 0, null);
    }

    public TrainsPosition(Car[] top, Car[][] ways, int steps, int uh, TrainsPosition cameFrom) {
        this.top = top;
        this.ways = ways;
        this.steps = steps;
        this.uh = uh;
        this.cameFrom = cameFrom;
    }

    // **way*** | ****top****
    public TrainsPosition moveDown(int way) {
        if (top.length == 0)
            return null;

        way -= 1;

        Car[] movingWay = ways[way];

        Car[] newTop = Arrays.copyOfRange(top, 1, top.length);
        Car[][] newWays = Arrays.copyOf(ways, ways.length);

        newWays[way] = Arrays.copyOf(movingWay, movingWay.length + 1);
        newWays[way][movingWay.length] = top[0];

        return new TrainsPosition(newTop, newWays, steps + 1, uh, this);
    }

    public TrainsPosition moveUp(int way) {
        if (uh == UH_MAX)
            return null;

        way -= 1;

        Car[] movingWay = ways[way];

        if (movingWay.length == 0)
            return null;

        Car[] newTop = new Car[movingWay.length + top.length];
        System.arraycopy(movingWay, 0, newTop, 0, movingWay.length);
        System.arraycopy(top, 0, newTop, movingWay.length, top.length);

        Car[][] newWays = Arrays.copyOf(ways, ways.length);
        newWays[way] = EMPTY_WAY;

        return new TrainsPosition(newTop, newWays, steps + 1, uh + 1, this);
    }

    public int h() {
//        return 0;
        if (hCache < 0)
            hCache = hEvaluate();
        return hCache;
    }

    private int hEvaluate() {
        int h = 0;

        for (int way = 1; way <= WAYS; way++) {
            Car[] cars = ways[way - 1];
            int goodCars = 0;
            for (int carInd = 0; carInd < cars.length; carInd++) {
                Car car = cars[carInd];
                if (car.number == carInd + 1 && car.station == way)
                    goodCars++;
                else {
                    goodCars = 0;
                    break;
                }
            }
            if (goodCars > 0)
                h += ON_WAY - goodCars;
            else {
                if (way <= FULL_WAYS)
                    h += ON_WAY;

                h += cars.length == 0 ? 0 : 1;
            }
        }

        //add fixes for disorder

        h += disorderHeur(top);
        for (int way = 1; way <= WAYS; way++)
            h += disorderHeur(ways[way - 1]);

        return h;
    }

    private int disorderHeur(Car[] rails) {
        int cnt = 0;

        for (int way = 1; way <= WAYS; way++) {
            int minN = 100;
            for (int carInd = rails.length - 1; carInd >= 0; carInd--) {
                Car car = rails[carInd];
                if (car.station != way)
                    continue;
                if (car.number > minN)
                    cnt++;
                else
                    minN = car.number;
            }
        }

        return cnt;
    }

    public boolean isFinal() {
        if (top.length > 0)
            return false;

        for (int way = 1; way <= ways.length; way++) {
            Car[] cars = ways[way - 1];
            for (int car = 1; car <= cars.length; car++) {
                Car c = cars[car - 1];
                if (c.station != way || c.number != car)
                    return false;
            }
        }

        return true;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        TrainsPosition that = (TrainsPosition) o;

        // Probably incorrect - comparing Object[] arrays with Arrays.equals
        return Arrays.equals(top, that.top) && Arrays.deepEquals(ways, that.ways);
    }

    @Override
    public int hashCode() {
        int result = Arrays.hashCode(top);
        result = 31 * result + Arrays.deepHashCode(ways);
        return result;
    }

    @Override
    public int compareTo(TrainsPosition that) {
        int v = this.steps + this.h() - that.steps - that.h();
        if (v == 0)
            return that.steps - this.steps;
        else
            return v;
    }

    public int getSteps() {
        return steps;
    }

    @Override
    public String toString() {
        StringBuilder o = new StringBuilder();

//        int dh = 0;
//        dh += disorderHeur(top);
//        for (int way = 1; way <= WAYS; way++)
//            dh += disorderHeur(ways[way - 1]);
//
//        dh += steps + h();

        o.append('(').append(steps).append(',').append(steps + h())/*.append(',').append(dh)*/.append(')');

        for (Car[] way : ways) {
            o.append(out(way)).append('|');
        }
        o.append(out(top));

        return o.toString();
    }

    private String out(Car[] cars) {
        StringBuilder o = new StringBuilder();
        boolean first = true;
        for (Car car : cars) {
            if (first)
                first = false;
            else
                o.append(',');
            o.append(car.station).append(car.number);
        }

        return o.toString();
    }

    public int heur() {
        return h() + steps;
    }

    public void printOut() {
        List<TrainsPosition> list = new LinkedList<>();
        TrainsPosition tp = this;
        while (tp != null) {
            list.add(0, tp);
            tp = tp.cameFrom;
        }

        list.forEach(System.out::println);

        System.out.println("total: " + steps);
    }
}
