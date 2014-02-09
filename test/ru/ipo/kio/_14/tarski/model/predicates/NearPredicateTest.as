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

public class NearPredicateTest extends TestCase {

    public function NearPredicateTest(testMethod:String) {
        super(testMethod);
    }

    public function testCanEvaluate():void {
        var nearPredicate:NearPredicate = new NearPredicate();
        Assert.assertFalse(nearPredicate.canBeEvaluated());
    }

    public function testTrue():void {
        var nearPredicate:NearPredicate = new NearPredicate();
        nearPredicate.formalOperand1="x";
        nearPredicate.formalOperand2="y";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(1,0);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(0,1);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(0,-1);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(-1,0);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(1,1);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(-1,-1);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(-1,1);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(1,-1);
        Assert.assertTrue(nearPredicate.evaluate(data));

    }


    public function testTrue2():void {
        var nearPredicate:NearPredicate = new NearPredicate();
        nearPredicate.formalOperand1="x";
        nearPredicate.formalOperand2="x";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(10,-10);
        data["y"]=new PlanePositionedEntity(10,11);
        Assert.assertTrue(nearPredicate.evaluate(data));
    }

    public function testTrue3():void {
        var nearPredicate:NearPredicate = new NearPredicate(5);
        nearPredicate.formalOperand1="x";
        nearPredicate.formalOperand2="y";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(5,0);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(0,5);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(0,-5);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(-5,0);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(5,5);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(-5,-5);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(-5,5);
        Assert.assertTrue(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(5,-5);
        Assert.assertTrue(nearPredicate.evaluate(data));

    }

    public function testFalse():void {
        var nearPredicate:NearPredicate = new NearPredicate();
        nearPredicate.formalOperand1="x";
        nearPredicate.formalOperand2="y";
        var data:Dictionary = new Dictionary();
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(2,0);
        Assert.assertFalse(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(-2,0);
        Assert.assertFalse(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(0,2);
        Assert.assertFalse(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(0,-2);
        Assert.assertFalse(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(1,2);
        Assert.assertFalse(nearPredicate.evaluate(data));
        data["x"]=new PlanePositionedEntity(0,0);
        data["y"]=new PlanePositionedEntity(2,2);
        Assert.assertFalse(nearPredicate.evaluate(data));
    }


    public function testException():void {
        var nearPredicate:NearPredicate = new NearPredicate();
        var data:Dictionary = new Dictionary();
        data["x"]=new ColoredEntity(ValueHolder.getColor(ColorValue.BLUE));
        Assert.assertThrows(IllegalOperationError,  function():void {nearPredicate.evaluate(data);});
    }


}
}
