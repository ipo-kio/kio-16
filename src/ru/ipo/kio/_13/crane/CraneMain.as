package ru.ipo.kio._13.crane {

import flash.display.Sprite;
import flash.text.TextField;

import ru.ipo.kio._13.crane.model.Cube;

import ru.ipo.kio._13.crane.model.FieldModel;

public class CraneMain extends Sprite {
    public function CraneMain() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);


        var scene:FieldModel = new FieldModel();

//        scene.test(1,2);
        scene.addCrane(0, 1);
        scene.addCube(1, 1, Cube.GREEN);
        trace(scene);
/*
        trace(scene.craneMoveDown());
        trace(scene);
        trace(scene.craneMoveDown());
        trace(scene);
        trace(scene.craneMoveUp());
*/
        trace(scene.craneTakeCube());
        trace(scene);
        trace(scene.craneMoveUp());

    }
}
}
