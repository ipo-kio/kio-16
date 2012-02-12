/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio._12.train.model.TrafficNetwork;

import ru.ipo.kio._12.train.util.TrafficNetworkCreator;

public class Main extends Sprite {
    public function Main() {
        var trafficNetwork:TrafficNetwork = TrafficNetworkCreator.instance.createTrafficNetwork(/*"traffic.xml"*/);
        addChild(trafficNetwork.view);

        var removeLast:Sprite = getTextButton('Remove last rail');
        addChild(removeLast);
        removeLast.addEventListener(MouseEvent.CLICK, function(event:MouseEvent){
            TrafficNetwork.instance.removeLastFromActive();
        });
        removeLast.x = 600;
        removeLast.y = 100;


        var clear:Sprite = getTextButton('Clear routes');
        addChild(clear);
        clear.addEventListener(MouseEvent.CLICK, function(event:MouseEvent){
            TrafficNetwork.instance.clearRoutes();
        });
        clear.x = 600;
        clear.y = 130;


        var play:Sprite = getTextButton('Play!');
        addChild(play);
        play.addEventListener(MouseEvent.CLICK, function(event:MouseEvent){
            TrafficNetwork.instance.play();
        });
        play.x = 600;
        play.y = 160;

        var tf:TextField = new TextField();
        tf.x = 600;
        tf.y = 190;
        tf.width=200;
        addChild(tf);
        TrafficNetworkCreator.instance.result=tf;

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
