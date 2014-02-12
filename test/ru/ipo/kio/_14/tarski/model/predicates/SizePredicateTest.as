/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import asunit.framework.Assert;
import asunit.framework.TestCase;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class SizePredicateTest extends TestCase {

    public function SizePredicateTest(testMethod:String) {
        ValueHolder.registerSize(new SizeValue(SizeValue.BIG, "большой"));
        ValueHolder.registerSize(new SizeValue(SizeValue.SMALL, "маленький"));
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var sizePredicate:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.BIG));
        Assert.assertFalse(sizePredicate.canBeEvaluated());
    }

    public function testTrue():void {
        var sizePredicate:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.BIG));
        sizePredicate.operand="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new SizedEntity(ValueHolder.getSize(SizeValue.BIG));
        Assert.assertTrue(sizePredicate.evaluate(data));
    }

    public function testTrue2():void {
        var sizePredicate:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.BIG));
        sizePredicate.operand="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new SizedEntity(new SizeValue(SizeValue.BIG, "болшой"));
        Assert.assertTrue(sizePredicate.evaluate(data));
    }

    public function testFalse():void {
        var sizePredicate:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.BIG));
        sizePredicate.operand="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new SizedEntity(ValueHolder.getSize(SizeValue.SMALL));
        Assert.assertFalse(sizePredicate.evaluate(data));
    }

    public function testException():void {
        var sizePredicate:SizePredicate = new SizePredicate(ValueHolder.getSize(SizeValue.BIG));
        var data:Dictionary = new Dictionary();
        data["x"]=new SizedEntity(ValueHolder.getSize(SizeValue.BIG));
        Assert.assertThrows(IllegalOperationError,  function():void {sizePredicate.evaluate(data);});
    }


}
}
