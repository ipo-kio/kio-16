/**
 * Created by ilya on 22.03.15.
 */
package ru.ipo.kio._15.spider {
import com.adobe.serialization.json.JSON_k;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.utils.ByteArray;
import flash.utils.Timer;

public class SpiderChecker extends Sprite {

    private var timer:Timer;

    private var filesToProcess:Array;
    private var file:FileReference;
    private var level:int;
    private var solutions:Vector.<String> = null;
    private var text:String = "";
    private var spiderMotion:SpiderMotionNoView;
    private var waitLoadingFile:Boolean = false;

    public function SpiderChecker() {
        var frl:FileReferenceList = new FileReferenceList();

        frl.addEventListener(Event.SELECT, frl_select_handler);
        frl.addEventListener(Event.CANCEL, function (e:Event):void {
            trace('cancel');
        });

        frl.browse();

        var finalSave:FileReference = new FileReference();
        addEventListener(Event.ADDED_TO_STAGE, function (e:Event):void {
            stage.addEventListener(MouseEvent.CLICK, function(e:Event):void {
                if (text != "") {
                    finalSave.addEventListener(Event.SELECT, function(e:Event):void {
                        trace(finalSave.name);
                        trace('saved');
                    });
                    finalSave.addEventListener(Event.CANCEL, function(e:Event):void {
                        trace('cancelled saving')
                    });
                    finalSave.save(text, "checked-externally-" + level + "-spider.txt");
                }
            });
        });
    }

    private function frl_select_handler(event:Event):void {
        var frl:FileReferenceList = FileReferenceList(event.target);
        filesToProcess = frl.fileList;

        timer = new Timer(10, 0);
        timer.addEventListener(TimerEvent.TIMER, tick);
        timer.start();
    }

    private function tick(event:TimerEvent):void {
        if (waitLoadingFile)
            return;

        if (solutions == null || solutions.length == 0) {
            processNewFile();
            return;
        }
        if (solutions != null)
            processNewSolution();
    }

    private function processNewFile():void {
        if (filesToProcess.length == 0) {
            stop();

            trace(text); //TODO also, save file here
            return;
        }

        file = filesToProcess.pop();
        file.addEventListener(Event.COMPLETE, file_loaded_handler);
        file.load();
        waitLoadingFile = true;

        solutions = null;
        text = "";
    }

    private function processNewSolution():void {
        var solution_as_text:String = solutions.pop();
        var solution:Object = JSON_k.decode(solution_as_text);

        var result:Object = check(solution, spiderMotion);
        if (result == null) {
            trace('incorrect solution processed, solutions left', solutions.length);
            return;
        }

        text += solution_as_text + "\n";
        text += JSON_k.encode(result) + "\n";
        trace('solution processed, solutions left', solutions.length);
    }

    private function stop():void {
        timer.stop();
        trace("stopped");
    }

    private function file_loaded_handler(event:Event):void {
        var file:FileReference = FileReference(event.target);
        trace('file loaded: ' + file.name);
        waitLoadingFile = false;

        if (file.name.indexOf('0') >= 0)
            level = 0;
        else if (file.name.indexOf('1') >= 0)
            level = 1;
        else if (file.name.indexOf('2') >= 0)
            level = 2;
        trace('level', level);

        spiderMotion = new SpiderMotionNoView(level);

        solutions = new <String>[];

        var data:ByteArray = file.data;
        var lines:Array = data.readUTFBytes(data.length).split('\n');
        for (var i:int = 0; i < lines.length; i++) {
            var line:String = lines[i];
            if (line != "")
                solutions.push(line);
        }
    }

    private function check(solution:Object, spiderMotion:SpiderMotionNoView):Object {
        var ls:* = solution.ls;
        if ('fixed' in ls)
            return null;

        if (level == 0 && ls.length != 7 || level == 1 && ls.length != 10 || level == 2 && ls.length != 12) {
            trace('wrong length');
            return null;
        }

        spiderMotion.ls = Vector.<Number>(ls);
        var result:Object = spiderMotion.result;
        return result;
    }
}
}
