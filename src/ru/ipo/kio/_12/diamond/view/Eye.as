/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 17.02.12
 * Time: 16:43
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;

import ru.ipo.kio._12.diamond.Vertex2D;

import ru.ipo.kio._12.diamond.model.Diamond;
import ru.ipo.kio._12.diamond.model.Ray;
import ru.ipo.kio._12.diamond.model.Spectrum;

public class Eye extends Sprite {

    [Embed(source='../resources/Eye_m.png', mimeType='image/png')]
    public static const EYE_IMAGE_CLASS:Class;

    [Embed(source='../resources/Canon.png', mimeType='image/png')]
    public static const LASER_IMAGE_CLASS:Class;

    private static const canon_x0:int = 149;
    private static const canon_y0:int = 147;

    private static const img_x0:int = 63;
    private static const img_y0:int = 55;

    //                |----------------|
    //                | ^              |
    //         d0     | |              |
    //     *<-------->| | h            |
    //    EYE         | |              |
    //                | v      w       |
    //                |<-------------->|

    private static var field_d0:Number = 25;
    private static const field_w:Number = 30;
    private static const field_h:Number = 30;
    private static const field_scale:Number = 10;

    private static const rays_extra_width:Number = 5;
    private static const rays_extra_height:Number = 5;

    private static var level_1_x_min:Number = field_d0;

    public static const MIN_ANGLE:Number = -Math.PI / 6;
    public static const MAX_ANGLE:Number = +Math.PI / 6;

    private var _angle:Number;

    private var _scaler:LinearScaler;

    private var _level:int;

    private var rays_layer:Sprite = null;

    private var diamond:Diamond;
    public static const ANGLE_CHANGED:String = 'ANGLE CHANGED';
    private static const ANGLE_CHANGED_EVENT:Event = new Event(ANGLE_CHANGED);
    private var _all_out_points:Array;
    
    private var laser_sprite:Sprite;

    public function Eye(diamond:Diamond, level:int) {
        _level = level;

        if (level == 2) {
            field_d0 += 3;
        } else {
            field_d0 += 5;
            level_1_x_min = field_d0;
        }

        this.diamond = diamond;

        var dx:Number = 0;
        var dy:Number = (field_h + rays_extra_height) * field_scale / 2;

        _scaler = new LinearScaler(field_scale, field_scale, dx, dy);

        var diamond_view:DiamondView = new DiamondView(
                diamond,
                field_d0,
                -field_h / 2,
                field_d0 + field_w,
                +field_h / 2,
                _scaler
        );
        diamond_view.x = 0;
        diamond_view.y = 0;

        if (_level == 2) {
            var mainImage:DisplayObject = new EYE_IMAGE_CLASS;
            mainImage.x = dx - img_x0;
            mainImage.y = dy - img_y0;
            addChild(mainImage);
        } else {
            laser_sprite = new Sprite();
            var laser_image:DisplayObject = new LASER_IMAGE_CLASS;
            laser_image.x = - canon_x0;
            laser_image.y = - canon_y0;
            laser_sprite.addChild(laser_image);
            laser_sprite.x = dx;
            laser_sprite.y = dy;
            addChild(laser_sprite);

            var matrix:Matrix = new Matrix();
            matrix.scale(1/3, 1/3);
            matrix.translate(dx, dy);
            laser_sprite.transform.matrix = matrix;
        }

        graphics.beginFill(0x000000);
        graphics.drawRect(
                0,
                0,
                (field_d0 + field_h + rays_extra_width) * field_scale,
                (field_w + rays_extra_height) * field_scale
        );
        graphics.endFill();

        _angle = 0;

        diamond.addEventListener(Diamond.UPDATE, function(e:Event):void {
            update();
        });
        
        addEventListener(MouseEvent.MOUSE_DOWN, mouse_change_angle);
        addEventListener(MouseEvent.MOUSE_MOVE, mouse_change_angle);

        addChild(diamond_view);
        
        //draw circle
        var s:Sprite = new Sprite();
        s.graphics.lineStyle(0.5, 0x888888);
        var c_center:Point = _scaler.vertex2point(new Vertex2D(field_d0 + field_w / 2, 0));

        addChild(s);

        if (level == 1) {
            graphics.lineStyle(1, 0xFFFFFF);
            var p:Point = _scaler.vertex2point(new Vertex2D(level_1_x_min, - field_h / 2 - rays_extra_height / 2));
            graphics.moveTo(p.x, p.y);
            p = _scaler.vertex2point(new Vertex2D(field_d0 + field_h + rays_extra_width, - field_h / 2 - rays_extra_height / 2));
            graphics.lineTo(p.x, p.y);
            p = _scaler.vertex2point(new Vertex2D(field_d0 + field_h + rays_extra_width, field_h / 2 + rays_extra_height / 2));
            graphics.lineTo(p.x, p.y);
            p = _scaler.vertex2point(new Vertex2D(level_1_x_min, field_h / 2 + rays_extra_height / 2));
            graphics.lineTo(p.x, p.y);
        }

        update();
    }

