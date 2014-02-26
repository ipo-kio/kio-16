/**
 * Условие мира
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model {


import ru.ipo.kio._14.tarski.TarskiProblem;
import ru.ipo.kio._14.tarski.TarskiProblemFirst;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator;
import ru.ipo.kio._14.tarski.model.operation.ImplicationOperation;
import ru.ipo.kio._14.tarski.model.parser.StatementParser;
import ru.ipo.kio._14.tarski.model.predicates.Variable;
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
import ru.ipo.kio._14.tarski.view.statement.FictiveLogicItem;
import ru.ipo.kio._14.tarski.view.statement.StatementViewFree;
import ru.ipo.kio.api.KioApi;

public class Statement {

    private static var counter:int;

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

    private var _active:Boolean=false;

    private var _id:int;

    public function get id():int {
        return _id;
    }

    public function set active(value:Boolean):void {
        _active = value;
    }

    public function get active():Boolean {
        return _active;
    }

    public function Statement(parser:StatementParser, checker:Evaluator) {
        this.parser=parser;
        this.checker=checker;
        _view=  new StatementViewFree(this);
        _id = counter;
        counter++;
    }


    public function get finished():Boolean {
        return _finished;
    }


    public function setLastItemBefore(value:Delimiter):void {
        clearActive();
        if(value.beforeItem==null){
            _lastItem = null;
        }else{
            _lastItem = value.beforeItem;
        }
        view.update();

    }

    public function addLogicItem(logicItem:LogicItem):void{

        if(_activeDelimiter!=null){

            if(_activeDelimiter.beforeItem==null){
//                if(logicItem is ImplicationOperation){
//                    var ifOp:FictiveLogicItem = new FictiveLogicItem(FictiveLogicItem.IF, null);
//                    var thenOp:FictiveLogicItem = new FictiveLogicItem(FictiveLogicItem.THEN, null);
//                    ifOp.couple=thenOp;
//                    thenOp.couple=ifOp;
//                    logicItems.unshift(thenOp);
//                    logicItems.unshift(ifOp);
//                    _lastItem=ifOp;
//                }else{
                    logicItems.unshift(logicItem);
                    KioApi.log(TarskiProblem.ID, "INSERT_ITEM @SSS", id, logicItem.getToolboxText(), 0);
                    _lastItem=logicItem;
//                }

            }else{
//                if(logicItem is ImplicationOperation){
//                    var ifOp:FictiveLogicItem = new FictiveLogicItem(FictiveLogicItem.IF, null);
//                    var thenOp:FictiveLogicItem = new FictiveLogicItem(FictiveLogicItem.THEN, null);
//                    ifOp.couple=thenOp;
//                    thenOp.couple=ifOp;
//                    logicItems.splice(logicItems.indexOf(_activeDelimiter.beforeItem)+1, 0, thenOp);
//                    logicItems.splice(logicItems.indexOf(_activeDelimiter.beforeItem)+1, 0, ifOp);
//                    _lastItem=ifOp;
//                }else{
                    logicItems.splice(logicItems.indexOf(_activeDelimiter.beforeItem)+1, 0, logicItem);
                    KioApi.log(TarskiProblem.ID, "INSERT_ITEM @SSS", id, logicItem.getToolboxText(), logicItems.indexOf(logicItem));
                    _lastItem=logicItem;
//                }
            }

            if(logicItem is Variable){
                activeVariable = Variable(logicItem);
            }else if(logicItem is OnePlacePredicate){
                (OnePlacePredicate(logicItem)).placeHolder.statement=this;
                activePlaceHolder = (OnePlacePredicate(logicItem)).placeHolder;
            }else if(logicItem is TwoPlacePredicate){
                (TwoPlacePredicate(logicItem)).placeHolder1.statement=this;
                (TwoPlacePredicate(logicItem)).placeHolder2.statement=this;
                activePlaceHolder = (TwoPlacePredicate(logicItem)).placeHolder1;
            }else if(logicItem is Quantifier){
                (Quantifier(logicItem)).placeHolder.statement=this;
                activePlaceHolder = (Quantifier(logicItem)).placeHolder;
            }

        }else if(_activeVariable!=null && (logicItem is BasePredicate || logicItem is Quantifier)){
            if(logicItem is OnePlacePredicate){
                (OnePlacePredicate(logicItem)).placeHolder.statement=this;
                (OnePlacePredicate(logicItem)).placeHolder.variable=_activeVariable;
                logicItems.splice(logicItems.indexOf(_activeVariable), 1, logicItem);
                KioApi.log(TarskiProblem.ID, "REPLACE_ITEM @SSSS", id, _activeVariable.code, logicItem.getToolboxText(), logicItems.indexOf(logicItem));
                activeVariable=null;
            }
            if(logicItem is TwoPlacePredicate){
                (TwoPlacePredicate(logicItem)).placeHolder1.statement=this;
                (TwoPlacePredicate(logicItem)).placeHolder2.statement=this;
                (TwoPlacePredicate(logicItem)).placeHolder1.variable=_activeVariable;
                logicItems.splice(logicItems.indexOf(_activeVariable), 1, logicItem);
                KioApi.log(TarskiProblem.ID, "REPLACE_ITEM @SSSS", id, _activeVariable.code, logicItem.getToolboxText(), logicItems.indexOf(logicItem));
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
                KioApi.log(TarskiProblem.ID, "SETVAR_ITEM @SSSS", id, Variable(logicItem), _activePlaceHolder.predicate.getToolboxText(), logicItems.indexOf(_activePlaceHolder.predicate));
                activePlaceHolder=null;
            }else if (_activePlaceHolder.predicate is Quantifier){
                _activePlaceHolder.variable= Variable(logicItem);
                _lastItem=_activePlaceHolder.predicate;
                activePlaceHolder=null;
            }else if(_activePlaceHolder.predicate is TwoPlacePredicate){
                _activePlaceHolder.variable= Variable(logicItem);
                if(((TwoPlacePredicate)(_activePlaceHolder.predicate)).placeHolder1==_activePlaceHolder){
                    KioApi.log(TarskiProblem.ID, "SETVAR1_ITEM @SSSS", id, Variable(logicItem), _activePlaceHolder.predicate.getToolboxText(), logicItems.indexOf(_activePlaceHolder.predicate));
                    activePlaceHolder=((TwoPlacePredicate)(_activePlaceHolder.predicate)).placeHolder2;
                }else{
                    KioApi.log(TarskiProblem.ID, "SETVAR2_ITEM @SSSS", id, Variable(logicItem), _activePlaceHolder.predicate.getToolboxText(), logicItems.indexOf(_activePlaceHolder.predicate));
                    _lastItem=_activePlaceHolder.predicate;
                    activePlaceHolder=null;
                }
            }
        }

        TarskiProblemFirst.instance.statementManager.parseAndCheckAll();
    }

    public function parse():void {
        _logicResulted = null;

        try {
            _logicResulted = parser.parse(logicItems);
        } catch (e:Error) {
            //не распарсили и фиг с ним
        }

        _finished = false;

        if (_logicResulted != null) {
            _logicResulted.commit();
            if (_logicResulted.canBeEvaluated()) {
                _finished = true;

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
        if(_activeDelimiter!=null && _activeDelimiter.beforeItem==null && _logicItems.length==0){
            TarskiProblemFirst.instance.statementManager.removeStatement();
            return;
        }

        if(_activeDelimiter!=null && _activeDelimiter.beforeItem!=null){
            var index:int = logicItems.indexOf(_activeDelimiter.beforeItem);
            KioApi.log(TarskiProblem.ID, "DELETE_ITEM @SS", id, index);
            logicItems.splice(index, 1);

            if(_activeDelimiter.beforeItem is FictiveLogicItem){
                var indexCouple:int = logicItems.indexOf(FictiveLogicItem(_activeDelimiter.beforeItem).couple);
                logicItems.splice(indexCouple, 1);
            }

            if(index>0 && _logicItems.length>(index-1)){
                _lastItem=_logicItems[index-1];
            }






            TarskiProblemFirst.instance.statementManager.parseAndCheckAll();
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



    public function check(configuration:Configuration):Boolean{
        if(_logicResulted!=null){
                return checker.checkExample(_logicResulted, configuration);
        }
        return false;

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

    public function load(logicItems:Vector.<LogicItem>):void {
        _logicItems = logicItems;
        for(var i:int=0; i<_logicItems.length; i++){
            var logicItem:LogicItem = logicItems[i];
            if(logicItem is OnePlacePredicate){
                (OnePlacePredicate(logicItem)).placeHolder.statement=this;
            }else if(logicItem is TwoPlacePredicate){
                (TwoPlacePredicate(logicItem)).placeHolder1.statement=this;
                (TwoPlacePredicate(logicItem)).placeHolder2.statement=this;
            }
        }

    }

    public function set id(id:int):void {
        _id = id;
        counter=Math.max(counter, _id)+1;
    }
}
}
