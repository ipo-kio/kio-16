/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 20:20
 */
package ru.ipo.kio._13.blocks.parser {

public interface Executor {

    //all function return null if there are no errors, or an error message

    function mayLeft():String;
    function mayRight():String;
    function mayTake():String;
    function mayPut():String;

    function left():void;
    function right():void;
    function take():void;
    function put():void;

}
}
