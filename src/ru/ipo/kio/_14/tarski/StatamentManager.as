/**
 * @author: Vasily Akimushkin
 * @since: 21.02.14
 */
package ru.ipo.kio._14.tarski {
import fl.containers.ScrollPane;

import flash.display.Sprite;
import flash.utils.ByteArray;

import ru.ipo.kio._14.tarski.model.Configuration;

import ru.ipo.kio._14.tarski.model.ConfigurationHolder;

import ru.ipo.kio._14.tarski.model.Statement;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator1;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator2;
import ru.ipo.kio._14.tarski.model.parser.StatementParser1;
import ru.ipo.kio._14.tarski.model.parser.StatementParser2;
import flashx.textLayout.container.ScrollPolicy;

import ru.ipo.kio._14.tarski.utils.LogicItemUtils;

public class StatamentManager {

    private var _statementList:Vector.<Statement> = new Vector.<Statement>();

    private var _statement:Statement;

    private var _scrollPane:ScrollPane = new ScrollPane();

    private var _canvas:Sprite = new Sprite();

    private var _level:int;

    public function StatamentManager(level:int) {
        _level=level;


        _scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
        _scrollPane.x=6;
        _scrollPane.y=472;
        _scrollPane.width=670;
        _scrollPane.height=128;
        _scrollPane.scrollDrag=true;
        _scrollPane.source=_canvas;

        _canvas.x=0;
        _canvas.y=0;
        _scrollPane.source=_canvas;
        _scrollPane.refreshPane();

        addStatement();

    }

    public function activate(statement:Statement):void{
        deactivateAll();
        if(statement!=null){
        statement.active=true;
        }
        _statement=statement;
        statement.view.update();
    }

    public function deactivateAll():void{
        for(var i:int=0; i<_statementList.length; i++){
            _statementList[i].active=false;
            _statementList[i].view.update();
        }

    }


    public function addStatement(){
        var statementNew:Statement=new Statement(new StatementParser2(true), new Evaluator2());


        statementNew.view.x=0;
        statementNew.view.y=_statementList.length*40;


        _statementList.push(statementNew);

        activate(statementNew);

        _canvas.addChild(statementNew.view);
        statementNew.view.update();
        _scrollPane.refreshPane();
    }


    public function get statement():Statement {
        return _statement;
    }

    public function update():void{
        _canvas.graphics.beginFill(0xFFFFFF);
        _canvas.graphics.drawRect(0,0,_canvas.width,_canvas.height);
        _canvas.graphics.endFill();


        for(var i:int=0; i<_statementList.length; i++){
            _statementList[i].view.update();
        }
    }

    public function get scrollPane():ScrollPane {
        return _scrollPane;
    }


    public function get view():Sprite {
        return _scrollPane;
    }

    public function perseAndCheckAll():void {
        for(var i:int=0; i<_statementList.length; i++){
            _statementList[i].parse();
        }
        for(var i:int = 0; i<ConfigurationHolder.instance.rightExamples.length; i++){
            var rightConfiguration:Configuration = ConfigurationHolder.instance.rightExamples[i];
            rightConfiguration.correct=checkAll(rightConfiguration);
        }
        for(var j:int = 0; j<ConfigurationHolder.instance.wrongExamples.length; j++){
             var wrongConfiguration:Configuration = ConfigurationHolder.instance.wrongExamples[j];
            wrongConfiguration.correct=checkAll(wrongConfiguration);
        }

        TarskiProblemFirst.instance.update();
    }

    public function getStatementAsJson():Object{
      var result:Array = new Array();
        for(var i:int=0; i<_statementList.length; i++){
            result.push(LogicItemUtils.createString(_statementList[i].logicItems));
        }
      return result;

    }

    public function clearAll():void{
        while (_canvas.numChildren > 0) {
            _canvas.removeChildAt(0);
        }
        _statementList = new Vector.<Statement>();
        _statement=null;
         TarskiProblemFirst.instance.update();
    }

    public function load(statements:Array):void {
        clearAll();
       for(var i:int=0; i<statements.length; i++){
           addStatement();
           statement.load(LogicItemUtils.createItemList(statements[i]));
       }
        perseAndCheckAll();
    }

    private function checkAll(rightConfiguration:Configuration):Boolean {
        var result:Boolean = true;
        for(var i:int=0; i<_statementList.length; i++){
            result=result&&_statementList[i].check(rightConfiguration);
        }
        return result;
    }

    public function removeStatement(){
        if(statement!=null){
            var i:int = _statementList.indexOf(statement);
            _statementList.splice(i,1);


                while (_canvas.numChildren > 0) {
                    _canvas.removeChildAt(0);
                }
            for(var i:int=0; i<_statementList.length; i++){
                _statementList[i].view.y=i*40;
                _canvas.addChild(_statementList[i].view);
            }

        }
        perseAndCheckAll();
        TarskiProblemFirst.instance.update();
    }

    public function getLength():int{
        var result:int = 0;
        for(var i:int=0; i<_statementList.length; i++){
            result+= _statementList[i].logicItems.length;
        }
        return result;
    }


}
}
