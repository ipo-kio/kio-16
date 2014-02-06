package ru.ipo.kio._14
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

/**
 * ...
 * @author Darya
 */
public class MyMainClass extends Sprite
{
    // Переменная drawing будет определять, рисовать ли линию в данный момент.
    private var drawing:Boolean = false;

    private var mouseStartX:Number;
    private var mouseStartY:Number;

    private var drawingLayer:Sprite;

    public function MyMainClass()
    {
        if (stage) init();
        else addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        var drawingField:Sprite = new Sprite();
        drawingLayer = new Sprite();

        drawingField.graphics.beginFill(0xEEEEEE);
        drawingField.graphics.drawRect(0, 0, 400, 400);
        drawingField.graphics.endFill();

        addChild(drawingField);
        drawingField.addChild(drawingLayer);

        //var field:MyMainClassField = new MyMainClassField();
        //addChild(field);

        //graphics.lineStyle(12, 0, 1);
        //graphics.moveTo(30, 60);
        //graphics.lineTo(100,220);

        // Присвоим ролику события
        addEventListener(MouseEvent.MOUSE_DOWN, startDrawing); //Если мышь нажата, начинает рисовать
        addEventListener(MouseEvent.MOUSE_MOVE, drawIt); // При движении мыши рисует линию
        addEventListener(MouseEvent.MOUSE_UP, stopDrawing); // Если мышь отпущена, прекращает рисовать
    }

    private function startDrawing(event:MouseEvent):void {
//        graphics.lineStyle(12,0,1); //Линия имеет ширину в 12 пикселей, ее цвет = 0 (черный), степень непрозрачности - 1
//        graphics.moveTo(mouseX, mouseY);//Ставим "начало" линии в точку положения курсора
        drawing = true;//Начинаем рисовать
        mouseStartX = event.localX;
        mouseStartY = event.localY;
    }

    private function drawIt (event:MouseEvent):void {
        if(drawing){//Проверка переменной drawing
            drawingLayer.graphics.clear();
            drawingLayer.graphics.lineStyle(12,0,1);
            drawingLayer.graphics.moveTo(mouseStartX, mouseStartY);
            drawingLayer.graphics.lineTo(event.localX,event.localY);//Линия ведется к новой координате
        }
    }

    private function stopDrawing (event:MouseEvent):void {
        drawing = false;//Прекращаем рисовать
    }
}

}