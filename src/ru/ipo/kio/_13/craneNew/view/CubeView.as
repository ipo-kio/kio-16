/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 18.11.12
 * Time: 2:09
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.craneNew.view {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._13.craneNew.model.Cube;

public class CubeView extends  Sprite{
    [Embed(source="../resources/cubes/cube_GREEN.png")]
    private static var _cube_GREEN:Class;
    [Embed(source="../resources/cubes/cube_GREY.png")]
    private static var _cube_BLUE:Class;
    [Embed(source="../resources/cubes/cube_RED.png")]
    private static var _cube_RED:Class;
    [Embed(source="../resources/cubes/cube_YELLOW.png")]
    private static var _cube_Yellow:Class;

//   private var color: int;            //нужен для перерисовки кубиков при движении
    public static const WIDTH: int = 60;
    public static const HEIGHT: int = 30;
    private var cube;

    private var _cubeModel: Cube;

    public function CubeView(cubeModel: Cube) {
        _cubeModel = cubeModel;
        switch (_cubeModel.color){
            case Cube.RED:
                cube =  new _cube_RED;
                break;
            case Cube.GREEN:
                cube =  new _cube_GREEN;
                break;
            case Cube.YELLOW:
                cube =  new _cube_Yellow;
                break;
            case Cube.BLUE:
                cube =  new _cube_BLUE;
                break;
        }
        addChild(cube);

        move();
        _cubeModel.addEventListener(Cube.EVENT_COLOR_CHANGED, changeColor)


    }

    public function move():void{
        x = WorkspaceView.Xlogical2screen(_cubeModel.i);
        y = WorkspaceView.Ylogical2screen(_cubeModel.j);
    }

    private function changeColor(e:Event):void {
        removeChild(cube);
        switch (_cubeModel.color){
            case Cube.RED:
                cube =  new _cube_RED;
                addChild(cube);
                break;
            case Cube.GREEN:
                cube =  new _cube_GREEN;
                addChild(cube);
                break;
            case Cube.YELLOW:
                cube =  new _cube_Yellow;
                addChild(cube);
                break;
            case Cube.BLUE:
                cube =  new _cube_BLUE;
                addChild(cube);
                break;
            case 0:
//                 cube = null;

        }

    }

    public function get cubeModel():Cube {
        return _cubeModel;
    }
}
}
