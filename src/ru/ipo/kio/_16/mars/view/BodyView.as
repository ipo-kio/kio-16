package ru.ipo.kio._16.mars.view {
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;

import mx.core.BitmapAsset;

import ru.ipo.kio._16.mars.model.Vector2D;
import ru.ipo.kio._16.mars.view.SolarSystem;

public class BodyView extends Shape {

    private var _ss:SolarSystem;
    private var _position:Vector2D;

    public function BodyView(ss:SolarSystem, _image_class:*) {
        _ss = ss;

        if (_image_class is Class) {
            var bmp:BitmapAsset = new _image_class;
            var m:Matrix = new Matrix();
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

    public function moveTo(position:Vector2D):void {
        _position = position;

        var point:Point = _ss.position2point(position);
        x = point.x;
        y = point.y;
    }

    public function get position():Vector2D {
        return _position;
    }
}
}
