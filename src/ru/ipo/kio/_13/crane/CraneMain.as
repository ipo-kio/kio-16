package ru.ipo.kio._13.crane {

import fl.controls.Button;
import fl.controls.DataGrid;
import fl.controls.dataGridClasses.DataGridColumn;
import fl.data.DataProvider;
import fl.events.DataGridEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import ru.ipo.kio._11_students.CrossedCountry.button;

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

[SWF(width = 800,height = 600)]
public class CraneMain extends Sprite {
    var model:FieldModel = new FieldModel();
    var view: WorkspaceView = new WorkspaceView();
    var crane: Crane;

    var controller: MovingModel;

    var btTest: Button = new Button();
    var btRight: Button = new Button();
    var btUpdate: Button = new Button();
    var btPut: Button = new Button();
    var btTake: Button = new Button();
    var btDown: Button = new Button();
    var btLeft: Button = new Button();
    var btUp: Button = new Button();


    var inputQueue: TextField = new TextField();
    var main: Programm = new Programm();


    var dp:DataProvider = new DataProvider();
    var dg:DataGrid = new DataGrid();
    var dataArray: Array = new Array();
    var dataArrayForDefault: Array = new Array();
    var cubeViewArrayDefault: Array = new Array();
    private var event:MouseEvent = new MouseEvent(String(btUpdate));
    function init(): void{
        for (var i = 0; i < FieldModel.fieldHeight; i++){
            cubeViewArrayDefault[i] = new Array(FieldModel.fieldLength);
        }
        model.addCube(2, 1, Cube.GREEN);
        view.addCube(2, 1, Cube.GREEN);
        model.addCube(1, 3, Cube.BLUE);
        view.addCube(1, 3, Cube.BLUE);
        model.addCube(2, 3, Cube.RED);
        view.addCube(2, 3, Cube.RED);
        model.addCube(2, 4, Cube.GREEN);
        view.addCube(2, 4, Cube.GREEN);
        model.addCube(2, 5, Cube.RED);
        view.addCube(2, 5, Cube.RED);

        controller = new MovingModel(crane,  view, 1000);

        btUp.label = '/\\';
        addChild(btUp);
        btUp.width = 30;
        btUp.x = view.x + view.width /2 - btUp.width / 2;
        btUp.y = view.y + view.height;
        btUp.addEventListener(MouseEvent.CLICK, upClick);

        btLeft.label = '<';
        addChild(btLeft);
        btLeft.width = 30;
        btLeft.x = view.x + view.width /2 - btUp.width / 2 - btLeft.width;
        btLeft.y = view.y + view.height + btUp.height;
        btLeft.addEventListener(MouseEvent.CLICK, leftClick)


        btRight.label = '>';
        addChild(btRight);
        btRight.width = 30;
        btRight.x = view.x + view.width /2 + btUp.width / 2 ;
        btRight.y = view.y + view.height + btUp.height;
        btRight.addEventListener(MouseEvent.CLICK, rigthClick)

        btDown.label = '\\/';
        addChild(btDown);
        btDown.width = 30;
        btDown.x = view.x + view.width /2 - btUp.width /2 ;
        btDown.y = view.y + view.height + btUp.height;
        btDown.addEventListener(MouseEvent.CLICK, downCLick);

        btTake.label = 'take';
        addChild(btTake);
        btTake.width = (btLeft.width + btRight.width + btDown.width) / 2;
        btTake.x = view.x + view.width /2 - btUp.width /2 - btLeft.width ;
        btTake.y = view.y + view.height + btUp.height + btLeft.height;
        btTake.addEventListener(MouseEvent.CLICK, takeCLick);

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


        dg.x = btRight.x - 100;
        dg.y = btTest.y + btTest.height + 10;
        btTest.addEventListener(MouseEvent.CLICK, testClick);
        var btSaveProblem: Button = new Button();
        btSaveProblem.x = dg.x - 200;
        btSaveProblem.y = dg.y;
        btSaveProblem.width = 180;
        btSaveProblem.label = "сохранить расположение";
        addChild(btSaveProblem);
        btSaveProblem.addEventListener(MouseEvent.CLICK, saveProblem)
        var btLoadProblem: Button = new Button();
        btLoadProblem.x = btSaveProblem.x;
        btLoadProblem.y = btSaveProblem.y + btSaveProblem.height;
        btLoadProblem.width = 180;
        btLoadProblem.label = "открыть расположение";
        addChild(btLoadProblem);
        btLoadProblem.addEventListener(MouseEvent.CLICK, loaderProblem)




        addChild(view);





    }

  /*  public function insertArray(): DataProvider{
        var temp, field: Array = new Array();
        var i,  j: int;
        field = model.getArray();
        for (i = 1; i < field. )

    }*/

    public function initModel(){
        view = new WorkspaceView();
        model = new FieldModel();

        crane = model.addCrane(0, 0);
        view.addCrane(0, 0);


        for (var i = 1; i < 6; i++){
            model.addCube(FieldModel.fieldHeight - 1, i, Cube.YELLOW);
            view.addCube(FieldModel.fieldHeight - 1, i, Cube.YELLOW);
        }
    }
    public function CraneMain() {
            trace("поехали");


    /*    var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);*/



        initModel();


        init();
        dg.setSize(300, 300);
        for (var i: int = 0; i < FieldModel.fieldLength; i++){
            dg.addColumn(String(i));
        }




        dg.editable = true;
        dg.enabled = true;



        btUpdate.label = "Оправить данные";
        btUpdate.width = 150;
        btUpdate.x = dg.x + dg.width + 10;
        btUpdate.y = dg.y;
        addChild(btUpdate);
        btUpdate.addEventListener(MouseEvent.CLICK, updateModel);
        addChild(dg);
//        dg.addEventListener(DataGridEvent.ITEM_EDIT_BEGIN, test)
  //      dg.addEventListener(DataGridEvent.ITEM_EDIT_END, changingModel)


        updateData();
        updateModel(event)






     //   main.push(new Action('R'));
     //   main.push(new Action('R'));
      //  controller.exec();

//        main.push(new Action('P'));



    }


    private function testClick(event:MouseEvent):void {
        setDefaults();

        main = new Programm();
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
            main.exec(controller);     //запуск цепочки на выполнение!
            trace(crane.toString());
        } catch (error: Error) {
            trace(error.errorID);
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
    public function updateData(): void{
        dp.merge(model.getArray());
        dp.removeItemAt(FieldModel.fieldHeight);
        dg.dataProvider = dp;
    }

    /*
    private function updateDP(event:MouseEvent):void {
        trace(model.getArray());
        var cubesTemp: Array = new Array();
        cubesTemp = dp.toArray();
        var numRows: int = cubesTemp.length;
        var numCol: int = cubesTemp[0].length;
*//*        for (var i: int = 0; i < view.cubeArray.length; i++)
        for each (var cube: CubeView in view.cubeArray[i]){
            if (cube != null)
                view.delCube(cube);
        }*//*
//        trace(cubesTemp[0][0]);

        cubesTemp.toString();
        for (var i: int = 0; i < numRows; i++)
            for (var j: int = 0; j < numCol; j++){
                //model.deleteCube(i,  j);
                //trace(typeof(cubesTemp[i][j]));
                if typeof(cubesTemp[i][j] == String(String))
                switch (cubesTemp[i][j]){
                    case "ж":
                        trace(cubesTemp[i][j]);
                        model.addCube(i, j, Cube.YELLOW);
                        view.addCube(i, j, Cube.YELLOW);
                        break;
                    case "к":
                        trace(cubesTemp[i][j]);
                        model.addCube(i, j, Cube.RED);
                        view.addCube(i, j, Cube.RED);
                        break;
                    case "г":
                        trace(cubesTemp[i][j]);
                        model.addCube(i, j, Cube.BLUE);
                        view.addCube(i, j, Cube.BLUE);
                        break;
                    case "з":
                        trace(cubesTemp[i][j]);
                        model.addCube(i, j, Cube.GREEN);
                        view.addCube(i, j, Cube.GREEN);
                        break;
                }
            }
        trace(typeof(cubesTemp[2][0]));
        trace(cubesTemp[2][0]);
        trace(model.getArray());
        //updateData();
    }*/
/*    private function changingModel(event: DataGridEvent):void {
        var cubesTemp: Array = new Array();
        cubesTemp = model.getArray();
        trace(event.dataField)
        trace(dp.toArray());
        trace(cubesTemp[event.rowIndex][event.columnIndex]);
        //model.forTests(event.rowIndex, event.columnIndex);
        //trace(event.columnIndex);
//        trace(dg.getCellRendererAt(dg));
    }*/

    private function test(e:DataGridEvent):void {
        trace(e);
    }

    override public function toString():String {
        return super.toString();
    }

    private function updateModel(event:MouseEvent):void {
//     trace(model.getArray());
        var cubesTemp: Array = new Array();
        cubesTemp = model.getArray();
        var numRows: int = cubesTemp.length;
        var numCol: int = cubesTemp[0].length;

        for (var i: int = 0; i < numRows; i++)
            for (var j: int = 0; j < numCol; j++){
                switch (cubesTemp[i][j]){
                    case "ж":
                        model.addCube(i, j, Cube.YELLOW);
                        view.addCube(i, j, Cube.YELLOW);
                        break;
                    case "к":
                        model.addCube(i, j, Cube.RED);
                        view.addCube(i, j, Cube.RED);
                        break;
                    case "г":
                        model.addCube(i, j, Cube.BLUE);
                        view.addCube(i, j, Cube.BLUE);
                        break;
                    case "з":
                        model.addCube(i, j, Cube.GREEN);
                        view.addCube(i, j, Cube.GREEN);
                        break;
                    case "":
                        if (view.cubeArray[i][j] != null){
                            model.deleteCube(i, j);
                            view.delCube(i, j);
                        }
                }
            }
        trace(model.getArray());
        dataArray = dp.toArray();
        for (var i: int = 0; i < dataArray.length; i++)
          for (var j: int = 0; j < dataArray[0].length; j++){
              if (j == 0) {
                  dataArrayForDefault[i] = new Array();
              }
              dataArrayForDefault[i][j] = dataArray[i][j];
          }
    }

    private function saveProblem(event:MouseEvent):void {
        var fileT: FileReference = new FileReference();
        setDefaults();
        fileT.save(dataArrayForDefault, "problem");
    }

    private function setDefaults():void {
        crane.setDefault();
        view.setCraneDefault();
        model.setCubesDefault(dataArrayForDefault);

        for (var i: int = 0; i < FieldModel.fieldHeight; i++)
            for (var j: int = 0; j < FieldModel.fieldLength; j++){

                if ((view.cubeArray[i][j] as CubeView) || (dataArrayForDefault[i][j] as Cube))
                    view.setCubesDefault(dataArrayForDefault[i][j], i, j);
            }

        trace(dataArrayForDefault);
        //dg.dataProvider = dp;

        trace(model.getArray());
    }

    private function loaderProblem(event:MouseEvent):void {
        var fileReferenceLoad:FileReference = new FileReference();
        fileReferenceLoad.addEventListener(Event.SELECT, onFileSelect);
         fileReferenceLoad.browse();
        function onFileSelect(event:Event):void
        {
            fileReferenceLoad.addEventListener(Event.COMPLETE, onComplete);
            fileReferenceLoad.load();
        }
        function onComplete(event:Event):void
        {
            var loaded: String = String(fileReferenceLoad.data);
            trace(loaded);
            var  col: int = 0;
            var row: int =0;
            trace(model.getArray().toString());

            for (var i: int = 0; i < FieldModel.fieldHeight; i++)
                for (var j: int = 0; j < FieldModel.fieldLength; j++){
                            if (view.cubeArray[i][j] != null){
                                model.deleteCube(i, j);
                                view.delCube(i, j);
                            }
                }




            for (var i: int = 0; i < loaded.length - 1; i++){
                //trace(model.getArray().toString());
//                trace(loaded.)
                if (row != 4)
                switch (loaded.charAt(i)){
                    case ",":
                        if (col < FieldModel.fieldLength - 1){
                            col++;
                        } else{
                            row++;
                            col = 0;
                        }
                        break;
                    case "ж":
                        model.addCube(row, col, Cube.YELLOW);
                        view.addCube(row, col, Cube.YELLOW);
                        break;
                    case "к":
                        model.addCube(row, col, Cube.RED);
                        view.addCube(row, col, Cube.RED);
                        break;
                    case "г":
                        model.addCube(row, col, Cube.BLUE);
                        view.addCube(row, col, Cube.BLUE);
                        break;
                    case "з":
                        model.addCube(row, col, Cube.GREEN);
                        view.addCube(row, col, Cube.GREEN);
                        break;
                }

            }
            /*for (var i: int = 0; i < FieldModel.fieldHeight; i++)
                for( var j: int = 0; i < FieldModel.fieldLength; j++){

                }
*/          trace(model.getArray().toString());
            dataArray = model.getArray();
            for (var i: int = 0; i < dataArray.length; i++)
                for (var j: int = 0; j < dataArray[0].length; j++){
                    if (j == 0) {
                        dataArrayForDefault[i] = new Array();
                    }
                    dataArrayForDefault[i][j] = dataArray[i][j];
                }
            trace(dataArrayForDefault.toString());
           // setDefaults();





        }

    }


}
}
