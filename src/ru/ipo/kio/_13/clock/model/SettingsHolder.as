/**
 * Бин для хранения настроек приложения
 *
 * Содержит настройки для отладки, специфицеские настройки для уровней хранятся в _levelImpl
 *
 * @author: Vasiliy
 * @date: 08.01.13
 */
package ru.ipo.kio._13.clock.model {
import ru.ipo.kio._13.clock.model.level.ITaskLevel;

public class SettingsHolder {

    public static const DOWN_TO_UP:int = 0;

    public static const UP_TO_DOWN:int = 1;

    private static var _instance:SettingsHolder;

    private var _sizeOfCog:int=15;
    
    public var crossZone:Number = 20;
    
    private var _stepRotate:Number=TransmissionMechanism.SLOW_SPEED;

    private var _maxDiv:Number=3;

    private var _levelImpl:ITaskLevel;
    
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

     public function get maxDiv():Number {
        return _maxDiv;
    }

    public function set maxDiv(value:Number):void {
        _maxDiv = value;
    }

    public function get direction():int {
        return _levelImpl.direction;
    }


    public function get levelImpl():ITaskLevel {
        if(_levelImpl==null){
            throw new Error("level implementation isn't registered");
        }
        return _levelImpl;
    }
    
    public function registerLevelImpl(levelImpl:ITaskLevel):void{
        if(_levelImpl!=null){
            throw new Error("level implementation is already registered");
        }
        _levelImpl = levelImpl;
    }
    
}
}

internal class PrivateClass{
    public function PrivateClass(){
    }
}

