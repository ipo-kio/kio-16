/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model {
import ru.ipo.kio._12.train.view.BasicView;

public class VisibleEntity {

    private var _view:BasicView;

    public function VisibleEntity() {
    }

    public function get view():BasicView {
        return _view;
    }

    public function set view(value:BasicView):void {
        _view = value;
    }
}
}
