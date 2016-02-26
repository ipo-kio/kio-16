package ru.ipo.kio._16.mower.model {
public class Field {

    public static const FIELD_GRASS:int = 0;
    public static const FIELD_GRASS_MOWED:int = 1;
    public static const FIELD_TREE:int = 2;
    public static const FIELD_SWAMP:int = 3;

    public static const FIELD_FORWARD:int = 5;
    public static const FIELD_TURN_LEFT:int = 6;
    public static const FIELD_TURN_RIGHT:int = 7;
    public static const FIELD_NOP:int = 8;
    public static const FIELD_EMPTY:int = 9;

    public static const FIELD_PROGRAM_GRASS:int = 10;
    public static const FIELD_PROGRAM_MOWED_GRASS:int = 11;
    public static const FIELD_PROGRAM_TREE:int = 12;
    public static const FIELD_PROGRAM_SWAMP:int = 13;
    public static const FIELD_PROGRAM_MOWER:int = 14;
//    public static const FIELD_PROGRAM_BROKEN_MOWER:int = 15;

    private var f:Vector.<Vector.<int>>;
    private var _m:int;
    private var _n:int;

    public function Field(m:int, n:int, v:*) {
        _m = m;
        _n = n;

        if (v is Vector.<Vector.<int>>) {
            f = v;
        } else {
            f = new Vector.<Vector.<int>>(_m, true);

            for (var i:int = 0; i < m; i++)
                f[i] = new Vector.<int>(_n, true);

            if (v is int) {
                for (i = 0; i < m; i++)
                    for (var j:int = 0; j < n; j++)
                        f[i][j] = v;
            } else if (v is String) {
                var t:int = 0;
                for (i = 0; i < m; i++)
                    for (j = 0; j < n; j++) {
                        switch (String(v).charAt(t++)) {
                            case '.':
                                f[i][j] = FIELD_GRASS;
                                break;
                            case '*':
                                f[i][j] = FIELD_TREE;
                                break;
                            case '&':
                                f[i][j] = FIELD_SWAMP;
                                break;
                        }
                    }
            }
        }
    }

    public function derive(ii:int, jj:int, newValue:int):Field {
        var newF:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(_m, true);
        for (var i:int = 0; i < _m; i++)
            newF[i] = f[i].slice();

        if (newValue >= 0)
            newF[ii][jj] = newValue;

        return new Field(_m, _n, newF);
    }

    public function get m():int {
        return _m;
    }

    public function get n():int {
        return _n;
    }

    public function getAt(i:int, j:int):int {
        if (i < 0 || i >= _m || j < 0 || j >= _n)
            return FIELD_SWAMP;
        return f[i][j];
    }

    public function setAt(i:int, j:int, value:int):void {
        if (i >= 0 && i < _m && j >= 0 && j < _n)
            f[i][j] = value;
    }

    public function deriveGrass(new_mowed_grass:Vector.<Position>):Field {
        var newF:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(_m, true);
        for (var i:int = 0; i < _m; i++)
            newF[i] = f[i].slice();

        for each (var position:Position in new_mowed_grass)
            newF[position.i][position.j] = FIELD_GRASS_MOWED;

        return new Field(_m, _n, newF);
    }

    public function countCells(v:int):int {
        var cnt:int = 0;
        for (var i:int = 0; i < _m; i++)
            for (var j:int = 0; j < _n; j++)
                if (f[i][j] == v)
                    cnt++;
        return cnt;
    }
}
}
