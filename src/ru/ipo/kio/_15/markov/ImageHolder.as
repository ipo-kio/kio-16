/**
 * Created by Vasiliy on 21.02.2015.
 */
package ru.ipo.kio._15.markov {
import com.nerdbucket.ToolTip;

import fl.controls.Button;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.SimpleButton;

import flash.events.MouseEvent;
import flash.sampler.sampleInternalAllocs;

import ru.ipo.kio.api.controls.TextButton;

public class ImageHolder {

    [Embed(source="_resources/level0/vegetable_1.png")]
    public static const EMPTY:Class;

    [Embed(source="_resources/level0/vegetable_1_Over.png")]
    public static const EMPTY_OVER:Class;

    [Embed(source="_resources/level0/vegetable_1_Press.png")]
    public static const EMPTY_PRESS:Class;

    [Embed(source="_resources/level0/vegetable_1_Selected.png")]
    public static const EMPTY_SELECT:Class;

    [Embed(source="_resources/level0/vegetable_2.png")]
    public static const CARROT:Class;

    [Embed(source="_resources/level0/vegetable_2_Over.png")]
    public static const CARROT_OVER:Class;

    [Embed(source="_resources/level0/vegetable_2_Press.png")]
    public static const CARROT_PRESS:Class;

    [Embed(source="_resources/level0/vegetable_2_Selected.png")]
    public static const CARROT_SELECT:Class;

    [Embed(source="_resources/level0/vegetable_4.png")]
    public static const FLOWER:Class;

    [Embed(source="_resources/level0/vegetable_4_Over.png")]
    public static const FLOWER_OVER:Class;

    [Embed(source="_resources/level0/vegetable_4_Press.png")]
    public static const FLOWER_PRESS:Class;

    [Embed(source="_resources/level0/vegetable_4_Selected.png")]
    public static const FLOWER_SELECT:Class;

    [Embed(source="_resources/level0/vegetable_5.png")]
    public static const WEED:Class;

    [Embed(source="_resources/level0/vegetable_5_Over.png")]
    public static const WEED_OVER:Class;

    [Embed(source="_resources/level0/vegetable_5_Press.png")]
    public static const WEED_PRESS:Class;

    [Embed(source="_resources/level0/vegetable_5_Selected.png")]
    public static const WEED_SELECT:Class;


    public function ImageHolder() {
    }

    public static function getVegetable(code:String) {
     if(code=="c"){
         return new CARROT();
     }else if(code=="w"){
         return new WEED();
     }else if(code=="f"){
         return new FLOWER();
     }else {
         return new EMPTY();
     }
    }

    public static function getVegetableSelected(code:String) {
        if(code=="c"){
            return new CARROT_SELECT();
        }else if(code=="w"){
            return new WEED_SELECT();
        }else if(code=="f"){
            return new FLOWER_SELECT();
        }else {
            return new EMPTY_SELECT();
        }
    }

    public static function getVegetableOver(code:String) {
        if(code=="c"){
            return new CARROT_OVER();
        }else if(code=="w"){
            return new WEED_OVER();
        }else if(code=="f"){
            return new FLOWER_OVER();
        }else {
            return new EMPTY_OVER();
        }
    }


    public static function getVegetablePress(code:String) {
        if(code=="c"){
            return new CARROT_PRESS();
        }else if(code=="w"){
            return new WEED_PRESS();
        }else if(code=="f"){
            return new FLOWER_PRESS();
        }else {
            return new EMPTY_PRESS();
        }
    }

    public static function createButton(parent:DisplayObjectContainer, label:String, x:int, y:int, func, tip:String):SimpleButton {
        var button:TextButton = new TextButton(label, 50);

        button.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            func();
        });
        button.x = x;
        button.y = y;
        parent.addChild(button);
        ToolTip.attach(button,tip);
        return button;
    }
}
}
