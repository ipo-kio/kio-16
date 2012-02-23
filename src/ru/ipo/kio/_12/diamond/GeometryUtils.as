/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 12.02.12
 * Time: 11:16
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond {

public class GeometryUtils {

    //positive for CCV
    public static function vect_prod(v10:Vertex2D, v11:Vertex2D, v20:Vertex2D, v21:Vertex2D):Number {
        var x1:Number = v11.x - v10.x;
        var y1:Number = v11.y - v10.y;
        var x2:Number = v21.x - v20.x;
        var y2:Number = v21.y - v20.y;

        return x1 * y2 - x2 * y1;
    }

    public static function scal_prod(v10:Vertex2D, v11:Vertex2D, v20:Vertex2D, v21:Vertex2D):Number {
        var x1:Number = v11.x - v10.x;
        var y1:Number = v11.y - v10.y;
        var x2:Number = v21.x - v20.x;
        var y2:Number = v21.y - v20.y;

        return x1 * x2 + y1 * y2;
    }
    
    public static function convex_hull(poly:Array/*Vertex2D*/):Array/*Vertex2D*/ {
        poly = poly.slice();
        
        if (poly.length < 3)
            return poly;

        //find the leftmost point of the lowest points
        var p0:Vertex2D = poly[0];
        var p0_ind:int = 0;
        
        for (var i:int = 1; i < poly.length; i++) {
            var p:Vertex2D = poly[i];
            if (p.y < p0.y || p.y == p0.y && p.x < p0.x) {
                p0 = p;
                p0_ind = i;
            }
        }

        //exchange points
        poly[p0_ind] = poly[0];
        poly[0] = p0;

        //sort by angle, bubble sort.
        for (i = 1; i < poly.length; i++)
            for (var j:int = i + 1; j < poly.length; j++) {
                //compare poly[i] and poly[j]
                var mul:Number = vect_prod(p0, poly[i], p0, poly[j]);

                var exchange:Boolean = false;
                if (mul < 0)
                    exchange = true;
                else if (mul === 0) {
                    var dxi:Number = poly[i].x - p0.x;
                    var dxj:Number = poly[j].x - p0.x;
                    var dyi:Number = poly[i].y - p0.y;
                    var dyj:Number = poly[j].y - p0.y;
                    exchange = dxi*dxi + dyi*dyi > dxj*dxj + dyj*dyj;
                }
                
                if (exchange) {
                    var tmp:Vertex2D = poly[i];
                    poly[i] = poly[j];
                    poly[j] = tmp;
                }
            }
        
        var stack:Array = new Array(p0, poly[1]);
        for (i = 2; i < poly.length; i++)
            while (true) {
                var len:int = stack.length;
                
                if (len < 2) {
                    stack.push(poly[i]);
                    break;
                }
                
                var next_to_top:Vertex2D = stack[len - 2];
                var top:Vertex2D = stack[len - 1];

                mul = vect_prod(next_to_top, top, top, poly[i]);
                
                var stop_popping:Boolean = false;
                if (mul > 0)
                    stop_popping = true;
                if (mul == 0)
                    stop_popping = scal_prod(next_to_top, top, top, poly[i]) < 0;
                
                if (stop_popping) {
                    stack.push(poly[i]);
                    break;
                }

                stack.pop();
            }
        
        return stack;
    }

    //returns a, b, c
    public static function points2line(v1:Vertex2D, v2:Vertex2D):Array {
        //x - x1 / x2 - x1 = y - y1 / y2 - y1
        //c = y1*(x2-x1) - x1*(y2 - y1) = y1 * x2 - x1 * y2;
        return [
                v2.y - v1.y,
                v1.x - v2.x,
                v1.y * v2.x - v1.x * v2.y
        ];
    }
    
    public static function intersect_lines(l1:Array, l2:Array):Vertex2D {
        //a1 b1 = -c1
        //a2 b2 = -c2
        var d:Number = l1[0]*l2[1] - l1[1]*l2[0];
        var d1:Number = - l1[2]*l2[1] + l2[2]*l1[1];
        var d2:Number = - l1[0]*l2[2] + l2[0]*l1[2];
        
        if (d == 0)
            return null;
        
        return new Vertex2D(d1 / d, d2 / d);
    }
    
    public static function line_value(line:Array, p:Vertex2D):Number {
        return line[0] * p.x + line[1] * p.y + line[2];
    }

    //null means no intersection
    public static function intersect_ray_and_segment(r0:Vertex2D, r1:Vertex2D, s1:Vertex2D, s2:Vertex2D):Vertex2D {
        var ray_line:Array = points2line(r0, r1);
        var d1:Number = line_value(ray_line, s1);
        var d2:Number = line_value(ray_line, s2);

        if (d1 * d2 > 0)
            return null;
        
        var seg_line:Array = points2line(s1, s2);
        var intersection:Vertex2D = intersect_lines(ray_line, seg_line);

        if (intersection == null)
            return null;

        if (scal_prod(r0, r1, r0, intersection) < 0)
            return null;
        
        return intersection;
    }

    public static function normal_for_segment(s1:Vertex2D, s2:Vertex2D):Vertex2D {
        var x:Number = s1.y - s2.y;
        var y:Number = s2.x - s1.x;

        var l:Number = 1; //Math.sqrt(x * x + y * y);
        
        return new Vertex2D(x / l,  y / l);
    }

    //r1 lays on segment, returns a vector parallel to the reflected ray
    public static function reflect_ray(r0:Vertex2D, r1:Vertex2D, s1:Vertex2D, s2:Vertex2D):Vertex2D {
        //reflected vector = r
        //initial vector = i
        //normal vector = n
        //i - 2 * (i*n) * n

        var n:Vertex2D = normal_for_segment(s1, s2);
        //test n goes to the incoming half-plane
        
        var n_norm_sq:Number = n.x * n.x + n.y * n.y;

        var mul:Number = scal_prod(r0, r1, Vertex2D.ZERO, n);

        return new Vertex2D(
                r1.x - r0.x - 2 * mul * n.x / n_norm_sq,
                r1.y - r0.y - 2 * mul * n.y / n_norm_sq
        );
    }
    
    public static function normalize(v:Vertex2D):Vertex2D {
        var l:Number = Math.sqrt(v.x * v.x + v.y * v.y);
        return new Vertex2D(
                v.x / l,
                v.y / l
        );
    }

    public static function normalize2(v1:Vertex2D, v2:Vertex2D):Vertex2D {
        var x:Number = v2.x - v1.x;
        var y:Number = v2.y - v1.y;
        var l:Number = Math.sqrt(x * x + y * y);
        return new Vertex2D(x / l, y / l);
    }

    //r1 lays on segment, returns a vector parallel to the refracted ray.
    //returns [vector, refraction percent]
    public static function refract_ray(r0:Vertex2D, r1:Vertex2D, s1:Vertex2D, s2:Vertex2D, eta12:Number):Array {
        var i:Vertex2D = normalize2(r0, r1);
        var n:Vertex2D = normalize(normal_for_segment(s1, s2));

        //make sure that normal goes to the half plane with the incoming ray
        var cos_ti:Number = - scal_prod(Vertex2D.ZERO, i, Vertex2D.ZERO, n);
        if (cos_ti < 0) {
            n = new Vertex2D(-n.x, -n.y);
            cos_ti = -cos_ti;
        }

        var sin_tn:Number = eta12 * eta12 * (1 - cos_ti * cos_ti);

        if (sin_tn > 1)
            return null; //Total internal reflection

        var k2:Number = eta12 * cos_ti - Math.sqrt(1 - sin_tn * sin_tn);

        var cos_tn:Number = Math.sqrt(1 - sin_tn * sin_tn);
        var r_perp:Number = Math.pow((eta12 * cos_ti - cos_tn) / (eta12 * cos_ti + cos_tn), 2);
        var r_par:Number = Math.pow((cos_ti - eta12 * cos_tn) / (cos_ti + eta12 * cos_tn), 2);

        return [new Vertex2D(
                eta12 * i.x + k2 * n.x,
                eta12 * i.y + k2 * n.y
        ),
                1 - (r_par + r_perp) / 2
        ];
    }

    //returns [intersection, i, j]
    //don't intersect with i0, i0 + 1
    //take_min = true means the closest intersection will be chosen
    public static function intersect_ray_and_poly(r0:Vertex2D, r1:Vertex2D, d:Array, i0:int, take_min:Boolean):Array {
        var s:Array = []; //candidates
        for (var i:int = 0; i < d.length; i++) {
            var j:int = i - 1;

            if (j < 0)
                j = d.length - 1;

            //don't intersect with i0
            if (j == i0)
                continue;

            var p:Vertex2D = intersect_ray_and_segment(r0, r1, d[i], d[j]);
            
            if (p != null)
                s.push([p, j]);
        }

        if (take_min) {
            var min:Array = null;
            var min_d:Number = Number.MAX_VALUE;
            for each (var r:Array in s) {
                var l:Number = (r0.x - r[0].x) * (r0.x - r[0].x) + (r0.y - r[0].y) * (r0.y - r[0].y);
                if (l < min_d) {
                    min_d = l;
                    min = r;
                }
            }

            return min;
        } else {
            //code duplication is not a mortal sin
            var max:Array = null;
            var max_d:Number = Number.MIN_VALUE;
            for each (r in s) {
                l = (r0.x - r[0].x) * (r0.x - r[0].x) + (r0.y - r[0].y) * (r0.y - r[0].y);
                if (l > max_d) {
                    max_d = l;
                    max = r;
                }
            }
            
            return max;
        }
    }

//    //returns [1. first ray 2. internal rays 3. out rays]
//    public static function trace_rays(r0:Vertex2D, r1:Vertex2D, d:Array/*Vertex2D*/, eta:Number):Array {
//        var int_rays:Array = [];
//        var out_rays:Array = [];
//
//        var first_intersection:Array = intersect_ray_and_poly(r0, r1, d, -1, -1, false);
//
//        if (first_intersection == null)
//            return [[r0, first_intersection[0]], [], []];
//
//        var cur_int:Array = first_intersection;
//
//        while (true) {
//            var rfl_r:Vertex2D = reflect_ray(r0, r1, d[cur_int[1]], d[cur_int[2]]);
//            var rfr_r:Vertex2D = refract_ray(r0, r1, d[cur_int[1]], d[cur_int[2]], eta);
//        }
//
//        return [[r0, first_intersection[0]], int_rays, out_rays];
//    }

}
}
