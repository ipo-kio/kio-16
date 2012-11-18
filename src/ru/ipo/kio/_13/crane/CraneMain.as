package ru.ipo.kio._13.crane {

import flash.display.Sprite;
import flash.text.TextField;

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
        addChild(view);


        model.addCrane(0, 1);
        view.addCrane(1, 1);

        model.addCube(1, 1, Cube.GREEN);
        view.addCube(1,1, "yellow");
     //   trace(view.cubeArray);



        trace(model);
/*
        trace(scene.craneMoveDown());
        trace(scene);
        trace(scene.craneMoveDown());
        trace(scene);
        trace(scene.craneMoveUp());
*/

        trace(model);
        trace(model.craneMoveUp());
        trace(model);

    }
}
}
