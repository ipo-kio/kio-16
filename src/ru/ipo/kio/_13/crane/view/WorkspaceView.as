/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 18.11.12
 * Time: 2:25
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.SetIntervalTimer;
import flash.utils.clearInterval;
import flash.utils.clearTimeout;
import flash.utils.setInterval;
import flash.utils.setTimeout;

import ru.ipo.kio._13.crane.model.Crane;
import ru.ipo.kio._13.crane.model.Cube;

import ru.ipo.kio._13.crane.model.FieldModel;

public class WorkspaceView extends Sprite {
    public const ANIMATION_X = 12;
    public const ANIMATION_Y = 6;
    public const DELAY = 200;
    public static var craneView:CraneView = new CraneView();
    public var cubeArray:Array = new Array();
    public static const BORDER_X:int = 10;
    public static const BORDER_Y = 10;
    public static const SpaceBetweenRows = 10;
    public static const SpaceBetweenCubes = 10;
    public static const StartX = 10;
    public static const StartY = 10;
    public static var x:int = 10;
    public var craneForHandle:Crane;
    public var bound:int;
    private static var _busy:Boolean = false;
    public var s:Array = new Array();
    public var event:Event = new Event(Event.ENTER_FRAME);

    public function isBusy():Boolean {
        return _busy;
    }

    public function WorkspaceView() {
        for (var i = 0; i < FieldModel.fieldHeight; i++) {
            cubeArray[i] = new Array(FieldModel.fieldLength);
        }
        for (var i = 0; i < FieldModel.fieldHeight; i++) {
            for (var j = 0; j < FieldModel.fieldHeight; j++)
                cubeArray[i][j] = null;
        }
        graphics.beginFill(0xDDDDDD);
        graphics.drawRect(0, 0, BORDER_X + FieldModel.fieldLength * (CubeView.WIDTH + SpaceBetweenCubes), FieldModel.fieldHeight * CubeView.HEIGHT);
        graphics.endFill();
        graphics.lineStyle(2, 0x000000, .3);
        for (var i = 1; i < FieldModel.fieldHeight; i++) {
            graphics.moveTo(0, i * CubeView.HEIGHT);
            graphics.lineTo(BORDER_X + FieldModel.fieldLength * (CubeView.WIDTH + SpaceBetweenCubes), i * CubeView.HEIGHT);
        }

        for (var i = 1; i < FieldModel.fieldLength; i++) {
            graphics.moveTo(i * (CubeView.WIDTH + SpaceBetweenCubes), 0);
            graphics.lineTo(i * (CubeView.WIDTH + SpaceBetweenCubes), FieldModel.fieldHeight * CubeView.HEIGHT)
        }

        this.x = StartX;
        this.y = StartY;

    }

    public function addCrane(row:int, col:int):void {
        addChild(craneView);
        craneView.y = row * CubeView.HEIGHT - CraneView.DY;
        craneView.x = col * (CubeView.WIDTH + SpaceBetweenCubes) + SpaceBetweenCubes / 2 - CraneView.DX;
    }

    public function delCube(i, j:int):void {
        removeChild(cubeArray[i][j]);
        cubeArray[i][j] = null;
    }

    public function setCraneDefault() {
        craneView.y = 0 * CubeView.HEIGHT - CraneView.DY;
        craneView.x = 0 * (CubeView.WIDTH + SpaceBetweenCubes) + SpaceBetweenCubes / 2 - CraneView.DX;
    }

    public function addCube(row:int, col:int, color:int):void {
        cubeArray[row][col] = new CubeView(color);
        addChild(cubeArray[row][col]);
        cubeArray[row][col].y = row * CubeView.HEIGHT;
        cubeArray[row][col].x = col * (CubeView.WIDTH + SpaceBetweenCubes) + SpaceBetweenCubes / 2;
    }

//    --------------------------------
//    в перемещении кубиков смотрим где был кран до перемещения (там и кубик)
//    -----------------------------------

    public function craneMoveRight(crane:Crane):void {
        craneForHandle = crane;
        s.push(setInterval(func, DELAY, "right"));
    }

    public function func():void {
        if (!craneView.hasEventListener(Event.ENTER_FRAME)) {
            switch (arguments[0]){
                case "right":
                    if (FieldModel.craneMoveRight(craneForHandle)){
                        craneView.addEventListener(Event.ENTER_FRAME, moveRight);
                        bound = craneView.x + CubeView.WIDTH + SpaceBetweenCubes;
                        moveRight(event);
                    }
                    break;
                case "left":
                    if (FieldModel.craneMoveLeft(craneForHandle)){
                        craneView.addEventListener(Event.ENTER_FRAME, moveLeft);
                        bound = craneView.x - CubeView.WIDTH - SpaceBetweenCubes;
                        moveLeft(event);
                    }
                    break;
                case "down":
                    if (FieldModel.craneMoveDown(craneForHandle)){
                        craneView.addEventListener(Event.ENTER_FRAME, moveDown);
                        bound = craneView.y + CubeView.HEIGHT;
                        moveDown(event);
                    }
                    break;
                case "up":
                    if (FieldModel.craneMoveUp(craneForHandle)){
                        craneView.addEventListener(Event.ENTER_FRAME, moveUp);
                        bound = craneView.y - CubeView.HEIGHT;
                        moveUp(event);
                    }
                    break;
                case "take":
                    if (FieldModel.craneTakeCube(craneForHandle)){
                        craneView.addEventListener(Event.ENTER_FRAME, takeCube);
                        takeCube(event);
                    }
                    break;
                case "put":
                    if (FieldModel.cranePutCube(craneForHandle)){
                        craneView.addEventListener(Event.ENTER_FRAME, putCube);
                        putCube(event);
                    }
                    break;
            }
            clearInterval(s[0]);
            s.shift();
            trace(s.toString());

        }
    }

