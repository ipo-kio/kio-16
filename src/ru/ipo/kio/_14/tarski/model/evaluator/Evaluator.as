/**
 * @author: Vasily Akimushkin
 * @since: 11.02.14
 */
package ru.ipo.kio._14.tarski.model.evaluator {
import ru.ipo.kio._14.tarski.model.Configuration;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;

public interface Evaluator {

    function checkExample(_logicResulted:LogicEvaluatedItem,configuration:Configuration):Boolean;
}
}
