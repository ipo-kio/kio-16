/**
 * @author: Vasily Akimushkin
 * @since: 31.01.14
 */
package ru.ipo.kio._14.tarski.view {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import ru.ipo.kio._13.checker.KioChecker;
import ru.ipo.kio._14.tarski.FigureToolbox;
import ru.ipo.kio._14.tarski.TarskiSprite;
import ru.ipo.kio._14.tarski.TarskiSpriteLevel0;

import ru.ipo.kio._14.tarski.model.Configuration;
import ru.ipo.kio._14.tarski.model.Figure;

public class ConfigurationView extends BasicView{

    private var configuration:Configuration;

    private var _bin:Bin = new Bin();

    public function ConfigurationView(configuration:Configuration) {
        this.configuration = configuration;

        addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
            deactivateAll();
        });
    }


    public  function stopActivate(figure:Figure, x:int, y:int){
        if(checkPoint(_bin, x+figure.view.x, y+figure.view.y)){
            configuration.removeFigure(figure);
        }else{
            var xc:int = Math.floor((x+figure.view.x)/FigureView.CELL_SIZE);
            var yc:int = 7-Math.floor((y+figure.view.y)/FigureView.CELL_SIZE);
            if(xc<8 && yc<8&&yc>=0&&xc>=0 && configuration.getFigure(xc, yc)==null){
                figure.x = xc;
                figure.y = yc;
                if(configuration.figures.indexOf(figure)<0){
                    configuration.addFigure(figure);
                }

            }
        }

        figure.view.stopDrag();
        deactivateAll();



        update();
        TarskiSpriteLevel0.instance.check();
    }

    private function checkPoint(sprite:Sprite, x:int, y:int):Boolean{
        return sprite.x<x&&x<=sprite.x+sprite.width&&
               sprite.y<y&&y<=sprite.y+sprite.height;
    }

    public function activate(figure:Figure){
        deactivateAll();
        figure.active=true;
        figure.view.update();
        figure.view.startDrag(false,new Rectangle(0,0, width+FigureView.CELL_SIZE, height-FigureView.CELL_SIZE));
    }

    private function deactivateAll(){
        for(var x:int = 0; x<configuration.width; x++){
            for(var y:int = 0; y<configuration.depth; y++){
                var figure:Figure = configuration.getFigure(x, y);
                if(figure!=null){
                    figure.active=false;
                    figure.view.update();
                }
            }
        }
     }




    public override function update():void{
        clearAll();
        graphics.clear();

        addChild(_bin);
        _bin.x = FigureView.CELL_SIZE*8;
        _bin.y = FigureView.CELL_SIZE*4;
        _bin.update();

        for(var x:int = 0; x<configuration.width; x++){
            for(var y:int = 0; y<configuration.depth; y++){
                graphics.beginFill(0xFFFFFF,1);
                graphics.lineStyle(1,0X666666);
                graphics.drawRect(x*FigureView.CELL_SIZE, y*FigureView.CELL_SIZE, FigureView.CELL_SIZE, FigureView.CELL_SIZE);
                graphics.endFill();
                var figure:Figure = configuration.getFigure(x, y);
                if(figure!=null){
                    addChild(figure.view);
                    figure.view.x = x * FigureView.CELL_SIZE;
                    figure.view.y = FigureView.CELL_SIZE*8 - (y+1) * FigureView.CELL_SIZE;
                    figure.view.update()
                }
            }
        }

        addChild(createTool("bC",8 * FigureView.CELL_SIZE, (3-0) * FigureView.CELL_SIZE));
        addChild(createTool("bS",9 * FigureView.CELL_SIZE, (3-0) * FigureView.CELL_SIZE));
        addChild(createTool("rC",8 * FigureView.CELL_SIZE, (3-1) * FigureView.CELL_SIZE));
        addChild(createTool("rS",9 * FigureView.CELL_SIZE, (3-1) * FigureView.CELL_SIZE));
        addChild(createTool("bc",8 * FigureView.CELL_SIZE, (3-2) * FigureView.CELL_SIZE));
        addChild(createTool("bs",9 * FigureView.CELL_SIZE, (3-2) * FigureView.CELL_SIZE));
        addChild(createTool("rc",8 * FigureView.CELL_SIZE, (3-3) * FigureView.CELL_SIZE));
        addChild(createTool("rs",9 * FigureView.CELL_SIZE, (3-3) * FigureView.CELL_SIZE));



    }


    private function createTool(code:String, x:int, y:int):FigureView {
        var _figure:Figure = Figure.createFigureByCode(0, 0, code);
        _figure.view.update();
        _figure.view.x=x;
        _figure.view.y=y;
        return FigureView(_figure.view);
    }





}
}
