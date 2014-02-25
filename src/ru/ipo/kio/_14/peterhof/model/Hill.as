/**
 * Created by ilya on 14.01.14.
 */
package ru.ipo.kio._14.peterhof.model {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

public class Hill extends EventDispatcher {

    private var _fountains:Vector.<Fountain> = new Vector.<Fountain>();
    private var _total_stream_length:Number;
    private var _close_fountains:Array = []; //array of pairs
    private var _fountains_in_close_pairs:Dictionary = new Dictionary(); //array of fountains
    private var _level:int;

    public function Hill(level:int) {
        _level = level;

        _fountains = initialFountainsList();

        addChangeListeners();
        updateLengthInfo();
        updateDistanceInfo();
    }
    
    private function initialFountainsList():Vector.<Fountain> {
        var fountains_set:Vector.<Fountain> = new <Fountain>[];

        var f1:Fountain = new Fountain(this);
        f1.x = 5;
        f1.z = 5;
        f1.l = 0.1;
        f1.d = 0.04;
        f1.phiGr = -20;
        f1.alphaGr = 70;

        var f2:Fountain = new Fountain(this);
        f2.x = 20;
        f2.z = 95;
        f2.l = 0.1;
        f2.d = 0.04;
        f2.phiGr = 0;
        f2.alphaGr = 70;

        var f3:Fountain = new Fountain(this);
        f3.x = 35;
        f3.z = 30;
        f3.l = 0.1;
        f3.d = 0.04;
        f3.phiGr = 160;
        f3.alphaGr = 70;

        var f4:Fountain = new Fountain(this);
        f4.x = 50;
        f4.z = 70;
        f4.l = 0.1;
        f4.d = 0.04;
        f4.phiGr = 160;
        f4.alphaGr = 70;

        var f5:Fountain = new Fountain(this);
        f5.x = 65;
        f5.z = 5;
        f5.l = 0.1;
        f5.d = 0.04;
        f5.phiGr = 90;
        f5.alphaGr = 71;

        var f6:Fountain = new Fountain(this);
        f6.x = 80;
        f6.z = 95;
        f6.l = 0.1;
        f6.d = 0.04;
        f6.phiGr = -140;
        f6.alphaGr = 71;

        fountains_set.push(f1);
        fountains_set.push(f2);
        fountains_set.push(f3);
        fountains_set.push(f4);
        fountains_set.push(f5);
        fountains_set.push(f6);

        if (_level > 0) {
            var f7:Fountain = new Fountain(this);
            f7.x = 95;
            f7.z = 30;
            f7.l = 0.1;
            f7.d = 0.04;
            f7.phiGr = 160;
            f7.alphaGr = 70;

            var f8:Fountain = new Fountain(this);
            f8.x = 110;
            f8.z = 70;
            f8.l = 0.1;
            f8.d = 0.04;
            f8.phiGr = 160;
            f8.alphaGr = 70;

            fountains_set.push(f7);
            fountains_set.push(f8);
        }
        
        return fountains_set;
    }

    private function addChangeListeners():void {
        for each (var fountain:Fountain in _fountains)
            fountain.addEventListener(Event.CHANGE, fountainChanged);
    }

    private function fountainChanged(event:Event):void {
        var f:Fountain = event.target as Fountain;

        updateLengthInfo();
        updateDistanceInfo();

        dispatchEvent(new FountainEvent(FountainEvent.CHANGED, f));
    }

    private function updateDistanceInfo():void {
        _close_fountains = [];
        _fountains_in_close_pairs = new Dictionary();

        var n:int = _fountains.length;
        for (var i:int = 0; i < n; i++)
            for (var j:int = i + 1; j < n; j++) {
                var fi:Fountain = _fountains[i];
                var fj:Fountain = _fountains[j];

                var dx:Number = fi.x - fj.x;
                var dy:Number = fi.y - fj.y;
                var dz:Number = fi.z - fj.z;
                var dist:Number = dx * dx + dy * dy + dz * dz;

                if (dist <= min_dist * min_dist) {
                    _close_fountains.push([fi, fj, Math.sqrt(dist)]);
                    _fountains_in_close_pairs[fi] = true;
                    _fountains_in_close_pairs[fj] = true;
                }
            }
    }

    private function updateLengthInfo():void {
        _total_stream_length = 0;
        for each (var f:Fountain in _fountains) {
            var stream:Stream = f.stream;

            if (!stream.goes_out && !(f in _fountains_in_close_pairs))
                _total_stream_length += f.stream.length;
        }
    }

    public function get fountains():Vector.<Fountain> {
        return _fountains;
    }

    public function get total_stream_length():Number {
        return _total_stream_length;
    }

    public function get close_fountains():Array {
        return _close_fountains;
    }

    //noinspection JSUnusedLocalSymbols
    public static function xz2y(x:Number, z:Number):Number {
        if (x < Consts.HILL_LENGTH1)
            return (Consts.HILL_LENGTH1 - x) * Consts.HILL_HEIGHT / Consts.HILL_LENGTH1;
        else
            return 0;
    }

    public static function pipeLengthTo(x:Number, z:Number):Number {
        if (x < Consts.HILL_LENGTH1) {
            var dy:Number = Consts.HILL_HEIGHT - xz2y(x, z);
            return Math.sqrt(x * x + dy * dy);
        } else
            return x - Consts.HILL_LENGTH1 + Math.sqrt(Consts.HILL_LENGTH1 * Consts.HILL_LENGTH1 + Consts.HILL_HEIGHT * Consts.HILL_HEIGHT);
    }

    public function invalidate_streams():void {
        for each (var fountain:Fountain in _fountains)
            fountain.invalidate_stream();
    }

    public function serialize():Object {
        var result:Array = [];

        for each (var fountain:Fountain in fountains)
            result.push(fountain.serialize());

        return result;
    }

    public function deserialize(a:Object):void {
        if (a == null)
            return;
        if (a.length != _fountains.length)
            return;
        for (var i:int = 0; i < _fountains.length; i++)
            _fountains[i].deserialize(a[i]);
    }

    public function get min_dist():Number {
        return Consts.MIN_DIST[_level];
    }

    public function clear():void {
        var f:Vector.<Fountain> = initialFountainsList();
        for (var i:int = 0; i < f.length; i++) {
            _fountains[i].alphaGr = f[i].alphaGr;
            _fountains[i].phiGr = f[i].phiGr;
            _fountains[i].d = f[i].d;
            _fountains[i].l = f[i].l;
            _fountains[i].x = f[i].x;
            _fountains[i].z = f[i].z;
        }

    }
}
}
