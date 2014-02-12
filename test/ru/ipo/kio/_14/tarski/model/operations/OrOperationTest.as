/**
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model.operations {
import asunit.framework.Assert;
import asunit.framework.TestCase;

import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.operation.OrOperation;
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ColoredEntity;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class OrOperationTest extends TestCase {

    public function OrOperationTest(testMethod:String) {
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var orOperation:OrOperation = new OrOperation();
        Assert.assertFalse(orOperation.canBeEvaluated());
    }

    public function testTrue():void {
        var orOperation:OrOperation = new OrOperation();

        var colorPredicateRed:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicateRed.operand="x";
        var colorPredicateBlue:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicateBlue.operand="y";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));

        orOperation.operand1=colorPredicateRed;
        orOperation.operand2=colorPredicateBlue;

        trace(orOperation.toString());

        Assert.assertTrue(orOperation.evaluate(data));

        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        Assert.assertTrue(orOperation.evaluate(data));

        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        Assert.assertTrue(orOperation.evaluate(data));
    }

    public function testFalse():void {
        var orOperation:OrOperation = new OrOperation();

        var colorPredicateRed:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicateRed.operand="x";
        var colorPredicateBlue:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicateBlue.operand="y";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));

        orOperation.operand1=colorPredicateRed;
        orOperation.operand2=colorPredicateBlue;

        Assert.assertFalse(orOperation.evaluate(data));



    }



    }
}
