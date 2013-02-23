package ru.ipo.kio.api {
import com.adobe.serialization.json.JSON_k;

import flash.events.Event;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.text.GridFitType;
import flash.utils.ByteArray;

import ru.ipo.kio.base.KioBase;

/**
 * ...
 * @author Ilya
 */
public class FileUtils {

    private static const SOLUTION_FILE_NAME:String = "solution";
    private static const RESULTS_FILE_NAME:String = "results";

    public static function loadSolution(problem:KioProblem):void {
        var fr:FileReference = new FileReference();

        var loc:Object = KioApi.getLocalization(KioBase.BASE_API_ID);

        fr.browse([
            new FileFilter(loc.files.solutions, "*.kio-" + problem.id + "-" + KioBase.instance.level),
            new FileFilter(loc.files.all_files, "*.*")
        ]);
        fr.addEventListener(Event.SELECT, function(e:Event):void {
            fr.addEventListener(Event.COMPLETE, function(e:Event):void {
                var data:ByteArray = fr.data;
                var solUTF:String = data.readUTFBytes(data.length);
                try {
                    var sol:Object = JSON_k.decode(solUTF);
                    problem.loadSolution(sol);
                } catch (error:Error) {
                    //TODO show error message
                }
            });
            fr.load();
        });
    }

    public static function saveSolution(problem:KioProblem):void {
        var fr:FileReference = new FileReference();
        var sol:Object = problem.solution;

        fr.save(JSON_k.encode(sol), SOLUTION_FILE_NAME + inventDate() + ".kio-" + problem.id + "-" + KioBase.instance.level);
    }

    public static function saveAll():void {
        var fr:FileReference = new FileReference();
        var sol:Object = KioBase.instance.lsoProxy.userData;
        fr.save(JSON_k.encode(sol), RESULTS_FILE_NAME + inventDate() + ".kio-" + KioBase.instance.level);
    }

    public static function saveLog():void {
        var fr:FileReference = new FileReference();
        var log:String = 'total memory ' + KioBase.instance.lsoProxy.usedBytes + "\n";
        KioBase.instance.outputLog(function(time:Number, cmd:String, extraArgs:Array):void {
            var d:Date = new Date();
            d.setTime(time);
            log += time + ' | ' + d + ' | ' + cmd;

            if (extraArgs.length > 0)
                for each (var arg:* in extraArgs)
                    log += "|" + arg;

            log += "\n";
        });
        fr.save(log, "kio" + inventDate() + ".log");
    }

    private static function inventDate():String {
        var d:Date = new Date();
        return '-' + /*dbl(d.getMonth()) + '-' +*/ dbl(d.getDay()) + "_" + dbl(d.getHours()) + '-' + dbl(d.getMinutes()) + '-' + dbl(d.getSeconds());
    }

    private static function dbl(x:int):String {
        var s:String = '' + x;
        while (s.length < 2)
            s = '0' + s;
        return s;
    }

    public static function loadAll():void {
        var fr:FileReference = new FileReference();

        var loc:Object = KioApi.getLocalization(KioBase.BASE_API_ID);

        fr.browse([
            new FileFilter(loc.files.results, "*.kio-" + KioBase.instance.level),
            new FileFilter(loc.files.all_files, "*.*")
        ]);
        fr.addEventListener(Event.SELECT, function(e:Event):void {
            fr.addEventListener(Event.COMPLETE, function(e:Event):void {
                var data:ByteArray = fr.data;
                var solUTF:String = data.readUTFBytes(data.length);
//                try {
                    var allData:* = JSON_k.decode(solUTF);
                    KioBase.instance.loadAllData(allData);
                /*} catch (error:Error) {
                    //TODO show error message
                    trace('failed to load all data');
                }*/
            });
            fr.load();
        });
    }

}
}