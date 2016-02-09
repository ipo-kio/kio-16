package ru.ipo.kio._16.mars.model {
public class ShipHistory {

    private var _actions:Vector.<ShipAction>;
    private var _positions:Vector.<Vector2D>;
    private var _orbits:Vector.<Orbit>;

    private var initialPosition:Vector2D;
    private var initialV:Vector2D;

    public function ShipHistory(initialPosition:Vector2D, initialV:Vector2D) {
        this.initialPosition = initialPosition;
        this.initialV = initialV;

        _actions = new <ShipAction>[];

        evaluatePositions();
    }

    public function evaluatePositions():void {
        _positions = new Vector.<Vector2D>(Consts.MAX_TIME + 1, true);
        _orbits = new <Orbit>[];

        _orbits[0] = Orbit.solveInitial(initialPosition.x, initialPosition.y, initialV.x, initialV.y, 0);

        var nextActionIndex:int = 0;
        var currentDirection:int = initialPosition.vectorMul(initialV);
        var currentOrbit:Orbit = _orbits[0];

        for (var timeInd:int = 0; timeInd <= Consts.MAX_TIME; timeInd++) {
            var time:Number = timeInd * Consts.dt;
            var currentPosition:Vector2D = currentOrbit.position(time);
            _positions[timeInd] = currentPosition;

            if (nextActionIndex < _actions.length && _actions[nextActionIndex].time == timeInd) {
                var r_:Vector2D = currentPosition.normalize();
                var t_:Vector2D = r_.rot90();

                var theta:Number = currentPosition.theta - currentOrbit.theta0;
                var Vt:Number = Math.sqrt((currentOrbit.eps * Math.cos(theta) + 1) * Consts.MU / currentPosition.r);
                var Vr:Number = currentOrbit.eps * Math.sin(theta) * Consts.MU / currentPosition.r / Vt;

                var Vx:Number = r_.x * Vr + t_.x * Vt;
                var Vy:Number = r_.y * Vr + t_.y * Vt;
                var V:Vector2D = Vector2D.create(Vx, Vy);

                var dir:Number = currentPosition.vectorMul(V);
                if (dir * currentDirection < 0) {
                    Vx = -Vx;
                    Vy = -Vy;
                }

                var dV:Vector2D = _actions[nextActionIndex].dV;
                Vx += dV.x;
                Vy += dV.y;
                V = Vector2D.create(Vx, Vy);

                var nextOrbit:Orbit = Orbit.solveInitial(currentPosition.x, currentPosition.y, Vx, Vy, time);
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
}
}
