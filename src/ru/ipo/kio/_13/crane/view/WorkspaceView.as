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

public class WorkspaceView extends Sprite{
        public static var craneView: CraneView = new CraneView();
        public var cubeArray: Array = new Array();
        public static const BORDER_X: int = 10;
        public static const BORDER_Y = 10;
        public static const SpaceBetweenRows = 10;
        public static const SpaceBetweenCubes = 10;
        public static const StartX = 10;
        public static const StartY = 10;
        public static var x: int = 10;
        public var craneForHandle: Crane;
        public var bound: int;
        private static var _busy: Boolean = false;
        public var s: Array = new Array();
       public var event: Event = new Event(Event.ENTER_FRAME);

       public function isBusy(): Boolean{
           return _busy;
       }

        public function WorkspaceView() {
            for (var i = 0; i < FieldModel.fieldHeight; i++){
                cubeArray[i] = new Array(FieldModel.fieldLength);
            }
            for (var i = 0; i < FieldModel.fieldHeight; i++){
                for (var j = 0; j < FieldModel.fieldHeight; j++)
                cubeArray[i][j] = null;
            }
            graphics.beginFill(0xDDDDDD);
            graphics.drawRect(0, 0, BORDER_X + FieldModel.fieldLength * (CubeView.WIDTH + SpaceBetweenCubes), FieldModel.fieldHeight * CubeView.HEIGHT);
            graphics.endFill();
            graphics.lineStyle(2, 0x000000, .3);
            for (var i = 1; i < FieldModel.fieldHeight; i++){
                graphics.moveTo(0, i * CubeView.HEIGHT);
                graphics.lineTo(BORDER_X + FieldModel.fieldLength * (CubeView.WIDTH + SpaceBetweenCubes), i * CubeView.HEIGHT);
            }

            for (var i = 1; i < FieldModel.fieldLength; i++){
                graphics.moveTo(i * (CubeView.WIDTH + SpaceBetweenCubes), 0);
                graphics.lineTo(i * (CubeView.WIDTH + SpaceBetweenCubes), FieldModel.fieldHeight * CubeView.HEIGHT)
            }

            this.x = StartX;
            this.y = StartY;

        }

    public function addCrane(row: int,  col: int): void{
        addChild(craneView);
        craneView.y = row * CubeView.HEIGHT - CraneView.DY;
        craneView.x = col * (CubeView.WIDTH + SpaceBetweenCubes) + SpaceBetweenCubes / 2 - CraneView.DX;
    }
    public function delCube(i, j: int): void{
        removeChild(cubeArray[i][j]);
        cubeArray[i][j] = null;
    }
    public function setCraneDefault(){
        craneView.y = 0 * CubeView.HEIGHT - CraneView.DY;
        craneView.x = 0 * (CubeView.WIDTH + SpaceBetweenCubes) + SpaceBetweenCubes / 2 - CraneView.DX;
    }
    public function addCube(row: int,  col: int, color: int): void{
        cubeArray[row][col] = new CubeView(color);
        addChild(cubeArray[row][col]);
        cubeArray[row][col].y = row * CubeView.HEIGHT;
        cubeArray[row][col].x = col * (CubeView.WIDTH + SpaceBetweenCubes) + SpaceBetweenCubes / 2;
    }

//    --------------------------------
//    в перемещении кубиков смотрим где был кран до переещения (там и кубик)
//    -----------------------------------

    public function craneMoveRight(crane: Crane): void{
           craneForHandle = crane;
          if (craneView.hasEventListener(Event.ENTER_FRAME)){
              s.push((setInterval(funcRight, 20, s.length)));
          }
        else
          {
           craneView.addEventListener(Event.ENTER_FRAME, moveRight);
              bound = craneView.x + CubeView.WIDTH + SpaceBetweenCubes;
              moveRight(event);
          }
    }
    public function funcRight():void{
           trace(arguments[0]);
            if (!craneView.hasEventListener(Event.ENTER_FRAME))  {
                craneView.addEventListener(Event.ENTER_FRAME, moveRight);
                bound = craneView.x + CubeView.WIDTH + SpaceBetweenCubes;
                moveRight(event);
                clearInterval(s[arguments[0]]);

            }
        }

