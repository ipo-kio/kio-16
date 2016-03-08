package ru.ipo.kio._16.mars.view {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;

import mx.core.BitmapAsset;

import ru.ipo.kio._16.mars.model.Orbit;

import ru.ipo.kio._16.mars.model.Vector2D;

public class BodyView extends Sprite {

    private var _ss:SpaceSystem;
    private var _position:Vector2D;

    public function BodyView(ss:SpaceSystem, _image_class:*) {
        _ss = ss;

        mouseEnabled = false;
        mouseChildren = false;

        if (_image_class is BitmapData) {
            var m:Matrix = new Matrix();
            m.translate(-_image_class.width / 2, -_image_class.height / 2);
            graphics.beginBitmapFill(_image_class, m, false);
            graphics.drawRect(-_image_class.width / 2, -_image_class.height / 2, _image_class.width, _image_class.height);
        } else if (_image_class is Class) {
            var bmp:BitmapAsset = new _image_class;
            m = new Matrix();
            m.translate(-bmp.width / 2, -bmp.height / 2);
            graphics.beginBitmapFill(bmp.bitmapData, m);
            graphics.drawRect(-bmp.width / 2, -bmp.height / 2, bmp.width, bmp.height);
        } else if (_image_class is uint) {
            graphics.beginFill(_image_class);
            graphics.drawCircle(0, 0, 3);
            graphics.endFill();
        } else if (_image_class === "ship") {
            graphics.beginFill(0x880044);
            graphics.drawRect(-4, -3, 8, 6);
            graphics.endFill();
        }
    }

    public function enableMouse():void {
        mouseEnabled = true;
        var h:Sprite = new Sprite();
        h = new Sprite();
        addChild(h);
        hitArea = h;
        h.visible = false;

        h.graphics.beginFill(0xFF0000);
        h.graphics.drawCircle(0, 0, 10);
        h.graphics.endFill();

        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

        if (stage != null)
            addedToStageHandler(null);
        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

        //stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
    }

    public function updateTransformation(size:Number = 1):void {
        var pm:Matrix = parent.transform.matrix;
        var m:Matrix = transform.matrix;

        m.a = size / pm.a;
        m.d = size / pm.d;

        transform.matrix = m;
    }

    public function moveTo(position:Vector2D):void {
        _position = position;

        var point:Point = _ss.position2point(position);
        x = point.x;
        y = point.y;
    }

    public function get position():Vector2D {
        return _position;
    }

    private var dragging:Boolean = false;

    private function mouseDownHandler(event:MouseEvent):void {
        startDrag();
        dragging = true;
    }

    private function stage_mouseUpHandler(event:MouseEvent):void {
        if (!dragging)
            return;
        dragging = false;
        stopDrag();
        relocate(event.stageX, event.stageY);
    }

    private function relocate(stageX:Number, stageY:Number):void {
        var localPoint:Point = parent.globalToLocal(new Point(stageX, stageY));
        var x:Number = localPoint.x;
        var y:Number = localPoint.y;

        var d:Number = Math.sqrt(x * x + y * y);

        var minDistance:Number = +Infinity;
        var optOrbit:OrbitView = null;

        for each (var orbit:OrbitView in PlanetsSystem(_ss).all_orbits) {
            var t:Number = orbit.o.a * orbit.scale;
            var theta:Number = Math.atan2(-y, x);

            theta = Math.round(theta / Math.PI * 180) * Math.PI / 180;

            var dist_to_cursor:Number = Math.abs(d - t);
            if (dist_to_cursor < minDistance) {
                optOrbit = orbit;
                minDistance = dist_to_cursor;
            }
        }

        if (optOrbit != null) {
            var newOrbit:Orbit = Orbit.createOrbitByInitial(Vector2D.createPolar(optOrbit.o.a, theta));
            PlanetsSystem(_ss).setOrbitForBody(this, newOrbit);
        }
    }

    private function addedToStageHandler(event:Event):void {
        stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
    }

    private function removedFromStageHandler(event:Event):void {
        stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
    }

    //embeddings

    [Embed(source="../res/planets/earth_13.png")]
    public static const EARTH_CLASS:Class;
    public static const EARTH_BMP:BitmapData = (new EARTH_CLASS).bitmapData;

    [Embed(source="../res/planets/mars_11.png")]
    public static const MARS_CLASS:Class;
    public static const MARS_BMP:BitmapData = (new MARS_CLASS).bitmapData;

    [Embed(source="../res/planets/ship_29.png")]
    public static const SHIP_CLASS:Class;
    public static const SHIP_BMP:BitmapData = (new SHIP_CLASS).bitmapData;

    [Embed(source="../res/planets/sun_23x23.png")]
    public static const SUN_CLASS:Class;
    public static const SUN_BMP:BitmapData = (new SUN_CLASS).bitmapData;

    //-------------------------------------------------------------------------------

    [Embed(source="../res/planets/Mercury_9.png")]
    public static const MERCURY_CLASS:Class;
    public static const MERCURY_BMP:BitmapData = (new MERCURY_CLASS).bitmapData;

    [Embed(source="../res/planets/Venera_13.png")]
    public static const VENERA_CLASS:Class;
    public static const VENERA_BMP:BitmapData = (new VENERA_CLASS).bitmapData;

    [Embed(source="../res/planets/jupiter_23.png")]
    public static const JUPITER_CLASS:Class;
    public static const JUPITER_BMP:BitmapData = (new JUPITER_CLASS).bitmapData;

    [Embed(source="../res/planets/Saturn_23.png")]
    public static const SATURN_CLASS:Class;
    public static const SATURN_BMP:BitmapData = (new SATURN_CLASS).bitmapData;

    [Embed(source="../res/planets/Uran_17.png")]
    public static const URAN_CLASS:Class;
    public static const URAN_BMP:BitmapData = (new URAN_CLASS).bitmapData;

    [Embed(source="../res/planets/Neptun_17.png")]
    public static const NEPTUN_CLASS:Class;
    public static const NEPTUN_BMP:BitmapData = (new NEPTUN_CLASS).bitmapData;
}
}
