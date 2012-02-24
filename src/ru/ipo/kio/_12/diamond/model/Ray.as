/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 21.02.12
 * Time: 19:15
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.model {
import ru.ipo.kio._12.diamond.GeometryUtils;
import ru.ipo.kio._12.diamond.Vertex2D;

public class Ray {

    private var _percent:Number;
    private var _energy:Number;
    private var _r0:Vertex2D; //from point
    private var _r1:Vertex2D; //through point
    private var _r2:Vertex2D = null; //stop point
    private var _is_internal:Boolean = false;
    private var _i0:int = -1; //the index of the side of the diamond
    
    private var _prev_ray:Ray;
    private var _reflect_refract_rays:Array/*Ray*/ = [null, null];

    public function Ray(prev_ray:Ray, r0:Vertex2D, r1:Vertex2D, is_internal:Boolean, i0:int, percent:Number) {
        _prev_ray = prev_ray;
        _is_internal = is_internal;
        _r0 = r0;
        _r1 = r1;
        _i0 = i0;
        _percent = percent;
    }

    //create the reflected ray
    private function reflect_refract(d:Array/*Vertex2D*/, eta:Number):void {
        var intersection:Array = GeometryUtils.intersect_ray_and_poly(_r0, _r1, d, _i0, !_is_internal);

        if (intersection == null) {
            _reflect_refract_rays[0] = null;
            return;
        }

        _r2 = intersection[0];
        var vi:int = intersection[1];
        var vj:int = vi + 1;
        if (vj == d.length)
            vj = 0;

        var rfl_ray:Vertex2D = GeometryUtils.reflect_ray(_r0, _r1, d[vi], d[vj]);
        var refraction_data:Array = GeometryUtils.refract_ray(_r0, _r1, d[vi], d[vj],
                _is_internal ? 1 / eta : eta
        );

        if (refraction_data != null) {
            //TODO eval p1 and p2
            var rfr_ray:Vertex2D = refraction_data[0];

            var p1:Number = 1 - refraction_data[1];
            var p2:Number = refraction_data[1];
            
            _reflect_refract_rays = [
                    new Ray(this, _r2, _r2.plus(rfl_ray), _is_internal, vi, _percent * p1),
                    new Ray(this, _r2, _r2.plus(rfr_ray), !_is_internal, vi, _percent * p2)
            ];
        } else {
            _reflect_refract_rays = [
                    new Ray(this, _r2, _r2.plus(rfl_ray), _is_internal, vi, _percent),
                    null
            ];
        }
    }


    public function get percent():Number {
        return _percent;
    }

    public function get r0():Vertex2D {
        return _r0;
    }

    public function get r1():Vertex2D {
        return _r1;
    }

    public function get r2():Vertex2D {
        return _r2;
    }

    public function get energy():Number {
        return _energy;
    }

    public function get base_energy():Number {
        return Math.abs(_r1.minus(_r0).normalize.y);
    }

    public function recurse_bild_rays(d:Array, eta:Number, level:int = 0):void {
        _energy = 0;

        if (level > 20 || percent < 0.001)
            return;

        if (d == null)
            return;

        reflect_refract(d, eta);

        var no_children:Boolean = true;
        for (var i:int = 0; i <= 1; i++) {
            var r:Ray = _reflect_refract_rays[i];
            if (r != null) {
                r.recurse_bild_rays(d, eta, level + 1);
                /*if (isNaN(r._energy)) {
                    trace(42);
                    r.recurse_bild_rays(d, eta, level + 1);
                }*/
                _energy += r.percent * r._energy;
                no_children = false;
            }
        }
        
        if (no_children && !_is_internal) {
            _energy = base_energy;
/*            if (isNaN(_energy)) {
                trace(42);
            }*/
        }
    }

    //0 - reflect, 1 - refract
    public function get_reflect_refract_ray(ind:int):Ray {
        return _reflect_refract_rays[ind];
    }

    public function get is_internal():Boolean {
        return _is_internal;
    }
}
}
