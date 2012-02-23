/**
 *
 * @author: Vasily Akimushkin
 * @since: 17.02.12
 */
package ru.ipo.kio._12.train {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.util.TrafficNetworkCreator;

import ru.ipo.kio.api.KioApi;

public class TrainSprite extends Sprite
{

    [Embed(source='_resources/Background.png')]
    private static const LEVEL_1_BACKGROUNG:Class;

    public function TrainSprite(level:int, readonly:Boolean, id:String = null)
    {
        var api:KioApi = KioApi.instance(id ? id : TrainProblem.ID);

        //Делаем спрайт размерои с рабочую область
        graphics.lineStyle(1,0xffffff);
        graphics.lineTo(776,578);

        
        if(level ==1 ){
          var background = new LEVEL_1_BACKGROUNG;
          background.x=130;
          background.y=0;
          addChild(background);

          addChild(TrafficNetwork.instance.view);
        }
        
//       if (!readonly)
//            textField.type = TextFieldType.INPUT;
//
//        textField.addEventListener(Event.CHANGE, function(e:Event):void {
//            api.autoSaveSolution();
//        });


        addButton('Clear routes', 20, 20, function(event:MouseEvent){TrafficNetwork.instance.clearRoutes()});
        addButton('Remove last rail', 20, 60, function(event:MouseEvent){TrafficNetwork.instance.removeLastFromActive()});
        addButton('Play', 20, 120, function(event:MouseEvent){TrafficNetwork.instance.play()});
        addButton('Step', 20, 160, function(event:MouseEvent){TrafficNetwork.instance.step()});
        addButton('Calc result', 20, 200, function(event:MouseEvent){TrafficNetwork.instance.calc()});
        addButton('Initial state', 20, 240, function(event:MouseEvent){TrafficNetwork.instance.initial()});


        var tf:TextField = new TextField();
        tf.backgroundColor = 0xffffff;
        tf.background = true;
        tf.x = 20;
        tf.y = 300;
        tf.width=100;
        addChild(tf);
        TrafficNetworkCreator.instance.result=tf;
    }
    
    function addButton(text:String, x:int, y:int, func:Function):void{
        var clear:Sprite = getTextButton(text);
        addChild(clear);
        clear.addEventListener(MouseEvent.CLICK, func);
        clear.x = x;
        clear.y = y;
    }


    function getTextButton(label:String):Sprite{
        var txt:TextField = new TextField();
        txt.defaultTextFormat = new TextFormat('Verdana',10,0x000000);
        txt.text = label;
        txt.autoSize = TextFieldAutoSize.LEFT;
        txt.background = txt.border = true;
        txt.selectable = false;
        var btn:Sprite = new Sprite();
        btn.mouseChildren = false;
        btn.addChild(txt);
        btn.buttonMode = true;
        return btn;
    }


}

}