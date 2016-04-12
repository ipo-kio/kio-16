package ru.ipo.kio.base {
import com.adobe.serialization.json.JSON_k;

import flash.display.Sprite;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.utils.ByteArray;
import flash.utils.Timer;

import ru.ipo.kio._16.mars.MarsChecker;

import ru.ipo.kio._16.mower.MowerChecker;
import ru.ipo.kio._16.rockgarden.RockGardenChecker;

[SWF(width=800, height=600)]
public class ExternalProblemCheckerRunner extends Sprite {
    private var timer:Timer;

    private var filesToProcess:Array;
    private var level:int;
    private var problemId:String;
    private var solutions:Vector.<String> = null;
    private var text:String = "";
    private var waitLoadingFile:Boolean = false;

    private var checker:ExternalProblemChecker;
    
    private var textArea:TextField = new TextField();

    private var loadingFileReference:FileReferenceList;
    private var savingFileReference:FileReference = new FileReference();

    public function clickToBrowse(e:Event):void {
        loadingFileReference.browse();
        textArea.removeEventListener(MouseEvent.CLICK, clickToBrowse);
    }

    public function ExternalProblemCheckerRunner() {
        initTextArea();
        
        loadingFileReference = new FileReferenceList();

        loadingFileReference.addEventListener(Event.SELECT, frl_select_handler);
        loadingFileReference.addEventListener(Event.CANCEL, function (e:Event):void {
            log('cancel');
        });

        textArea.addEventListener(MouseEvent.CLICK, clickToBrowse);

        /*var finalSave:FileReference = new FileReference();
        addEventListener(Event.ADDED_TO_STAGE, function (e:Event):void {
            stage.addEventListener(MouseEvent.CLICK, function(e:Event):void {
                if (text != "") {
                    finalSave.addEventListener(Event.SELECT, function(e:Event):void {
                        log(finalSave.name);
                        log('saved');
                    });
                    finalSave.addEventListener(Event.CANCEL, function(e:Event):void {
                        log('cancelled saving')
                    });
                    finalSave.save(text, "checked-externally-" + level + "-" + problemId + ".txt");
                }
            });
        });*/
    }

    private function initTextArea():void {
        textArea = new TextField();
        textArea.width = 800;
        textArea.height = 600;
        textArea.background = true;
        textArea.backgroundColor = 0xAAAAAA;
        textArea.multiline = true;
        textArea.type = TextFieldType.DYNAMIC;
        addChild(textArea);
    }
    
    private function log(message:String):void {
        textArea.appendText(message);
        textArea.appendText("\n");
        textArea.scrollV = textArea.maxScrollV;
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

            log(text); //TODO also, save file here
            saveFile("checked-externally-" + level + "-" + problemId + ".txt", text);
            return;
        }

        var file:FileReference = filesToProcess.pop();
        file.addEventListener(Event.COMPLETE, file_loaded_handler);
        file.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void {
            log("error loading " + file.name);
        });
        file.load();
        waitLoadingFile = true;

        log('process new file ' + file.name);

        solutions = null;
        text = "";
    }

    private function saveFile(fileName:String, text:String):void {
        savingFileReference.addEventListener(Event.COMPLETE, function (e:Event):void {
            log("saving complete");
        });
        savingFileReference.addEventListener(Event.SELECT, function (e:Event):void {
            log("selected...");
        });
        savingFileReference.addEventListener(Event.OPEN, function (e:Event):void {
            log("opened...");
        });
        savingFileReference.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
            log("saving error " + e.errorID);
        });
        log("click to save");
        textArea.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            log("saving after clicked to save");
            savingFileReference.save(text, fileName);
        });
    }

    private static function getCheckerById(level:int, problemId:String):ExternalProblemChecker {
        switch (problemId) {
            case "mars":
                return new MarsChecker(level);
            case "mower":
                return new MowerChecker(level);
            case "rockgarden":
                return new RockGardenChecker(level);
        }
        return null;
    }

    private function processNewSolution():void {
        var solution_as_text:String = solutions.pop();
        var solution:Object = JSON_k.decode(solution_as_text);

        var result:Object = check(solution);
        if (result == null) {
            log('incorrect solution processed, solutions left' + solutions.length);
            return;
        }

        text += solution_as_text + "\n";
        text += JSON_k.encode(result) + "\n";
        log('solution processed, solutions left ' + solutions.length);
    }

    private function stop():void {
        timer.stop();
        log("stopped");
    }

    private function file_loaded_handler(event:Event):void {
        var file:FileReference = FileReference(event.target);
        log('file loaded: ' + file.name);
        waitLoadingFile = false;

        if (file.name.indexOf('0') >= 0)
            level = 0;
        else if (file.name.indexOf('1') >= 0)
            level = 1;
        else if (file.name.indexOf('2') >= 0)
            level = 2;
        log('level ' + level);

        problemId = file.name.substring(file.name.lastIndexOf('-') + 1, file.name.lastIndexOf('.'));

        checker = getCheckerById(level, problemId);
        log("getting checker " + level + problemId);

        solutions = new <String>[];

        var data:ByteArray = file.data;
        var lines:Array = data.readUTFBytes(data.length).split('\n');
        for (var i:int = 0; i < lines.length; i++) {
            var line:String = lines[i];
            if (line != "")
                solutions.push(line);
        }
    }

    private function check(solution:Object):Object {
        checker.solution = solution;
        var result:Object = checker.result;
        return result;
    }

}
}

