/**
 * Генератор цветов для шестеренок
 *
 * @author: Vasiliy
 * @date: 01.01.13
 */
package ru.ipo.kio._13.clock.utils {


import ru.ipo.kio._13.clock.model.TransferGear;

public class ColorGenerator {
    
    public static var COLORS:Array = [0,30,60,120,180,240,270,300];
    
    public function ColorGenerator(pvt:PrivateClass) {
    }

    private static const HUE_SHIFT:int = 5;

    private static const MAX_ITERATION_THROUGH_COLORS:int = 6;

    public static function nextHueOfColor(hueList:Vector.<TransferGear>):int{
       for(var i:int = 0; i<MAX_ITERATION_THROUGH_COLORS; i++){
        for(var j:int=0; j<COLORS.length; j++){
           var hue:int = COLORS[j];
           if(!contains(hue+i*HUE_SHIFT, hueList)){
               return hue+i*HUE_SHIFT;
           }
        }
       }
       //слишком жестко, просто генерим рандом 
       //throw new Error("Too mush colors");
       return COLORS[Math.floor(Math.random()*COLORS.length)];
    }

    private static function contains(hue:int, hueList:Vector.<TransferGear>):Boolean {
      for(var i:int = 0; i<hueList.length; i++){
          var transferGear:TransferGear = hueList[i];
           if(transferGear.hue==hue){
               return true;
           }
        }
        return false;
    }
    
   
}
}

internal class PrivateClass{
    public function PrivateClass(){
    }
}
