package ru.ipo.kio._16.mars.view {
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;

import mx.core.BitmapAsset;

import ru.ipo.kio._16.mars.model.Vector2D;

public class BodyView extends Shape {

    private var _ss:SpaceSystem;
    private var _position:Vector2D;

    public function BodyView(ss:SpaceSystem, _image_class:*) {
        _ss = ss;

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

    public function updateTransformation():void {
        var pm:Matrix = parent.transform.matrix;
        var m:Matrix = transform.matrix;

        m.a = 1 / pm.a;
        m.d = 1 / pm.d;

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
}
}
