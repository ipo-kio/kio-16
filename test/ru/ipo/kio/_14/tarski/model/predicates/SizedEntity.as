/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import ru.ipo.kio._14.tarski.model.properties.Sizable;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;

public class SizedEntity implements Sizable{

    private var _size:SizeValue;


    public function SizedEntity(size:SizeValue) {
        _size = size;
    }


    public function get size():SizeValue {
        return _size;
    }
}
}
