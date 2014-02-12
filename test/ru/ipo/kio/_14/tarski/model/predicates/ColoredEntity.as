/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.Colorable;

public class ColoredEntity implements Colorable{

    private var _color:ColorValue;


    public function ColoredEntity(color:ColorValue) {
        this._color = color;
    }


    public function get color():ColorValue {
        return _color;
    }
}
}
