/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 28.01.13
 * Time: 19:54
 */
package ru.ipo.kio._13.cut {
import com.adobe.serialization.json.JSON_k;
import com.hurlant.util.Base64;

import flash.debugger.enterDebugger;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.net.SharedObject;
import flash.system.System;
import flash.text.TextField;
import flash.utils.ByteArray;
import flash.utils.Timer;

public class TestUTF extends Sprite {
    public function TestUTF() {

        testMemLeak();

        return;

        testByteArrayInLSO();

        return;

        var s:String = ''; //TODO report two unreachable codes
        for (var i:int = 128; i<=2047; i++)
            s += String.fromCharCode(i);
        trace('s.len =', s.length);
        var b:ByteArray = new ByteArray();
        b.writeUTFBytes(s);
        trace('bytes = ', b.length);

        var o:Object = {
//            x: 42
            s: s
        };
//        o[s] = s;

        var encode:String = JSON_k.encode(o);
        trace(encode);
        trace('encoding length', encode.length - 8);

        var x:int = 19/10;
        trace(x);
    }

    var t:TextField = new TextField();

    private function testMemLeak():void {
        t.x = 100;
        t.x = 100;
        t.text = 'Alles!';
        addChild(t);
        trace('memory', System.totalMemory);

        var tt:Timer = new Timer(1000);
        tt.addEventListener(TimerEvent.TIMER, t_timerHandler); //TODO report create event handler - does not test existance
        tt.start();
    }

    private function t_timerHandler(event:TimerEvent):void {
        for (var i:int = 0; i < 100000; i++) {
            var p:Point = new Point(i, i);
            if (i == 42)
                trace(p.x, p.y);
        }

        trace('memory', System.totalMemory);
        t.text = 'mem: ' + System.totalMemory;
    }

    private function testByteArrayInLSO():void {
        var local:SharedObject = SharedObject.getLocal("ru/ipo/kio/test-lso/");
        local.addEventListener(NetStatusEvent.NET_STATUS, function (event:Event):void {
            trace('net status handled');
            //TODO find out WHY this event was not triggered before. (google suggests it is just not triggered at all in linux)
        });

        local.clear();
        var data:Object = local.data;

        data.s = '';
        local.flush();
        var init:int = local.size;

        for (var i:int = 0; i < 100000; i++)
            data.s += String.fromCharCode(200);

        local.flush();
        trace(local.size - init);

        trace(JSON_k.encode(data.s).length);
        trace(JSON.stringify(data.s).length);

        var ba:ByteArray = new ByteArray();
        for (i = 0; i < 300; i++)
            ba.writeByte(i % 256);

        var enc:String = JSON_k.encode({
            'a' : ba,
            'b' : 42,
            'c' : {}
        });

        trace(enc);

        var o:Object = JSON_k.decode(enc);
        trace('o.a.len', o.a.length);
        trace('o.b', o.b);

        if (! o.d)
            trace('no d');

        trace(new Date());
    }

}
}
