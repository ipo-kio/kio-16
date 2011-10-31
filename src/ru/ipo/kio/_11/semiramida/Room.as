/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 16.02.11
 * Time: 18:13
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.semiramida {
import flash.display.Shape;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

public class Room extends Shape {

    private var _highlight:Boolean;
//    private var _over:Shape;

    public function Room(house:House, floor:int, ind:int) {
        //floor 0 -> House.FLOORS + 1
        //ind 0 from left
        var rooms_on_floor:int = house.FLOORS - floor + 1;
        var floor_ind_from_top:int = house.FLOORS - floor - 1;

        /*
         var bd:BitmapData = new BitmapData(Resources.Flowers.bitmapData.width / rooms_on_floor, house.floorHeight);
         bd.copyPixels(
         Resources.Flowers.bitmapData,
         new Rectangle(
         ind * Resources.Flowers.bitmapData.width / rooms_on_floor,
         Resources.Flowers.bitmapData.width * floor_ind_from_top / house.FLOORS,
         bd.width,
         bd.height
         ),
         new Point(0, 0)
         );*/
        //TODO why room shifts down compared to the initial image?
        var m:Matrix = new Matrix();//Resources.Flowers.transform.matrix.clone();
        m.translate(-ind * house.house_width / rooms_on_floor, -floor_ind_from_top * house.floorHeight - 1);
        graphics.beginBitmapFill(Resources.Flowers2.bitmapData, m);
        graphics.lineStyle(0, 0, 0);
        graphics.drawRect(0, 0, house.house_width / rooms_on_floor, house.floorHeight);
        graphics.endFill();

        x = ind * house.house_width / rooms_on_floor;
        y = house.floorHeight * floor_ind_from_top;

        /*_over = new Shape;
        _over.x = 0;
        _over.y = 0;
        _over.graphics.beginFill(0x00FFFF, 0.3);
        _over.graphics.drawRect(0, 0, );
        addChild(_over);*/
    }


    public function get highlight():Boolean {
        return _highlight;
    }

    public function set highlight(value:Boolean):void {
        if (_highlight == value)
            return;

        _highlight = value;

        if (value)
            transform.colorTransform = new ColorTransform(1.2, 1.2, 1.2, 1, 0, 0, 0);
        else
            transform.colorTransform = new ColorTransform();

        /*if (value)
            filters = [BrightnessFilter(5/4)];
        else
            filters = [];*/
    }

}
}
