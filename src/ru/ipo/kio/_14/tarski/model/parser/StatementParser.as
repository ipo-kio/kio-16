/**
 * @author: Vasily Akimushkin
 * @since: 11.02.14
 */
package ru.ipo.kio._14.tarski.model.parser {
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;

public interface StatementParser {
    function parse(logicItems:Vector.<LogicItem>):LogicEvaluatedItem
}
}
