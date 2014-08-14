/**
 * @author: Vasily Akimushkin
 * @since: 11.02.14
 */
package ru.ipo.kio._14.tarski.model.parser {
import ru.ipo.kio._14.tarski.TarskiProblem;
import ru.ipo.kio._14.tarski.TarskiProblemFirst;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.operation.AndOperation;
import ru.ipo.kio._14.tarski.model.operation.EquivalenceOperation;
import ru.ipo.kio._14.tarski.model.operation.ImplicationOperation;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;
import ru.ipo.kio._14.tarski.model.operation.OrOperation;
import ru.ipo.kio._14.tarski.model.predicates.BasePredicate;
import ru.ipo.kio.api.KioApi;

public class StatementParser1 implements StatementParser{
    public function StatementParser1() {
    }

    public function parse(logicItems:Vector.<LogicItem>):LogicEvaluatedItem {
        var api:KioApi = KioApi.instance(TarskiProblemFirst.instance.problem);
        var index:int = getIndexOf(logicItems, EquivalenceOperation);
        if(index>0){
            var equivalence:EquivalenceOperation = new EquivalenceOperation(api.localization.buttons.eqv, api.localization.hints.eqv);
            equivalence.operand1=parse(logicItems.slice(0,index));
            equivalence.operand2=parse(logicItems.slice(index+1));
            return equivalence;
        }
        index = getIndexOf(logicItems, ImplicationOperation);
        if(index>0){
            var implication:ImplicationOperation = new ImplicationOperation(api.localization.buttons.impl, api.localization.hints.impl);
            implication.operand1=parse(logicItems.slice(0,index));
            implication.operand2=parse(logicItems.slice(index+1));
            return implication;
        }
        index = getIndexOf(logicItems, OrOperation);
        if(index>0){
            var orOperation:OrOperation = new OrOperation(api.localization.buttons.or);
            orOperation.operand1=parse(logicItems.slice(0,index));
            orOperation.operand2=parse(logicItems.slice(index+1));
            return orOperation;
        }
        index = getIndexOf(logicItems, AndOperation);
        if(index>0){
            var andOperation:AndOperation = new AndOperation(api.localization.buttons.and);
            andOperation.operand1=parse(logicItems.slice(0,index));
            andOperation.operand2=parse(logicItems.slice(index+1));
            return andOperation;
        }

        if(logicItems.length==1 && logicItems[0] instanceof BasePredicate){
            return BasePredicate(logicItems[0]);
        }

        return null;
    }

    protected function getIndexOf(logicItems:Vector.<LogicItem>, type:Class):int {
        for (var i:int = 0; i < logicItems.length; i++) {
            if (logicItems[i] is type) {
                return i;
            }
        }
        return -1;
    }
}
}
