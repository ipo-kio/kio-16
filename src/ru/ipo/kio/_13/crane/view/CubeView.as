/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 18.11.12
 * Time: 2:09
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.view {
import flash.display.Sprite;

public class CubeView extends  Sprite{
    [Embed(source="../resources/cubes/cube_GREEN.png")]
    private static var _cube_GREEN:Class;
    [Embed(source="../resources/cubes/cube_GREY.png")]
    private static var _cube_GREY:Class;
    [Embed(source="../resources/cubes/cube_RED.png")]
    private static var _cube_RED:Class;
    [Embed(source="../resources/cubes/cube_YELLOW.png")]
    private static var _cube_Yellow:Class;

    public static const WIDTH: int = 113;
    public static const HEIGHT: int = 65;



    public function CubeView(color: String) {
        switch (color){
            case "red":
                var cube =  new _cube_RED;
                break;
            case "green":
                var cube =  new _cube_GREEN;
                break;
            case "yellow":
                var cube =  new _cube_Yellow;
                break;
            case "grey":
                var cube =  new _cube_GREY;
                break;
        }
        addChild(cube);
    }



    public static function get cube_GREY():Class {
        return _cube_GREY;
    }

    public static function get cube_RED():Class {
        return _cube_RED;
    }

    public static function get cube_Yellow():Class {
        return _cube_Yellow;
    }
}
}