    private function moveRight(event:Event):void {
        _busy = true;
          craneView.x += 8;

        if (craneForHandle.hasCube){
            cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1].x += CubeView.WIDTH + SpaceBetweenCubes;
            cubeArray[craneForHandle.pos.i][craneForHandle.pos.j] = new CubeView(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1].getColor());
            addChild(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j]);
            cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].x = cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1].x;
            cubeArray[craneForHandle.pos.i][craneForHandle.pos.j].y = cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1].y;
            removeChild(cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1]);
            cubeArray[craneForHandle.pos.i][craneForHandle.pos.j - 1] = null;

        }
        if (craneView.x > bound){
                           _busy = false;
            craneView.removeEventListener(Event.ENTER_FRAME, moveRight);
            craneView.x = bound;

        }
               //tested
    }


    public function craneMoveLeft(crane: Crane): void{
        craneView.x -= CubeView.WIDTH + SpaceBetweenCubes;
        if (crane.hasCube){
            cubeArray[crane.pos.i][crane.pos.j + 1].x -= CubeView.WIDTH + SpaceBetweenCubes;
            cubeArray[crane.pos.i][crane.pos.j] = new CubeView(cubeArray[crane.pos.i][crane.pos.j + 1].getColor());
            addChild(cubeArray[crane.pos.i][crane.pos.j]);
            cubeArray[crane.pos.i][crane.pos.j].x = cubeArray[crane.pos.i][crane.pos.j + 1].x;
            cubeArray[crane.pos.i][crane.pos.j].y = cubeArray[crane.pos.i][crane.pos.j + 1].y;
            removeChild(cubeArray[crane.pos.i][crane.pos.j + 1]);
            cubeArray[crane.pos.i][crane.pos.j + 1] = null;
        }
    }
    public function craneMoveDown(crane: Crane): void{
        craneView.y += CubeView.HEIGHT;
        if (crane.hasCube){
            cubeArray[crane.pos.i - 1][crane.pos.j].y += CubeView.HEIGHT;
            cubeArray[crane.pos.i][crane.pos.j] = new CubeView(cubeArray[crane.pos.i - 1][crane.pos.j].getColor());
            addChild(cubeArray[crane.pos.i][crane.pos.j]);
            cubeArray[crane.pos.i][crane.pos.j].x = cubeArray[crane.pos.i - 1][crane.pos.j].x;
            cubeArray[crane.pos.i][crane.pos.j].y = cubeArray[crane.pos.i - 1][crane.pos.j].y;
            removeChild(cubeArray[crane.pos.i - 1][crane.pos.j]);
            cubeArray[crane.pos.i - 1][crane.pos.j] = null;
        }

    }
    public function craneMoveUp(crane: Crane): void{
        craneView.y -= CubeView.HEIGHT;
        if (crane.hasCube){
            cubeArray[crane.pos.i + 1][crane.pos.j].y -= CubeView.HEIGHT;
            cubeArray[crane.pos.i][crane.pos.j] = new CubeView(cubeArray[crane.pos.i + 1][crane.pos.j].getColor());
            addChild(cubeArray[crane.pos.i][crane.pos.j]);
            cubeArray[crane.pos.i][crane.pos.j].x = cubeArray[crane.pos.i + 1][crane.pos.j].x;
            cubeArray[crane.pos.i][crane.pos.j].y = cubeArray[crane.pos.i + 1][crane.pos.j].y;
            removeChild(cubeArray[crane.pos.i + 1][crane.pos.j]);
            cubeArray[crane.pos.i + 1][crane.pos.j] = null;
        }
    }
    public function craneTakeCube(crane: Crane): void{
// NOTHING to do here by now
    }
    public function cranePutCube(crane: Crane): void{
// NOTHING to do here by now
    }


    public function setCubesDefault(data: Cube, i, j: int):void {

            if (cubeArray[i][j] != null) {
                removeChild(cubeArray[i][j]);
                cubeArray[i][j] = null;
            }
            if (data != null){
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
