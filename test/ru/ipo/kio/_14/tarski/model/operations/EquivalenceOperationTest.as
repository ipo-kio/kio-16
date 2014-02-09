/**
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model.operations {
import asunit.framework.Assert;
import asunit.framework.TestCase;

import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.operation.EquivalenceOperation;
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ColoredEntity;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class EquivalenceOperationTest extends TestCase {

    public function EquivalenceOperationTest(testMethod:String) {
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var equivalenceOperation:EquivalenceOperation = new EquivalenceOperation();
        Assert.assertFalse(equivalenceOperation.canBeEvaluated());
    }

    public function testTrue():void {
        var equivalenceOperation:EquivalenceOperation = new EquivalenceOperation();

        var colorPredicateRed:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicateRed.operand="x";
        var colorPredicateBlue:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicateBlue.operand="y";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));

        equivalenceOperation.operand1=colorPredicateRed;
        equivalenceOperation.operand2=colorPredicateBlue;

        trace(equivalenceOperation.toString());

        Assert.assertTrue(equivalenceOperation.evaluate(data));

        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        Assert.assertTrue(equivalenceOperation.evaluate(data));
    }

    public function testFalse():void {
        var equivalenceOperation:EquivalenceOperation = new EquivalenceOperation();

        var colorPredicateRed:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicateRed.operand="x";
        var colorPredicateBlue:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE));
        colorPredicateBlue.operand="y";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));

        equivalenceOperation.operand1=colorPredicateRed;
        equivalenceOperation.operand2=colorPredicateBlue;

        Assert.assertFalse(equivalenceOperation.evaluate(data));

        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        data["y"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        Assert.assertFalse(equivalenceOperation.evaluate(data));
    }



    }
}
