/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 22.02.14
 */
package ru.ipo.kio._14.tarski.view.construct {
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._14.tarski.TarskiProblemZero;
import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.view.BasicView;

public class FigureView extends BasicView{

    private var _figure:Figure;

    public static const CELL_SIZE:int=43;

    [Embed(source="../../_resources/level0/blue_big_ball.png")]
    private static const BLUE_BIG_BALL:Class;

    [Embed(source="../../_resources/level0/red_big_ball.png")]
    private static const RED_BIG_BALL:Class;

    [Embed(source="../../_resources/level0/blue_small_ball.png")]
    private static const BLUE_SMALL_BALL:Class;

    [Embed(source="../../_resources/level0/red_small_ball.png")]
    private static const RED_SMALL_BALL:Class;

    [Embed(source="../../_resources/level0/blue_big_rec.png")]
    private static const BLUE_BIG_REC:Class;

    [Embed(source="../../_resources/level0/red_big_rec.png")]
    private static const RED_BIG_REC:Class;

    [Embed(source="../../_resources/level0/blue_small_rec.png")]
    private static const BLUE_SMALL_REC:Class;

    [Embed(source="../../_resources/level0/red_small_rec.png")]
    private static const RED_SMALL_REC:Class;


    public function FigureView(figure:Figure) {
        _figure = figure;

        addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void{
             (ConfigurationView(TarskiProblemZero.instance.configuration.view)).activate(_figure);
        });

        addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
            if(figure.active){
                (ConfigurationView(TarskiProblemZero.instance.configuration.view)).stopActivate(_figure, e.localX, e.localY);
            }
        });
    }

    public override function update():void{
        graphics.clear();
        clearAll();
        //graphics.lineStyle(1,0X666666);
        //graphics.drawRect(0, 0, CELL_SIZE, CELL_SIZE);
        if (_figure == null) {
            //graphics.lineStyle(1,0X666666);
            //graphics.drawRect(0, 0, CELL_SIZE, CELL_SIZE);
        } else {
            //graphics.lineStyle(0,0X000000);
            if (_figure.color.code == ColorValue.RED) {
                //graphics.beginFill(0xFF3366);
            } else {
                //graphics.beginFill(0x3366FF);
            }
            if (_figure.shape.code == ShapeValue.SPHERE) {
                if (_figure.size.code == SizeValue.BIG) {
                    if (_figure.color.code == ColorValue.RED) {
                       addChildTo(new RED_BIG_BALL,3,3);
                    } else {
                        addChildTo(new BLUE_BIG_BALL,3,3);
                    }
                        //graphics.drawCircle(CELL_SIZE/2, CELL_SIZE/2, CELL_SIZE/2);
                } else {
                    if (_figure.color.code == ColorValue.RED) {
                        addChildTo(new RED_SMALL_BALL,3,3);
                    } else {
                        addChildTo(new BLUE_SMALL_BALL,3,3);
                    }

                   // graphics.drawCircle(CELL_SIZE/2, CELL_SIZE/2, CELL_SIZE/2 * 0.7);
                }
            } else {
                if (_figure.size.code == SizeValue.BIG) {
                    if (_figure.color.code == ColorValue.RED) {
                        addChildTo(new RED_BIG_REC,3,3);
                    } else {
                        addChildTo(new BLUE_BIG_REC,3,3);
                    }
                    //graphics.drawRect(0, 0, CELL_SIZE, CELL_SIZE);
                } else {
                    if (_figure.color.code == ColorValue.RED) {
                        addChildTo(new RED_SMALL_REC,3,3);
                    } else {
                        addChildTo(new BLUE_SMALL_REC,3,3);
                    }
                    //graphics.drawRect(CELL_SIZE*0.15 , CELL_SIZE*0.15, CELL_SIZE * 0.7, CELL_SIZE * 0.7);
                }
            }
            //graphics.endFill();
        }

        if(_figure.active){
            graphics.beginFill(0x9999FF, 0.2);
            graphics.drawRect(0, 0, CELL_SIZE, CELL_SIZE);
            graphics.endFill();
        }
    }
}
}