    private function moveRight(event:Event):void {
        craneView.x += ANIMATION_X;

        if (craneForHandle.hasCube) {
            cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1].x += ANIMATION_X;
        }
        //WATCHOUT NEED TO ADD animation WITH CUBES-----------------------------------------------------

        if (craneView.x > bound) {

            if (craneForHandle.hasCube){
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1].x -= craneView.x - bound
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j] = new CubeView(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1].getColor());
                addChild(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j]);
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].x = cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1].x;
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].y = cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1].y;
                removeChild(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1]);
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1] = null;
            }
            craneView.removeEventListener(Event.ENTER_FRAME, moveRight);
            craneView.x = bound;
        }
        //tested
    }


    public function craneMoveLeft(crane:Crane):void {
        craneForHandle = crane;
        s.push(setInterval(func, DELAY, "left"));
    }
    public function moveLeft(event: Event):void{
        craneView.x -= ANIMATION_X;
        if (craneForHandle.hasCube) {
            cubeArray[craneForHandle.pos.i][craneForHandle.pos.j + 1].x -= ANIMATION_X;
        }
        if (craneView.x < bound) {


            if (craneForHandle.hasCube){
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j + 1].x -= craneView.x - bound; //поправка от смещения
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j] = new CubeView(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j + 1].getColor());
                addChild(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j]);
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].x = cubeArray[craneForHandle.pos.i][craneForHandle.pos.j + 1].x;
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].y = cubeArray[craneForHandle.pos.i][craneForHandle.pos.j + 1].y;
                removeChild(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j + 1]);
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j + 1] = null;
            }
            craneView.removeEventListener(Event.ENTER_FRAME, moveLeft);
            craneView.x = bound;

        }
    }

    public function craneMoveDown(crane:Crane):void {
        craneForHandle = crane;
        s.push(setInterval(func, DELAY, "down"));
    }

    public function moveDown(event: Event){
        craneView.y += ANIMATION_Y;

        if (craneForHandle.hasCube) {
            cubeArray[craneForHandle.pos.i - 1][craneForHandle.pos.j].y += ANIMATION_Y;

        }

        if (craneView.y > bound) {

            if (craneForHandle.hasCube){
                cubeArray[craneForHandle.pos.i - 1][craneForHandle.pos.j].y -= craneView.y - bound;
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j] = new CubeView(cubeArray[craneForHandle.pos.i - 1][craneForHandle.pos.j].getColor());
                addChild(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j]);
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].x = cubeArray[craneForHandle.pos.i - 1][craneForHandle.pos.j].x;
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].y = cubeArray[craneForHandle.pos.i - 1][craneForHandle.pos.j].y;
                removeChild(cubeArray[craneForHandle.pos.i - 1][craneForHandle.pos.j]);
                cubeArray[craneForHandle.pos.i - 1][craneForHandle.pos.j] = null;
            }
            craneView.removeEventListener(Event.ENTER_FRAME, moveDown);
            craneView.y = bound;
        }

    }

    public function craneMoveUp(crane:Crane):void {
        craneForHandle = crane;
        s.push(setInterval(func, DELAY, "up"));
    }

    public function moveUp(event: Event):void{
        craneView.y -= ANIMATION_Y;
        if (craneForHandle.hasCube) {
            cubeArray[craneForHandle.pos.i + 1][craneForHandle.pos.j].y -= ANIMATION_Y;

        }
        if (craneView.y < bound) {

            if (craneForHandle.hasCube){
                cubeArray[craneForHandle.pos.i + 1][craneForHandle.pos.j].y -= craneView.y - bound;
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j] = new CubeView(cubeArray[craneForHandle.pos.i + 1][craneForHandle.pos.j].getColor());
                addChild(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j]);
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].x = cubeArray[craneForHandle.pos.i + 1][craneForHandle.pos.j].x;
                cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].y = cubeArray[craneForHandle.pos.i + 1][craneForHandle.pos.j].y;
                removeChild(cubeArray[craneForHandle.pos.i + 1][craneForHandle.pos.j]);
                cubeArray[craneForHandle.pos.i + 1][craneForHandle.pos.j] = null;
            }
            craneView.removeEventListener(Event.ENTER_FRAME, moveUp);
            craneView.y = bound;
        }
    }

    public function craneTakeCube(crane:Crane):void {
        craneForHandle = crane;
        s.push(setInterval(func, DELAY, "take"));

    }
    public function takeCube(event:Event): void{
// NOTHING to do here by now
        craneView.removeEventListener(Event.ENTER_FRAME, takeCube);
    }

    public function cranePutCube(crane:Crane):void {
        craneForHandle = crane;
        s.push(setInterval(func, DELAY, "put"));
    }

    public function putCube(event: Event): void{
// NOTHING to do here by now
        craneView.removeEventListener(Event.ENTER_FRAME, putCube);
    }


    public function setCubesDefault(data:Cube, i, j:int):void {

        if (cubeArray[i][j] != null) {
            removeChild(cubeArray[i][j]);
            cubeArray[i][j] = null;
        }
        if (data != null) {
            addCube(i, j, data.color);
        }


    }

    public function get busy():Boolean {
        return _busy;
    }

    public function set busy(value:Boolean):void {
        _busy = value;
    }
}
}
