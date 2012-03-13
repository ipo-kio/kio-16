/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.02.12
 * Time: 7:48
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.geom.Point;

import ru.ipo.kio._12.diamond.GeometryUtils;
import ru.ipo.kio._12.diamond.Vertex2D;
import ru.ipo.kio._12.diamond.model.Ray;
import ru.ipo.kio._12.diamond.model.Spectrum;

public class VisibleRay extends Sprite {
    private var _outer_intersection:Vertex2D = null;

    private static function visible_energy(energy:Number):Number {
//        return Math.pow(energy, 1/3);
        return Math.pow((0.01 + energy) / 1.01, 1/2);
    }
    
    public function VisibleRay(ray:Ray, scaler:Scaler, color:uint, x_min:Number, y_min:Number, x_max:Number, y_max:Number, level:int) {
        var r2:Vertex2D = ray.r2;
        if (r2 == null) {
            var intersection:Array = GeometryUtils.intersect_ray_and_poly(ray.r0, ray.r1, [
                new Vertex2D(x_min, y_min),
                new Vertex2D(x_min, y_max),
                new Vertex2D(x_max, y_max),
                new Vertex2D(x_max, y_min)
            ], -1, false);
            if (intersection != null && intersection[0] != null) {
                r2 = intersection[0];
                _outer_intersection = r2;
            }

            if (ray.is_internal)
                r2 = ray.r1;
        }

        var e:Number = level == 1 ? visible_energy(ray.percent) : visible_energy(ray.energy);
        color = Spectrum.multiply_color(color, e);

        if (r2 == null) {
            trace('ERROR #02ffe32');
            return;
        }

        var p1:Point = scaler.vertex2point(ray.r0);
        var p2:Point = scaler.vertex2point(r2);

        blendMode = BlendMode.ADD;
        graphics.lineStyle(3, color);
        graphics.moveTo(p1.x, p1.y);
        graphics.lineTo(p2.x, p2.y);
    }

    public function get outer_intersection():Vertex2D {
        return _outer_intersection;
    }
}
}
