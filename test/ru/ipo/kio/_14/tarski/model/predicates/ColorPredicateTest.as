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
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class ColorPredicateTest extends TestCase {

    public function ColorPredicateTest(testMethod:String) {
        ValueHolder.registerColor(new ColorValue(ColorValue.RED, "Красный", 0xFF0000));
        ValueHolder.registerColor(new ColorValue(ColorValue.BLUE, "Синий", 0x0000FF));
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        Assert.assertFalse(colorPredicate.canBeEvaluated());
    }

    public function testTrue():void {
        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicate.operand="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.RED));
        Assert.assertTrue(colorPredicate.evaluate(data));
    }

    public function testTrue2():void {
        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicate.operand="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(new ColorValue(ColorValue.RED, "Красный", 0xFF0000));
        Assert.assertTrue(colorPredicate.evaluate(data));
    }

    public function testFalse():void {
        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        colorPredicate.operand="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        Assert.assertFalse(colorPredicate.evaluate(data));
    }

    public function testException():void {
        var colorPredicate:ColorPredicate = new ColorPredicate(ValueHolder.getColor(ColorValue.RED));
        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        Assert.assertThrows(IllegalOperationError,  function():void {colorPredicate.evaluate(data);});
    }


}
}
