/**
 * Created by ilya on 17.02.14.
 */
package ru.ipo.kio._14.peterhof.view {
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;

public class Sprayer extends Sprite {

    [Embed(source="../resources/sprayer.jpg")]
    public static const WATER_IMAGE:Class;
    public static const WATER_IMAGE_BITMAP:BitmapData = (new WATER_IMAGE).bitmapData;

    private static const LINES_COLOR:uint = 0xFF0000;
    private static const BOTTOM_HEIGHT:int = 20;

    private var _sprite_width:Number;
    private var _sprite_height:Number;

    private var _f_width:Number = 0;
    private var _f_length:Number = 0;
    private var _outer_width:Number;
    private var _outer_pixel_width:Number;

    private var innerSprite:Sprite = new Sprite();

    public function Sprayer(sprite_width:Number, sprite_height:Number, outer_width:Number, outer_pixel_width:Number) {
        _sprite_width = sprite_width;
        _sprite_height = sprite_height;
        _outer_width = outer_width;
        _outer_pixel_width = outer_pixel_width;

        addChild(innerSprite);
        var mask:Shape = new Shape();
        mask.graphics.beginFill(0xFFFFFF);
        mask.graphics.drawRect(1, 1, sprite_width - 2, sprite_height - 2);
        mask.graphics.endFill();
        addChild(mask);
        mask.visible = false;
        innerSprite.mask = mask;

        //draw border
        graphics.lineStyle(1, 0xFFFFFF);
        graphics.drawRect(0, 0, sprite_width, sprite_height);
    }

    public function rotate(angle:Number):void {
        var m:Matrix = new Matrix();
        m.translate(-_sprite_width / 2, -_sprite_height / 2);
        m.rotate(Math.PI / 2 - angle);
        m.translate(_sprite_width / 2, _sprite_height / 2);
        innerSprite.transform.matrix = m;
    }

    public function get f_width():Number {
        return _f_width;
    }

    public function set f_width(value:Number):void {
        _f_width = value;
        redraw();
    }

    public function get f_length():Number {
        return _f_length;
    }

    public function set f_length(value:Number):void {
        _f_length = value;
        redraw();
    }

    private function redraw():void {
        var center_width:Number = _outer_pixel_width * _f_width / _outer_width; // (_f_width - _min_width) / (_max_width - _min_width);
        var center_length:Number = _outer_pixel_width / _outer_width * _f_length;
        var x0:Number = (_sprite_width - _outer_pixel_width) / 2;

        /*
            |   |
        |---|   |---|
        |           |
        */

        var g:Graphics = innerSprite.graphics;

        g.clear();

        var m:Matrix = new Matrix();
        m.translate(-10, 0);
        g.beginBitmapFill(WATER_IMAGE_BITMAP, m);
        g.drawRect(x0, _sprite_height - BOTTOM_HEIGHT, _outer_pixel_width, 10 * BOTTOM_HEIGHT + 2);
        g.drawRect((_sprite_width - center_width) / 2, -100, center_width, _sprite_height - BOTTOM_HEIGHT + 100);
        g.endFill();

        g.lineStyle(2, LINES_COLOR);
        g.moveTo(x0, 10 * _sprite_height);
        g.lineTo(x0, _sprite_height - BOTTOM_HEIGHT);
        g.lineTo((_sprite_width - center_width) / 2, _sprite_height - BOTTOM_HEIGHT);
        g.lineTo((_sprite_width - center_width) / 2, _sprite_height - BOTTOM_HEIGHT - center_length);

        g.moveTo(_sprite_width - x0, 10 * _sprite_height);
        g.lineTo(_sprite_width - x0, _sprite_height - BOTTOM_HEIGHT);
        g.lineTo((_sprite_width + center_width) / 2, _sprite_height - BOTTOM_HEIGHT);
        g.lineTo((_sprite_width + center_width) / 2, _sprite_height - BOTTOM_HEIGHT - center_length);
    }

    public function get sprite_height():int {
        return _sprite_height;
    }

    public function get sprite_width():int {
        return _sprite_width;
    }
}
}
