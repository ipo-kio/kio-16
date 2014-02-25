/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 25.02.14
 */
package ru.ipo.kio._14.tarski.view {
import flash.events.MouseEvent;

import org.osmf.events.ContainerChangeEvent;

import ru.ipo.kio._14.tarski.model.Configuration;
import ru.ipo.kio._14.tarski.model.ConfigurationHolder;
import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;

public class ConfigsView extends BasicView {
    public function ConfigsView() {

    }

    public override function update():void{
        graphics.clear();


        var cellSize:int = 23;

        var spaceX:int=123;
        var spaceY:int=150;
        var figH:int=120;

        drawConfigs(ConfigurationHolder.instance.rightExamples, 14, spaceX, 60, spaceY, cellSize, figH);
        drawConfigs(ConfigurationHolder.instance.wrongExamples, 405, spaceX, 60, spaceY, cellSize, figH);

    }

    private function drawConfigs(configs:Vector.<Configuration>, startX:int, spaceX:int, startY:int, spaceY:int, cellSize:int, figH:int):void {

        for (var i:int = 0; i < configs.length; i++) {
            var config:Configuration = configs[i];
            var figX:int = 0;
            var figY:int = 0;
            if (i < 3) {
                figX = startX + i * spaceX;
                figY = startY;
            } else {
                figX = startX + (i - 3) * spaceX;
                figY = startY + spaceY;
            }


            if (config.correct) {
                graphics.lineStyle(5,0x21753A);
                graphics.drawRect(figX-2,figY+2,figH,figH+22);
            }

            for (var x:int = 0; x < config.width; x++) {
                for (var y:int = 0; y < config.depth; y++) {
                    var figure:Figure = config.getFigure(x, y);
                    drawFigure(figure, figX + cellSize * x, figY + figH - (y + 1) * cellSize, cellSize);
                }
            }
        }
    }


    private function calcMaxSize(list:Vector.<Configuration>, maxSize:int):int {
        for (var i:int = 0; i < list.length; i++) {
            var configuration:Configuration = list[i];
            maxSize = Math.max(configuration.width, maxSize);
            maxSize = Math.max(configuration.depth, maxSize);
        }
        return maxSize;
    }

    private function drawFigure(figure:Figure, x:int, y:int, cellSize:int):void {
        if (figure == null) {

        } else {
            graphics.lineStyle(0,0X000000);
            if (figure.color.code == ColorValue.RED) {
                graphics.beginFill(0xFF3366);
            } else {
                graphics.beginFill(0x3366FF);
            }
            if (figure.shape.code == ShapeValue.SPHERE) {
                if (figure.size.code == SizeValue.BIG) {
                    graphics.drawCircle(x+cellSize/2, y+cellSize/2, cellSize/2);
                } else {
                    graphics.drawCircle(x+cellSize/2, y+cellSize/2, cellSize/2 * 0.7);
                }
            } else {
                if (figure.size.code == SizeValue.BIG) {
                    graphics.drawRect(x, y, cellSize, cellSize);
                } else {
                    graphics.drawRect(x+cellSize*0.15 , y+cellSize*0.15, cellSize * 0.7, cellSize * 0.7);
                }
            }
            graphics.endFill();
        }
    }
}
}
