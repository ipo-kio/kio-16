/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 20:11
 */
package ru.ipo.kio._13.blocks.parser {

public interface Program {
    function getProgramIterator(from_end:Boolean = false):ProgramIterator;
}
}
