/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 21.02.11
 * Time: 0:16
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api.controls {
import flash.filters.BitmapFilter;
import flash.filters.ColorMatrixFilter;

public function BrightnessFilter(mul:Number):BitmapFilter {
    var filter:ColorMatrixFilter = new ColorMatrixFilter();

    //TODO make real multiplication
    if (mul > 1.4)
        filter.matrix = [ // * 3/2
            1.14948, 0.293459, 0.0569921, 0, 0,
            0.149511, 1.29352, 0.057004, 0, 0,
            0.1495, 0.2935, 1.057, 0, 0,
            0, 0, 0, 1, 0
        ];
    else
        filter.matrix = [
            1.07474, 0.14673, 0.028496, 0, 0,
            0.0747553, 1.14767, 0.028502, 0, 0,
            0.07475, 0.14675, 1.0285, 0, 0,
            0, 0, 0, 1, 0
        ];
    return filter;
}
}
