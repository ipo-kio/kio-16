/**
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model.operations {
import asunit.framework.Assert;
import asunit.framework.TestCase;

import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.operation.ImplicationOperation;
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ColoredEntity;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class ImplicationOperationTest extends TestCase {

    public function ImplicationOperationTest(testMethod:String) {
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();
        Assert.assertFalse(implicationOperation.canBeEvaluated());
    }

    public function testTrue():void {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();

        var colorPredicateRed:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicateRed.operand="x";
        var colorPredicateBlue:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicateBlue.operand="y";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));

        implicationOperation.operand1=colorPredicateRed;
        implicationOperation.operand2=colorPredicateBlue;

        trace(implicationOperation.toString());

        Assert.assertTrue(implicationOperation.evaluate(data));

        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        Assert.assertTrue(implicationOperation.evaluate(data));

        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        Assert.assertTrue(implicationOperation.evaluate(data));
    }

    public function testFalse():void {
        var implicationOperation:ImplicationOperation = new ImplicationOperation();

        var colorPredicateRed:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicateRed.operand="x";
        var colorPredicateBlue:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicateBlue.operand="y";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));

        implicationOperation.operand1=colorPredicateRed;
        implicationOperation.operand2=colorPredicateBlue;

        Assert.assertFalse(implicationOperation.evaluate(data));
    }



    }
}
