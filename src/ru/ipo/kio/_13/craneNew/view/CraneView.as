/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 06.02.13
 * Time: 3:29
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.craneNew.view {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._13.craneNew.model.Crane;
import ru.ipo.kio._13.craneNew.model.MyEvent;
import ru.ipo.kio._13.craneNew.view.WorkspaceView;

public class CraneView extends Sprite {

    [Embed(source="../resources/crane.png")]
    private static var CranePic:Class;
    public static const WIDTH = 67;
    public static const HEIGHT = 49;
    public static const DX = Math.round((WIDTH - CubeView.WIDTH) / 2);
    public static const DY = (HEIGHT - CubeView.HEIGHT) + 17;         //   WATCH OUT



    private var _crane:Crane;
    private var _sequence: Array = new Array();
    private var _currentFrame: int = 0;
    private var _moveFrom: int = -1;

    private  static const FRAMES_TO_MOVE: int = 40;

    public function CraneView(crane:Crane) {
        _crane = crane;
        _crane.addEventListener(Crane.EVENT_CRANE_POSITION_CHANGED, startMoveAnimated)
        var v = new CranePic;
        addChild(v);
        move();
    }

    private function move():void {
        x = WorkspaceView.Xlogical2screen(_crane.j) /*+ WorkspaceView.SpaceBetweenCubes / 2*/ - CraneView.DX;
        y = WorkspaceView.Ylogical2screen(_crane.i) - CraneView.DY;


    }


    private function startMoveAnimated(event: MyEvent):void {
        if (_moveFrom < 0){

        }

    }
}
}
