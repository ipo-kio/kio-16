package ru.ipo.kio._16.mars.model {
public class ShipHistory {

    private var _actions:Vector.<ShipAction>;
    private var _positions:Vector.<Vector2D>;
    private var _speeds:Vector.<Vector2D>;
    private var _orbits:Vector.<Orbit>;
    private var _marsResults:Vector.<MarsResult>;

    private var _bestMarsResult:MarsResult;

    private var initialPosition:Vector2D;
    private var initialV:Vector2D;
    private var marsOrbit:Orbit;

    public function ShipHistory(initialPosition:Vector2D, initialV:Vector2D, marsOrbit:Orbit) {
        this.initialPosition = initialPosition;
        this.initialV = initialV;
        this.marsOrbit = marsOrbit;

        _actions = new <ShipAction>[];

        evaluatePositions();
    }

    public function evaluatePositions():void {
        _positions = new Vector.<Vector2D>(Consts.MAX_TIME + 1, true);
        _speeds = new Vector.<Vector2D>(Consts.MAX_TIME + 1, true);
        _marsResults = new Vector.<MarsResult>(Consts.MAX_TIME + 1, true);
        _bestMarsResult = null;

        _orbits = new <Orbit>[];

        _orbits[0] = Orbit.solveInitial(initialPosition.x, initialPosition.y, initialV.x, initialV.y, 0);

        var nextActionIndex:int = 0;
        var currentDirection:int = initialPosition.vectorMul(initialV);
        var currentOrbit:Orbit = _orbits[0];

        var currentFuel:Number = 0;

        var nearEarth:Boolean = true;

        for (var timeInd:int = 0; timeInd <= Consts.MAX_TIME; timeInd++) {
            //eval position

            var time:Number = timeInd * Consts.dt;
            var currentPosition:Vector2D = currentOrbit.position(time);
            _positions[timeInd] = currentPosition;

            //eval speed (now copied to Orbit.speed)

            var r_:Vector2D = currentPosition.normalize();
            var t_:Vector2D = r_.rot90();

            var theta:Number = currentPosition.theta - currentOrbit.theta0;
            var Vt:Number = Math.sqrt((currentOrbit.eps * Math.cos(theta) + 1) * Consts.MU / currentPosition.r);
            var Vr:Number = currentOrbit.eps * Math.sin(theta) * Consts.MU / currentPosition.r / Vt;

            var Vx:Number = r_.x * Vr + t_.x * Vt;
            var Vy:Number = r_.y * Vr + t_.y * Vt;
            var V:Vector2D = Vector2D.create(Vx, Vy);

//            var dir:Number = currentPosition.vectorMul(V);
//            if (dir * currentDirection < 0) {
//                Vx = -Vx;
//                Vy = -Vy;
//                V = V.neg();
//            }

            _speeds[timeInd] = V;
            _marsResults[timeInd] = new MarsResult(
                    timeInd,
                    marsOrbit.position(timeInd * Consts.dt).distanceTo(currentPosition),
                    marsOrbit.speed(timeInd * Consts.dt).sub(V).r,
                    currentFuel
            );

            if (_bestMarsResult == null || _bestMarsResult.compareTo(_marsResults[timeInd]) < 0)
                _bestMarsResult = _marsResults[timeInd];

            if (nextActionIndex < _actions.length && _actions[nextActionIndex].time == timeInd) {

                var dV:Vector2D = _actions[nextActionIndex].dV;

                if (nearEarth) {
                    /*
                     В момент применения deltaV тело ещё находится в гравитационном поле Земли, т.е. если мы применили импульс в сторону от Земли, то скорость удаления от Земли падает по сравнению с изначальным v1 + deltaV.
                     Можно в этой ситуации говорить о скорости выхода из сферы действия Земли (V_вых). Это скорость относительно Земли, которую КА будет иметь к тому моменту, как окажется на таком расстоянии от Земли, что действием земной гравитации можно пренебречь.

                     Формула для V_вых следующая: V_вых = sqrt(V^2 - V_осв^2).
                     где V -- скорость сразу после применения deltaV, а V_осв -- вторая космическая скорость для данной высоты.
                     Формула взята из книги [1], которая содержит всю теорию, необходимую для вычисления орбит КА. В нашем случае см. часть 4 "межпланетные перелёты".

                     Если мы применим импульс ровно такой, чтобы слететь с земной орбиты (V = V_осв), то получим Vвых = 0, т.е. КА останется в итоге неподвижным относительно Земли и будет вращаться вокруг Солнца по орбите, схожей с орбитой Земли.

                     Посчитаем, как набрать "гомановскую" скорость (Vвых = 2.94 км/c) с низкой околоземной орбиты:
                     r = 6600 км, орбитальная скорость = 7.77 км/c, V_осв = 10.99 км/c.
                     V = sqrt(Vвых^2 + V_осв^2) = 11.38 км/c.
                     следовательно deltaV = 11.38 - 7.77 = 3.61 км/c.
                     */

                    var VV:Number = Consts.EARTH_V1 + dV.r;

                    if (VV < Consts.EARTH_V2) {
                        //do nothing with V
                    } else {
                        var Vout:Number = Math.sqrt(VV * VV - Consts.EARTH_V2 * Consts.EARTH_V2);
                        V = Vector2D.createPolar(Vout, dV.theta);
                        Vx += V.x;
                        Vy += V.y;
                        nearEarth = false;
                    }
                } else {
                    Vx += dV.x;
                    Vy += dV.y;
                }

                V = Vector2D.create(Vx, Vy);

                currentFuel += dV.r;

                var nextOrbit:Orbit = Orbit.solveInitial(currentPosition.x, currentPosition.y, V.x, V.y, time);
                var nextDirection:Number = currentPosition.vectorMul(V);
                if (nextOrbit != null && Math.abs(nextDirection) > Consts._EPS) {
                    _orbits.push(nextOrbit);
                    currentOrbit = nextOrbit;
                    currentDirection = nextDirection;
                }

                nextActionIndex++;
            }
        }
    }

    public function time2position(timeInd:int):Vector2D {
        return _positions[timeInd];
    }

    public function get actions():Vector.<ShipAction> {
        return _actions;
    }

    public function get positions():Vector.<Vector2D> {
        return _positions;
    }

    public function get orbits():Vector.<Orbit> {
        return _orbits;
    }

    public function push(shipHistoryEntry:ShipAction):void {
        _actions.push(shipHistoryEntry);
        evaluatePositions();
    }

    public function get speeds():Vector.<Vector2D> {
        return _speeds;
    }

    public function get marsResults():Vector.<MarsResult> {
        return _marsResults;
    }

    public function get bestMarsResult():MarsResult {
        return _bestMarsResult;
    }

    public function get as_object():Object {
        var a:Array = [];
        for each (var action:ShipAction in _actions) {
            a.push({
                dvr: action.dV.r,
                dvt: action.dV.theta,
                t: action.time
            });
        }

        return {a: a};
    }

    public function set as_object(value:Object):void {
        if (value == null)
            return;

//        if (!('a' in value))
//            return;

        var a:Array = value.a;

        _actions = new <ShipAction>[];
        for each (var o:Object in a) {
            _actions.push(new ShipAction(o.t, Vector2D.createPolar(o.dvr, o.dvt)));
        }
    }
}
}
