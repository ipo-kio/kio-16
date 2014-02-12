/**
 * Условие мира
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model {

import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.TarskiSprite;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator;
import ru.ipo.kio._14.tarski.model.parser.StatementParser;
import ru.ipo.kio._14.tarski.model.predicates.Variable;
import ru.ipo.kio._14.tarski.model.predicates.VariablePlaceHolder;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;
import ru.ipo.kio._14.tarski.model.predicates.BasePredicate;
import ru.ipo.kio._14.tarski.model.predicates.OnePlacePredicate;
import ru.ipo.kio._14.tarski.model.predicates.TwoPlacePredicate;
import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;
import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.statement.Delimiter;
import ru.ipo.kio._14.tarski.view.statement.StatementViewFree;

public class Statement {

    private var parser:StatementParser;

    private var checker:Evaluator;

    private var _finished:Boolean=false;

    private var _view:BasicView;

    private var _logicResulted:LogicEvaluatedItem;

    private var _activePlaceHolder:VariablePlaceHolder;

    private var _activeDelimiter:Delimiter;

    private var _activeVariable:Variable;

    private var _logicItems:Vector.<LogicItem> = new Vector.<LogicItem>();

    private var _lastItem:LogicItem;

    public function Statement(parser:StatementParser, checker:Evaluator) {
        this.parser=parser;
        this.checker=checker;
        _view=  new StatementViewFree(this);
    }


    public function get finished():Boolean {
        return _finished;
    }

    public function addLogicItem(logicItem:LogicItem):void{

        if(_activeDelimiter!=null){
            if(_activeDelimiter.beforeItem==null){
                logicItems.unshift(logicItem);
            }else{
                logicItems.splice(logicItems.indexOf(_activeDelimiter.beforeItem)+1, 0, logicItem);
            }
            _lastItem=logicItem;
            if(logicItem is Variable){
                activeVariable = Variable(logicItem);
            }else if(logicItem is OnePlacePredicate){
                activePlaceHolder = (OnePlacePredicate(logicItem)).placeHolder;
            }else if(logicItem is TwoPlacePredicate){
                activePlaceHolder = (TwoPlacePredicate(logicItem)).placeHolder1;
            }else if(logicItem is Quantifier){
                activePlaceHolder = (Quantifier(logicItem)).placeHolder;
            }

        }else if(_activeVariable!=null && (logicItem is BasePredicate || logicItem is Quantifier)){
            if(logicItem is OnePlacePredicate){
                (OnePlacePredicate(logicItem)).placeHolder.variable=_activeVariable;
                logicItems.splice(logicItems.indexOf(_activeVariable), 1, logicItem);
                activeVariable=null;
            }
            if(logicItem is TwoPlacePredicate){
                (TwoPlacePredicate(logicItem)).placeHolder1.variable=_activeVariable;
                logicItems.splice(logicItems.indexOf(_activeVariable), 1, logicItem);
                activePlaceHolder=(TwoPlacePredicate(logicItem)).placeHolder2;
            }
            if(logicItem is Quantifier){
                (Quantifier(logicItem)).placeHolder.variable=_activeVariable;
                logicItems.splice(logicItems.indexOf(_activeVariable), 1, logicItem);
                activeVariable=null;
            }
            _lastItem=logicItem;
        }else if(_activePlaceHolder!=null && logicItem is Variable){
            if(_activePlaceHolder.predicate is OnePlacePredicate){
                _activePlaceHolder.variable= Variable(logicItem);
                _lastItem=_activePlaceHolder.predicate;
                activePlaceHolder=null;
            }else if (_activePlaceHolder.predicate is Quantifier){
                _activePlaceHolder.variable= Variable(logicItem);
                _lastItem=_activePlaceHolder.predicate;
                activePlaceHolder=null;
            }else if(_activePlaceHolder.predicate is TwoPlacePredicate){
                _activePlaceHolder.variable= Variable(logicItem);
                if(((TwoPlacePredicate)(_activePlaceHolder.predicate)).placeHolder1==_activePlaceHolder){
                    activePlaceHolder=((TwoPlacePredicate)(_activePlaceHolder.predicate)).placeHolder2;
                }else{
                    _lastItem=_activePlaceHolder.predicate;
                    activePlaceHolder=null;
                }
            }
        }

        _logicResulted=null;

        try{
            _logicResulted=parser.parse(logicItems);
        }catch (e:Error){
            //не распарсили и фиг с ним
        }

        _finished=false;

        if(_logicResulted!=null){
            _logicResulted.commit();
            if(_logicResulted.canBeEvaluated()){
                _finished=true;
                check();
            }
        }
        _view.update();

    }




    private function clearActive():void{
        if(_activeDelimiter!=null){
            _activeDelimiter.active=false;
            _activeDelimiter.update();
            _activeDelimiter=null;
        }
        if(_activeVariable!=null){
            _activeVariable.active=false;
            _activeVariable.getView().update();
            _activeVariable=null;
        }
        if(_activePlaceHolder!=null){
            _activePlaceHolder.active=false;
            _activePlaceHolder.view.update();
            _activePlaceHolder=null;
        }
    }

    public function set activeDelimiter(value:Delimiter):void {
        clearActive();
        _activeDelimiter = value;
        if(_activeDelimiter!=null){
            _activeDelimiter.active=true;
            _activeDelimiter.update();
        }
    }

    public function set activeVariable(value:Variable):void {
        clearActive();
        _activeVariable=value
        if(_activeVariable!=null){
            _activeVariable.active=true;
            _activeVariable.getView().update();
        }
    }

    public function set activePlaceHolder(value:VariablePlaceHolder):void {
        clearActive();
        _activePlaceHolder=value;
        if(_activePlaceHolder!=null){
            _activePlaceHolder.active=true;
            _activePlaceHolder.view.update();
        }
    }

    public function backspace():void{
        if(_activeDelimiter!=null && _activeDelimiter.beforeItem!=null){
            var index:int = logicItems.indexOf(_activeDelimiter.beforeItem);
            logicItems.splice(index, 1);
            if(index>0){
                _lastItem=_logicItems[index-1];
            }


            _logicResulted=null;

            try{
                _logicResulted=parser.parse(logicItems);
            }catch (e:Error){
                //не распарсили и фиг с ним
            }

            _finished=false;

            if(_logicResulted!=null){
                _logicResulted.commit();
                if(_logicResulted.canBeEvaluated()){
                    _finished=true;
                    check();
                }
            }

            _view.update();
        }
    }

  public function clear():void{
        _activePlaceHolder=null;
        _activeDelimiter=null;
        _activeVariable=null;
        _logicResulted=null;
        _logicItems = new Vector.<LogicItem>();
        view.update();
    }



    public function check():void{
        if(_logicResulted!=null){
            for(var i:int = 0; i<ConfigurationHolder.instance.rightExamples.length; i++){
                var rightConfiguration:Configuration = ConfigurationHolder.instance.rightExamples[i];
                checker.checkExample(_logicResulted, rightConfiguration);
            }
            for(var j:int = 0; j<ConfigurationHolder.instance.wrongExamples.length; j++){
                var wrongConfiguration:Configuration = ConfigurationHolder.instance.wrongExamples[j];
                checker.checkExample(_logicResulted, wrongConfiguration);
            }
        }
        TarskiSprite.instance.update();
    }




    public function get logicResulted():LogicEvaluatedItem {
        return _logicResulted;
    }

    public function get logicItems():Vector.<LogicItem> {
        return _logicItems;
    }


    public function get view():BasicView {
        return _view;
    }

    public function get lastItem():LogicItem {
        return _lastItem;
    }


    public function get activePlaceHolder():VariablePlaceHolder {
        return _activePlaceHolder;
    }

    public function get activeDelimiter():Delimiter {
        return _activeDelimiter;
    }

    public function get activeVariable():Variable {
        return _activeVariable;
    }
}
}
