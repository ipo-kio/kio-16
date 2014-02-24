package ru.ipo.kio.api {
import com.adobe.serialization.json.JSON_k;

import flash.crypto.generateRandomBytes;

import flash.events.Event;
import flash.net.FileFilter;
import flash.net.FileReference;
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
                    problem.loadSolution(sol.solution);

                    var allLogs:Object = sol.logs;
                    var allIds:Array = [];
                    for (var machine_id:String in allLogs)
                        if (allLogs.hasOwnProperty(machine_id)) {
                            KioBase.instance.updateLog(machine_id, allLogs[machine_id]);
                            allIds.push(machine_id);
                        }
                    KioBase.instance.log("Loaded solution@tt", [sol.save_id, allIds.join(", ")]);
                } catch (error:Error) {
                    //TODO show error message
                }
            });
            fr.load();
        });
    }

    public static function saveSolution(problem:KioProblem):void {
        var fr:FileReference = new FileReference();
        var sol:Object = wrapSolutionToSave(problem.solution);

        fr.save(JSON_k.encode(sol), SOLUTION_FILE_NAME + inventDate() + ".kio-" + problem.id + "-" + KioBase.instance.level);

        KioBase.instance.log("Solution saved@tt", [sol.save_id, KioBase.instance.logId]);
    }

    private static function wrapSolutionToSave(solution:Object):Object {
        var result:Object = {
            solution: solution,
            save_id: DataUtils.convertByteArrayToString(generateRandomBytes(10)),
            machine_id: KioBase.instance.machineId,
            logs: KioBase.instance.getAllLoggers()
        };

        return result;
    }

    public static function saveAll():void {
        var fr:FileReference = new FileReference();
        var sol:Object = KioBase.instance.lsoProxy.userData;
        sol.save_id = DataUtils.convertByteArrayToString(generateRandomBytes(10));

        KioBase.instance.log("All solutions saved@tt", [sol.save_id, KioBase.instance.logId]);

        fr.save(JSON_k.encode(sol), RESULTS_FILE_NAME + inventDate() + ".kio-" + KioBase.instance.level);
    }

    public static function saveLog():void {
        var fr:FileReference = new FileReference();
        var log:String = 'total memory ' + KioBase.instance.lsoProxy.usedBytes + "\n";

        var all_logs:Object = KioBase.instance.allLogs;
        for (var log_id:String in all_logs) {
            if (!all_logs.hasOwnProperty(log_id))
                continue;

            var logData:Object = all_logs[log_id];

            log += "--------------------------------------------------------------\n";
//          log += "fadaa129-14422533008-70dda1-1442253281b-68\n"
            log += "        Machine  Time        RND    Time(user)  RND\n";
            log += "log id: " + log_id + "\n";
            //TODO add info about this id
            var info:Object = logData.machine_info;
            log += "OS:             " + info.os + "\n";
            log += "Manufacturer:   " + info.manufacturer + "\n";
            log += "CPU:            " + info.cpu + "\n";
            log += "Player version: " + info.version + "\n";
            log += "Language:       " + info.language + "\n";
            log += "Player type:    " + info.playerType + "\n";
            log += "DPI:            " + info.dpi + "\n";
            log += "Screen width:   " + info.screenWidth + "\n";
            log += "Screen height:  " + info.screenHeight + "\n";

            KioBase.instance.outputLog(function(time:Number, cmd:String, extraArgs:Array):void {
                var d:Date = new Date();
                d.setTime(time);
                log += time + ' | ' + d + ' | ' + cmd;

                if (extraArgs.length > 0)
                    for each (var arg:* in extraArgs)
                        log += "|" + arg;

                log += "\n";
            }, logData);
        }
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
                var save_id:String = allData.save_id;
                KioBase.instance.log("Loaded all solutions solution@t", [save_id]);
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