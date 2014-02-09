/**
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import asunit.framework.Assert;
import asunit.framework.TestCase;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class CloserPredicateTest extends TestCase {

    public function CloserPredicateTest(testMethod:String) {
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var closerPredicate:CloserPredicate = new CloserPredicate();
        Assert.assertFalse(closerPredicate.canBeEvaluated());
    }

    public function testTrue():void {
        var closerPredicate:CloserPredicate = new CloserPredicate();
        closerPredicate.formalOperand1="x";
        closerPredicate.formalOperand2="y";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(10,5);
        data["y"]=new PlanePositionedEntity(10,6);
        Assert.assertTrue(closerPredicate.evaluate(data));
    }

    public function testTrue2():void {
        var closerPredicate:CloserPredicate = new CloserPredicate();
        closerPredicate.formalOperand1="x";
        closerPredicate.formalOperand2="y";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(10,-10);
        data["y"]=new PlanePositionedEntity(10,11);
        Assert.assertTrue(closerPredicate.evaluate(data));
    }

    public function testFalse():void {
        var closerPredicate:CloserPredicate = new CloserPredicate();
        closerPredicate.formalOperand1="x";
        closerPredicate.formalOperand2="y";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(11,80);
        data["y"]=new PlanePositionedEntity(10,20);
        Assert.assertFalse(closerPredicate.evaluate(data));
    }

    public function testFalse2():void {
        var closerPredicate:CloserPredicate = new CloserPredicate();
        closerPredicate.formalOperand1="x";
        closerPredicate.formalOperand2="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(11,11);
        data["y"]=new PlanePositionedEntity(10,11);
        Assert.assertFalse(closerPredicate.evaluate(data));
    }

    public function testException():void {
        var closerPredicate:CloserPredicate = new CloserPredicate();
        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        Assert.assertThrows(IllegalOperationError,  function():void {closerPredicate.evaluate(data);});
    }


}
}
