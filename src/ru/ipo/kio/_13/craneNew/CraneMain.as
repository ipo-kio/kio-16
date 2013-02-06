/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 05.02.13
 * Time: 23:11
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.craneNew {
import fl.controls.Button;

import flash.display.Sprite;
import flash.events.MouseEvent;

import ru.ipo.kio._13.craneNew.model.Crane;

import ru.ipo.kio._13.craneNew.model.Cube;
import ru.ipo.kio._13.craneNew.model.FieldModel;
import ru.ipo.kio._13.craneNew.view.CraneView;
import ru.ipo.kio._13.craneNew.view.CubeView;


import ru.ipo.kio._13.craneNew.view.WorkspaceView;


public class CraneMain extends Sprite{
    public var cubeArray: Array = new Array();
    public var vCubeArray: Array = new Array();
    public var workView: WorkspaceView = new WorkspaceView(cubeArray, vCubeArray);
    public var crane = new Crane(0, 0);
    public var vCrane = new CraneView(crane);
    internal var btTest: Button = new Button();
    internal var btRight: Button = new Button();
    internal var btUpdate: Button = new Button();
    internal var btPut: Button = new Button();
    internal var btTake: Button = new Button();
    internal var btDown: Button = new Button();
    internal var btLeft: Button = new Button();
    internal var btUp: Button = new Button();


    public function CraneMain() {

        CraneProblem();


    }
    public function CraneProblem():void {
        addChild(workView);
        cubeArray.push(new Cube(1, 1));
        vCubeArray.push(new CubeView(cubeArray[cubeArray.length - 1]));
        workView.addChild(vCubeArray[vCubeArray.length - 1]);
        workView.addChild(vCrane);
        trace(cubeArray.toString());



        btUp.label = '/\\';
        addChild(btUp);
        btUp.width = 30;
        btUp.x = workView.x + workView.width /2 - btUp.width / 2;
        btUp.y = workView.y + workView.height;
        btUp.addEventListener(MouseEvent.CLICK, upClick);

        btLeft.label = '<';
        addChild(btLeft);
        btLeft.width = 30;
        btLeft.x = workView.x + workView.width /2 - btUp.width / 2 - btLeft.width;
        btLeft.y = workView.y + workView.height + btUp.height;
        btLeft.addEventListener(MouseEvent.CLICK, leftClick);


        btRight.label = '>';
        addChild(btRight);
        btRight.width = 30;
        btRight.x = workView.x + workView.width /2 + btUp.width / 2 ;
        btRight.y = workView.y + workView.height + btUp.height;
        btRight.addEventListener(MouseEvent.CLICK, rightClick);

        btDown.label = '\\/';
        addChild(btDown);
        btDown.width = 30;
        btDown.x = workView.x + workView.width /2 - btUp.width /2 ;
        btDown.y = workView.y + workView.height + btUp.height;
        btDown.addEventListener(MouseEvent.CLICK, downCLick);

        btTake.label = 'take';
        addChild(btTake);
        btTake.width = (btLeft.width + btRight.width + btDown.width) / 2;
        btTake.x = workView.x + workView.width /2 - btUp.width /2 - btLeft.width ;
        btTake.y = workView.y + workView.height + btUp.height + btLeft.height;
        btTake.addEventListener(MouseEvent.CLICK, takeCLick);

        btPut.label = 'put';
        addChild(btPut);
        btPut.width = (btLeft.width + btRight.width + btDown.width) / 2;
        btPut.x = workView.x + workView.width /2 - btUp.width /2 - btLeft.width + btTake.width ;
        btPut.y = workView.y + workView.height + btUp.height + btLeft.height;
        btPut.addEventListener(MouseEvent.CLICK, putClick);

    }


    private function upClick(event:MouseEvent):void {

    }

    private function leftClick(event:MouseEvent):void {

    }

    private function rightClick(event:MouseEvent):void {
        if (possibleMove(crane.i,  crane.j + 1) && !searchCube(crane.i - 1, crane.j + 1)){
           trace("можно");
            crane.j++;
       }
           else{
            trace("cannot");
        }
    }

    private function possibleMove(i:int, j:int):Boolean {
        if (i >= 0 && i < FieldModel.fieldHeight && j >= 0 && j < FieldModel.fieldLength){
            return true;
        }
        return false;
    }

    private function downCLick(event:MouseEvent):void {
    }

    private function takeCLick(event:MouseEvent):void {
    }

    private function putClick(event:MouseEvent):void {

    }


    public function searchCube(i:int, j:int):Boolean {
        if (i >= 0 && j < FieldModel.fieldLength && i < FieldModel.fieldHeight && j >= 0) {
            for each (var cube:Cube in cubeArray) {
                if ((cube.i == i) && (cube.j == j)) {
                    return true;
                }
            }
        }
        return false;
    }
}
}
