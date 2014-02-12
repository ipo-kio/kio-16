/**
 * @author: Vasily Akimushkin
 * @since: 11.02.14
 */
package ru.ipo.kio._14.tarski.model.editor {
public interface LogicItemProvider {

    function get operations():Vector.<LogicItem>;

    function get predicates():Vector.<LogicItem>;

    function get variables():Vector.<LogicItem>;
}
}
