/**
 * Created by ilya on 17.02.14.
 */
package ru.ipo.kio._14.peterhof.view {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;

public class Sprayer extends Sprite {

    [Embed(source="../resources/sprayer.jpg")]
    public static const WATER_IMAGE:Class;
    public static const WATER_IMAGE_BITMAP:BitmapData = (new WATER_IMAGE).bitmapData;

    public static const WATER_COLOR:uint = 0x0000FF;
    public static const LINES_COLOR:uint = 0xFFFFFF;
    public static const LEFT_WIDTH:int = 20;
    public static const RIGHT_WIDTH:int = 10;

    private var _sprite_width:Number;
    private var _sprite_height:Number;

    private var _f_width:Number = 0;
    private var _f_length:Number = 0;
//    private var _min_width:Number;
//    private var _max_width:Number;
//    private var _min_length:Number;
//    private var _max_length:Number;
    private var _outer_width:Number;

    public function Sprayer(sprite_width:Number, sprite_height:Number, /*min_width:Number, max_width:Number, min_length:Number, max_length:Number,*/ outer_width:Number) {
        _sprite_width = sprite_width;
        _sprite_height = sprite_height;
//        _min_width = min_width;
//        _max_width = max_width;
//        _min_length = min_length;
//        _max_length = max_length;
        _outer_width = outer_width;
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
        var center_height:Number = _sprite_height * _f_width / _outer_width; // (_f_width - _min_width) / (_max_width - _min_width);
        var center_length:Number = _sprite_height / _outer_width * _f_length;

        graphics.clear();

        /*
        -----|
             |
             -----

             -----
             |
        -----|
        */

        var m:Matrix = new Matrix();
        m.translate(-10, 0);
        graphics.beginBitmapFill(WATER_IMAGE_BITMAP, m);
        graphics.drawRect(-2, 0, 2 + LEFT_WIDTH, _sprite_height);
        graphics.drawRect(LEFT_WIDTH, (_sprite_height - center_height) / 2, _sprite_width - LEFT_WIDTH, center_height);
        graphics.endFill();

        graphics.lineStyle(2, LINES_COLOR);
        graphics.moveTo(0, 0);
        graphics.lineTo(LEFT_WIDTH, 0);
        graphics.lineTo(LEFT_WIDTH, (_sprite_height - center_height) / 2);
        graphics.lineTo(LEFT_WIDTH + center_length, (_sprite_height - center_height) / 2);

        graphics.moveTo(0, _sprite_height);
        graphics.lineTo(LEFT_WIDTH, _sprite_height);
        graphics.lineTo(LEFT_WIDTH, (_sprite_height + center_height) / 2);
        graphics.lineTo(LEFT_WIDTH + center_length, (_sprite_height + center_height) / 2);
    }
}
}
