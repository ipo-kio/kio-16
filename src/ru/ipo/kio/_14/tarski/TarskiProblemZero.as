/**
 * @author: Vasily Akimushkin
 * @since: 31.01.14
 */
package ru.ipo.kio._14.tarski {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.utils.ByteArray;

import mx.core.ByteArrayAsset;

import mx.utils.StringUtil;

import ru.ipo.kio._14.tarski.model.Configuration;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator2;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;
import ru.ipo.kio._14.tarski.model.parser.StatementParser2;
import ru.ipo.kio._14.tarski.utils.LogicItemUtils;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.construct.ResultPanel;
import ru.ipo.kio._14.tarski.view.statement.PlainLogicItemView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;
import ru.ipo.kio.base.displays.ShellButton;

/**
 * Спрайт для нулевого уровня
 */
public class TarskiProblemZero extends BasicView {


    [Embed(source="_resources/level0/bg_2.png")]
    private static const BACKGROUND:Class;

    [Embed(source="_resources/examples/statements2.txt", mimeType="application/octet-stream")]
    private static const STATEMENTS:Class;

    [Embed(source="_resources/examples/statements2th.txt", mimeType="application/octet-stream")]
    private static const STATEMENTS_TH:Class;

    private static var _instance:TarskiProblemZero;

    public static function get instance():TarskiProblemZero {
        return _instance;
    }

    /**
     * Список условий
     */
    private var _statements:Vector.<LogicEvaluatedItem> = new Vector.<LogicEvaluatedItem>();

    /**
     * Конфигурация фигурок
     */
    private var _configuration:Configuration = new Configuration(8,8);

    /**
     * Вычислитель условий
     */
    private var _evaluator:Evaluator2 = new Evaluator2();

    private var _problem:KioProblem;

    private var _resultPanel;

    [Embed(source="loc/Tarski.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    [Embed(source="loc/Tarski.th.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_TH:Class;

    public function TarskiProblemZero(problem:KioProblem) {
        _instance=this;
        KioApi.registerLocalization(TarskiProblem.ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);
        KioApi.registerLocalization(TarskiProblem.ID, KioApi.L_TH, new Settings(LOCALIZATION_TH).data);
        _resultPanel = new ResultPanel(problem);
        this._problem=problem;

        var bg = new BACKGROUND;
        addChild(bg);

        addChildTo(_resultPanel,500,200);
        addChildTo(_configuration.view,10,190);
        _configuration.view.update();

        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0,0,780,600);
        graphics.endFill();

        var byteArrayAsset:ByteArrayAsset;
        if(KioApi.language==KioApi.L_TH){
            byteArrayAsset = new STATEMENTS_TH;
        }else {
            byteArrayAsset = new STATEMENTS;
        }
        var text:String = byteArrayAsset.toString();
        load(text);

        update();

        var loadButton:ShellButton = new ShellButton("load");
//        addChildTo(loadButton,600,200);
        loadButton.addEventListener(MouseEvent.CLICK, function(e:Event):void{
            var fileRef:FileReference = new FileReference();
            fileRef.browse();
            fileRef.addEventListener(Event.SELECT, function(e:Event):void {
                fileRef.addEventListener(Event.COMPLETE, function(e:Event):void {
                    var data:ByteArray = fileRef.data;
                    var dataUTF:String = data.readUTFBytes(data.length);
                    load(dataUTF);
                });
                fileRef.load();
                update();
            });
        });

        KioApi.instance(problem).addEventListener(KioApi.RECORD_EVENT, recordChanged);
   }

    public function load(data:String){
        for(var i:int=0; i<_statements.length; i++){
            removeChild(_statements[i].getView());
        }
        _statements=new Vector.<LogicEvaluatedItem>();

        var lines:Array = data.split("\n");
        for(var i:int=0; i<lines.length; i++){
            lines[i]=StringUtil.trim(lines[i]);
            if(lines[i]==""){
                continue;
            }
            var parts:Array = lines[i].split(":");
            var item:LogicEvaluatedItem = new StatementParser2().parse(LogicItemUtils.createItemList(parts[0]));
            item.itemView = new PlainLogicItemView(item, parts[1]);
            _statements.push(item);
        }

        for(var i:int=0; i<_statements.length; i++){
            _statements[i].getView().y = 10+i*18;
            _statements[i].getView().x = 20;
            addChild(_statements[i].getView());
            _statements[i].getView().update();
        }
    }

    override public function update():void{
        checkAllStatements();
        _resultPanel.updateResult(getAmountOfCorrectStatements()+"",_configuration.figures.length+"");
        configuration.view.update();
        KioApi.instance(_problem).autoSaveSolution();
        KioApi.instance(_problem).submitResult(TarskiProblem(KioApi.instance(_problem).problem).best);
    }

    private function recordChanged(event:Event):void {
        updateBest(KioApi.instance(_problem).record_result);
    }

    private function updateBest(result:Object):void {
        if(result!=null){
            _resultPanel.updateBest(getAmountOfCorrectStatements()+"",_configuration.figures.length+"");
        }
    }

    private function checkAllStatements():void{
        for(var i:int=0; i<_statements.length; i++){
            _statements[i].correct = _evaluator.checkExample(_statements[i], configuration);
            _statements[i].getView().update();
        }
    }

    public function get configuration():Configuration {
        return _configuration;
    }

    public function getAmountOfCorrectStatements():int{
        var count:int=0;
        for(var i:int=0; i<_statements.length; i++){
            if(_statements[i].correct){
                count++;
            }
        }
        return count;
    }


    public function clearFigures():void {
        _configuration.clear();
        update();
    }
}
}
