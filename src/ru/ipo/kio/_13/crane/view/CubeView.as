/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 18.11.12
 * Time: 2:09
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.view {
import flash.display.Sprite;

import ru.ipo.kio._13.crane.model.Cube;

public class CubeView extends  Sprite{
    [Embed(source="../resources/cubes/cube_GREEN.png")]
    private static var _cube_GREEN:Class;
    [Embed(source="../resources/cubes/cube_GREY.png")]
    private static var _cube_GREY:Class;
    [Embed(source="../resources/cubes/cube_RED.png")]
    private static var _cube_RED:Class;
    [Embed(source="../resources/cubes/cube_YELLOW.png")]
    private static var _cube_Yellow:Class;
    private var color: int;            //нужен для перерисовки кубиков при движении
    public static const WIDTH: int = 113;
    public static const HEIGHT: int = 65;



    public function CubeView(Cubes_color: int) {
        color = Cubes_color;
        switch (Cubes_color){
            case Cube.RED:
                var cube =  new _cube_RED;
                break;
            case Cube.GREEN:
                var cube =  new _cube_GREEN;
                break;
            case Cube.YELLOW:
                var cube =  new _cube_Yellow;
                break;
            case Cube.GREY:
                var cube =  new _cube_GREY;
                break;
        }
        addChild(cube);
    }

   public function getColor(): int{
       return color;
   }

    public override function toString():String {
        return super.toString() + "{color=" + String(color) + "}";
    }
}
}
