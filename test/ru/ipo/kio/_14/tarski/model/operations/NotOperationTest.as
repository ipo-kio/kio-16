/**
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model.operations {
import asunit.framework.Assert;
import asunit.framework.TestCase;

import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.operation.NotOperation;
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ColoredEntity;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class NotOperationTest extends TestCase {

    public function NotOperationTest(testMethod:String) {
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var notOperation:NotOperation = new NotOperation();
        Assert.assertFalse(notOperation.canBeEvaluated());
    }

    public function testTrue():void {
        var notOperation:NotOperation = new NotOperation();

        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicate.operand="x";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));

        notOperation.operand=colorPredicate

        trace(notOperation.toString());

        Assert.assertTrue(notOperation.evaluate(data));
    }

    public function testFalse():void {
        var notOperation:NotOperation = new NotOperation();

        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicate.operand="x";

        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));

        notOperation.operand=colorPredicate

        Assert.assertFalse(notOperation.evaluate(data));
    }



    }
}
