/**
 *
 * @author: Vasiliy
 * @date: 05.05.13
 */
package ru.ipo.kio.api {
import ru.ipo.kio.base.logdebug.LogDebugCommand;

public interface ILogDebuggerHandler {
    function execute(command:LogDebugCommand):Boolean;
    function canExecute(command:LogDebugCommand):Boolean;
}
}
