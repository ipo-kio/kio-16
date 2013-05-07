package ru.ipo.kio.base {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.PressAndTapGestureEvent;
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
import ru.ipo.kio.base.logdebug.LogDebugger;
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

    private var _version_config:Object;

    private var spaceSettings:SpaceSettingsDialog = null;

    private var _allowLogDebugger:Boolean = false;
    private var logDebugger:LogDebugger = new LogDebugger();
    private var logDebuggerDisplay:Sprite = null;

    [Embed(source="resources/version-config.json-settings", mimeType="application/octet-stream")]
    public static var VERSION_CONFIG:Class;

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
        _version_config = new Settings(VERSION_CONFIG).data;

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

        stage.stage.scaleMode = 'noScale';
    }

    public function init(stage:DisplayObjectContainer, problems:Array, year:int, level:int):void {
        basicInitialization(level, year, stage, problems);

        if(allowLogDebugger){
            stage.addEventListener(Event.ENTER_FRAME, function(e:Event):void{
                logDebugger.tick();
            });
        }
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
    }

    private var _mouseKeyboardLoggersInitialized:Boolean = false;
    public function initMouseKeyboardLoggers():void {
        if (_version_config.log_mouse_and_keyboard_level == 0)
            return;

        if (_mouseKeyboardLoggersInitialized)
            return;
        else
            _mouseKeyboardLoggersInitialized = true;

        if (_version_config.log_mouse_and_keyboard_level == 2)
            stage.addEventListener(MouseEvent.MOUSE_MOVE, logMouseEvent, false, 10);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, logMouseEvent, false, 10);
        stage.addEventListener(MouseEvent.MOUSE_UP, logMouseEvent, false, 10);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, logKeyboardEvent, false, 10);
        stage.addEventListener(KeyboardEvent.KEY_UP, logKeyboardEvent, false, 10);
    }

    private function logMouseEvent(event:MouseEvent):void {
        log('mouse event ' + event.type + '@ii', [event.stageX, event.stageY]);
    }

    private function logKeyboardEvent(event:KeyboardEvent):void {
        log('keyboard event ' + event.type + '@II', [event.keyCode, event.charCode]);
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
        addDebuggerIfNeeded(stage);

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

        KioApi.instance(problem).resetRecordResult();
        if (best)
            problem.loadSolution(best);
    }

    /**
     * Добавляет спрайт отладчика под рабочей областью
     * @param stage
     */
    private function addDebuggerIfNeeded(stage:DisplayObjectContainer):void {
        if (!logDebuggerDisplay && _allowLogDebugger) {
            logDebuggerDisplay = logDebugger.display;
            logDebuggerDisplay.x = GlobalMetrics.WORKSPACE_X;
            logDebuggerDisplay.y = GlobalMetrics.DEBUGGER_Y;
            stage.addChild(logDebuggerDisplay);
        }
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

        addDebuggerIfNeeded(stage);

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
        if (logDebuggerDisplay) {
            stage.removeChild(logDebuggerDisplay);
            logDebuggerDisplay = null;
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

        if (global.log.data.position != global.log.data.length)
            global.log.data.position = global.log.data.length;
    }

    public function log(msg:String, extraArguments:Array):void {
        initLogger(); //TODO init only on start

        var lso:LsoProxy = lsoProxy;
        var global:Object = lso.getGlobalData();
        var logger:Object = global.log;
        var log:ByteArray = logger.data;

        if (log.length > 2 * 1024 * 1024) //don't log more than 2 mbs
            return;

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

        //log extra arguments if any
        var spec:String = getLogSpecification(msg);
        var specFail:String = null;
        if (spec != null)
            specFail = writeSpec(log, spec, extraArguments);

        logger.last_log_time = passed;

        if (specFail != null)
            throw new IllegalOperationError(specFail);
    }

    private static function getLogSpecification(msg:String):String {
        var atIndex:int = msg.lastIndexOf('@');
        if (atIndex >= 0)
            return msg.substring(atIndex + 1);
        else
            return null;
    }

    private static function writeSpec(log:ByteArray, spec:String, arguments:Array):String {
        var fail:String = null;

        if (spec.length != arguments.length)
            fail = "Spec and arguments sizes do not match";

        for (var i:int = 0; i < spec.length; i++) {
            var sp:String = spec.charAt(i);
            var arg:*;
            if (i >= arguments.length)
                arg = sp == 't' ? '' : 0;
            else
                arg = arguments[i];

            switch (sp) {
                case 'i':
                    log.writeInt(arg);
                    break;
                case 'I':
                    log.writeUnsignedInt(arg);
                    break;
                case 'b':
                case 'B':
                    log.writeByte(arg);
                    break;
                case 's':
                case 'S':
                    log.writeShort(arg);
                    break;
                case 't':
                    log.writeUTF(arg);
                    break;
                default:
                    fail = "Unknown specifier " + sp + " in the log specification";
            }
        }

        return fail;
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

    public function outputLog(callback:Function, log:Object = null):void {
        if (log == null) {
            var globalData:Object = lsoProxy.getGlobalData();
            var log:Object = globalData.log;

            if (log == null)
                return;
        }

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
            if (command == null)
                throw new IllegalOperationError("Unknown command in log");

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

                    var extraArguments:Array;
                    var spec:String = getLogSpecification(command);
                    if (spec != null)
                        extraArguments = readExtraArguments(spec, data);
                    else
                        extraArguments = [];

                    //filter command
                    var at_pos:int = command.lastIndexOf('@');
                    if (at_pos >= 0)
                        command = command.substring(0, at_pos).replace(/\s+$/g, ''); //replace = trim right

                    callback(time, command, extraArguments);
            }
        }

        data.position = pos;
    }

    private static function readExtraArguments(spec:String, data:ByteArray):Array {
        var result:Array = [];
        for (var i:int = 0; i < spec.length; i++)
            switch (spec.charAt(i)) {
                case 'i':
                    result.push(data.readInt());
                    break;
                case 'I':
                    result.push(data.readUnsignedInt());
                    break;
                case 'b':
                    result.push(data.readByte());
                    break;
                case 'B':
                    result.push(data.readUnsignedByte());
                    break;
                case 's':
                    result.push(data.readShort());
                    break;
                case 'S':
                    result.push(data.readUnsignedShort());
                    break;
                case 't':
                    result.push(data.readUTF());
                    break;
            }

        return result;
    }

    public function addLogDebuggerHandler(handler:ILogDebuggerHandler){
        logDebugger.addHandler(handler);
    }

    public function get version_config():Object {
        return _version_config;
    }


    public function get allowLogDebugger():Boolean {
        return _allowLogDebugger;
    }

    public function set allowLogDebugger(value:Boolean):void {
        _allowLogDebugger = value;
    }
}
}