/**
 *
 * @author: Vasiliy
 * @date: 07.02.13
 */
package ru.ipo.kio._13.clock {
import flexunit.framework.Assert;

public class SimpleTest {

    [Test( description = "This tests addition" )]
    public function simpleAdd():void {
        var x:int = 5 + 3;
        Assert.assertEquals( 8, x );
    }


}
}
