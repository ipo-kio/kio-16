/**
 * @author: Vasily Akimushkin
 * @since: 11.02.14
 */
package ru.ipo.kio._14.tarski.model.editor {
import ru.ipo.kio._14.tarski.model.operation.AndOperation;
import ru.ipo.kio._14.tarski.model.operation.Brace;
import ru.ipo.kio._14.tarski.model.operation.EquivalenceOperation;
import ru.ipo.kio._14.tarski.model.operation.ImplicationOperation;
import ru.ipo.kio._14.tarski.model.operation.OrOperation;
import ru.ipo.kio._14.tarski.model.predicates.UpperPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.LefterPredicate;
import ru.ipo.kio._14.tarski.model.predicates.NearPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ShapePredicate;
import ru.ipo.kio._14.tarski.model.predicates.SizePredicate;
import ru.ipo.kio._14.tarski.model.predicates.Variable;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class LogicItemProvider1 implements LogicItemProvider{


    protected var _variables:Vector.<LogicItem> = new Vector.<LogicItem>();

    protected var _predicates:Vector.<LogicItem> = new Vector.<LogicItem>();

    protected var _operations:Vector.<LogicItem> = new Vector.<LogicItem>();


    public function LogicItemProvider1() {
        _predicates.push(new ColorPredicate(ValueHolder.getColor(ColorValue.RED)));
        _predicates.push(new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE)));
        _predicates.push(new ShapePredicate(ValueHolder.getShape(ShapeValue.CUBE)));
        _predicates.push(new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE)));
        _predicates.push(new SizePredicate(ValueHolder.getSize(SizeValue.BIG)));
        _predicates.push(new SizePredicate(ValueHolder.getSize(SizeValue.SMALL)));
        _predicates.push(new LefterPredicate());
        _predicates.push(new UpperPredicate());
        _predicates.push(new NearPredicate());

        _operations.push(new AndOperation());
        _operations.push(new OrOperation());
        _operations.push(new ImplicationOperation());
        _operations.push(new EquivalenceOperation());
        _operations.push(new Brace(true));
        _operations.push(new Brace(false));


        _variables.push(new Variable("X"));
        _variables.push(new Variable("Y"));
        _variables.push(new Variable("Z"));
    }

    public function get operations():Vector.<LogicItem> {
        return _operations;
    }

    public function get predicates():Vector.<LogicItem> {
        return _predicates;
    }

    public function get variables():Vector.<LogicItem> {
        return _variables;
    }
}
}
