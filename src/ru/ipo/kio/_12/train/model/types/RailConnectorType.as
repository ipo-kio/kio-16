/**
 * Класс содержит возможные типы соединений
 *
 * (Левый нижний имеет вид |_)
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model.types {
public class RailConnectorType {

    public static const HORIZONTAL:RailConnectorType = new RailConnectorType();

    public static const VERTICAL:RailConnectorType = new RailConnectorType();

    public static const TOP_LEFT:RailConnectorType = new RailConnectorType();

    public static const TOP_RIGHT:RailConnectorType = new RailConnectorType();

    public static const BOTTOM_LEFT:RailConnectorType = new RailConnectorType();

    public static const BOTTOM_RIGHT:RailConnectorType = new RailConnectorType();

    public function RailConnectorType() {
    }
}
}
