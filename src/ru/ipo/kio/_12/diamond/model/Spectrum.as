/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.02.12
 * Time: 22:57
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.model {
import ru.ipo.kio._12.diamond.Vertex2D;

public class Spectrum {

    public static const COLORS:Array = [
            0xFF0000,
            0x00FF00,
            0x0000FF
    ];
    public static var COLORS_COUNT:int = COLORS.length;
    public static var TICKS_MAX:int = 42;

    private var _table:Array;
    private var _mean_light:Number;
    private var _mean_disp:Number;
    
    public static function multiply_color(color:uint, mul:Number):uint {
        var r:uint = ((color >> 16) & 0xFF) * mul;
        var g:uint = ((color >> 8) & 0xFF) * mul;
        var b:uint = (color & 0xFF) * mul;

        return (r << 16) | (g << 8) | b;
    }

    public function Spectrum(diamond:Diamond, min_angle:Number, max_angle:Number) {
        
        _table = new Array(TICKS_MAX + 1);

        for (var i:int = 0; i <= TICKS_MAX; i++) {
            var angle:Number = min_angle + i * (max_angle - min_angle) / TICKS_MAX;

            _table[i] = color_ray(angle, diamond);
        }

        evaluate_data();
    }

    public static function color_ray(angle:Number, diamond:Diamond):Array {
        var ray:Ray = new Ray(
                null,
                new Vertex2D(0, 0),
                new Vertex2D(Math.cos(angle), Math.sin(angle)),
                false,
                -1,
                1
        );

        var ca:Array = new Array(COLORS_COUNT);

        for (var col:int = 0; col < COLORS_COUNT; col++) {
            ray.recurse_bild_rays(diamond.hull, Diamond.ETA + 0.01 * col);
            ca[col] = ray.energy;
        }

        return ca;
    }
    
    public static function mean(data:Array):Number {
        var sum:Number = 0;
        for (var col:int = 0; col < data.length; col++)
            sum += data[col];
        
        return sum / data.length;
    }

    public static function variance(data:Array):Number {
        var mn:Number = mean(data);
        var sum:Number = 0;
        for (var col:int = 0; col < data.length; col++)
            sum += data[col] * data[col];

        return sum / data.length - mn * mn;
    }

    private function evaluate_data():void {
        //среднее освещение
        var all_light:Number = 0;
        for (var i:int = 0; i <= TICKS_MAX; i++)
            all_light += mean(_table[i]);

        _mean_light = all_light / (1.0 + TICKS_MAX);

        //средняя дисперсия
        var all_disp:Number = 0;
        for (i = 0; i <= TICKS_MAX; i++)
            all_disp += variance(_table[i]);

        _mean_disp = all_disp / (TICKS_MAX + 1);
    }

    public function get table():Array {
        return _table;
    }

    public function get mean_light():Number {
        return _mean_light;
    }

    public function get mean_disp():Number {
        return _mean_disp;
    }
}
}
