/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 21.02.11
 * Time: 2:19
 */
package ru.ipo.kio._11.digit {
public interface Out {
    function get connectors():Array; //Array of all connectors
    function get value():int; //0, 1 or some other from Gate class except VAL_UNKNOWN
    function bindConnector(c:Connector):void;
}
}
