package ru.ipo.kio._13.crane {

import flash.display.Sprite;
import flash.text.TextField;

import ru.ipo.kio._13.crane.controller.MovingModel;
import ru.ipo.kio._13.crane.model.Crane;

import ru.ipo.kio._13.crane.model.Cube;

import ru.ipo.kio._13.crane.model.FieldModel;
import ru.ipo.kio._13.crane.view.CraneView;
import ru.ipo.kio._13.crane.view.CubeView;
import ru.ipo.kio._13.crane.view.WorkspaceView;

public class CraneMain extends Sprite {
    public function CraneMain() {
    /*    var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);*/


        var model:FieldModel = new FieldModel();
        var view: WorkspaceView = new WorkspaceView();
        var crane: Crane;
        addChild(view);
        var controller: MovingModel = new MovingModel();

        crane = model.addCrane(0, 0);
        view.addCrane(0, 0);

        model.addCube(1, 0, Cube.GREEN);
        view.addCube(1,0, Cube.GREEN);
        model.addCube(2, 3, Cube.YELLOW);
        view.addCube(2,3, Cube.YELLOW);

//        trace(model);
        trace('.....................................');
        controller.CraneDown(crane,view);
        trace('.....................................');
//        trace(model);
        controller.CraneTakeCube(crane,view);
        trace('.....................................');
//        trace(model);
        trace('.....................................');
        trace(view.cubeArray);
        controller.CraneRight(crane, view);
        trace('.....................................');
        trace(view.cubeArray);
        controller.CraneLeft(crane,view);
        trace(view.cubeArray);
        controller.CraneDown(crane, view);
        trace(view.cubeArray);
        controller.CraneUp(crane, view);
        trace(view.cubeArray);
        controller.CraneUp(crane, view);
        trace(view.cubeArray);
        controller.CranePutCube(crane, view);
        trace(crane);
/*        controller.CraneRight(crane, view);
        trace('.....................................');
        controller.CraneRight(crane, view);
        trace(crane);
        trace('.....................................');*/

//        trace(model);

       /* controller.CraneRight();
        trace(model);
        trace('.....................................');
        controller.CraneDown();
        trace(model);
        trace('.....................................');
        controller.CraneTakeCube();
*/





    }
}
}
