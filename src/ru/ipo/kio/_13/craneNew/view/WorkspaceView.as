/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 18.11.12
 * Time: 2:25
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.craneNew.view {
import flash.display.Sprite;
import flash.events.MouseEvent;

import ru.ipo.kio._13.craneNew.model.Cube;
import ru.ipo.kio._13.craneNew.model.FieldModel;
import ru.ipo.kio._13.craneNew.view.CubeView;

public class WorkspaceView extends Sprite {

    private var _cubeArray: Array;
    private var _vCubeArray: Array;
    public const ANIMATION_X:int = 12;
    public const ANIMATION_Y:int = 6;
    public const DELAY:int = 200;

    public var cubeArray:Array = new Array();
    public static const BORDER_X:int = 10;
    public static const BORDER_Y: int = 10;
    public static const SpaceBetweenRows: int = 10;
    public static const SpaceBetweenCubes: int = 10;
    public static const StartX: int = 10;
    public static const StartY: int = 10;
//    public static var x:int = 10;



    public function WorkspaceView(cubeAr: Array, viewCubArr: Array) {
        _cubeArray = cubeAr;
        _vCubeArray = viewCubArr;
        graphics.beginFill(0xDDDDDD);
        graphics.drawRect(0, 0, BORDER_X + FieldModel.fieldLength * (CubeView.WIDTH + SpaceBetweenCubes), FieldModel.fieldHeight * CubeView.HEIGHT);
        graphics.endFill();
        graphics.lineStyle(2, 0x000000, .3);
        for (var i:int = 1; i < FieldModel.fieldHeight; i++) {
            graphics.moveTo(0, i * CubeView.HEIGHT);
            graphics.lineTo(BORDER_X + FieldModel.fieldLength * (CubeView.WIDTH + SpaceBetweenRows), i * CubeView.HEIGHT);
        }

        for (var i: int = 1; i < FieldModel.fieldLength; i++) {
            graphics.moveTo(i * (CubeView.WIDTH + SpaceBetweenCubes), 0);
            graphics.lineTo(i * (CubeView.WIDTH + SpaceBetweenCubes), FieldModel.fieldHeight * CubeView.HEIGHT)
        }

        x = StartX;
        y = StartY;
        addEventListener(MouseEvent.CLICK, workspaceClicked)
    }

    private function workspaceClicked(e:MouseEvent):void {
//        trace("clicked");
        var x:int = Xscreen2logical(e.localX);
        var y: int = Yscreen2logical(e.localY);
        if (e.target == e.currentTarget) {

            trace("create Cube");

            _cubeArray.push(new Cube(x, y));
            _vCubeArray.push(new CubeView(_cubeArray[_cubeArray.length - 1]));
            addChild(_vCubeArray[_vCubeArray.length - 1]);

        }
        else
        {
            trace("change color");
      //      e.target.cubeModel.color = Cube.YELLOW;
            changeCubeColor(e.target.cubeModel);

        }
        trace(_cubeArray.toString());
    }



    public function changeCubeColor(cube: Cube): void{
        switch (cube.color){
            case Cube.RED:
                cube.color = Cube.GREEN;
                break;
            case Cube.GREEN:
                cube.color = Cube.YELLOW;
                break;
            case Cube.YELLOW:
                cube.color = Cube.BLUE;
                break;
            case Cube.BLUE:
                cube.color = null;
                var temp: String;
                trace(_cubeArray.toString());
               for (var i: String in _cubeArray){
                  if (_cubeArray[i] == cube){
                      temp = i;
                  }
               }
               if (temp == "0") {
                   _cubeArray.shift();
               }
               else{
                   _cubeArray.splice(temp, temp);

               }

                break;
        }
    }




    public static function Xlogical2screen(x:int):Number {
        return x * (CubeView.WIDTH + SpaceBetweenCubes) + SpaceBetweenCubes /2 ;
    }
    public static function Ylogical2screen(y: int):Number {
        return y * CubeView.HEIGHT;
    }

    public static function Xscreen2logical(x:Number): int {
        return Math.floor(x / (CubeView.WIDTH + SpaceBetweenCubes));
    }
    public static function Yscreen2logical(y: Number): int {
        return Math.floor(y / CubeView.HEIGHT);
    }



}
}
