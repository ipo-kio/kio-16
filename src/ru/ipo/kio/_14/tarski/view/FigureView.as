/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 22.02.14
 */
package ru.ipo.kio._14.tarski.view {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.ui.Mouse;

import ru.ipo.kio._13.clock.view.BasicView;
import ru.ipo.kio._14.tarski.TarskiSpriteLevel0;
import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;

public class FigureView extends ru.ipo.kio._13.clock.view.BasicView{

    private var _figure:Figure;

    public static const CELL_SIZE:int=50;

    public function FigureView(figure:Figure) {
        _figure = figure;

        addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void{
             (ConfigurationView(TarskiSpriteLevel0.instance.configuration.view)).activate(_figure);
        });

        addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
            if(figure.active){
                (ConfigurationView(TarskiSpriteLevel0.instance.configuration.view)).stopActivate(_figure, e.localX, e.localY);
            }
        });
    }

    public override function update():void{
        graphics.clear();
        graphics.lineStyle(1,0X666666);
        graphics.drawRect(0, 0, CELL_SIZE, CELL_SIZE);
        if (_figure == null) {
            graphics.lineStyle(1,0X666666);
            graphics.drawRect(0, 0, CELL_SIZE, CELL_SIZE);
        } else {
            graphics.lineStyle(0,0X000000);
            if (_figure.color.code == ColorValue.RED) {
                graphics.beginFill(0xFF3366);
            } else {
                graphics.beginFill(0x3366FF);
            }
            if (_figure.shape.code == ShapeValue.SPHERE) {
                if (_figure.size.code == SizeValue.BIG) {
                    graphics.drawCircle(CELL_SIZE/2, CELL_SIZE/2, CELL_SIZE/2);
                } else {
                    graphics.drawCircle(CELL_SIZE/2, CELL_SIZE/2, CELL_SIZE/2 * 0.7);
                }
            } else {
                if (_figure.size.code == SizeValue.BIG) {
                    graphics.drawRect(0, 0, CELL_SIZE, CELL_SIZE);
                } else {
                    graphics.drawRect(CELL_SIZE*0.15 , CELL_SIZE*0.15, CELL_SIZE * 0.7, CELL_SIZE * 0.7);
                }
            }
            graphics.endFill();
        }

        if(_figure.active){
            graphics.beginFill(0x9999FF, 0.2);
            graphics.drawRect(0, 0, CELL_SIZE, CELL_SIZE);
            graphics.endFill();
        }
    }
}
}
