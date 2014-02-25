/**
 * Created by IntelliJ IDEA.
 * User: iposov
 * Date: 23.12.10
 * Time: 16:38
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api {
import flash.display.DisplayObject;

public interface KioProblem {

    function get id():String;

    function get year():int;

    function get level():int;

    function get display():DisplayObject;

    function get solution():Object;

    function get best():Object;

    function loadSolution(solution:Object):Boolean;

    function check(solution:Object):Object;

    function compare(solution1:Object, solution2:Object):int;

    function get icon():Class;

    function get icon_help():Class;

    function get icon_statement():Class;

    function clear():void;

    //function get help_icon():Class;
}
}