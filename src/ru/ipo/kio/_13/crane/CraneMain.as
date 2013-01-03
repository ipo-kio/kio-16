package ru.ipo.kio._13.crane {

import fl.controls.Button;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import ru.ipo.kio._13.crane.controller.Action;

import ru.ipo.kio._13.crane.controller.MovingModel;
import ru.ipo.kio._13.crane.controller.Programm;
import ru.ipo.kio._13.crane.controller.LangModel;
import ru.ipo.kio._13.crane.model.Crane;

import ru.ipo.kio._13.crane.model.Cube;

import ru.ipo.kio._13.crane.model.FieldModel;
import ru.ipo.kio._13.crane.view.CraneView;
import ru.ipo.kio._13.crane.view.CubeView;
import ru.ipo.kio._13.crane.view.WorkspaceView;

public class CraneMain extends Sprite {
    var model:FieldModel = new FieldModel();
    var view: WorkspaceView = new WorkspaceView();
    var crane: Crane;

    var controller: MovingModel;

    var btTest: Button = new Button();
    var inputQueue: TextField = new TextField();
    var main: Programm = new Programm();
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

            controller = new MovingModel(crane,  view, 1000);



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
        btPut.addEventListener(MouseEvent.CLICK, putClick);

        var format:TextFormat = new TextFormat();
        format.font = "Times New Roman";
        format.color = 0x000000;
        format.size = 12;
        format.underline = false;


        addChild(inputQueue);
        inputQueue.background = true;
        inputQueue.border = true;
        inputQueue.defaultTextFormat = format;
        inputQueue.x = view.x + view.width /2 - btUp.width /2 + 2 * btRight.width + btTake.width;
        inputQueue.y = view.y + view.height + btUp.height + btRight.height;
        inputQueue.type = TextFieldType.INPUT;
        inputQueue.width = 200;
        inputQueue.height = 20;


        btTest.label = "test queue";
        btTest.width = 100;
        btTest.x = inputQueue.width + inputQueue.x + 10;
        btTest.y = inputQueue.y;
        addChild(btTest);
        btTest.addEventListener(MouseEvent.CLICK, testClick);

        addChild(view);
        init();


     //   main.push(new Action('R'));
     //   main.push(new Action('R'));
      //  controller.exec();

//        main.push(new Action('P'));



    }

    private function testClick(event:MouseEvent):void {
        var test: LangModel = new LangModel(main);
        test.input = inputQueue.text;
         trace(test.input);
        try {
            //читаем выражение
            test.read_beginning();

            //проверяем, что чтение дошло до конца
            if (test.read() != '$')
                test.errorFunc();

            //если не произошло ошибок, сообщаем, что строка корректна
            trace("строка корректна");
            main.exec(controller);
            trace(crane.toString());
        } catch (error: Error) {
            //если функцией error() было брошено исключение, сообщаем об ошибке и позиции.
            trace("ошибка в позиции ", (test.pos + 1)); // + 1, чтобы считать позиции с 1, а не с 0
        }

    }


    private function upClick(event:MouseEvent):void {
        controller.CraneUp()//crane,view);
    }

    private function leftClick(event:MouseEvent):void {
        controller.CraneLeft()//crane, view);
    }

    private function rigthClick(event:MouseEvent):void {
        controller.CraneRight()//crane, view);
    }

    private function downCLick(event:MouseEvent):void {
        controller.CraneDown()//crane, view);
    }

    private function takeCLick(event:MouseEvent):void {
        controller.CraneTakeCube()//crane, view);
    }

    private function putClick(event:MouseEvent):void {
        controller.CranePutCube()//crane, view);
    }
}
}
