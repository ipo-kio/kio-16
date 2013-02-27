/**
 *
 * @author: Vasiliy
 * @date: 17.02.13
 */
package ru.ipo.kio._13.clock.view.gui {

import flash.display.MovieClip;
import flash.events.Event;

[Embed(source="../../_resources/level0/bird.swf#bird")]
public class Bird extends MovieClip {
    private var _looked:Boolean = true;

    private static const AMOUNT_OF_FRAMES:int = 24;

    public function Bird() {
        addEventListener(Event.ENTER_FRAME, function(e:Event):void{
          if(currentFrame==AMOUNT_OF_FRAMES){
              stop();
          }
        });


    }


    public function get looked():Boolean {
        return _looked;
    }

    public function set looked(value:Boolean):void {
        _looked = value;
    }
}
}

