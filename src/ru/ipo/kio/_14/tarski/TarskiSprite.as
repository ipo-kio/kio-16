/**
 * @author: Vasily Akimushkin
 * @since: 31.01.14
 */
package ru.ipo.kio._14.tarski {
import com.adobe.serialization.json.JSON_k;

import flash.net.FileReference;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.engine.TabAlignment;
import flash.utils.ByteArray;

import mx.states.State;

import ru.ipo.kio._14.tarski.model.Configuration;

import ru.ipo.kio._14.tarski.model.ConfigurationHolder;
import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.Statement;
import ru.ipo.kio._14.tarski.model.editor.LogicItemProvider;
import ru.ipo.kio._14.tarski.model.editor.LogicItemProvider1;
import ru.ipo.kio._14.tarski.model.editor.LogicItemProvider2;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator1;
import ru.ipo.kio._14.tarski.model.evaluator.Evaluator2;
import ru.ipo.kio._14.tarski.model.parser.StatementParser1;
import ru.ipo.kio._14.tarski.model.parser.StatementParser2;
import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.view.toolbox.ToolboxView;

import ru.ipo.kio.api.controls.TextButton;
import ru.ipo.kio.base.displays.ShellButton;

public class TarskiSprite extends Sprite {

    private static var _instance:TarskiSprite;


    public static function get instance():TarskiSprite {
        return _instance;
    }


    private var _variableToolboxView:ToolboxView;

    private var _predicateToolboxView:ToolboxView;

    private var _operationToolboxView:ToolboxView;

    private var _statement:Statement;

    private var _logicItemProvider:LogicItemProvider;

    public function TarskiSprite(level:int) {
        _instance=this;

        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0,0,800,600);
        graphics.endFill();

        if(level==1){
            _statement=new Statement(new StatementParser1(), new Evaluator1());
            _logicItemProvider = new LogicItemProvider1();
        }else if (level==2){
            _statement=new Statement(new StatementParser2(), new Evaluator2());
            _logicItemProvider = new LogicItemProvider2();
        }

        _variableToolboxView = new ToolboxView(_logicItemProvider.variables, 200);
        _predicateToolboxView = new ToolboxView(_logicItemProvider.predicates, 300);
        _operationToolboxView = new ToolboxView(_logicItemProvider.operations, 150);

        _variableToolboxView.x=20;
        _variableToolboxView.y=370;
        addChild(_variableToolboxView);

        _predicateToolboxView.x=20+_variableToolboxView.width+20;
        _predicateToolboxView.y=370;
        addChild(_predicateToolboxView);

        _operationToolboxView.x=20+_variableToolboxView.width+20+_predicateToolboxView.width+20;
        _operationToolboxView.y=370;
        addChild(_operationToolboxView);



        _statement.view.x=20;
        _statement.view.y=530;
        addChild(_statement.view);
        _statement.view.update();

        var loadButton:ShellButton = new ShellButton("Загрузить");
        loadButton.x = 10;
        loadButton.y = 5;
        addChild(loadButton);
        loadButton.addEventListener(MouseEvent.CLICK, function(e:Event):void{
            var fileRef:FileReference = new FileReference();
            fileRef.browse();
            fileRef.addEventListener(Event.SELECT, function(e:Event):void {
                fileRef.addEventListener(Event.COMPLETE, function(e:Event):void {
                    var data:ByteArray = fileRef.data;
                    var dataUTF:String = data.readUTFBytes(data.length);
                        ConfigurationHolder.instance.load(dataUTF);
                });
                fileRef.load();
            });
        });

        var clearButton:ShellButton = new ShellButton("Очистить");
        clearButton.x = 100;
        clearButton.y = 5;
        addChild(clearButton);
        clearButton.addEventListener(MouseEvent.CLICK, function(e:Event):void{
            _statement.clear();
        });


        var backspaceButton:ShellButton = new ShellButton("<- Стереть");
        backspaceButton.x = 650;
        backspaceButton.y = 500;
        addChild(backspaceButton);
        backspaceButton.addEventListener(MouseEvent.CLICK, function(e:Event):void{
            _statement.backspace();
        });

    }


    public function get statement():Statement {
        return _statement;
    }

    public function update():void{
        _statement.view.update();
        _variableToolboxView.update();

        graphics.clear();

        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0,0,800,600);
        graphics.endFill();

        var maxSize:int=0;
        maxSize = calcMaxSize(ConfigurationHolder.instance.rightExamples, maxSize);
        maxSize = calcMaxSize(ConfigurationHolder.instance.wrongExamples, maxSize);

        var cellSize:int = 150/maxSize;
        var shiftX:int=30;
        var shiftY:int=30;

        for(var i:int = 0; i<ConfigurationHolder.instance.rightExamples.length; i++){
            var rightConfiguration:Configuration = ConfigurationHolder.instance.rightExamples[i];
            if(rightConfiguration.correct){
                graphics.lineStyle(3,0x66FF33);
                graphics.moveTo(shiftX+i * 200, shiftX);
                graphics.lineTo(shiftX+i * 200+70, shiftY+150);
                graphics.lineTo(shiftX+i * 200+120, shiftY+70);
            }else{
                graphics.lineStyle(3,0xFF6600);
                graphics.moveTo(shiftX+i * 200, shiftY);
                graphics.lineTo(shiftX+i * 200+150, shiftX+150);
            }
            for(var x:int = 0; x<rightConfiguration.width; x++){
                for(var y:int = 0; y<rightConfiguration.depth; y++){
                    var figure:Figure = rightConfiguration.getFigure(x, y);
                    drawFigure(figure, shiftX+x * cellSize + i * 200, shiftY+150 - (y+1) * cellSize, cellSize);
                }
            }
        }

        for(var j:int = 0; j<ConfigurationHolder.instance.wrongExamples.length; j++){
            var wrongConfiguration:Configuration = ConfigurationHolder.instance.wrongExamples[j];
            if(wrongConfiguration.correct){
                graphics.lineStyle(3,0x66FF33);
                graphics.moveTo(shiftX+j * 200, shiftY*2+150);
                graphics.lineTo(shiftX+j * 200+70, shiftY*2+300);
                graphics.lineTo(shiftX+j * 200+120, shiftY*2+70+150);
            }else{
                graphics.lineStyle(3,0xFF6600);
                graphics.moveTo(shiftX+j * 200, shiftY*2+150);
                graphics.lineTo(shiftX+j * 200+150, shiftX*2+300);
            }
            for(var x1:int = 0; x1<wrongConfiguration.width; x1++){
                for(var y1:int = 0; y1<wrongConfiguration.depth; y1++){
                    var figure:Figure = wrongConfiguration.getFigure(x1, y1);
                    drawFigure(figure, shiftX+x1 * cellSize + j * 200, shiftY*2+300 - (y1+1) * cellSize, cellSize);
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
        graphics.lineStyle(1,0X666666);
        graphics.drawRect(x, y, cellSize, cellSize);
        if (figure == null) {
            graphics.lineStyle(1,0X666666);
            graphics.drawRect(x, y, cellSize, cellSize);
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
