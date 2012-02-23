/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 17.02.12
 * Time: 22:32
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;

public class RayDrawUtils {

    public static function drawRay(bd:BitmapData, p1:Point, p2:Point, color:uint, percent:Number):void {
        var line_sprite:Sprite = new Sprite();

        line_sprite.graphics.lineStyle(2, color);
        line_sprite.graphics.moveTo(p1.x, p1.y);
        line_sprite.graphics.lineTo(p2.x, p2.y);

        bd.draw(line_sprite, null, new ColorTransform(percent, percent, percent), BlendMode.ADD);
    }

}
}
