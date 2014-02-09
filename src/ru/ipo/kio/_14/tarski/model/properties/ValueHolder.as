/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.properties {
import flash.utils.Dictionary;

public class ValueHolder {
    private static var dictionary:Dictionary=new Dictionary();

    public static function registerColor(colorValue:ColorValue):void{
        dictionary[colorValue.code]=colorValue;
    }

    public static function registerShape(shapeValue:ShapeValue):void{
        dictionary[shapeValue.code]=shapeValue;
    }

    public static function registerSize(sizeValue:SizeValue):void{
        dictionary[sizeValue.code]=sizeValue;
    }

    public static function getColor(code:String):ColorValue{
        var color:ColorValue = dictionary[code];
        if(color==null){
            registerColor(new ColorValue(code,"unknown", 0));
        }
        return dictionary[code];
    }

    public static function getShape(code:String):ShapeValue{
        var shape:ShapeValue = dictionary[code];
        if(shape==null){
            registerShape(new ShapeValue(code,"unknown"));
        }
        return dictionary[code];
    }

    public static function getSize(code:String):SizeValue{
        var size:SizeValue = dictionary[code];
        if(size==null){
            registerSize(new SizeValue(code,"unknown"));
        }
        return dictionary[code];
    }
}
}
