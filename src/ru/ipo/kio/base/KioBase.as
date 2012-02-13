package ru.ipo.kio.base {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.text.TextField;

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
    private static var _instance:KioBase;

    private var _currentProblem:KioProblem;

    private var workspace:DisplayObject = null;
    private var contestPanel:DisplayObject = null;
    private var stage:DisplayObjectContainer;
    //noinspection JSMismatchedCollectionQueryUpdateInspection
    private var problems:Array /*KioProblem*/ = new Array;

    private var _lsoProxy:LsoProxy;
    private var _level:int;
    private var _problems_bg:DisplayObject;
    private var _problem_header:TextField = null;

    private var spaceSettings:SpaceSettingsDialog = null;

    [Embed(source="loc/shell.ru.json-settings",mimeType="application/octet-stream")]
    public static var SHELL_RU:Class;
    [Embed(source="loc/shell.es.json-settings",mimeType="application/octet-stream")]
    public static var SHELL_ES:Class;
    [Embed(source="loc/shell.bg.json-settings",mimeType="application/octet-stream")]
    public static var SHELL_BG:Class;

    public function KioBase() {
        KioApi.registerLocalization(BASE_API_ID, KioApi.L_RU, new Settings(SHELL_RU).data);
        KioApi.registerLocalization(BASE_API_ID, KioApi.L_ES, new Settings(SHELL_ES).data);
        KioApi.registerLocalization(BASE_API_ID, KioApi.L_BG, new Settings(SHELL_BG).data);
    }

    private function basicInitialization(level:int, year:int, stage:DisplayObjectContainer, problems:Array):void {
        _level = level;
        _lsoProxy = LsoProxy.getInstance(level, year);

        this.stage = stage;
        this.problems = problems;

        _problems_bg = new Resources.BG_PR_IMAGE;
        _problems_bg.visible = false;
        stage.addChild(_problems_bg);
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
        if (!data.kio_base.level)
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
        if (!data.kio_base.level)
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
}
}