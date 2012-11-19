package ru.ipo.kio._13.crane {

import fl.controls.Button;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.ipo.kio._13.crane.controller.MovingModel;
import ru.ipo.kio._13.crane.model.Crane;

import ru.ipo.kio._13.crane.model.Cube;

import ru.ipo.kio._13.crane.model.FieldModel;
import ru.ipo.kio._13.crane.view.CraneView;
import ru.ipo.kio._13.crane.view.CubeView;
import ru.ipo.kio._13.crane.view.WorkspaceView;

public class CraneMain extends Sprite {
    var model:FieldModel = new FieldModel();
    var view: WorkspaceView = new WorkspaceView();
    var controller: MovingModel = new MovingModel();
    var crane: Crane;
    public function CraneMain() {

        function init(): void{
            crane = model.addCrane(0, 0);
            view.addCrane(0, 0);


            for (var i = 0; i < FieldModel.fieldLength; i++){
                model.addCube(FieldModel.fieldHeight - 1, i, Cube.YELLOW);
                view.addCube(FieldModel.fieldHeight - 1, i, Cube.YELLOW);
            }
            model.addCube(2, 1, Cube.GREEN);
            view.addCube(2, 1, Cube.GREEN);
            model.addCube(1, 3, Cube.GREY);
            view.addCube(1, 3, Cube.GREY);
            model.addCube(2, 3, Cube.RED);
            view.addCube(2, 3, Cube.RED);
            model.addCube(2, 4, Cube.GREEN);
            view.addCube(2, 4, Cube.GREEN);
            model.addCube(2, 5, Cube.RED);
            view.addCube(2, 5, Cube.RED);





        }

    /*    var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);*/







        var btUp: Button = new Button();
        btUp.label = '/\\';
        addChild(btUp);
        btUp.width = 30;
        btUp.x = view.x + view.width /2 - btUp.width / 2;
        btUp.y = view.y + view.height;
        btUp.addEventListener(MouseEvent.CLICK, upClick);

        var btLeft: Button = new Button();
        btLeft.label = '<';
        addChild(btLeft);
        btLeft.width = 30;
        btLeft.x = view.x + view.width /2 - btUp.width / 2 - btLeft.width;
        btLeft.y = view.y + view.height + btUp.height;
        btLeft.addEventListener(MouseEvent.CLICK, leftClick)

        var btRight: Button = new Button();
        btRight.label = '>';
        addChild(btRight);
        btRight.width = 30;
        btRight.x = view.x + view.width /2 + btUp.width / 2 ;
        btRight.y = view.y + view.height + btUp.height;
        btRight.addEventListener(MouseEvent.CLICK, rigthClick)

        var btDown: Button = new Button();
        btDown.label = '\\/';
        addChild(btDown);
        btDown.width = 30;
        btDown.x = view.x + view.width /2 - btUp.width /2 ;
        btDown.y = view.y + view.height + btUp.height;
        btDown.addEventListener(MouseEvent.CLICK, downCLick);

        var btTake: Button = new Button();
        btTake.label = 'take';
        addChild(btTake);
        btTake.width = (btLeft.width + btRight.width + btDown.width) / 2;
        btTake.x = view.x + view.width /2 - btUp.width /2 - btLeft.width ;
        btTake.y = view.y + view.height + btUp.height + btLeft.height;
        btTake.addEventListener(MouseEvent.CLICK, takeCLick);

        var btPut: Button = new Button();
        btPut.label = 'put';
        addChild(btPut);
        btPut.width = (btLeft.width + btRight.width + btDown.width) / 2;
        btPut.x = view.x + view.width /2 - btUp.width /2 - btLeft.width + btTake.width ;
        btPut.y = view.y + view.height + btUp.height + btLeft.height;
        btPut.addEventListener(MouseEvent.CLICK, putClick)


        addChild(view);
        init();



    }


    private function upClick(event:MouseEvent):void {
        controller.CraneUp(crane,view);
    }

    private function leftClick(event:MouseEvent):void {
        controller.CraneLeft(crane, view);
    }

    private function rigthClick(event:MouseEvent):void {
        controller.CraneRight(crane, view);
    }

    private function downCLick(event:MouseEvent):void {
        controller.CraneDown(crane, view);
    }

    private function takeCLick(event:MouseEvent):void {
        controller.CraneTakeCube(crane, view);
    }

    private function putClick(event:MouseEvent):void {
        controller.CranePutCube(crane, view);
    }
}
}
