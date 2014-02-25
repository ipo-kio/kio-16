/**
 * @author: Vasily Akimushkin
 * @since: 06.02.14
 */
package ru.ipo.kio._14.tarski.model.editor {
import ru.ipo.kio._14.tarski.view.BasicView;

/**
 * Сущность, которая может использоваться при построении формул
 */
public interface LogicItem {

    /**
     * Представления для тулбокса
     * @return
     */
    function getToolboxView():BasicView;

    /**
     * Текст для тулбокса
     * @return
     */
    function getToolboxText():String;

    function getTooltipText():String;

    /**
     * Текст для тулбокса
     * @return
     */
    function getFormulaText():String;

    /**
     * Получить клона сущности
     * @return
     */
    function getCloned():LogicItem;

    /**
     * Получить  представления для формулы
     * @return
     */
    function getView():BasicView;

    /**
     * Зафиксировать результаты редактирования
     */
    function commit():void;

}
}
