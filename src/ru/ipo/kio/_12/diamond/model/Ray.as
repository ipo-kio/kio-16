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
    private function reflect_refract(d:Array/*Vertex2D*/):void {
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
        var rfr_ray:Vertex2D = GeometryUtils.refract_ray(_r0, _r1, d[vi], d[vj],
                _is_internal ? 1 / Diamond.ETA : Diamond.ETA
        );

        if (rfr_ray != null)  {
            //TODO eval p1 and p2
            var p1:Number = 1/2;
            var p2:Number = 1/2;
            
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
}
}
