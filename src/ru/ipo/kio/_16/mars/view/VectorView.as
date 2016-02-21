package ru.ipo.kio._16.mars.view {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio._16.mars.model.Vector2D;

public class VectorView extends Sprite {

    public static const VALUE_CHANGED:String = 'vector view value changed';

    private var _value:Vector2D;
    private var _anglesNumber:int;
    private var _radiusesNumber:int;
    private var _maxValue:Number;
    private var _size:Number;

    private var _delta_R:Number;
    private var _delta_Phi:Number;
    private var _mul:Number;

    private var _arrow_layer:Sprite;

    public function VectorView(anglesNumber:int, radiusesNumber:int, maxValue:Number, size:Number) {
        _anglesNumber = anglesNumber;
        _radiusesNumber = radiusesNumber;
        _maxValue = maxValue;
        _size = size;

        _delta_R = _maxValue / _radiusesNumber;
        _delta_Phi = 2 * Math.PI / _anglesNumber;
        _mul = size / maxValue;

        initBg();

        _arrow_layer = new Sprite();
        addChild(_arrow_layer);

        init_hit_area();

        addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        addEventListener(MouseEvent.CLICK, mouseClickHandler);
    }

    private function init_hit_area():void {
        var hit_area:Sprite = new Sprite();
        hit_area.mouseEnabled = false;
        hit_area.visible = false;
        hitArea = hit_area;

        hit_area.graphics.beginFill(0x000000);
        hit_area.graphics.drawCircle(0, 0, _size);
        hit_area.graphics.endFill();

        addChild(hit_area);
    }

    private function initBg():void {
        graphics.lineStyle(1, 0xAAAAAA);
        for (var i:int = 1; i <= _radiusesNumber; i++)
            graphics.drawCircle(0, 0, _size * i / _radiusesNumber);
    }

    public function get value():Vector2D {
        return _value;
    }

    public function set value(value:Vector2D):void {
        _value = value;

        redrawArrow();
    }

    private function redrawArrow():void {
        var g:Graphics = _arrow_layer.graphics;
        g.clear();

        g.lineStyle(2, 0x000000);
        var point:Point = value2position(_value);
        g.moveTo(0, 0);
        g.lineTo(point.x, point.y);

        var p:Point = point.clone();
        p.normalize(10);

        var c18:Number = Math.cos(Math.PI / 10);
        var s18:Number = Math.sin(Math.PI / 10);

        g.moveTo(point.x, point.y);
        g.lineTo(point.x - c18 * p.x + s18 * p.y, point.y - s18 * p.x - c18 * p.y);
        g.moveTo(point.x, point.y);
        g.lineTo(point.x - c18 * p.x - s18 * p.y, point.y + s18 * p.x - c18 * p.y);
    }

    private function value2position(vector:Vector2D):Point {
        var vector2D:Vector2D = roundVector(vector);

        return new Point(vector2D.x * _mul, -vector2D.y * _mul);
    }

    private function roundVector(vector:Vector2D):Vector2D {
        //round R
        var dR:int = Math.round(vector.r / _delta_R);
        if (dR < 0)
            dR = 0;
        if (dR > _radiusesNumber)
            dR = _radiusesNumber;

        var r:Number = dR * _delta_R;

        //round Phi
        var dPhi:int = Math.round(vector.theta / _delta_Phi);
        dPhi = dPhi % _anglesNumber;

        var phi:Number = dPhi * _delta_Phi;

        return Vector2D.createPolar(r, phi);
    }

    private function positionXY2value(x:Number, y:Number):Vector2D {
        var d:Number = Math.sqrt(x * x + y * y);
        var r:Number = _maxValue * d / _size;
        var phi:Number = Math.atan2(-y, x);

        return roundVector(Vector2D.createPolar(r, phi));
    }

    private function position2value(p:Point):Vector2D {
        return positionXY2value(p.x, p.y);
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        if (event.buttonDown)
            newMousePosition(event);
    }

    private function mouseClickHandler(event:MouseEvent):void {
        newMousePosition(event);
    }

    private function newMousePosition(event:MouseEvent):void {
        var vector2D:Vector2D = positionXY2value(event.localX, event.localY);
        value = vector2D;
        dispatchEvent(new Event(VALUE_CHANGED));
    }
}
}
