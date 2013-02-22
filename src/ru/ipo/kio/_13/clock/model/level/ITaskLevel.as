/**
 * Интерфейс содержит методы, специфичные для каждого уровня
 * 
 * @author: Vasiliy
 * @date: 21.02.13
 */
package ru.ipo.kio._13.clock.model.level {
import flash.display.Sprite;

public interface ITaskLevel {

    /**
     * Возвращает номер уровня (0,1,2)
     */
    function get level():int;

    /**
     * Вохвращает правильное передаточное число
     */
    function get correctRatio():Number

    /**
     * Возвращает процент совпадения
     * @param precision
     * @return
     */
    function getFormattedPrecision(precision:Number):String;
    
    function get icon_help():Class;
    
    function get icon_statement():Class;

    function getProductSprite():Sprite;

    function updateProductSprite():void;
    

}
}
