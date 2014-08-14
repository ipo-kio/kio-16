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
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.LefterPredicate;
import ru.ipo.kio._14.tarski.model.predicates.NearPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ShapePredicate;
import ru.ipo.kio._14.tarski.model.predicates.SizePredicate;
import ru.ipo.kio._14.tarski.model.predicates.UpperPredicate;
import ru.ipo.kio._14.tarski.model.predicates.Variable;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;
import ru.ipo.kio.api.KioApi;

public class LogicItemProvider1 implements LogicItemProvider{


    protected var _variables:Vector.<LogicItem> = new Vector.<LogicItem>();

    protected var _predicates:Vector.<LogicItem> = new Vector.<LogicItem>();

    protected var _operations:Vector.<LogicItem> = new Vector.<LogicItem>();


    public function LogicItemProvider1(api:KioApi) {
        _predicates.push(new ShapePredicate(ValueHolder.getShape(ShapeValue.CUBE),api.localization.buttons.cube,api.localization.buttons.sphere));
        _predicates.push(new ColorPredicate(ValueHolder.getColor(ColorValue.RED),api.localization.buttons.red,api.localization.buttons.blue));
        _predicates.push(new SizePredicate(ValueHolder.getSize(SizeValue.BIG),api.localization.buttons.big,api.localization.buttons.small));

        _predicates.push(new ShapePredicate(ValueHolder.getShape(ShapeValue.SPHERE),api.localization.buttons.cube,api.localization.buttons.sphere));
        _predicates.push(new ColorPredicate(ValueHolder.getColor(ColorValue.BLUE),api.localization.buttons.red,api.localization.buttons.blue));
        _predicates.push(new SizePredicate(ValueHolder.getSize(SizeValue.SMALL),api.localization.buttons.big,api.localization.buttons.small));

        _predicates.push(new NearPredicate(1,api.localization.buttons.near,api.localization.hints.near));
        _predicates.push(new UpperPredicate(api.localization.buttons.upper,api.localization.hints.upper));
        _predicates.push(new LefterPredicate(api.localization.buttons.lefter,api.localization.hints.lefter));

        _operations.push(new AndOperation(api.localization.buttons.and));
        _operations.push(new ImplicationOperation(api.localization.buttons.impl,api.localization.hints.impl));
        _operations.push(new Brace(true));
        _operations.push(new OrOperation(api.localization.buttons.or));

        _operations.push(new EquivalenceOperation(api.localization.buttons.eqv,api.localization.hints.eqv));

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
