/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski {
import asunit.framework.TestSuite;

import ru.ipo.kio._14.tarski.model.operations.AndOperationTest;
import ru.ipo.kio._14.tarski.model.operations.EquivalenceOperationTest;
import ru.ipo.kio._14.tarski.model.operations.ImplicationOperationTest;

import ru.ipo.kio._14.tarski.model.operations.NotOperationTest;
import ru.ipo.kio._14.tarski.model.operations.OrOperationTest;

import ru.ipo.kio._14.tarski.model.predicates.CloserPredicateTest;

import ru.ipo.kio._14.tarski.model.predicates.ColorPredicateTest;
import ru.ipo.kio._14.tarski.model.predicates.LefterPredicateTest;
import ru.ipo.kio._14.tarski.model.predicates.NearPredicateTest;
import ru.ipo.kio._14.tarski.model.predicates.ShapePredicateTest;
import ru.ipo.kio._14.tarski.model.predicates.SizePredicateTest;

public class TarskiTestSuite extends asunit.framework.TestSuite {
    public function TarskiTestSuite() {
        addPredicateTests();
        addTest(new NotOperationTest("testCanEvaluate"));
        addTest(new NotOperationTest("testTrue"));
        addTest(new NotOperationTest("testFalse"));

        addTest(new AndOperationTest("testCanEvaluate"));
        addTest(new AndOperationTest("testTrue"));
        addTest(new AndOperationTest("testFalse"));

        addTest(new OrOperationTest("testCanEvaluate"));
        addTest(new OrOperationTest("testTrue"));
        addTest(new OrOperationTest("testFalse"));

        addTest(new ImplicationOperationTest("testCanEvaluate"));
        addTest(new ImplicationOperationTest("testTrue"));
        addTest(new ImplicationOperationTest("testFalse"));

        addTest(new EquivalenceOperationTest("testCanEvaluate"));
        addTest(new EquivalenceOperationTest("testTrue"));
        addTest(new EquivalenceOperationTest("testFalse"));

    }

    private function addPredicateTests():void {
        addTest(new ColorPredicateTest("testCanEvaluate"));
        addTest(new ColorPredicateTest("testTrue"));
        addTest(new ColorPredicateTest("testTrue2"));
        addTest(new ColorPredicateTest("testFalse"));
        addTest(new ColorPredicateTest("testException"));

        addTest(new SizePredicateTest("testCanEvaluate"));
        addTest(new SizePredicateTest("testTrue"));
        addTest(new SizePredicateTest("testTrue2"));
        addTest(new SizePredicateTest("testFalse"));
        addTest(new SizePredicateTest("testException"));

        addTest(new ShapePredicateTest("testCanEvaluate"));
        addTest(new ShapePredicateTest("testTrue"));
        addTest(new ShapePredicateTest("testTrue2"));
        addTest(new ShapePredicateTest("testFalse"));
        addTest(new ShapePredicateTest("testException"));

        addTest(new LefterPredicateTest("testCanEvaluate"));
        addTest(new LefterPredicateTest("testTrue"));
        addTest(new LefterPredicateTest("testTrue2"));
        addTest(new LefterPredicateTest("testFalse"));
        addTest(new LefterPredicateTest("testFalse2"));
        addTest(new LefterPredicateTest("testException"));

        addTest(new CloserPredicateTest("testCanEvaluate"));
        addTest(new CloserPredicateTest("testTrue"));
        addTest(new CloserPredicateTest("testTrue2"));
        addTest(new CloserPredicateTest("testFalse"));
        addTest(new CloserPredicateTest("testFalse2"));
        addTest(new CloserPredicateTest("testException"));

        addTest(new NearPredicateTest("testCanEvaluate"));
        addTest(new NearPredicateTest("testTrue"));
        addTest(new NearPredicateTest("testTrue2"));
        addTest(new NearPredicateTest("testTrue3"));
        addTest(new NearPredicateTest("testFalse"));
        addTest(new NearPredicateTest("testException"));
    }
}
}
