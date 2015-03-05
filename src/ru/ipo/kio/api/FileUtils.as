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

                    var allLogs:Object = sol.logs;
                    var allIds:Array = [];
                    for (var machine_id:String in allLogs)
                        if (allLogs.hasOwnProperty(machine_id)) {
                            KioBase.instance.updateLog(machine_id, allLogs[machine_id]);
                            allIds.push(machine_id);
                        }
                    KioApi.instance(problem).log("Loading solution from file@ttt", sol.save_id, allIds.join(", "), JSON_k.encode(sol.solution));

                    problem.loadSolution(sol.solution);
                } catch (error:Error) {
                    //TODO show error message
                }
            });
            fr.load();
        });
    }

    public static function saveSolution(problem:KioProblem):void {
        var fr:FileReference = new FileReference();
        var problem_solution:Object = problem.solution;
        var sol:Object = wrapSolutionToSave(problem_solution);

        KioApi.instance(problem).log("Saving solution to file@ttt", sol.save_id, KioBase.instance.logId, JSON_k.encode(problem_solution));

        fr.save(JSON_k.encode(sol), SOLUTION_FILE_NAME + inventDate() + ".kio-" + problem.id + "-" + KioBase.instance.level);
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

        KioBase.instance.log("Saving all solutions to file@tt", [sol.save_id, KioBase.instance.logId]);

        fr.save(JSON_k.encode(sol), RESULTS_FILE_NAME + inventDate() + ".kio-" + KioBase.instance.level);
    }

    public static function saveLog():void {
        var fr:FileReference = new FileReference();

        var all_logs:Object = KioBase.instance.allLogs;

        var log:String = prettyPrintLog(all_logs);
        fr.save(log, "kio" + inventDate() + ".log");
    }

    public static function prettyPrintLog(logsList:Object):String {
        var lsoProxy:LsoProxy = KioBase.instance.lsoProxy;
        if (lsoProxy != null)
            var log:String = 'total memory ' + lsoProxy.usedBytes + "\n";
        else
            log = '';

        for (var log_id:String in logsList) {
            if (!logsList.hasOwnProperty(log_id))
                continue;

            var logData:Object = logsList[log_id];

            log  += "--------------------------------------------------------------\n";
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

        return log;
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
                /*} catch (error:Error) {
                    //TODO show error message
                    trace('failed to load all data');
                }*/
                KioBase.instance.loadAllData(allData);
            });
            fr.load();
        });
    }

}
}