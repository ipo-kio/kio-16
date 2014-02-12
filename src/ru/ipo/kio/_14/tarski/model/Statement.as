/**
 * Условие мира
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model {
import avmplus.factoryXml;

import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.TarskiSprite;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.operation.ImplicationOperation;
import ru.ipo.kio._14.tarski.model.predicates.Variable;
import ru.ipo.kio._14.tarski.model.predicates.VariablePlaceHolder;
import ru.ipo.kio._14.tarski.model.operation.AndOperation;
import ru.ipo.kio._14.tarski.model.operation.EquivalenceOperation;
import ru.ipo.kio._14.tarski.model.operation.ImplicationOperation;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;
import ru.ipo.kio._14.tarski.model.operation.OrOperation;
import ru.ipo.kio._14.tarski.model.predicates.BasePredicate;
import ru.ipo.kio._14.tarski.model.predicates.CloserPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.LefterPredicate;
import ru.ipo.kio._14.tarski.model.predicates.NearPredicate;
import ru.ipo.kio._14.tarski.model.predicates.OnePlacePredicate;
import ru.ipo.kio._14.tarski.model.predicates.ShapePredicate;
import ru.ipo.kio._14.tarski.model.predicates.SizePredicate;
import ru.ipo.kio._14.tarski.model.predicates.TwoPlacePredicate;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.statement.Delimiter;
import ru.ipo.kio._14.tarski.view.statement.StatementViewFree;

public class Statement {

    private var _finished:Boolean=false;

    private static var _instance:Statement = new Statement();

    public static function get instance():Statement {
        return _instance;
    }

    private var _view:BasicView;

    private var _variables:Vector.<LogicItem> = new Vector.<LogicItem>();

    private var _predicates:Vector.<LogicItem> = new Vector.<LogicItem>();

    private var _operations:Vector.<LogicItem> = new Vector.<LogicItem>();



    private var _logicResulted:LogicEvaluatedItem;

    private var _activePlaceHolder:VariablePlaceHolder;

    private var _activeDelimiter:Delimiter;

    private var _activeVariable:Variable;

    private var _logicItems:Vector.<LogicItem> = new Vector.<LogicItem>();

    private var _lastItem:LogicItem;


    private var quantor1:Quantifier;
    private var quantor2:Quantifier;
    private var quantor3:Quantifier;

    public function Statement() {
        _view=  new StatementViewFree(this);
        _predicates.push(new ColorPredicate(ValueHolder.getColor(ColorValue.RED)));
        _predicates.push(new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE)));
        _predicates.push(new ShapePredicate(ValueHolder.getShape(ShapeValue.CUBE)));
        _predicates.push(new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE)));
        _predicates.push(new SizePredicate(ValueHolder.getSize(SizeValue.BIG)));
        _predicates.push(new SizePredicate(ValueHolder.getSize(SizeValue.SMALL)));
        _predicates.push(new LefterPredicate());
        _predicates.push(new CloserPredicate());
        _predicates.push(new NearPredicate());

        _operations.push(new AndOperation());
        _operations.push(new OrOperation());
        _operations.push(new ImplicationOperation());
        _operations.push(new EquivalenceOperation());

        _variables.push(new Variable("X"));
        _variables.push(new Variable("Y"));
        _variables.push(new Variable("Z"));
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
            }

        }else if(_activeVariable!=null && logicItem is BasePredicate){
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
            _lastItem=logicItem;
        }else if(_activePlaceHolder!=null && logicItem is Variable){
            if(_activePlaceHolder.predicate is OnePlacePredicate){
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
            _logicResulted=parse(logicItems);
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

    private function parse(logicItems:Vector.<LogicItem>):LogicEvaluatedItem {
        var index:int = getIndexOf(logicItems, EquivalenceOperation);
        if(index>0){
           var equivalence:EquivalenceOperation = new EquivalenceOperation();
            equivalence.operand1=parse(logicItems.slice(0,index));
            equivalence.operand2=parse(logicItems.slice(index+1));
            return equivalence;
        }
        index = getIndexOf(logicItems, ImplicationOperation);
        if(index>0){
            var implication:ImplicationOperation = new ImplicationOperation();
            implication.operand1=parse(logicItems.slice(0,index));
            implication.operand2=parse(logicItems.slice(index+1));
            return implication;
        }
        index = getIndexOf(logicItems, OrOperation);
        if(index>0){
            var orOperation:OrOperation = new OrOperation();
            orOperation.operand1=parse(logicItems.slice(0,index));
            orOperation.operand2=parse(logicItems.slice(index+1));
            return orOperation;
        }
        index = getIndexOf(logicItems, AndOperation);
        if(index>0){
            var andOperation:AndOperation = new AndOperation();
            andOperation.operand1=parse(logicItems.slice(0,index));
            andOperation.operand2=parse(logicItems.slice(index+1));
            return andOperation;
        }

        if(logicItems.length==1 && logicItems[0] instanceof BasePredicate){
            return BasePredicate(logicItems[0]);
        }

        return null;
    }

    private function getIndexOf(logicItems:Vector.<LogicItem>, type:Class):int {
        for (var i:int = 0; i < logicItems.length; i++) {
            if (logicItems[i] is type) {
                return 1;
            }
        }
        return -1;
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
            logicItems.splice(logicItems.indexOf(_activeDelimiter.beforeItem), 1)
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
                checkExample(rightConfiguration);
            }
            for(var j:int = 0; j<ConfigurationHolder.instance.wrongExamples.length; j++){
                var wrongConfiguration:Configuration = ConfigurationHolder.instance.wrongExamples[j];
                checkExample(wrongConfiguration);
            }
        }
        TarskiSprite.instance.update();
    }

    private function checkExample(configuration:Configuration):void {
        var dict:Dictionary = _logicResulted.collectFormalOperand();
        var size:int = 0;
        var first:Object = null;
        var second:Object = null;
        var third:Object = null;

        for (var kk:Object in dict) {
            if(size == 0){
                first=kk;
            }
            if(size == 1){
                second=kk;
            }
            if(size == 2){
                third=kk;
            }
            size++;
        }

        var figures:Vector.<Figure> = configuration.getListFigure();

        var ok:Boolean=true;

        var data:Dictionary = new Dictionary();
        if(size==1){
            for(var i:int=0;i<figures.length;i++){
                data[first]=figures[i];
                ok=ok&&_logicResulted.evaluate(data);
            }
        }else if(size==2){
            for(var i:int=0;i<figures.length;i++){
                for(var j:int=0;j<figures.length;j++){
                    if(i!=j){
                        data[first]=figures[i];
                        data[second]=figures[j];
                        ok=ok&&_logicResulted.evaluate(data);
                    }
                }
            }
        }else if(size==3){
            for(var i:int=0;i<figures.length;i++){
                for(var j:int=0;j<figures.length;j++){
                    for(var k:int=0;k<figures.length;k++){
                        if(i!=j && j!=k){
                            data[first]=figures[i];
                            data[second]=figures[j];
                            data[third]=figures[k];
                            ok=ok&&_logicResulted.evaluate(data);
                        }
                    }
                }
            }
        }

        configuration.correct=ok;

    }


    public function get logicResulted():LogicEvaluatedItem {
        return _logicResulted;
    }

    public function get operations():Vector.<LogicItem> {
        return _operations;
    }

    public function get predicates():Vector.<LogicItem> {
        return _predicates;
    }

    public function get variables():Vector.<LogicItem> {
        return _variables;
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
