/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 17.02.12
 * Time: 16:43
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;

import ru.ipo.kio._12.diamond.Vertex2D;

import ru.ipo.kio._12.diamond.model.Diamond;

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

    private static const min_angle:int = - Math.PI / 4;
    private static const max_angle:int = + Math.PI / 4;
    
    private var _angle:Number;

    private var _scaler:LinearScaler;

    private var rays_layer:DisplayObject = null;

    public function Eye(diamond:Diamond) {
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
        addChild(mainImage);

        addChild(diamond_view);

        graphics.beginFill(0x000000);
        graphics.drawRect(
                0,
                - rays_extra_height * field_scale / 2,
                (field_d0 + field_h + rays_extra_width) * field_scale,
                (field_w + rays_extra_height) * field_scale
        );
        graphics.endFill();
        
        update();
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

        var rays_bd:BitmapData = new BitmapData(field_W, field_H);

        var v1:Vertex2D = new Vertex2D(0, 0);
        var v2:Vertex2D = new Vertex2D(30, 10);

        var p1:Point = _scaler.vertex2point(v1);
        var p2:Point = _scaler.vertex2point(v2);

        trace(p1.x + ', ' + p1.y);
        trace(p2.x + ', ' + p2.y);

        //RayDrawUtils.drawRay(rays_bd, p1, p2, 0xFFFF0000, 0.5);

        var s:Sprite = new Sprite();

        var s1:Sprite = new Sprite();
        var s2:Sprite = new Sprite();

        s1.graphics.lineStyle(3, 0xFF0000);
        s1.graphics.moveTo(p1.x, p1.y);
        s1.graphics.lineTo(p2.x, p2.y);

        s2.graphics.lineStyle(10, 0x00FF00);
        s2.graphics.moveTo(p1.x, p1.y);
        s2.graphics.lineTo(p2.x, p2.y);

        s1.blendMode = BlendMode.ADD;
        s2.blendMode = BlendMode.ADD;

        s.addChild(s1);
        s.addChild(s2);

        rays_layer = s;//new Bitmap(rays_bd);

        addChild(rays_layer);
    }

}
}
