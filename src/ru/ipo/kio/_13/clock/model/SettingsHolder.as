/**
 *
 * @author: Vasiliy
 * @date: 08.01.13
 */
package ru.ipo.kio._13.clock.model {
public class SettingsHolder {
    
    public static const DOWN_TO_UP:int = 0;
    
    public static const UP_TO_DOWN:int = 1;

    private static var _instance:SettingsHolder;

    private var _sizeOfCog:int=15;
    
    public var crossZone:Number = 20;
    
    private var _stepRotate:Number=2;

    private var _maxDiv:Number=3;

    private var _direction:int = UP_TO_DOWN;
    
    public static function get instance():SettingsHolder {
        if(SettingsHolder._instance == null)
            SettingsHolder._instance=new SettingsHolder(new PrivateClass( ));
        return _instance;
    }

    public function SettingsHolder(pvt:PrivateClass) {
    }

    public function isDownToUp():Boolean{
        return direction==DOWN_TO_UP;
    }


    public function get sizeOfCog():int {
        return _sizeOfCog;
    }

    public function set sizeOfCog(value:int):void {
        _sizeOfCog = value;
    }

    public function set stepRotate(stepRotate:Number):void {
        _stepRotate = stepRotate;
    }

    public function get stepRotate():Number {
        return _stepRotate;
    }

    public function get stepRotateInRadians():Number {
        return _stepRotate*Math.PI/180;
    }

    public function get direction():int {
        return _direction;
    }

    public function set direction(value:int):void {
        _direction = value;
    }


    public function get maxDiv():Number {
        return _maxDiv;
    }

    public function set maxDiv(value:Number):void {
        _maxDiv = value;
    }
}
}

internal class PrivateClass{
    public function PrivateClass(){
    }
}

