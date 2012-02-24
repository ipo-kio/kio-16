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
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import ru.ipo.kio._12.diamond.GeometryUtils;
import ru.ipo.kio._12.diamond.Vertex2D;
import ru.ipo.kio._12.diamond.model.Ray;
import ru.ipo.kio._12.diamond.model.Spectrum;

public class VisibleRay extends Sprite {
    private var info_text:TextField; 
    
    private static function visible_energy(energy:Number):Number {
        return Math.pow(energy, 1/3);
//        return Math.pow((0.2 + energy) / 1.2, 1/3);
    }
    
    public function VisibleRay(ray:Ray, scaler:Scaler, color:uint, x_min:Number, y_min:Number, x_max:Number, y_max:Number) {
        var r2:Vertex2D = ray.r2;
        if (r2 == null) {
            var intersection:Array = GeometryUtils.intersect_ray_and_poly(ray.r0, ray.r1, [
                    new Vertex2D(x_min, y_min),
                    new Vertex2D(x_min, y_max),
                    new Vertex2D(x_max, y_max),
                    new Vertex2D(x_max, y_min)
            ], -1, false);
            if (intersection != null && intersection[0] != null)
                r2 = intersection[0];
            
            if (ray.is_internal)
                r2 = ray.r1;
        }

        var e:Number = visible_energy(ray.energy);
        color = Spectrum.multiply_color(color, e);

        if (r2 == null) {
            trace('ERROR #02ffe32');
            return;
        }

        var p1:Point = scaler.vertex2point(ray.r0);
        var p2:Point = scaler.vertex2point(r2);
        
        blendMode = BlendMode.ADD;
        graphics.lineStyle(2, color);
        graphics.moveTo(p1.x, p1.y);
        graphics.lineTo(p2.x, p2.y);

        //add text
        var number:Number = Math.round(ray.energy * 100);
        if (number == 0)
            return;

        var text_pos:Point = scaler.vertex2point(ray.r0.plus(r2).mul(0.5));
        var ray_p_from:Point = scaler.vertex2point(ray.r0);
        var ray_p_to:Point = scaler.vertex2point(r2);
        var ray_p_vec:Point = new Point(ray_p_to.x - ray_p_from.x, ray_p_to.y - ray_p_from.y);

        info_text = new TextField();
        info_text.text = number + '%';
        info_text.textColor = 0xFFFFFF;//color;
        info_text.autoSize = TextFieldAutoSize.CENTER;
//        info_text.
//        var tr:Matrix = new Matrix();
//        tr.translate(text_pos.x, text_pos.y);
//        tr.rotate(Math.PI);
//        tr.rotate(ray.r1.minus(ray.r0).angle);

//        info_text.transform.matrix = tr;
        
        var l:Number = Math.sqrt(ray_p_vec.x * ray_p_vec.x + ray_p_vec.y * ray_p_vec.y);
        
        info_text.x = text_pos.x - info_text.textWidth / 2 + 10 * ray_p_vec.y / l;
        info_text.y = text_pos.y - info_text.textHeight / 2 - 10 * ray_p_vec.x / l;
        
        info_text.visible = false;
        info_text.mouseEnabled = false;
        
        addChild(info_text);
        
        addEventListener(MouseEvent.ROLL_OVER, function (event:MouseEvent):void {
            info_text.visible = true;
        });

        addEventListener(MouseEvent.ROLL_OUT, function (event:MouseEvent):void {
            info_text.visible = false;
        });
    }
}
}
