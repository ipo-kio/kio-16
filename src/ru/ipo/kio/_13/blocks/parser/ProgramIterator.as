/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 11.02.13
 * Time: 15:25
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.blocks.parser {
public interface ProgramIterator {

    function hasNext():Boolean;
    function hasPrev():Boolean;

    function next():Command;
    function prev():Command; //may throw not implemented error
}
}
