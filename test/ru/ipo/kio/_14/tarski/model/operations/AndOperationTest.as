/**
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model.operations {
import asunit.framework.Assert;
import asunit.framework.TestCase;

import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.operation.AndOperation;
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ColoredEntity;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class AndOperationTest extends TestCase {

    public function AndOperationTest(testMethod:String) {
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var andOperation:AndOperation = new AndOperation();
        Assert.assertFalse(andOperation.canBeEvaluated());
    }

    public function testTrue():void {
        var andOperation:AndOperation = new AndOperation();

        var colorPredicateRed:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicateRed.operand="x";
        var colorPredicateBlue:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicateBlue.operand="y";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));

        andOperation.operand1=colorPredicateRed;
        andOperation.operand2=colorPredicateBlue;

        trace(andOperation.toString());

        Assert.assertTrue(andOperation.evaluate(data));
    }

    public function testFalse():void {
        var andOperation:AndOperation = new AndOperation();

        var colorPredicateRed:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicateRed.operand="x";
        var colorPredicateBlue:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicateBlue.operand="y";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));

        andOperation.operand1=colorPredicateRed;
        andOperation.operand2=colorPredicateBlue;

        Assert.assertFalse(andOperation.evaluate(data));

        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        Assert.assertFalse(andOperation.evaluate(data));

        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        Assert.assertFalse(andOperation.evaluate(data));

    }



    }
}
