package ru.ipo.kio._11_students.CrossedCountry {
import flash.display.*;
import flash.events.*;
import flash.text.TextFormat;

//import org.flashdevelop.utils.FlashConnect;


/**
 * ...
 * @author Anna
 */
public class Main extends Sprite {

    public var pointArray:Array = new Array();
    public var EndP:pointer = new pointer(610, 40, 0xff0000, 5, 1.0);
    public var line:Sprite;
    public var LinesAndPointers:Sprite = new Sprite();
    public var txt:description = new description();
    public var land:landscape = new landscape();
    public var lines:Array = new Array();
    public var k:int = 4;
    public var landpoint:pointer;
    public var newPoint:pointer;

    public var p:int;
    public var ptX:int;
    public var ptY:int;
    public var pi:int;
    public var pointNumber:int = 0;
    public var newPointLine:int = 0;
    public var lineNumber:int = 0;
    public var checkPoint:Boolean;
    public var path:Number;
    public var mouseOver:Boolean = false;
    public var notRemovedNewPoint:Boolean = false;
    public var selectPoint:Boolean = false;
    public var prevPoint:int = 0;
    public var selectline:int = -1;
    public var pickLine:int = -1;
    public var selLine:Array = new Array();
    public var PointDeleted:Boolean = false;
    public var eDragX:int;
    public var eDragY:int;
    public var heroExist:Boolean = false;

    [Embed(source="Background_01.jpg")]
    public static const BG:Class;
    public var bg:* = new BG;
    public var bgSpr:Sprite = new Sprite();

    public static var instance:Main;

    public function Main():void {
        instance = this;

        bgSpr.addChild(bg);
        addChild(bgSpr);
        addChild(txt);
        addChild(land);
        addChild(LinesAndPointers);

        if (stage) init();
        else addEventListener(Event.ADDED_TO_STAGE, init);
    }

    //e.stageX -> this.mouseX, mouseX
    //         -> Main.instance.mouseX
    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        var StartP:pointer = new pointer(30, 540, 0xff0000, 5, 1.0);
        LinesAndPointers.addChild(StartP);
        LinesAndPointers.addChild(EndP);
        pointArray.push(StartP);
        pointArray.push(30, 540);

        land.addEventListener(MouseEvent.CLICK, landPt); // добавление точки
        land.addEventListener(MouseEvent.MOUSE_MOVE, landCap); // добавление подсказки
        this.addEventListener(MouseEvent.MOUSE_MOVE, landLines); // перерисовка линий
        txt.DelLast.addEventListener(MouseEvent.CLICK, del); // удаление последнего шага
        txt.DelSel.addEventListener(MouseEvent.CLICK, delselectedPoint); // удаление выбранной точки
        txt.butHero.addEventListener(MouseEvent.CLICK, StartHero);
        this.addEventListener(MouseEvent.MOUSE_DOWN, DragPoint);
        this.addEventListener(MouseEvent.MOUSE_UP, DropPoint);


        if (txt.deleteLastPoint)
            txt.deleteLastPoint = false;

    }

    private function StartHero(e:MouseEvent):void {
        // test load solution
        deleteAll();
        var arr:Array = new Array(new pointer(30, 540, 0xff0000, 5, 1.0), 30, 540, new pointer(400, 300, 0xff0000, 5, 1.0), 400, 300, new pointer(610, 40, 0xff0000, 5, 1.0), 610, 40);
        loadSol(arr);
        // создание героя

        /*var ar:Array = new Array(30,540,610,40);
         var hero1:hero = new hero(heroExist, pointArray,land);
         this.addChild(hero1);*/
    }

    private function landLines(e:MouseEvent):void {
        if (land.hitTestPoint(mouseX + this.x, mouseY + this.y, true)) {
            if (pointArray[pointNumber].startdr) {
                trace("need to drag lines");
                trace("length array " + pointArray.length);
                pi = pointNumber;

                ptX = mouseX;
                ptY = mouseY;

                pointArray[pi + 1] = ptX;
                pointArray[pi + 2] = ptY;

                DragLines();
            }
        }
    }

    private function landCap(e:MouseEvent):void {
        if (land.hitTestPoint(mouseX, mouseY, true)) {

            DrawNewPoint(e);

            land.eventHandler(e);


        }
        else {
            if (land.notRemoved) {
                land.removeDrawC();
                //
            }

            /*if (notRemovedNewPoint)
             {
             land.removeChild(newPoint);
             notRemovedNewPoint = false;
             trace("deleted point");
             }*/
        }


        /*if (pointArray[pointNumber].startdr)
         {
         trace("need to drag lines");
         trace("length array " + pointArray.length);
         pi = pointNumber;

         ptX = e.stageX;
         ptY = e.stageY;

         pointArray[pi + 1] = ptX;
         pointArray[pi + 2] = ptY;

         DragLines();
         }*/
    }


    private function DrawNewPoint(e:MouseEvent):void {
        if (!notRemovedNewPoint) {
            ptX = (mouseX - mouseX % 10) + 5;
            ptY = (mouseY - mouseY % 10) + 5;


            newPoint = new pointer(ptX, ptY, 0x00ff00, 5, 0.3);

            LinesAndPointers.addChildAt(newPoint, 0);

            notRemovedNewPoint = true;

            newPoint.addEventListener(MouseEvent.CLICK, landPt);

        }
        else {

            newPoint.pt.x = (mouseX - mouseX % 10) + 5 - ptX;
            newPoint.pt.y = (mouseY - mouseY % 10) + 5 - ptY;
        }

    }


    private function landPt(e:MouseEvent):void {
        trace("click on land");
        selectPoint = false;

        if (notRemovedNewPoint) {
            LinesAndPointers.removeChild(newPoint);
            notRemovedNewPoint = false;
        }

        ptX = (mouseX - mouseX % 10) + 5;
        ptY = (mouseY - mouseY % 10) + 5;

        if (selectline == -1) {


            drawPoint();

            PointDeleted = false;

            drawLines();

            pi = pointArray.length - 6;
            pointArray[pi].Dr(land);

            pointArray[pi].pt.addEventListener(MouseEvent.CLICK, PickDel);

            if (pointArray[pi].selPt == 0)
                selectPoint = true;
            else
                pointArray[pi].Dr(land);

        }
        else {
            //trace(pointArray);
            newPointLine = (selectline + 1) * 3;
            //trace("new point line"+ newPointLine);


            drawPoint();
            PointDeleted = false;

            pointArray.splice(newPointLine, 0, landpoint, ptX, ptY);
            LinesAndPointers.removeChild(lines[selectline]);
            lines.splice(selectline, 1);
            selLine.splice(selectline, 1);
            //trace(pointArray);

            k = newPointLine + 1;
            landLine();
            pi = newPointLine;
            pointArray[pi].Dr(land);
            k = pointArray.length - 5;
            pointArray[pi].pt.addEventListener(MouseEvent.CLICK, PickDel);

            if (pointArray[pi].selPt == 0)
                selectPoint = true;
            else
                pointArray[pi].Dr(land);

            path = land.collisionTest(pointArray);
            txt.t1.text = "Длина " + Math.round(path) + " м";
            txt.t1.setTextFormat(new TextFormat("Greece", 15));
            txt.t2.text = "Время " + Math.round(land.PathTime) + " с";
            txt.t2.setTextFormat(new TextFormat("Greece", 15));

            //sel
            if (selectline != -1) {
                ChangeLine(lines[selectline], selectline, 3, 0x000000);
                selLine[selectline]++;
                lines[selectline].addEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
                lines[selectline].addEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);
                selectline = -1;
            }
        }
        // проверка на выбранную точку
        if (selectPoint) {
            for (var i:int = 3; i < pointArray.length - 3; i = i + 3)
                if ((pointArray[i].selPt & 1) != 0) {
                    trace("i =" + i);
                    pointArray[i].pt.graphics.clear();
                    pointArray[i].pt.graphics.beginFill(0x00ff00, 1.0);
                    pointArray[i].pt.graphics.drawCircle(pointArray[i + 1], pointArray[i + 2], 3);
                    pointArray[i].pt.graphics.endFill();
                    pointArray[i].selPt++;
                    pointArray[i].Dr(land);
                }
        }

        // выделение новой точки

        if (pointArray[pi].selPt == 0)
            selectPoint = true;
        pointArray[pi].SelectedPt(e);
        trace("selected point " + pointArray[pi].selPt);

        pointNumber = pi;
    }

    public function PickDel(e:MouseEvent):void {

        trace("delete point");

    }

    private function drawPoint():void {


        landpoint = new pointer(ptX, ptY, 0x00ff00, 3, 1);

        LinesAndPointers.addChild(landpoint);


    }

    private function landLine():void {
        //pointArray.push(EndP, 510, 30);
        var h:int = 0;

        if (PointDeleted)
            h++;

        for (var i:int = k; (i < pointArray.length) && (h < 2); i = i + 3) {
            line = new Sprite();
            line.graphics.lineStyle(3);
            line.x = pointArray[i - 3];
            line.y = pointArray[i - 2];

            line.graphics.lineTo(pointArray[i] - line.x, pointArray[i + 1] - line.y);

            //trace(pointArray[i], pointArray[i + 1]);
            trace(i - 1);
            trace((i - 1) / 3 - 1);
            lines.splice((i - 1) / 3 - 1, 0, line);
            selLine.splice((i - 1) / 3 - 1, 0, 0);
            //
            lineNumber = (i - 1) / 3 - 1;
            lines[lineNumber].addEventListener(MouseEvent.CLICK, SelectLineToDrawNewPoint);
            lines[lineNumber].addEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
            lines[lineNumber].addEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);


            LinesAndPointers.addChildAt(line, h);
            h++;
        }
    }

    private function SelectLineChangeOut(e:MouseEvent):void {

        for (var i:int = 0; i < selLine.length; i++)
            if (((selLine[i] & 1) != 0) && (i != selectline)) {
                trace("Out");
                trace(i);
                trace(lines[i]);
                ChangeLine(lines[i], i, 3, 0x000000);
                selLine[i]++;
            }
        pickLine = -1;

    }

    private function ChangeLine(l:Sprite, index:int, thickness:Number, color:uint):void {
        l.graphics.clear();
        l.graphics.lineStyle(thickness, color);
        trace((index + 1) * 3 + 1);
        l.graphics.lineTo(pointArray[(index + 1) * 3 + 1] - l.x, pointArray[(index + 1) * 3 + 2] - l.y);

        LinesAndPointers.setChildIndex(l, 0);
    }

    private function SelectLineChangeOver(e:MouseEvent):void {


        pickLine = FindLine(e);
        trace("PickLine");
        if (((selLine[pickLine] & 1) == 0) && (pickLine != -1)) {
            trace("Over");
            ChangeLine(lines[pickLine], pickLine, 5, 0x000000);
            selLine[pickLine]++;
        }
        //

    }

    private function FindLine(e:MouseEvent):int {
        for (var i:int = 0; i < lines.length; i++) {
            if (lines[i].hitTestPoint(mouseX + this.x, mouseY + this.y, true)) {
                trace(i);
                return i;
                //
            }
        }
        trace("didn't find");
        return (-1);
    }

    private function SelectLineToDrawNewPoint(e:MouseEvent):void {
        var selL:int = 0;

        if (!selectPoint) {

            if (selectline != -1) {
                ChangeLine(lines[selectline], selectline, 3, 0x000000);
                lines[selectline].addEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
                lines[selectline].addEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);
                trace("delete selecting");
            }
            selL = selectline;
            selectline = FindLine(e);

            if (selectline != -1) {
                if ((selLine[selectline] & 1) == 0) {
                    ChangeLine(lines[selectline], selectline, 3, 0x000000);
                    //selLine[selectline]++;
                    lines[selectline].addEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
                    lines[selectline].addEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);

                }
                else {

                    ChangeLine(lines[selectline], selectline, 5, 0x00ff00);
                    selLine[selectline]++;
                    lines[selectline].removeEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
                    lines[selectline].removeEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);


                }
            }

        }

    }

    private function del(e:MouseEvent):void {
        deletePoint();

        path = land.collisionTest(pointArray);
        txt.t1.text = "Длина " + Math.round(path) + " м";
        txt.t1.setTextFormat(new TextFormat("Greece", 15));
        txt.t2.text = "Время " + Math.round(land.PathTime) + " с";
        txt.t2.setTextFormat(new TextFormat("Greece", 15));
    }

    private function delselectedPoint(e:MouseEvent):void {

        if ((pointArray[pointNumber].selPt & 1) != 0) {
            txt.RemError();
            if (pointArray.length > 9) {
                if (selectline != -1) {
                    ChangeLine(lines[selectline], selectline, 3, 0x000000);
                    selLine[selectline]++;
                    lines[selectline].addEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
                    lines[selectline].addEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);
                    selectline = -1;
                }

                PointDeleted = true;

                trace("length array " + pointArray.length);
                trace("lines = " + lines.length);
                LinesAndPointers.removeChild(pointArray[pointNumber]);
                pointArray.splice(pointNumber, 3);

                LinesAndPointers.removeChild(lines[pointNumber / 3 - 1]);
                LinesAndPointers.removeChild(lines[pointNumber / 3]);
                lines.splice(pointNumber / 3 - 1, 2);
                selLine.splice(pointNumber / 3 - 1, 2);
                //	pointArray.push(EndP, 510, 30);

                k = pointNumber + 1;
                trace("k = " + k);
                trace("lines = " + lines.length);
                landLine();
                //	k = k - 3;
                trace(" k 2 = " + k);
                trace("length array " + pointArray.length);
                trace("delete point");
                trace("lines = " + lines.length);
                trace(pointArray);
                PointDeleted = false;

            }
            else
            if (pointArray.length == 9) {
                LinesAndPointers.removeChild(pointArray[pointArray.length - 6]);
                pointArray.splice(pointArray.length - 6, 6);
                LinesAndPointers.removeChild(lines.pop());
                LinesAndPointers.removeChild(lines.pop());

                if (selectline != -1) {
                    ChangeLine(lines[selectline], selectline, 3, 0x000000);
                    selLine[selectline]++;
                    lines[selectline].addEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
                    lines[selectline].addEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);
                    selectline = -1;
                }
                selLine.pop();
                selLine.pop();

                //	pointArray.push(EndP, 510, 30);
                land.PathTime = 0;
                k = 4;
                prevPoint = pointNumber;
                pointNumber = 0;

                trace("delete selected point");
            }

            path = land.collisionTest(pointArray);
            txt.t1.text = "Длина " + Math.round(path) + " м";
            txt.t1.setTextFormat(new TextFormat("Greece", 15));
            txt.t2.text = "Время " + Math.round(land.PathTime) + " с";
            txt.t2.setTextFormat(new TextFormat("Greece", 15));

        }
        else {
            txt.AdError();
        }


    }

    private function deletePoint():void {
        if (pointArray.length > 9) {
            if (selectline != -1) {
                ChangeLine(lines[selectline], selectline, 3, 0x000000);
                selLine[selectline]++;
                lines[selectline].addEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
                lines[selectline].addEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);
                selectline = -1;
            }

            trace("length array " + pointArray.length);
            trace("lines = " + lines.length);
            trace(" k = " + k);
            k = pointArray.length - 5;

            LinesAndPointers.removeChild(pointArray[pointArray.length - 6]);
            pointArray.splice(pointArray.length - 6, 6);
            LinesAndPointers.removeChild(lines.pop());
            LinesAndPointers.removeChild(lines.pop());

            selLine.pop();
            selLine.pop();
            pointArray.push(EndP, 610, 40);

            landLine();
            k = k - 3;
            trace("length array " + pointArray.length);
            trace("lines = " + lines.length);
            pointNumber = 0;

        }
        else
        if (pointArray.length == 9) {
            if (selectline != -1) {
                ChangeLine(lines[selectline], selectline, 3, 0x000000);
                selLine[selectline]++;
                lines[selectline].addEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
                lines[selectline].addEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);
                selectline = -1;
            }	 // удаление выбранного отрезка

            LinesAndPointers.removeChild(pointArray[pointArray.length - 6]);
            pointArray.splice(pointArray.length - 6, 6);
            LinesAndPointers.removeChild(lines.pop());
            LinesAndPointers.removeChild(lines.pop());

            selLine.pop();
            selLine.pop();
            land.PathTime = 0;
            prevPoint = pointNumber;
            pointNumber = 0;
            k = 4;

        }
        else
            trace("no points");
    }

    private function DragPoint(e:MouseEvent):void {
        var b:Boolean = false;

        trace("length array " + pointArray.length);
        selectPoint = false;
        trace(FindLine(e));
        if ((!txt.DelSel.hitTestPoint(mouseX, mouseY, true))) {

            prevPoint = pointNumber;
            //pointNumber = 0;

            trace("drag on field");
            // цикл: чтоб найти точку
            for (var i:int = 3; i < pointArray.length - 3 && (!b); i = i + 3) {
                b = pointArray[i].CheckPick();
                if (b) {
                    trace("вы попали на точку " + i);
                    trace("length array " + pointArray.length);

                    pointNumber = i;
                    selectPoint = true;

                    eDragX = (mouseX - mouseX % 10) + 5;
                    eDragY = (mouseY - mouseY % 10) + 5;


                }


            }

        }
    }

    private function DragLines():void {
        var h:int = 0;
        trace("drag lines");
        trace(pi);


        LinesAndPointers.removeChild(lines[pi / 3 - 1 ]);
        LinesAndPointers.removeChild(lines[pi / 3]);
        lines.splice(pi / 3 - 1, 2);
        selLine.splice(pi / 3 - 1, 2);
        //trace(lines);

        for (var i:int = pi + 1; (i < pointArray.length) && (h < 2); i = i + 3) {
            line = new Sprite();
            trace("new line");
            line.graphics.lineStyle(3);
            line.x = pointArray[i - 3];
            line.y = pointArray[i - 2];

            line.graphics.lineTo(pointArray[i] - line.x, pointArray[i + 1] - line.y);

            //trace(pointArray[i], pointArray[i + 1]);

            LinesAndPointers.addChildAt(line, h);

            lines.splice(pi / 3 - 1 + h, 0, line);
            selLine.splice(pi / 3 - 1 + h, 0, 0);
            trace(selLine);

            lineNumber = pi / 3 - 1 + h;
            lines[lineNumber].addEventListener(MouseEvent.CLICK, SelectLineToDrawNewPoint);
            lines[lineNumber].addEventListener(MouseEvent.MOUSE_OVER, SelectLineChangeOver);
            lines[lineNumber].addEventListener(MouseEvent.MOUSE_OUT, SelectLineChangeOut);
            //trace(lines + h + i+ pointArray.length);
            h++;
        }
        //trace(h);
    }

    public function DropPoint(e:MouseEvent):void {
        var h:int = 0;
        var b:Boolean;


        if (!txt.DelSel.hitTestPoint(mouseX, mouseY, true)) {

            ptX = (mouseX - mouseX % 10) + 5;
            ptY = (mouseY - mouseY % 10) + 5;


            trace("drop on field");

            if (notRemovedNewPoint) {
                LinesAndPointers.removeChild(newPoint);
                trace("delete");
            }

            notRemovedNewPoint = false;

            if (((eDragX != ptX) || (eDragY != ptY) || (!selectPoint))) {
                trace("dropping on field");
                for (pi = 3; pi < pointArray.length - 3; pi = pi + 3) {
                    b = pointArray[pi].Check();

                    if (b) {
                        prevPoint = pointNumber;
                        pointNumber = pi;
                        //trace(pointArray[pi].pt.x, pointArray[pi].pt.y);
                        //trace(pointArray[pi].pX,pointArray[pi].pY);
                        //trace(pointArray[pi + 1], pointArray[pi + 2]);
                        //trace(pointArray[pi].pX - pointArray[pi + 1], pointArray[pi].pY - pointArray[pi + 2]);

                        ptX = pointArray[pi].pX;
                        ptY = pointArray[pi].pY;

                        LinesAndPointers.removeChild(pointArray[pi]);
                        drawPoint();
                        pointArray.splice(pi, 3, landpoint, ptX, ptY);

                        pointArray[pi].Dr(land);
                        pointArray[pi].pt.addEventListener(MouseEvent.CLICK, PickDel);


                        DragLines();


                    }
                }


                path = land.collisionTest(pointArray);
                txt.t1.text = "Длина " + Math.round(path) + " м";
                txt.t1.setTextFormat(new TextFormat("Greece", 15));
                txt.t2.text = "Время " + Math.round(land.PathTime) + " с";
                txt.t2.setTextFormat(new TextFormat("Greece", 15));
                trace("путь" + path);
                trace(pointNumber);


            }
            else {
                if (selectPoint) {
                    for (var i:int = 3; i < pointArray.length - 3; i = i + 3)
                        if ((pointArray[i].selPt & 1) != 0) {
                            trace("i =" + i);
                            pointArray[i].pt.graphics.clear();
                            pointArray[i].pt.graphics.beginFill(0x00ff00, 1.0);
                            pointArray[i].pt.graphics.drawCircle(pointArray[i + 1], pointArray[i + 2], 3);
                            pointArray[i].pt.graphics.endFill();
                            pointArray[i].selPt++;
                            pointArray[i].Dr(land);
                        }
                }
                trace("selected point " + pointArray[pointNumber].selPt);
                pointArray[pointNumber].SelectedPt(e);
                trace("selected point " + pointArray[pointNumber].selPt);
//                TODO uncomment
//                selectPoint = pointArray[pointNumber].selPt & 1 != 0;
                trace("selected");


            }
        }
    }

    private function drawLines():void {
        if (pointArray.length == 3) {
            pointArray.push(landpoint);
            pointArray.push(ptX, ptY);

            pointArray.push(EndP, 610, 40);


            landLine();
        }
        else {
            k = k + 3;
            pointArray.splice(pointArray.length - 3, 3, landpoint, ptX, ptY);
            LinesAndPointers.removeChild(lines.pop());
            selLine.pop();
            pointArray.push(EndP, 610, 40);

            k = pointArray.length - 5;
            landLine();

        }


        trace("path  = " + path);
        path = land.collisionTest(pointArray);
        txt.t1.text = "Длина " + Math.round(path) + " м";
        txt.t1.setTextFormat(new TextFormat("Greece", 15));
        txt.t2.text = "Время " + Math.round(land.PathTime) + " с";
        txt.t2.setTextFormat(new TextFormat("Greece", 15));

    }

    public function getPathTime():Number {
        return Math.round(land.PathTime);
    }

    public function getPath():Number {
        return Math.round(path);
    }

    public function deleteAll():void {
        var Arr:int = pointArray.length;
        for (var i:int = 0; i < (Arr - 6) / 3; i++) {
            deletePoint();
            trace(pointArray);
        }

        path = 0;
        land.PathTime = 0;
        txt.t1.text = "Длина " + Math.round(path) + " м";
        txt.t1.setTextFormat(new TextFormat("Greece", 15));
        txt.t2.text = "Время " + Math.round(land.PathTime) + " с";
        txt.t2.setTextFormat(new TextFormat("Greece", 15));

    }

    public function loadSol(solPoints:Array):void {
        trace("load solution");
        selectPoint = false;
        //removeChild(LinesAndPointers);
        //LinesAndPointers = new Sprite();

        for (var i:int = 4; i < solPoints.length - 3; i = i + 3) {
            ptX = solPoints[i];

            ptY = solPoints[i + 1];
            //pointArray.push(solPoints[i-1],solPoints[i],solPoints[i+1]);
            trace(pointArray);
            drawPoint();

            PointDeleted = false;

            drawLines();

            pi = pointArray.length - 6;
            pointArray[pi].Dr(land);

            pointArray[pi].pt.addEventListener(MouseEvent.CLICK, PickDel);

            if (pointArray[pi].selPt == 0)
                selectPoint = true;
            else
                pointArray[pi].Dr(land);
        }


    }


}

}