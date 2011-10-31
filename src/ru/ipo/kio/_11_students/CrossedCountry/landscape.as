package ru.ipo.kio._11_students.CrossedCountry {
import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;

/**
 * ...
 * @author Anna
 */
public class landscape extends Sprite {


    public var mShape:LandObj;

    // объекты ландшафта
    public var ObjArray1:Array = new Array(600, 0, 600, 11, 11, 11, 11, 507, 0, 507, 0, 0, "горы");
    public var ObjArray2:Array = new Array(206, 0, 206, 60, 266, 60, 266, 230, 99, 230, 99, 192, 228, 192, 228, 98, 168, 98, 168, 36, 38, 36, 38, 300, 99, 300, 99, 432, 36, 432, 36, 519, -11, 519, -11, 485, 0, 485, 0, 396, 62, 396, 62, 336, 0, 336, 0, 0, "песок");
    public var ObjArray3:Array = new Array(62, 0, 62, 60, 0, 60, 0, 0, "лес"); // координаты объекта относительно заданных для этого объекта начал координат
    public var ObjArray4:Array = new Array(130, 0, 130, 62, 61, 62, 61, 107, 0, 107, 0, 0, "озеро");
    public var ObjArray5:Array = new Array(62, 0, 62, 157, 0, 157, 0, 0, "стена");
    public var ObjArray6:Array = new Array(129, 0, 129, 94, 0, 94, 0, 0, "лес");

    public var ObjArray7:Array = new Array(60, 0, 60, 60, 0, 60, 0, 0, "стена");
    public var ObjArray8:Array = new Array(60, 0, 60, 230, 0, 230, 0, 0, "стена");
    public var ObjArray9:Array = new Array(50, 0, 50, 97, 264, 97, 264, 252, 215, 252, 215, 144, 50, 144, 50, 203, 0, 203, 0, 0, "горы");
    public var ObjArray10:Array = new Array(34, 0, 34, 60, 214, 60, 214, 97, 0, 97, 0, 0, "стена");
    public var ObjArray11:Array = new Array(137, 0, 137, 60, 0, 60, 0, 0, "озеро");

    public var ObjArray12:Array = new Array(260, 0, 260, 50, 215, 50, 215, 38, 0, 38, 0, 0, "песок");
    public var ObjArray13:Array = new Array(37, 0, 37, 252, -7, 252, -7, 192, 0, 192, 0, 0, "песок");
    public var ObjArray14:Array = new Array(58, 0, 58, 337, 0, 337, 0, 0, "стена");
    public var ObjArray15:Array = new Array(120, 0, 120, 48, 0, 48, 0, 0, "горы");
    public var ObjArray16:Array = new Array(45, 0, 45, -50, 48, -50, 48, 1, 36, 1, 36, 72, -120, 72, -120, 36, 0, 36, 0, 0, "песок");
    public var ObjArray17:Array = new Array(36, 0, 36, 51, 156, 51, 156, 170, 0, 170, 0, 133, 119, 133, 119, 87, 0, 87, 0, 0, "песок");

    public var ObjArray18:Array = new Array(120, 0, 120, 48, 0, 48, 0, 0, "лес");
    public var ObjArray19:Array = new Array(119, 0, 119, 47, 0, 47, 0, 0, "горы");
    public var ObjArray20:Array = new Array(12, 0, 12, 480, 0, 480, 0, 0, "горы");
    public var ObjArray21:Array = new Array(36, 0, 36, 51, 156, 51, 156, 230, -145, 230, -145, 192, 36, 192, 36, 146, 119, 146, 119, 86, 0, 86, 0, 0, "песок");
    public var ObjArray22:Array = new Array(121, 0, 121, 51, 0, 51, 0, 0, "лес");
    public var ObjArray23:Array = new Array(177, 0, 177, 62, 94, 62, 94, 108, 0, 108, 0, 0, "озеро");

    public var ObjArray24:Array = new Array(600, 0, 600, 11, 0, 11, 0, 0, "горы");
    public var ObjArray25:Array = new Array(141, 0, 141, 51, 0, 51, 0, 0, "лес");
    public var ObjArray26:Array = new Array(141, 0, 141, -51, 114, -51, 114, -110, 280, -110, 280, 0, 241, 0, 241, -72, 178, -72, 178, 36, 0, 36, 0, 0, "песок");
    public var ObjArray27:Array = new Array(63, 0, 63, 110, 0, 110, 0, 0, "стена");

    public var ArrayObjs:Array = new Array();

    public var ObjsArrays:Array = new Array();
    public var ObjNArray:Array = new Array();
    public var PointCrossArray:Array = new Array();
    public var ArrayCheckObj:Array = new Array();
    public var ArrayWeight:Array = new Array(0.1, 9, 5, 7, 1, 5, 1, 1, 0.1, 1, 7, 9, 9, 1, 0.1, 9, 9, 5, 0.1, 0.1, 9, 5, 7, 0.1, 5, 9, 0.1); // скорость в 1м/ 1мин
    public var interval:uint;
    private var delay:Number = 2000;
    //private var label_txt:String = "болото";
    //public var alt:Sprite = new Sprite();
    public var alt1:Sprite;
    public var ObjIndex:int;
    public var notRemoved:int = 0;
    public var landObjN:LandObj;
    //
    public var land1:LandObj = new LandObj(20, 20, 6, ObjArray1, 0, 0);
    public var land2:LandObj = new LandObj(31, 31, 25, ObjArray2, 588, 529);

    public var land3:LandObj = new LandObj(31, 367, 4, ObjArray3, 588, 194);
    public var land4:LandObj = new LandObj(69, 67, 6, ObjArray4, 552, 493);
    public var land5:LandObj = new LandObj(68, 174, 4, ObjArray5, 552, 384);
    public var land6:LandObj = new LandObj(130, 129, 4, ObjArray6, 491, 429);

    public var land7:LandObj = new LandObj(237, 31, 4, ObjArray7, 380, 529);
    public var land8:LandObj = new LandObj(297, 31, 4, ObjArray8, 322, 529);
    public var land9:LandObj = new LandObj(130, 260, 10, ObjArray9, 491, 300);
    public var land10:LandObj = new LandObj(180, 260, 6, ObjArray10, 441, 299);
    public var land11:LandObj = new LandObj(214, 260, 4, ObjArray11, 400, 299);
    public var land12:LandObj = new LandObj(357, 31, 6, ObjArray12, 260, 529);
    public var land13:LandObj = new LandObj(357, 69, 6, ObjArray13, 263, 493);
    public var land14:LandObj = new LandObj(394, 69, 4, ObjArray14, 225, 492);
    public var land15:LandObj = new LandObj(452, 69, 4, ObjArray15, 168, 492);
    public var land16:LandObj = new LandObj(572, 81, 10, ObjArray16, 48, 479);
    public var land17:LandObj = new LandObj(452, 150, 10, ObjArray17, 168, 410);
    public var land18:LandObj = new LandObj(488, 153, 4, ObjArray18, 132, 407);
    public var land19:LandObj = new LandObj(452, 237, 4, ObjArray19, 168, 322);
    public var land20:LandObj = new LandObj(608, 81, 4, ObjArray20, 11, 505);
    public var land21:LandObj = new LandObj(452, 320, 12, ObjArray21, 167, 780);
    public var land22:LandObj = new LandObj(487, 320, 10, ObjArray22, 134, 780);
    public var land23:LandObj = new LandObj(394, 404, 6, ObjArray23, 225, 697);
    public var land24:LandObj = new LandObj(20, 550, 4, ObjArray24, 0, 1627);
    public var land25:LandObj = new LandObj(66, 463, 4, ObjArray25, 548, 97);
    public var land26:LandObj = new LandObj(66, 514, 12, ObjArray26, 549, 47);
    public var land27:LandObj = new LandObj(244, 440, 4, ObjArray27, 374, 120);


    public var eventX:Number;
    public var eventY:Number;
    public var target:DisplayObjectContainer;
    public var h:Boolean = false;
    public var lMath:LMath = new LMath;

    public var PathLand:Number = 0;
    public var PathTime:Number = 0;

    public function landscape() {
        ArrayObjs.push(land1, land2, land3, land4, land5, land6, land7, land8, land9, land10, land11, land12, land13, land14, land15, land16, land17, land18, land19, land20, land21, land22, land23, land24, land25, land26, land27);
        //ArrayObjs.push(land2);

        // вывод на экран всех объектов
        for (var l:int = 0; l < ArrayObjs.length; l++) {
            addChild(ArrayObjs[l]);
            ObjsArrays.push(ArrayObjs[l].ObjArrXY());
        }

        ArrayCheckObj.push(true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true);

        // вывод на экран сетки
        var grid:gridObj = new gridObj();
        addChild(grid);
    }


    public function eventHandler(e:MouseEvent):void {

        eventX = Main.instance.mouseX;
        eventY = Main.instance.mouseY;

        for (var k:int = 0; k < ArrayObjs.length; k++) {
            if (ArrayObjs[k].mShape.hitTestPoint(Main.instance.mouseX, Main.instance.mouseY, true)) {
                if (ArrayCheckObj[k]) {
                    for (var m:int = 0; m < ArrayCheckObj.length; m++) {
                        if (k != m)
                            ArrayCheckObj[m] = true;
                        else
                            ArrayCheckObj[k] = false;
                    }
                    landObjN = ArrayObjs[k];
                    clearInterval(interval);
                    ObjIndex = k + 1;
                    //drawCap();
                    writeCap();

                    //trace("object " + (k + 1));

                }

            }
        }

    }

    public function writeCap():void {
        clearInterval(interval);

        Main.instance.txt.t3.text = landObjN.ObjA[landObjN.ObjA.length - 1] + "   " + ArrayWeight[ObjIndex - 1] + " м/с";
        Main.instance.txt.t3.setTextFormat(new TextFormat("Greece", 15));
    }

    public function drawCap():void {
        if (notRemoved)
            removeDrawC();

        clearInterval(interval);
        alt1 = new Sprite();

        alt1.graphics.beginFill(0xC1FFC1);
        alt1.graphics.drawRoundRect(0, 0, 100, 100 / 2, 20);
        alt1.graphics.endFill();

        alt1.x = eventX + 10;
        alt1.y = eventY + 15;

        var altFormat:TextFormat = new TextFormat();
        altFormat.font = "arial";
        altFormat.size = 15;

        var label:TextField = new TextField();

        label.setTextFormat(altFormat);
        label.selectable = false;
        label.borderColor = 0x000000;
        label.text = landObjN.ObjA[landObjN.ObjA.length - 1] + "   " + ArrayWeight[ObjIndex - 1] + " м/с";

        label.x = 0;
        label.y = 0;

        //trace(label.text);

        addChild(alt1);
        alt1.addChild(label);
        //trace("add");
        notRemoved = 1;

        interval = setInterval(removeDrawC, delay);


    }


    public function removeDrawC():void {
        //trace("remove");
        clearInterval(interval);
        if (alt1)
            if (alt1.parent != null) {
                this.removeChild(alt1);
                notRemoved = 0;
            }
    }


    public function collisionTest(pointArray:Array):Number {
        PathLand = 0;
        PathTime = 0;

        var i:int;
        var k:int;
        var j:int;
        var lp0:Point = new Point, lp1:Point = new Point, p0:Point = new Point, p1:Point = new Point,colP:Point;
        //var StartP:Point = new Point;
        var StEndPoint:Boolean = false;

        //trace("start path");

        for (k = 0; k < ObjsArrays.length; k++) {
            ObjNArray = ObjsArrays[k];


            for (i = 0; i < pointArray.length - 5; i = i + 3) {

                p0.x = pointArray[i + 1];
                p0.y = pointArray[i + 2];
                p1.x = pointArray[i + 4];
                p1.y = pointArray[i + 5];

                StEndPoint = false;


                if (ArrayObjs[k].mShape.hitTestPoint(p0.x + (Main.instance.x), p0.y + (Main.instance.y), true)) {
                    PointCrossArray.push(p0.x, p0.y);
                    //	trace(p0.x,p0.y);
                    //	trace("начальная точка принадлежит к объекту" + (k+1));
                    StEndPoint = true;
                }

                var h:int = 0;

                for (j = 0; j < ObjNArray.length - 3; j = j + 2) {


                    lp0.x = ObjNArray[j];
                    lp0.y = ObjNArray[j + 1];
                    lp1.x = ObjNArray[j + 2];
                    lp1.y = ObjNArray[j + 3];


                    if (lMath.lineCross(lp0, lp1, p0, p1)) {
                        //trace("пересекает объект" + (k + 1));
                        //trace(PointCrossArray);
                        colP = lMath.lineIntersect(lp0, lp1, p0, p1);

                        //var p:pointer = new pointer(colP.x, colP.y, 0x00ff00,3,0.5);
                        //addChild(p);
                        //trace(colP.x, colP.y);

                        for (var g:int = 0; g < PointCrossArray.length; g = g + 2)
                            if ((PointCrossArray[g] == colP.x) && (PointCrossArray[g + 1] == colP.y))
                                h = 1;
                        if (h != 1)
                            PointCrossArray.push(colP.x, colP.y); // точки пересечения


                    }
                }

                //trace("2 точка" + ArrayObjs[1].mShape.hitTestPoint(p1.x, p1.y, true));

                if (ArrayObjs[k].mShape.hitTestPoint(p1.x + Main.instance.x, p1.y + Main.instance.y, true)) {
                    //trace(p1.x+Main.instance.x);
                    PointCrossArray.push(p1.x, p1.y);
                    StEndPoint = true;
                    //trace("2 точка принадлежит");
                }

                if (PointCrossArray.length == 2)
                    if (StEndPoint != true)
                        PointCrossArray.splice(0);

                //trace(PointCrossArray);

                var m:int;
                var n:int;
                var minX:Number;
                var minY:Number;
                var l:int;
                var min_index:int;
                var min:Number;
                var min0:Number;


                while (PointCrossArray.length != 0) {
                    //trace("pointcross array  "+PointCrossArray);
                    m = 0;
                    minX = PointCrossArray[m];
                    minY = PointCrossArray[m + 1];
                    // нахождение ближайшей точки к началу координат

                    for (l = 2; l < PointCrossArray.length; l = l + 2) {
                        if (PointCrossArray[l] < PointCrossArray[m]) {
                            m = l;
                            minX = PointCrossArray[l];
                            minY = PointCrossArray[l + 1];
                        }


                        else
                        if (PointCrossArray[l] == PointCrossArray[m])
                            if (PointCrossArray[l + 1] < PointCrossArray[m + 1]) {
                                m = l;
                                minY = PointCrossArray[l + 1];
                            }
                    }
                    PointCrossArray.splice(m, 2);


                    min0 = Math.sqrt(Math.pow(minX - PointCrossArray[0], 2) + Math.pow(minY - PointCrossArray[1], 2));
                    min_index = 0;


                    //trace("min0"+min0);

                    for (n = 2; n < PointCrossArray.length; n = n + 2) {

                        min = Math.sqrt(Math.pow(minX - PointCrossArray[n], 2) + Math.pow(minY - PointCrossArray[n + 1], 2));
                        if (min0 > min) {
                            min0 = min;
                            min_index = n;
                        }
                    }


                    PointCrossArray.splice(min_index, 2);
                    //trace("pathland = " + PathLand);
                    PathLand = PathLand + min0;
                    PathTime = PathTime + min0 / ArrayWeight[k];


                }

            }

        }

        return PathLand;

    }

    public function HitObj(HX:Number, HY:Number):int {
        for (var k:int = 0; k < ArrayObjs.length; k++) {
            if (ArrayObjs[k].mShape.hitTestPoint(HX, HY, true)) {
                return k;

            }
        }
        return 0;
    }

}

}