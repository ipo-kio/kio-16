/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 25.02.11
 * Time: 16:52
 */
package ru.ipo.kio._11.ariadne.model {
public interface Terra {

    function get width():int;
    function get height():int;

    /**
     * x  ------->
     * y |
     *   |
     *   |
     *   v
     * @param x x coordinate
     * @param y y coordinate
     * @return some code
     */
    function squareType(x:int, y:int):int;
    function description(type:int):String;
    function velocity(type:int):Number;

}
}
