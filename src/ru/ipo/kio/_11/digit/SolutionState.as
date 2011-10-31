/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.02.11
 * Time: 20:36
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.digit {
public interface SolutionState {

    function get recognized():int;

    function updateData():void;
    function updateView():void;

}
}
