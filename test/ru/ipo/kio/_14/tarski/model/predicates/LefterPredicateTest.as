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

public class LefterPredicateTest extends TestCase {

    public function LefterPredicateTest(testMethod:String) {
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var lefterPredicate:LefterPredicate = new LefterPredicate();
        Assert.assertFalse(lefterPredicate.canBeEvaluated());
    }

    public function testTrue():void {
        var lefterPredicate:LefterPredicate = new LefterPredicate();
        lefterPredicate.formalOperand1="x";
        lefterPredicate.formalOperand2="y";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(9,11);
        data["y"]=new PlanePositionedEntity(10,11);
        Assert.assertTrue(lefterPredicate.evaluate(data));
    }

    public function testTrue2():void {
        var lefterPredicate:LefterPredicate = new LefterPredicate();
        lefterPredicate.formalOperand1="x";
        lefterPredicate.formalOperand2="y";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(-10,11);
        data["y"]=new PlanePositionedEntity(10,11);
        Assert.assertTrue(lefterPredicate.evaluate(data));
    }

    public function testFalse():void {
        var lefterPredicate:LefterPredicate = new LefterPredicate();
        lefterPredicate.formalOperand1="x";
        lefterPredicate.formalOperand2="y";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(11,11);
        data["y"]=new PlanePositionedEntity(10,11);
        Assert.assertFalse(lefterPredicate.evaluate(data));
    }

    public function testFalse2():void {
        var lefterPredicate:LefterPredicate = new LefterPredicate();
        lefterPredicate.formalOperand1="x";
        lefterPredicate.formalOperand2="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(11,11);
        data["y"]=new PlanePositionedEntity(10,11);
        Assert.assertFalse(lefterPredicate.evaluate(data));
    }

    public function testException():void {
        var lefterPredicate:LefterPredicate = new LefterPredicate();
        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        Assert.assertThrows(IllegalOperationError,  function():void {lefterPredicate.evaluate(data);});
    }


}
}
