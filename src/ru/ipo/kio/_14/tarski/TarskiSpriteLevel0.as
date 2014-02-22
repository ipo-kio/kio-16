/**
 * @author: Vasily Akimushkin
 * @since: 31.01.14
 */
package ru.ipo.kio._14.tarski {
import com.adobe.serialization.json.JSON_k;

import fl.containers.ScrollPane;

import flash.net.FileReference;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.engine.TabAlignment;
import flash.utils.ByteArray;

import flashx.textLayout.container.ScrollPolicy;

import mx.states.State;

import ru.ipo.kio._14.tarski.model.Configuration;

import ru.ipo.kio._14.tarski.model.ConfigurationHolder;
import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.Statement;
import ru.ipo.kio._14.tarski.model.editor.LogicItemProvider;
import ru.ipo.kio._14.tarski.model.editor.LogicItemProvider1;
import ru.ipo.kio._14.tarski.model.editor.LogicItemProvider2;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator1;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator2;
import ru.ipo.kio._14.tarski.model.operation.AndOperation;
import ru.ipo.kio._14.tarski.model.operation.ImplicationOperation;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;
import ru.ipo.kio._14.tarski.model.operation.NotOperation;
import ru.ipo.kio._14.tarski.model.parser.StatementParser1;
import ru.ipo.kio._14.tarski.model.parser.StatementParser2;
import ru.ipo.kio._14.tarski.model.predicates.CloserPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.LefterPredicate;
import ru.ipo.kio._14.tarski.model.predicates.NearPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ShapePredicate;
import ru.ipo.kio._14.tarski.model.predicates.SizePredicate;
import ru.ipo.kio._14.tarski.model.predicates.Variable;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;
import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;
import ru.ipo.kio._14.tarski.view.statement.PlainLogicItemView;
import ru.ipo.kio._14.tarski.view.toolbox.ToolboxView;

import ru.ipo.kio.api.controls.TextButton;
import ru.ipo.kio.base.displays.ShellButton;

public class TarskiSpriteLevel0 extends Sprite {

    private static var _instance:TarskiSpriteLevel0;


    public static function get instance():TarskiSpriteLevel0 {
        return _instance;
    }


    private static const X:String = "X";
    private static const Y:String = "Y";

    private var items:Vector.<LogicEvaluatedItem> = new Vector.<LogicEvaluatedItem>();

    private var _configuration:Configuration = new Configuration(8,8);

    private var checker:Evaluator2 = new Evaluator2();

    public function TarskiSpriteLevel0() {
        _instance=this;


        var item1:LogicEvaluatedItem = create1();
        item1.itemView = new PlainLogicItemView(item1, "В доме живет по крайней мере один большой красный шарик");
        items.push(item1);

        var item2:LogicEvaluatedItem = create2();
        item2.itemView = new PlainLogicItemView(item2, "Ниже красных шариков могут жить только шарики");
        items.push(item2);

        var item3:LogicEvaluatedItem = create3();
        item3.itemView = new PlainLogicItemView(item3, "Рядом с каждым красным жителем живет по крайней мере один кубик");
        items.push(item3);

        var item4:LogicEvaluatedItem = create4();
        item4.itemView = new PlainLogicItemView(item4, "Рядом с каждым кубиком живет по крайней мере один синий житель");
        items.push(item4);

        var item5:LogicEvaluatedItem = create5();
        item5.itemView = new PlainLogicItemView(item5, "Над каждым кубиком живет по крайней мере один синий шарик");
        items.push(item5);

        var item6:LogicEvaluatedItem = create6();
        item6.itemView = new PlainLogicItemView(item6, "Если житель большой, то левее его могут жить только маленькие жители");
        items.push(item6);

        var item7:LogicEvaluatedItem = create7();
        item7.itemView = new PlainLogicItemView(item7, "Если житель маленький, то ниже его могут жить только большие шарики");
        items.push(item7);


        var item8:LogicEvaluatedItem = create8();
        item8.itemView = new PlainLogicItemView(item8, "Правее шариков нет маленьких синих жителей");
        items.push(item8);




        for(var i:int=0; i<items.length; i++){
            items[i].getView().y = 40*Math.floor(i/2);
            items[i].getView().x = (i%2==0?10:400);
            addChild(items[i].getView());
            items[i].getView().update();
        }


        _configuration.addFigure(Figure.createFigureByCode(5, 5, "bC"));

        _configuration.addFigure(Figure.createFigureByCode(4, 4, "rs"));

        _configuration.addFigure(Figure.createFigureByCode(3, 3, "rS"));

        _configuration.view.x=10;
        _configuration.view.y=200;

        addChild(_configuration.view);
        _configuration.view.update();

        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0,0,800,600);
        graphics.endFill();

        check();


    }

    public function check():void{
        for(var i:int=0; i<items.length; i++){
            items[i].correct = checker.checkExample(items[i], configuration);
            items[i].getView().update();
        }
    }


    public function get configuration():Configuration {
        return _configuration;
    }

    private function create1():AndOperation {
        var andOperation:AndOperation = new AndOperation();
        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicate.operand = X;
        andOperation.operand1 = colorPredicate;
        var sizePredicate:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.BIG));
        sizePredicate.operand = X;
        andOperation.operand2 = sizePredicate;
        andOperation.quants.push(getExistQuantor(X));
        return andOperation;
    }

    private function create2():ImplicationOperation {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();

        var andOperation1:AndOperation = new AndOperation();

        var andOperation:AndOperation = new AndOperation();
        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicate.operand = X;
        andOperation.operand1 = colorPredicate;
        var closerPredicate:CloserPredicate = new CloserPredicate();
        closerPredicate.formalOperand1=Y;
        closerPredicate.formalOperand2=X;
        andOperation.operand2 = closerPredicate;

        var shapePredicate1:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        shapePredicate1.operand = X;
        andOperation1.operand1=shapePredicate1;
        andOperation1.operand2=andOperation;

        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        shapePredicate.operand = Y;

        implicationOperation.operand1=andOperation1;
        implicationOperation.operand2=shapePredicate;
        implicationOperation.quants.push(getAllQuantor(X))
        implicationOperation.quants.push(getAllQuantor(Y))

        return implicationOperation;
    }


    private function create3():ImplicationOperation {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();

        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicate.operand = X;

        var andOperation:AndOperation = new AndOperation();
        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.CUBE));
        shapePredicate.operand = Y;
        var nearPredicate:NearPredicate = new NearPredicate();
        nearPredicate.formalOperand1=X;
        nearPredicate.formalOperand2=Y;
        andOperation.operand1=shapePredicate;
        andOperation.operand2=nearPredicate;
        andOperation.quants.push(getExistQuantor(Y));

        implicationOperation.operand1=colorPredicate;
        implicationOperation.operand2=andOperation;

        implicationOperation.quants.push(getAllQuantor(X))

        return implicationOperation;
    }

    private function create4():ImplicationOperation {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();


        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.CUBE));
        shapePredicate.operand = X;

        var andOperation:AndOperation = new AndOperation();
        var nearPredicate:NearPredicate = new NearPredicate();
        nearPredicate.formalOperand1=X;
        nearPredicate.formalOperand2=Y;
        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicate.operand = Y;
        andOperation.operand1=colorPredicate;
        andOperation.operand2=nearPredicate;
        andOperation.quants.push(getExistQuantor(Y));

        implicationOperation.operand1=shapePredicate;
        implicationOperation.operand2=andOperation;

        implicationOperation.quants.push(getAllQuantor(X))

        return implicationOperation;
    }

    private function create5():ImplicationOperation {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();


        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.CUBE));
        shapePredicate.operand = X;

        var andOperation:AndOperation = new AndOperation();
        var closerPredicate:CloserPredicate = new CloserPredicate();
        closerPredicate.formalOperand1=X;
        closerPredicate.formalOperand2=Y;
        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicate.operand = Y;
        var shapePredicate1:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        shapePredicate1.operand = Y;
        andOperation.operand1=closerPredicate;

        var andOperation1:AndOperation = new AndOperation();
        andOperation.operand2=andOperation1;
        andOperation1.operand1=closerPredicate;
        andOperation1.operand2=colorPredicate;

        andOperation.quants.push(getExistQuantor(Y));

        implicationOperation.operand1=shapePredicate;
        implicationOperation.operand2=andOperation;

        implicationOperation.quants.push(getAllQuantor(X))

        return implicationOperation;
    }


    private function create6():ImplicationOperation {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();

        var sizePredicate:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.BIG));
        sizePredicate.operand = X;

        var andOperation:AndOperation = new AndOperation();

        var lefterPredicate:LefterPredicate = new LefterPredicate();
        lefterPredicate.formalOperand1=Y;
        lefterPredicate.formalOperand2=X;

        andOperation.operand1=sizePredicate;
        andOperation.operand2=lefterPredicate;


        var sizePredicate1:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.SMALL));
        sizePredicate1.operand = Y;

        implicationOperation.operand1=andOperation;
        implicationOperation.operand2=sizePredicate1;

        implicationOperation.quants.push(getAllQuantor(X))
        implicationOperation.quants.push(getAllQuantor(Y))
        return implicationOperation;
    }


    private function create7():ImplicationOperation {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();

        var sizePredicate:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.SMALL));
        sizePredicate.operand = X;

        var andOperation:AndOperation = new AndOperation();

        var closerPredicate:CloserPredicate = new CloserPredicate();
        closerPredicate.formalOperand1=Y;
        closerPredicate.formalOperand2=X;

        andOperation.operand1=sizePredicate;
        andOperation.operand2=closerPredicate;

        var andOperation1:AndOperation = new AndOperation();


        var sizePredicate1:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.BIG));
        sizePredicate1.operand = Y;

        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        shapePredicate.operand = Y;

        andOperation1.operand1=sizePredicate1;
        andOperation1.operand2=shapePredicate;

        implicationOperation.operand1=andOperation;
        implicationOperation.operand2=andOperation1;

        implicationOperation.quants.push(getAllQuantor(X))
        implicationOperation.quants.push(getAllQuantor(Y))
        return implicationOperation;
    }


    private function create8():ImplicationOperation {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();

        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        shapePredicate.operand = X;

        var andOperation:AndOperation = new AndOperation();

        var lefterPredicate:LefterPredicate = new LefterPredicate();
        lefterPredicate.formalOperand1=X;
        lefterPredicate.formalOperand2=Y;



        var andOperation1:AndOperation = new AndOperation();


        var sizePredicate1:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.SMALL));
        sizePredicate1.operand = Y;

        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicate.operand = Y;

        andOperation1.operand1=sizePredicate1;
        andOperation1.operand2=colorPredicate;


        andOperation.operand1=lefterPredicate;
        andOperation.operand2=andOperation1;

        andOperation.quants.push(getExistQuantor(Y));

        var notOperation:NotOperation = new NotOperation();
        notOperation.operand=andOperation;

        implicationOperation.operand1=shapePredicate;
        implicationOperation.operand2=notOperation;

        implicationOperation.quants.push(getAllQuantor(X))


        return implicationOperation;
    }


    private function getExistQuantor(operand:String):Quantifier {
        var quant:Quantifier = new Quantifier(Quantifier.EXIST);
        quant.operand = operand;
        quant.placeHolder.variable=new Variable(operand);
        return quant;
    }

    private function getAllQuantor(operand:String):Quantifier {
        var quant:Quantifier = new Quantifier(Quantifier.ALL);
        quant.operand = operand;
        quant.placeHolder.variable=new Variable(operand);
        return quant;
    }






}
}
