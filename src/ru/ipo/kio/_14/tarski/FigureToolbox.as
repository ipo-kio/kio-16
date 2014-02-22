/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 22.02.14
 */
package ru.ipo.kio._14.tarski {
import flash.events.MouseEvent;

import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.view.BasicView;

public class FigureToolbox extends BasicView{
    private var figure:Figure;

    public function FigureToolbox(figure:Figure) {
        this.figure=figure;
        addChild(figure.view);
        addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
            trace("creation!!!");
        })
    }

    public override function update():void{
         figure.view.update();
    }
}
}
