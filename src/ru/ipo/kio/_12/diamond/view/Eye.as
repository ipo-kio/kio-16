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

import ru.ipo.kio._11.semiramida.SemiramidaProblem;

import ru.ipo.kio._12.diamond.Vertex2D;

import ru.ipo.kio._12.diamond.model.Diamond;
import ru.ipo.kio._12.diamond.model.Ray;

public class Eye extends Sprite {

    [Embed(source='../resources/eye.png', mimeType='image/png')]
    public static const EYE_IMAGE_CLASS:Class;

    private static const img_x0:int = 5;
    private static const img_y0:int = 15;

    //                |----------------|
    //                | ^              |
    //         d0     | |              |
    //     *<-------->| | h            |
    //    EYE         | |              |
    //                | v      w       |
    //                |<-------------->|

    private static const field_d0:Number = 20;
    private static const field_w:Number = 30;
    private static const field_h:Number = 30;
    private static const field_scale:Number = 10;

    private static const rays_extra_width:Number = 10;
    private static const rays_extra_height:Number = 10;

    //width and height of the overall field
    private static const field_W:Number = field_d0 + field_w + rays_extra_width;
    private static const field_H:Number = field_h + rays_extra_height;

    private static const min_angle:int = -Math.PI / 4;
    private static const max_angle:int = +Math.PI / 4;

    private var _angle:Number;

    private var _scaler:LinearScaler;

    private var rays_layer:Sprite = null;

    private var diamond:Diamond;

    public function Eye(diamond:Diamond) {

        this.diamond = diamond;

        var dx:Number = 0;
        var dy:Number = field_h * field_scale / 2;

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

        var mainImage:DisplayObject = new EYE_IMAGE_CLASS;
        mainImage.x = dx - img_x0;
        mainImage.y = dy - img_y0;

        graphics.beginFill(0x000000);
        graphics.drawRect(
                0,
                -rays_extra_height * field_scale / 2,
                (field_d0 + field_h + rays_extra_width) * field_scale,
                (field_w + rays_extra_height) * field_scale
        );
        graphics.endFill();

        _angle = 0;

        update();

        diamond.addEventListener(Diamond.UPDATE, function(e:Event):void {
            update();
        });

        addChild(mainImage);
        addChild(diamond_view);
    }

    public function set angle(value:Number):void {
        value = Math.max(value, min_angle);
        value = Math.min(value, max_angle);

        _angle = value;

        update();
    }


    public function get angle():Number {
        return _angle;
    }

    private function update():void {
        if (rays_layer != null) {
            removeChild(rays_layer);
            rays_layer = null;
        }

        var ray:Ray = new Ray(
                null,
                new Vertex2D(0, 0),
                new Vertex2D(Math.cos(_angle), Math.sin(_angle)),
                false,
                -1,
                1
        );

        rays_layer = new Sprite();

        for (var col:int = 0; col <= 2; col ++) {
            ray.recurse_bild_rays(diamond.hull, Diamond.ETA + 0.01 * col);

            var ray_color_layer:Sprite = new Sprite();

            add_all_rays(ray, ray_color_layer, 0xFF << (col * 8));

            rays_layer.addChild(ray_color_layer);
        }

        addChild(rays_layer);
    }

    private function add_all_rays(ray:Ray, s:Sprite, color:uint):void {
        s.addChild(new VisibleRay(ray, _scaler, color,
                0,
                - field_h / 2 - rays_extra_height / 2,
                field_d0 + field_h + rays_extra_width,
                field_h / 2 + rays_extra_height / 2)
        );

        for (var i:int = 0; i <= 1; i++) {
            var rr:Ray = ray.get_reflect_refract_ray(i);
            if (rr != null)
                add_all_rays(rr, s, color);
        }
    }

}
}