    private function mouse_change_angle(event:MouseEvent):void {
        if (!event.buttonDown)
            return;
        
        var v:Vertex2D = _scaler.point2vertex(new Point(event.localX, event.localY));
        
        if (v.x >= field_d0 - 2)
            return;

        var new_angle:Number = Math.atan2(v.y, v.x);

        if (new_angle < MIN_ANGLE || new_angle > MAX_ANGLE)
            return;

        angle = new_angle;
    }

    public function set angle(value:Number):void {
        value = Math.max(value, MIN_ANGLE);
        value = Math.min(value, MAX_ANGLE);

        _angle = value;

        if (_level == 1) {
            var dx:Number = 0;
            var dy:Number = (field_h + rays_extra_height) * field_scale / 2;

            var matrix:Matrix = new Matrix();
            matrix.scale(1/3, 1/3);
            matrix.rotate(_angle);
            matrix.translate(dx, dy);
            laser_sprite.transform.matrix = matrix;
        }

        update();

        dispatchEvent(ANGLE_CHANGED_EVENT);
    }


    public function get angle():Number {
        return _angle;
    }

    private function update():void {
        if (rays_layer != null) {
            removeChild(rays_layer);
            rays_layer = null;
        }

        //code duplication with spectrum
        var ray:Ray = new Ray(
                null,
                new Vertex2D(0, 0),
                new Vertex2D(Math.cos(_angle), Math.sin(_angle)),
                false,
                -1,
                1
        );

        rays_layer = new Sprite();

        _all_out_points = [];
        for (var col:int = 0; col <= 2; col ++) {
            ray.recurse_bild_rays(diamond.hull, 1/(Diamond.ETA + 0.01 * col));

            var ray_color_layer:Sprite = new Sprite();

            add_all_rays(ray, ray_color_layer, Spectrum.COLORS[col]);

            rays_layer.addChild(ray_color_layer);
        }

        addChildAt(rays_layer, 0);
    }

    private function add_all_rays(ray:Ray, s:Sprite, color:uint):void {
        var vr:VisibleRay = new VisibleRay(ray, _scaler, color,
                0,
                - field_h / 2 - rays_extra_height / 2,
                field_d0 + field_h + rays_extra_width,
                field_h / 2 + rays_extra_height / 2,
                _level
        );

        s.addChild(vr);

        var oi:Vertex2D = vr.outer_intersection;
        if (oi != null && oi.x >= level_1_x_min && _level == 1) {
            _all_out_points.push(oi);
            var point:Point = _scaler.vertex2point(oi);
            s.graphics.beginFill(color, 0.5);
            s.graphics.drawCircle(point.x, point.y, 5);
            s.graphics.endFill();
        }

        for (var i:int = 0; i <= 1; i++) {
            var rr:Ray = ray.get_reflect_refract_ray(i);
            if (rr != null)
                add_all_rays(rr, s, color);
        }
    }
    
    public function get spectrum():Spectrum {
        return new Spectrum(diamond, MIN_ANGLE, MAX_ANGLE);
    }

    public function evaluate_outer_intersections():Object {
        if (_all_out_points.length == 0)
            return {points:0, variance:1};
        
        var x_min:Number = level_1_x_min;
        var x_max:Number = field_d0 + field_h + rays_extra_width;
        var y_min:Number = - field_h / 2 - rays_extra_height / 2;
        var y_max:Number = + field_h / 2 + rays_extra_height / 2;
        var eps:Number = 1e-6;
        
        //sort points
        var p:Array = new Array(_all_out_points.length);
        for (var i:int = 0; i < _all_out_points.length; i++) {
            var v:Vertex2D = _all_out_points[i];
            if (Math.abs(v.y - y_min) < eps)
                p[i] = v.x - x_min;
            else if (Math.abs(v.x - x_max) < eps)
                p[i] = x_max - x_min + v.y - y_min;
            else
                p[i] = x_max - x_min + y_max - y_min + x_max - v.x;
        }
        
        var sum:Number = 0;
        var sum2:Number = 0;
        for (i = 0; i < p.length; i++) {
            sum += p[i];
            sum2 += p[i] * p[i];
        }
        
        return {
            points: p.length,
            variance: Math.sqrt(sum2 / p.length - sum * sum / (p.length * p.length))
        };
    }
}
}
