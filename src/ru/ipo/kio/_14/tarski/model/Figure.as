/**
 * Фигура в мире, имеет существующие свойства
 *
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model {
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.Colorable;
import ru.ipo.kio._14.tarski.model.properties.PlanePositionable;
import ru.ipo.kio._14.tarski.model.properties.Shapable;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.Sizable;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.construct.FigureView;

public class Figure implements Sizable, Shapable, Colorable, PlanePositionable{

    private var _x:int;

    private var _y:int;

    private var _color:ColorValue;

    private var _size:SizeValue;

    private var _shape:ShapeValue;

    private var _view:BasicView;

    private var _active:Boolean =  false;


    public function get active():Boolean {
        return _active;
    }

    public function set active(value:Boolean):void {
        _active = value;
    }

    public static function createFigureByCode(x:int, y:int, string:String):Figure{
        var colorCode:String = string.substr(0,1);
        var colorValue:ColorValue;
        if(colorCode=="b"){
            colorValue = ValueHolder.getColor(ColorValue.BLUE);
        }else if(colorCode=="r"){
            colorValue = ValueHolder.getColor(ColorValue.RED);
        }else{
            colorValue = ValueHolder.getColor(colorCode);
        }

        var sizeValue:SizeValue;
        var shapeValue:ShapeValue;

        var shapeCode:String = string.substr(1,1);
        if(shapeCode=="C"){
            sizeValue = ValueHolder.getSize(SizeValue.BIG);
            shapeValue = ValueHolder.getShape(ShapeValue.CUBE);
        }else if(shapeCode=="c"){
            sizeValue = ValueHolder.getSize(SizeValue.SMALL);
            shapeValue = ValueHolder.getShape(ShapeValue.CUBE);
        }else if(shapeCode=="S"){
            sizeValue = ValueHolder.getSize(SizeValue.BIG);
            shapeValue = ValueHolder.getShape(ShapeValue.SPHERE);
        }else if(shapeCode=="s"){
            sizeValue = ValueHolder.getSize(SizeValue.SMALL);
            shapeValue = ValueHolder.getShape(ShapeValue.SPHERE);
        }else{
            sizeValue = ValueHolder.getSize(shapeCode);
            shapeValue = ValueHolder.getShape(shapeCode);
        }

        return new Figure(x,y,colorValue,sizeValue,shapeValue);
    }


    public function get view():BasicView {
        return _view;
    }

    public static function createFigure(x:int, y:int, color:String, size:String, shape:String):Figure{
        var colorValue:ColorValue = ValueHolder.getColor(color);
        var sizeValue:SizeValue = ValueHolder.getSize(size);
        var shapeValue:ShapeValue = ValueHolder.getShape(shape);
        return new Figure(x,y,colorValue,sizeValue,shapeValue);
    }

    public function Figure(x:int, y:int, color:ColorValue, size:SizeValue, shape:ShapeValue) {
        _x = x;
        _y = y;
        _color = color;
        _size = size;
        _shape = shape;
        _view = new FigureView(this);
    }

    public function get x():int {
        return _x;
    }

    public function set x(value:int):void {
        _x = value;
    }

    public function get y():int {
        return _y;
    }

    public function set y(value:int):void {
        _y = value;
    }

    public function get color():ColorValue {
        return _color;
    }

    public function set color(value:ColorValue):void {
        _color = value;
    }

    public function get size():SizeValue {
        return _size;
    }

    public function set size(value:SizeValue):void {
        _size = value;
    }

    public function get shape():ShapeValue {
        return _shape;
    }

    public function set shape(value:ShapeValue):void {
        _shape = value;
    }


    public function toString():String {
        return _color.code.substr(0,1)+
                (_size.code==SizeValue.BIG?
                        _shape.code.substr(0,1).toUpperCase():
                        _shape.code.substr(0,1).toLowerCase());
    }
}
}
