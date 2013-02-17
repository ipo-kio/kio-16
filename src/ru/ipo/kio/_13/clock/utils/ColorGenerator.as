/**
 *
 * @author: Vasiliy
 * @date: 01.01.13
 */
package ru.ipo.kio._13.clock.utils {


import ru.ipo.kio._13.clock.model.TransferGear;

public class ColorGenerator {
    
    public static var COLORS:Array = [0,30,60,120,180,240,270,300];
    
    public function ColorGenerator() {
    }

    public static function nextHueOfColor(hueList:Vector.<TransferGear>):int{
       for(var i:int = 0; i<6; i++){
        for(var j:int=0; j<COLORS.length; j++){
           var hue:int = COLORS[j];
           if(!contains(hue+i*5, hueList)){
               return hue+i*5;
           }
        }
       }
       throw new Error("Too mush colors"); 
       return 0; 
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
