/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import asunit.framework.Assert;
import asunit.framework.TestCase;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class ShapePredicateTest extends TestCase {

    public function ShapePredicateTest(testMethod:String) {
        ValueHolder.registerShape(new ShapeValue(ShapeValue.SPHERE, "шар"));
        ValueHolder.registerShape(new ShapeValue(ShapeValue.CUBE, "куб"));
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        Assert.assertFalse(shapePredicate.canBeEvaluated());
    }

    public function testTrue():void {
        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        shapePredicate.operand="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new ShapedEntity(ValueHolder.getShape(ShapeValue.SPHERE));
        Assert.assertTrue(shapePredicate.evaluate(data));
    }

    public function testTrue2():void {
        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        shapePredicate.operand="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new ShapedEntity(new ShapeValue(ShapeValue.SPHERE, "шар"));
        Assert.assertTrue(shapePredicate.evaluate(data));
    }

    public function testFalse():void {
        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        shapePredicate.operand="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new ShapedEntity(ValueHolder.getShape(ShapeValue.CUBE));
        Assert.assertFalse(shapePredicate.evaluate(data));
    }

    public function testException():void {
        var shapePredicate:ShapePredicate = new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE));
        var data:Dictionary = new Dictionary();
        data["x"]=new ShapedEntity(ValueHolder.getShape(ShapeValue.SPHERE));
        Assert.assertThrows(IllegalOperationError,  function():void {shapePredicate.evaluate(data);});
    }


}
}
