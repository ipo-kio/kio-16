package ru.ipo.kio.base {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.utils.ByteArray;
import flash.utils.Timer;

import ru.ipo.kio.api.*;
import ru.ipo.kio.api.controls.SpaceSettingsDialog;
import ru.ipo.kio.base.displays.DisplayUtils;
import ru.ipo.kio.base.displays.MultipleUsersWelcomeDisplay;
import ru.ipo.kio.base.displays.OneUserWelcomeDisplay;
import ru.ipo.kio.base.displays.ProblemsDisplay;
import ru.ipo.kio.base.displays.WelcomeDisplay;
import ru.ipo.kio.base.resources.Resources;

/**
 * ...
 * @author Ilya
 */
public class KioBase {

    public static const BASE_API_ID:String = "kio-base";
    private static const FLUSH_TIMER_DELAY:int = 10000; //10 seconds
    private static var _instance:KioBase;

    private var _currentProblem:KioProblem;

    private var workspace:DisplayObject = null;
    private var contestPanel:DisplayObject = null;
    private var stage:DisplayObjectContainer;
    //noinspection JSMismatchedCollectionQueryUpdateInspection
    private var problems:Array /*KioProblem*/ = [];

    private var _lsoProxy:LsoProxy;
    private var _level:int;
    private var _problems_bg:DisplayObject;
    private var _problem_header:TextField = null;

    private var spaceSettings:SpaceSettingsDialog = null;

    [Embed(source="loc/shell.ru.json-settings", mimeType="application/octet-stream")]
    public static var SHELL_RU:Class;
    [Embed(source="loc/shell.es.json-settings", mimeType="application/octet-stream")]
    public static var SHELL_ES:Class;
    [Embed(source="loc/shell.bg.json-settings", mimeType="application/octet-stream")]
    public static var SHELL_BG:Class;
    [Embed(source="loc/shell.en.json-settings", mimeType="application/octet-stream")]
    public static var SHELL_EN:Class;
    [Embed(source="loc/shell.th.json-settings", mimeType="application/octet-stream")]
    public static var SHELL_TH:Class;

    public function KioBase() {
        KioApi.registerLocalization(BASE_API_ID, KioApi.L_RU, new Settings(SHELL_RU).data);
        KioApi.registerLocalization(BASE_API_ID, KioApi.L_ES, new Settings(SHELL_ES).data);
        KioApi.registerLocalization(BASE_API_ID, KioApi.L_BG, new Settings(SHELL_BG).data);
        KioApi.registerLocalization(BASE_API_ID, KioApi.L_EN, new Settings(SHELL_EN).data);
        KioApi.registerLocalization(BASE_API_ID, KioApi.L_TH, new Settings(SHELL_TH).data);
    }

    private function basicInitialization(level:int, year:int, stage:DisplayObjectContainer, problems:Array):void {
        _level = level;
        _lsoProxy = LsoProxy.getInstance(level, year);

        this.stage = stage;
        this.problems = problems;

        _problems_bg = new Resources.BG_PR_IMAGE;
        _problems_bg.visible = false;
        stage.addChild(_problems_bg);

        var flush_timer:Timer = new Timer(FLUSH_TIMER_DELAY);
        flush_timer.addEventListener(TimerEvent.TIMER, function (event:Event):void {
            _lsoProxy.flush();
        });
    }

    public function init(stage:DisplayObjectContainer, problems:Array, year:int, level:int):void {
        basicInitialization(level, year, stage, problems);

        //test this is the first start
        switch (_lsoProxy.userCount()) {
            case 0:
                currentDisplay = new WelcomeDisplay;
                break;
            case 1:
                currentDisplay = new OneUserWelcomeDisplay;
                break;
            default:
                currentDisplay = new MultipleUsersWelcomeDisplay;
                break;
        }
    }

    public function initOneProblem(stage:DisplayObjectContainer, problem:KioProblem):void {
        basicInitialization(problem.level, problem.year, stage, [problem]);

        //this index will be needed in setting of current problem
        _lsoProxy.setOneProblemDebugRegime();
        currentProblem = problem;

        stage.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent):void {
            if (event.altKey && event.ctrlKey && event.keyCode == 'L'.charCodeAt())
                FileUtils.saveLog();
        });
    }

    public function checkProblem(stage:DisplayObjectContainer, problem:KioProblem, data:*):void {
        //TODO here is some copy paste from various other functions
        _level = problem.level;
        _lsoProxy = LsoProxy.getInstance(problem.level, problem.year);
        _lsoProxy.userIndex = 0;

        this.stage = stage;
        this.problems = null;

        if (!_problems_bg) {
            _problems_bg = new Resources.BG_PR_IMAGE;
            _problems_bg.visible = false;
        }

        _currentProblem = problem;

        if (workspace)
            stage.removeChild(workspace);

        if (!contestPanel) {
            contestPanel = new ContestPanel;
            contestPanel.x = GlobalMetrics.CONTEST_PANEL_X;
            contestPanel.y = GlobalMetrics.CONTEST_PANEL_Y;
            stage.addChild(contestPanel);
        }

        //load data

        //some unnecessary checks
        if (!data.kio_base)
            return;
        if (!data.kio_base.level && data.kio_base.level !== 0)
            return;
        if (data.kio_base.level != _level)
            return;

        _lsoProxy.userData = data;

        //place problem view on the screen
        workspace = problem.display;
        workspace.x = GlobalMetrics.WORKSPACE_X + Math.floor((GlobalMetrics.WORKSPACE_WIDTH - workspace.width) / 2);
        workspace.y = GlobalMetrics.WORKSPACE_Y + Math.floor((GlobalMetrics.WORKSPACE_HEIGHT - workspace.height) / 2);
        workspace.visible = false;
        stage.addChild(workspace);

        //load autosave solution
        var problemData:Object = _lsoProxy.getProblemData(problem.id);

        var best:Object = problemData.best;

        if (best)
            problem.loadSolution(best);
    }

    public static function get instance():KioBase {
        if (!_instance)
            _instance = new KioBase;
        return _instance;
    }

    public function get currentProblem():KioProblem {
        return _currentProblem;
    }

    public function set currentProblem(problem:KioProblem):void {
        _currentProblem = problem;

        if (workspace)
            stage.removeChild(workspace);

        if (!contestPanel) {
            contestPanel = new ContestPanel;
            contestPanel.x = GlobalMetrics.CONTEST_PANEL_X;
            contestPanel.y = GlobalMetrics.CONTEST_PANEL_Y;
            stage.addChild(contestPanel);
        }

        _problems_bg.visible = true;

        //place problem view on the screen
        workspace = problem.display;
        workspace.x = GlobalMetrics.WORKSPACE_X + Math.floor((GlobalMetrics.WORKSPACE_WIDTH - workspace.width) / 2);
        workspace.y = GlobalMetrics.WORKSPACE_Y + Math.floor((GlobalMetrics.WORKSPACE_HEIGHT - workspace.height) / 2);
        stage.addChild(workspace);

        if (_problem_header) {
            stage.removeChild(_problem_header);
            _problem_header = null;
        }
        _problem_header = DisplayUtils.placeHeader(stage, problem);

        //load autosave solution
        var problemData:Object = _lsoProxy.getProblemData(problem.id);

        var best:Object = problemData.best;
        var autoSave:Object = problemData.autoSave;

        if (best)
            problem.loadSolution(best);

        if (autoSave)
            problem.loadSolution(autoSave);
    }

    public function set currentDisplay(display:Sprite):void {
        _currentProblem = null;

        if (workspace)
            stage.removeChild(workspace);
        if (contestPanel) {
            stage.removeChild(contestPanel);
            contestPanel = null;
        }

        _problems_bg.visible = false;

        workspace = display;
        workspace.x = 0;
        workspace.y = 0;
        stage.addChild(workspace);

        if (_problem_header) {
            stage.removeChild(_problem_header);
            _problem_header = null;
        }
    }

    public function get lsoProxy():LsoProxy {
        return _lsoProxy;
    }

    public function complainLSO():void {
        if (!spaceSettings) {
            spaceSettings = new SpaceSettingsDialog;
            stage.addChild(spaceSettings);
        } else {
            stage.setChildIndex(spaceSettings, stage.numChildren - 1);
        }
    }

    public function LSOConcernResolved():void {
        if (spaceSettings)
            stage.removeChild(spaceSettings);
        spaceSettings = null;
    }

    public function setProblem(pind:int):void {
        currentProblem = problems[pind];
    }

    public function problem(ind:int):KioProblem {
        return problems[ind];
    }

    //TODO rewrite
    public function loadAllData(data:*):void {
        if (!data.kio_base)
            return;
        if (!data.kio_base.level && data.kio_base.level !== 0)
            return;
        if (data.kio_base.level != _level)
            return;

        var lso:LsoProxy = KioBase.instance.lsoProxy;
        lso.userData = data;

        if (_currentProblem)
            currentProblem = _currentProblem;
        else
            currentDisplay = new ProblemsDisplay;
    }

    public function get level():int {
        return _level;
    }

    //logging

    private static const MSG_1_BYTE_MAX:int = 250;
    private static const LOG_CMD_TIMESTAMP:String = 'timestamp';
    private static const LOG_CMD_TIME_BYTE:String = 'time-byte';

    private function initLogger():void {
        var lso:LsoProxy = lsoProxy;
        var global:Object = lso.getGlobalData();

        if (!global.log) {
            global.log = {
                dict: {},
                data: new ByteArray,
                next_msg_code: 0,
                last_log_start: 0, //milliseconds accurate log start (after the program loaded)
                last_log_time: 0 //last logged value, accurate to 10 ms
            };
            lso.flush();
        }

        global.log.data.position = global.log.data.length;
    }

    public function log(msg:String):void {
        initLogger(); //TODO init only on start

        var lso:LsoProxy = lsoProxy;
        var global:Object = lso.getGlobalData();
        var logger:Object = global.log;
        var log:ByteArray = logger.data;

        var now:Number = new Date().getTime();

        //time passed from last log
        var passed:Number = now - logger.last_log_start; //passed from last log start
        passed = Math.round(passed / 10);
        //try to convert to two bytes
        var deltaTime:Number = passed - logger.last_log_time;
        if (deltaTime >= 16777216) { //3 bytes
            writeCommandToLog(LOG_CMD_TIMESTAMP);
            log.writeDouble(now);
            logger.last_log_start = now;
            logger.last_log_time = 0;
            deltaTime = 0;
            passed = 0;
        } else if (deltaTime >= 65536) { //2 bytes
            writeCommandToLog(LOG_CMD_TIME_BYTE);
            log.writeByte(deltaTime / 65536);
            deltaTime %= 65536;
        }

        writeCommandToLog(msg);
        log.writeShort(deltaTime);

        logger.last_log_time = passed;
    }

    private function writeCommandToLog(msg:String):void {
        var log:Object = lsoProxy.getGlobalData().log;

        if (!Object(log.dict).hasOwnProperty(msg))
            log.dict[msg] = log.next_msg_code++;
        var code:int = log.dict[msg];

        if (code < MSG_1_BYTE_MAX) //TODO make a constant
            log.data.writeByte(code);
        else { // 250 -> 250, 0    251 -> 250, 1 .... 250 + 255 -> 250, 255, 250 + 256 -> 251, 0
            var rst:int = code - MSG_1_BYTE_MAX;
            log.data.writeByte(MSG_1_BYTE_MAX + int(rst / 256));
            log.data.writeByte(rst % 256);
        }
    }

    public function __debug_resetLogTime():void {
        var globalData:Object = lsoProxy.getGlobalData();
        var log:Object = globalData.log;
        log.last_log_start = 0;
        log.last_log_time = 0;
    }

    public function outputLog(callback:Function):void {
        var globalData:Object = lsoProxy.getGlobalData();
        var log:Object = globalData.log;

        if (log == null)
            return;

        var data:ByteArray = log.data;
        var pos:uint = data.position;

        data.position = 0;
        var last_log_start:Number = 0;
        var last_log_time:Number = 0;

        var inverseDict:Array = [];

        for (var key:String in log.dict)
            if (log.dict.hasOwnProperty(key))
                inverseDict[log.dict[key]] = key;

        var timeByte:int = 0;
        while (data.bytesAvailable > 0) {
            //read command

            var cmd:int = data.readUnsignedByte();
            if (cmd >= MSG_1_BYTE_MAX) {
                var rst:int = data.readUnsignedByte();
                cmd = MSG_1_BYTE_MAX + (cmd - MSG_1_BYTE_MAX) * 256 + rst;
            }

            var command:String = inverseDict[cmd];

            switch (command) {
                case LOG_CMD_TIME_BYTE:
                    timeByte = data.readUnsignedByte();
                    continue;
                case LOG_CMD_TIMESTAMP:
                    timeByte = 0;
                    last_log_start = data.readDouble();
                    last_log_time = 0;
                    continue;
                default:
                    last_log_time += data.readUnsignedShort() + timeByte * 65536;
                    timeByte = 0;
                    var time:Number = 10 * last_log_time + last_log_start;
                    callback(time, command);
            }
        }

        data.position = pos;
    }

}
}