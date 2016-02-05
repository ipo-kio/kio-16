package ru.ipo.kio._16.mars.model {
public class ShipHistory {

    private var _actions:Vector.<ShipHistoryEntry>;
    private var _positions:Vector.<Vector2D>;
    private var orbits:Vector.<Orbit>;

    private var initialPosition:Vector2D;
    private var initialV:Vector2D;

    public function ShipHistory(initialPosition:Vector2D, initialV:Vector2D) {
        this.initialPosition = initialPosition;
        this.initialV = initialV;
    }

    public function evaluatePositions():void {
        _positions = new Vector.<Vector2D>(Consts.MAX_TIME + 1, true);
        orbits = new <Orbit>[];

        orbits[0] = Orbit.solveInitial(initialPosition.x, initialPosition.y, initialV.x, initialV.y);

        var nextActionIndex:int = 0;
        var currentDirection:int = initialPosition.vectorMul(initialV);
        var currentOrbit:Orbit = orbits[0];

        for (var time:int = 0; time < Consts.MAX_TIME; time++) {
            var currentPosition:Vector2D = currentOrbit.position(time);
            _positions[time] = currentPosition;

            if (nextActionIndex < _actions.length && _actions[nextActionIndex].time == time) {
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

                var nextOrbit:Orbit = Orbit.solveInitial(currentPosition.x, currentPosition.y, Vx, Vy);
                var nextDirection:Number = currentPosition.vectorMul(V);
                if (nextOrbit != null && Math.abs(nextDirection) > Consts._EPS) {
                    orbits.push(nextOrbit);
                    currentOrbit = nextOrbit;
                    currentDirection = nextDirection;
                }

                nextActionIndex++;
            }
        }
    }

    public function get actions():Vector.<ShipHistoryEntry> {
        return _actions;
    }

    public function get positions():Vector.<Vector2D> {
        return _positions;
    }
}
}
