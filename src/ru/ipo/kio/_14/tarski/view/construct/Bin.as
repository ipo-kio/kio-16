/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 22.02.14
 */
package ru.ipo.kio._14.tarski.view.construct {
import ru.ipo.kio._14.tarski.view.*;

public class Bin  extends BasicView{
    public function Bin() {
    }

    public override function update():void{
        graphics.clear();
        graphics.lineStyle(1, 0x000000, 0);
        graphics.drawRect(0,0,FigureView.CELL_SIZE*2+30, FigureView.CELL_SIZE*2+20);
    }
}
}
