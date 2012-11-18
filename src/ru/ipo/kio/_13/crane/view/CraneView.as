/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 04.11.12
 * Time: 14:00
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.view {

import flash.display.Sprite;

import ru.ipo.kio._13.crane.model.Crane;

public class CraneView extends Sprite{


    [Embed(source="../resources/crane.png")]
    private static var CranePic:Class;
    public static const WIDTH = 120;
    public static const HEIGHT = 87;
    public static const DX = Math.round((WIDTH - CubeView.WIDTH) / 2);
    public static const DY = (HEIGHT - CubeView.HEIGHT) + 42;         //   WATCH OUT
    public function CraneView() {
       var _crane =  new CranePic;
       addChild(_crane);

    }




}

}
