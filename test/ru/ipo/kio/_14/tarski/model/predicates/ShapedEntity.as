/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import ru.ipo.kio._14.tarski.model.properties.Shapable;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;

public class ShapedEntity implements Shapable{

    private var _shape:ShapeValue;


    public function ShapedEntity(shape:ShapeValue) {
        _shape = shape;
    }


    public function get shape():ShapeValue {
        return _shape;
    }
}
}
