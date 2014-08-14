/**
 * @author: Vasily Akimushkin
 * @since: 31.01.14
 */
package ru.ipo.kio._14.tarski {
import com.adobe.serialization.json.JSON_k;
import com.nerdbucket.ToolTip;

import fl.containers.ScrollPane;
import fl.controls.Button;

import flash.display.SimpleButton;

import flash.display.Stage;

import flash.net.FileReference;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.sampler.getSavedThis;
import flash.text.engine.TabAlignment;
import flash.utils.ByteArray;

import flashx.textLayout.container.ScrollPolicy;

import mx.controls.listClasses.BaseListData;

import mx.states.State;

import ru.ipo.kio._14.tarski.model.Configuration;

import ru.ipo.kio._14.tarski.model.ConfigurationHolder;
import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.Statement;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.editor.LogicItemProvider;
import ru.ipo.kio._14.tarski.model.editor.LogicItemProvider1;
import ru.ipo.kio._14.tarski.model.editor.LogicItemProvider2;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator1;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator2;
import ru.ipo.kio._14.tarski.model.parser.StatementParser1;
import ru.ipo.kio._14.tarski.model.parser.StatementParser2;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.ConfigsView;
import ru.ipo.kio._14.tarski.view.toolbox.ResultPanel;
import ru.ipo.kio._14.tarski.view.toolbox.ToolboxView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

import ru.ipo.kio.api.controls.TextButton;
import ru.ipo.kio.base.displays.ShellButton;

public class TarskiProblemFirst extends BasicView {

    private static var _instance:TarskiProblemFirst;


    public static function get instance():TarskiProblemFirst {
        return _instance;
    }

    [Embed(source="_resources/level1/bg.png")]
    private static const BACKGROUND:Class;

    private var _variableToolboxView:ToolboxView;

    private var _predicateToolboxView:ToolboxView;

    private var _operationToolboxView:ToolboxView;

    private var _logicItemProvider:LogicItemProvider;

    private var _statementManager:StatamentManager;

    private var _stage:Stage;

    private var _level:int;

    private var configView:ConfigsView = new ConfigsView();

    private var resultPanel:ResultPanel;


    public function get level():int {
        return _level;
    }

    private var _problem:KioProblem;

    [Embed(source="loc/Tarski.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    [Embed(source="loc/Tarski.th.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_TH:Class;

    private var _kioApi:KioApi;

    public function TarskiProblemFirst(level:int, stage:Stage, problem:KioProblem) {
        _instance=this;
        _stage=stage;
        _problem=problem;
        KioApi.registerLocalization(TarskiProblem.ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);
        KioApi.registerLocalization(TarskiProblem.ID, KioApi.L_TH, new Settings(LOCALIZATION_TH).data);


        ToolTip.init(stage, {textalign: 'center', opacity: 80, defaultdelay: 500});
        resultPanel= new ResultPanel(problem);
        var bg = new BACKGROUND;
        addChild(bg);
        addChild(configView);
        addChildTo(resultPanel,0,0);

        this._level = level;


        ConfigurationHolder.instance.init();

        _statementManager=new StatamentManager(level);

        _kioApi = KioApi.instance(problem);
        _logicItemProvider = new LogicItemProvider1(_kioApi);



        placeButtons(_logicItemProvider.variables, 16, 383, 28);
        placeButtons(list(_logicItemProvider.predicates,0,2), 136, 383, 28);
        placeButtons(list(_logicItemProvider.predicates,3,5), 240, 383, 28);
        placeButtons(list(_logicItemProvider.predicates,6,8), 344, 383, 28);
        placeButtons(list(_logicItemProvider.operations,0,2), 468, 383, 28);
        placeButtons(list(_logicItemProvider.operations,3,5), 570, 383, 28);
//        _variableToolboxView = new ToolboxView(_logicItemProvider.variables, 100);
//        _predicateToolboxView = new ToolboxView(_logicItemProvider.predicates, 300);
//        _operationToolboxView = new ToolboxView(_logicItemProvider.operations, 150);
//
//        _variableToolboxView.x=20;
//        _variableToolboxView.y=370;
//        addChild(_variableToolboxView);
//
//        _predicateToolboxView.x=20+_variableToolboxView.width+20;
//        _predicateToolboxView.y=370;
//        addChild(_predicateToolboxView);
//
//        _operationToolboxView.x=20+_variableToolboxView.width+20+_predicateToolboxView.width+20;
//        _operationToolboxView.y=370;
//        addChild(_operationToolboxView);




        addChild(_statementManager.view);

        var loadButton:ShellButton = new ShellButton("Загрузить");
        loadButton.x = 10;
        loadButton.y = 5;
//        addChild(loadButton);
        loadButton.addEventListener(MouseEvent.CLICK, function(e:Event):void{
            var fileRef:FileReference = new FileReference();
            fileRef.browse();
            fileRef.addEventListener(Event.SELECT, function(e:Event):void {
                fileRef.addEventListener(Event.COMPLETE, function(e:Event):void {
                    var data:ByteArray = fileRef.data;
                    var dataUTF:String = data.readUTFBytes(data.length);
                        ConfigurationHolder.instance.load(dataUTF);
                });
                fileRef.load();
            });
        });



        addChild(createPlainButton(_kioApi.localization.buttons.backspace, 678, 100+383, function(e:Event):void{statement.backspace();}));
        addChild(createPlainButton(_kioApi.localization.buttons.create, 678, 100+383+28, function(e:Event):void{_statementManager.addStatement();}));
        addChild(createPlainButton(_kioApi.localization.buttons.remove, 678, 100+383+28+28, function(e:Event):void{_statementManager.removeStatement();}));



        configView.update();

        KioApi.instance(problem).addEventListener(KioApi.RECORD_EVENT, recordChanged);
    }

    private function createPlainButton(label:String, x:int, y:int, f):SimpleButton{
        var removeButton:SimpleButton = new ShellButton(label);
        removeButton.x = x;
        removeButton.y = y;
        removeButton.addEventListener(MouseEvent.CLICK, f);
        return removeButton;
    }

    private function list(predicates:Vector.<LogicItem>, istart:int, iend:int):Vector.<LogicItem> {
        var list:Vector.<LogicItem> = new Vector.<LogicItem>();
        for(var i:int=istart; i<=iend; i++){
            list.push(predicates[i]);
        }
        return list;
    }

    private function placeButtons(items:Vector.<LogicItem>, xS:int, yS:int, ySpace:int):void {
        for (var i:int = 0; i < items.length; i++) {
            var button = createButton(items[i], xS, yS);
            yS += ySpace;
            ToolTip.attach(button, items[i].getTooltipText());
        }
    }



    private function createButton(item:LogicItem, x:int, y:int):Object {
        var button:Button = new Button();
        button.label = item.getToolboxText();
        addChild(button);
        button.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            TarskiProblemFirst.instance.statement.addLogicItem(item.getCloned());
        });
        button.x = x;
        button.y = y;
        button.width=93;
        return button;
    }

    public function getStage():Stage {
        return _stage;
    }



    public function get statementManager():StatamentManager {
        return _statementManager;
    }

    public function get statement():Statement {
        return _statementManager.statement;
    }

    public override function update():void{
        if(_statementManager!=null){
            _statementManager.update();
            configView.update();
            if(resultPanel!=null){
                resultPanel.updateResult(ConfigurationHolder.instance.getRightSelectionAmount()+"",TarskiProblemFirst.instance.statementManager.getLength()+"");
                KioApi.instance(_problem).autoSaveSolution();
                KioApi.instance(_problem).submitResult(TarskiProblem(KioApi.instance(_problem).problem).best);
            }
        }

    }

    private function recordChanged(event:Event):void {
        updateBest(KioApi.instance(_problem).record_result);
    }


    private function updateBest(result:Object):void {
        if(result!=null){
            resultPanel.updateBest(ConfigurationHolder.instance.getRightSelectionAmount()+"",TarskiProblemFirst.instance.statementManager.getLength()+"");
        }
    }


    public function get kioApi():KioApi {
        return _kioApi;
    }

    public function get problem():KioProblem {
        return _problem;
    }
}
}
