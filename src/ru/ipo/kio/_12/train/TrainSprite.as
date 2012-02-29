/**
 *
 * @author: Vasily Akimushkin
 * @since: 17.02.12
 */
package ru.ipo.kio._12.train {

import fl.controls.DataGrid;
import fl.controls.dataGridClasses.DataGridColumn;
import fl.controls.listClasses.CellRenderer;
import fl.events.DataGridEvent;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;


import flash.text.TextFormat;

import ru.ipo.kio._12.train.model.Automation;

import ru.ipo.kio._12.train.model.AutomationStep;

import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.util.TrafficNetworkCreator;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.displays.ShellButton;

public class TrainSprite extends Sprite {

    [Embed(source='_resources/bg_left.png')]
    private static const LEFT_BACKGROUNG:Class;

    [Embed(source='_resources/zero/Background_01.png')]
    private static const LEVEL_0_BACKGROUNG:Class;

    [Embed(source='_resources/one/Background.png')]
    private static const LEVEL_1_BACKGROUNG:Class;

    [Embed(source='_resources/label.png')]
    private static const LABEL:Class;

    public function TrainSprite(level:int, readonly:Boolean, id:String = null) {
        var api:KioApi = KioApi.instance(id ? id : TrainProblem.ID);

        TrafficNetwork.instance.api = api;
        
        var leftBackground = new LEFT_BACKGROUNG;
        addChild(leftBackground);

        var background;
        if (level == 2) {
            background = new LEVEL_1_BACKGROUNG;
        } else if (level == 0 || level == 1) {
            background = new LEVEL_0_BACKGROUNG;
        } else {
            throw new Error("Undefined level: " + level);
        }

        background.x = 130;
        background.y = 0;
        addChild(background);
        addChild(TrafficNetwork.instance.view);

//       if (!readonly)
//            textField.type = TextFieldType.INPUT;
//
//        textField.addEventListener(Event.CHANGE, function(e:Event):void {
//            api.autoSaveSolution();
//        });


       // if(level == 0 || level ==1){
            addButtonsForZeroFirstLevel(level);
        //}else{
         //  addButtonsForSecondLevel();
          // addGrid();
        //}

    }

    private function addButtonsForZeroFirstLevel(level:int):void {
        var loc:Object = KioApi.getLocalization(TrainProblem.ID);

        var tf:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tf.width = 130;
        tf.htmlText = "<p align='center'>" + loc.headers.edit + "</p>";
        tf.x = 0;
        tf.y = 10;
        addChild(tf);



        var tfAnimation:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tfAnimation.width = 130;
        tfAnimation.htmlText = "<p align='center'>" + loc.headers.animation + "</p>";
        tfAnimation.x = 0;
        tfAnimation.y = 165-28;
        addChild(tfAnimation);

        if(level==2){
            tfAnimation.y += 20;
        }


        var tfResult:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tfResult.width = 130;
        tfResult.htmlText = "<p align='center'>" + loc.headers.result + "</p>";
        tfResult.x = 0;
        tfResult.y = 375-18;
        addChild(tfResult);


        var tfRecord:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tfRecord.width = 130;
        tfRecord.htmlText = "<p align='center'>" + loc.headers.record + "</p>";
        tfRecord.x = 0;
        tfRecord.y = 470-18;
        addChild(tfRecord);

        createButton(loc.buttons.clear_routes, 15, 38, function (event:MouseEvent) {
            TrafficNetwork.instance.clearRoutes();
        });

        createButton(loc.buttons.remove_last, 15, 88, function (event:MouseEvent) {
            TrafficNetwork.instance.removeLastFromActive();
        });

        if(level!=2)
        {
        createButton(loc.buttons.play, 15, 165, function (event:MouseEvent) {
            TrafficNetwork.instance.play();
        });
        }

        createButton(loc.buttons.step, 15, 214, function (event:MouseEvent) {
            TrafficNetwork.instance.step();
        });

        createButton(loc.buttons.result, 15, 265, function (event:MouseEvent) {
            TrafficNetwork.instance.calc();
        });

        createButton(loc.buttons.init, 15, 314, function (event:MouseEvent) {
            TrafficNetwork.instance.initial();
        });


        var label1 = new LABEL;
        var label2 = new LABEL;
        label1.x=15;
        label2.x=15;
        label1.y=375;
        label2.y=470;
        addChild(label1);
        addChild(label2);


        var tfAmountLabel:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tfAmountLabel.width = 130;
        tfAmountLabel.htmlText = "<p align='center'>" + loc.headers.amounts + "</p>";
        tfAmountLabel.x = 0;
        tfAmountLabel.y = 375;
        addChild(tfAmountLabel);

        var tfAmount:TextField = new TextField();
        tfAmount.background = false;
        tfAmount.x = 15;
        tfAmount.y = 390;
        tfAmount.width = 100;
        tfAmount.height = 20;
        addChild(tfAmount);
        tfAmount.htmlText = "<p align='center'>0</p>";
        TrafficNetworkCreator.instance.resultAmount = tfAmount;

        var tfTimeLabel:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tfTimeLabel.width = 130;
        tfTimeLabel.htmlText = "<p align='center'>" + loc.headers.time + "</p>";
        tfTimeLabel.x = 0;
        tfTimeLabel.y = 405;
        addChild(tfTimeLabel);

        var tfTime:TextField = new TextField();
        tfTime.background = false;
        tfTime.x = 15;
        tfTime.y = 420;
        tfTime.width = 100;
        tfTime.height = 20;
        tfTime.htmlText = "<p align='center'>0</p>";
        addChild(tfTime);
        TrafficNetworkCreator.instance.resultTime = tfTime;





        var tfAmountLabel1:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tfAmountLabel1.width = 130;
        tfAmountLabel1.htmlText = "<p align='center'>" + loc.headers.amounts + "</p>";
        tfAmountLabel1.x = 0;
        tfAmountLabel1.y = 375+95;
        addChild(tfAmountLabel1);

        var tfAmount1:TextField = new TextField();
        tfAmount1.background = false;
        tfAmount1.x = 15;
        tfAmount1.y = 390+95;
        tfAmount1.width = 100;
        tfAmount1.height = 20;
        addChild(tfAmount1);
        tfAmount1.htmlText = "<p align='center'>0</p>";
        TrafficNetworkCreator.instance.resultAmountRecord = tfAmount1;

        var tfTimeLabel1:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tfTimeLabel1.width = 130;
        tfTimeLabel1.htmlText = "<p align='center'>" + loc.headers.time + "</p>";
        tfTimeLabel1.x = 0;
        tfTimeLabel1.y = 405+95;
        addChild(tfTimeLabel1);

        var tfTime1:TextField = new TextField();
        tfTime1.background = false;
        tfTime1.x = 15;
        tfTime1.y = 420+95;
        tfTime1.width = 100;
        tfTime1.height = 20;
        tfTime1.htmlText = "<p align='center'>0</p>";
        addChild(tfTime1);
        TrafficNetworkCreator.instance.resultTimeRecord = tfTime1;




        var tfCrash:TextField = new TextField();
        tfCrash.background = true;
        tfCrash.backgroundColor = 0xaa3333;
        tfCrash.x = 15;
        tfCrash.y = 545;
        tfCrash.width = 100;
        tfCrash.height = 20;
        addChild(tfCrash);
        tfCrash.htmlText = "<p align='center' bgcolor='0xff0000'>Авария</p>";
        TrafficNetworkCreator.instance.resultCrash = tfCrash;
        tfCrash.visible = false;
    }


    var label1;

    var label2;

    var tfAmountLabel:TextField;

    var tfAmount:TextField;

    var tfTimeLabel:TextField;

    var tfTime:TextField;

    private function addButtonsForSecondLevel():void {
        var loc:Object = KioApi.getLocalization(TrainProblem.ID);

//        var tf:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
//        tf.width = 130;
//        tf.htmlText = "<p align='center'>" + loc.headers.edit + "</p>";
//        tf.x = 0;
//        tf.y = 140;
//        addChild(tf);
//
//        var tfAnimation:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
//        tfAnimation.width = 130;
//        tfAnimation.htmlText = "<p align='center'>" + loc.headers.animation + "</p>";
//        tfAnimation.x = 0;
//        tfAnimation.y = 230-28;
//        addChild(tfAnimation);

        createButton(loc.buttons.reset, 15, 145, function (event:MouseEvent) {
            TrafficNetwork.instance.resetArrows();
        });

        createButton(loc.buttons.play, 15, 195, function (event:MouseEvent) {
            TrafficNetwork.instance.play();
        });

        createButton(loc.buttons.step, 15, 245, function (event:MouseEvent) {
            TrafficNetwork.instance.step();
        });

        createButton(loc.buttons.result, 15, 295, function (event:MouseEvent) {
            TrafficNetwork.instance.calc();
        });

        createButton(loc.buttons.init, 15, 345, function (event:MouseEvent) {
            TrafficNetwork.instance.initial();
        });



        label1 = new LABEL;
        label2 = new LABEL;
        label1.x=15;
        label2.x=15;
        label1.y=360;
        label2.y=470;
        addChild(label1);
        addChild(label2);


        tfAmountLabel = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tfAmountLabel.width = 130;
        tfAmountLabel.htmlText = "<p align='center'>" + loc.headers.amounts + "</p>";
        tfAmountLabel.x = 0;
        tfAmountLabel.y = 390;
        addChild(tfAmountLabel);

        tfAmount = new TextField();
        tfAmount.background = false;
        tfAmount.x = 15;
        tfAmount.y = 435;
        tfAmount.width = 100;
        tfAmount.height = 20;
        addChild(tfAmount);
        tfAmount.htmlText = "<p align='center'>0</p>";
        TrafficNetworkCreator.instance.resultAmount = tfAmount;

        tfTimeLabel = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tfTimeLabel.width = 130;
        tfTimeLabel.htmlText = "<p align='center'>" + loc.headers.time + "</p>";
        tfTimeLabel.x = 0;
        tfTimeLabel.y = 470;
        addChild(tfTimeLabel);

        tfTime = new TextField();
        tfTime.background = false;
        tfTime.x = 15;
        tfTime.y = 515;
        tfTime.width = 100;
        tfTime.height = 20;
        tfTime.htmlText = "<p align='center'>0</p>";
        addChild(tfTime);
        TrafficNetworkCreator.instance.resultTime = tfTime;



        var tfCrash:TextField = new TextField();
        tfCrash.background = true;
        tfCrash.backgroundColor = 0xaa3333;
        tfCrash.x = 15;
        tfCrash.y = 545;
        tfCrash.width = 100;
        tfCrash.height = 20;
        addChild(tfCrash);
        tfCrash.htmlText = "<p align='center' bgcolor='0xff0000'>Авария</p>";
        TrafficNetworkCreator.instance.resultCrash = tfCrash;
        tfCrash.visible = false;


    }

    private function createButton(caption:String, x:int, y:int, func:Function, high:Boolean = true):ShellButton {
        var clearButton:ShellButton = new ShellButton(caption, false, high);
        addChild(clearButton);
        clearButton.x = x;
        clearButton.y = y;
        clearButton.addEventListener(MouseEvent.CLICK, func);
        return clearButton;
    }

    private function addGrid():void {
        var loc:Object = KioApi.getLocalization(TrainProblem.ID);

        var dg:DataGrid = new DataGrid();
        dg.setStyle("headerTextPadding", "0");

        addColumn(dg, "№", "number");
        var leftColumn:DataGridColumn = addColumn(dg, "-", "leftArrowStatePic", false);
        addColumn(dg, "L", "leftStep");
        var rightColumn:DataGridColumn = addColumn(dg, "-", "rightArrowStatePic", false);
        addColumn(dg, "R", "rightStep");
        var directColumn:DataGridColumn = addColumn(dg, "-", "directArrowStatePic", false);
        addColumn(dg, "D", "directStep");

//        leftColumn.cellRenderer.addEventListener(MouseEvent.CLICK, function(e:Event):void{
//            var index:int = dg.selectedIndex;
//            if(index == -1)
//                return;
//            var step:AutomationStep = AutomationStep(dg.getItemAt(index));
//            step.nextLeftDirection();
//            updateDataProvider(dg);
//        });
//
//
//        rightColumn.cellRenderer.addEventListener(MouseEvent.CLICK, function(e:Event):void{
//            var index:int = dg.selectedIndex;
//            if(index == -1)
//                return;
//            var step:AutomationStep = AutomationStep(dg.getItemAt(index));
//            step.nextRightDirection();
//            updateDataProvider(dg);
//        });
//
//        directColumn.cellRenderer.addEventListener(MouseEvent.CLICK, function(e:Event):void{
//            var index:int = dg.selectedIndex;
//            if(index == -1)
//                return;
//            var step:AutomationStep = AutomationStep(dg.getItemAt(index));
//            step.nextDirectDirection();
//            updateDataProvider(dg);
//        });

        dg.addEventListener(MouseEvent.CLICK, function(e:Event):void{
            var index:int = dg.selectedIndex;
            if(index == -1)
                return;
            var step:AutomationStep = AutomationStep(dg.getItemAt(index));
            if(dg.mouseX>=18 && dg.mouseX<=34){
                step.nextLeftDirection();
                updateDataProvider(dg);
            }
            else if(dg.mouseX>=52 && dg.mouseX<=68){
                step.nextRightDirection();
                updateDataProvider(dg);
            }
            else if(dg.mouseX>=84 && dg.mouseX<=100){
                step.nextDirectDirection();
                updateDataProvider(dg);
            }

        });

        dg.editable = true;
        dg.sortableColumns = false;
        dg.opaqueBackground=false;
        dg.x = 10;
        dg.y = 10;

        createButton(loc.buttons.expand, 15, 110, function (event:MouseEvent) {
            dg.width =110;
            dg.height =400;
            collapse.visible=true;
            add.visible=true;
            remove.visible=true;
            label1.visible=false;
            label2.visible=false;
            tfAmountLabel.visible=false;
            tfAmount.visible=false;
            tfTimeLabel.visible=false;
            tfTime.visible=false;
        },false);

        var add:ShellButton = createButton(loc.buttons.add, 15, 450, function (event:MouseEvent) {
            Automation.instance.states.push(new AutomationStep(0));
            updateDataProvider(dg);
        },false);

        var remove:ShellButton = createButton(loc.buttons.remove, 15, 480, function (event:MouseEvent) {
            var index:int = dg.selectedIndex;
            if(index == -1)
                return;
            var step:AutomationStep = AutomationStep(dg.getItemAt(index));
            Automation.instance.removeStep(step);
            updateDataProvider(dg);
        },false);

        var collapse:ShellButton = createButton(loc.buttons.collapse, 15, 410, function (event:MouseEvent) {
            dg.width = 110;
            dg.height = 100;
            collapse.visible=false;
            add.visible=false;
            remove.visible=false;
            label1.visible=true;
            label2.visible=true;
            tfAmountLabel.visible=true;
            tfAmount.visible=true;
            tfTimeLabel.visible=true;
            tfTime.visible=true;
        },false);

        dg.width =110;
        dg.height =100;
        collapse.visible=false;
        add.visible=false;
        remove.visible=false;

        var format:TextFormat = new TextFormat();
        format.align="center";
        dg.setStyle("textFormat", format);
        dg.setStyle("textPadding", 0);


        

        updateDataProvider(dg);
        addChild(dg);

    }

    private function updateDataProvider(dg:DataGrid):void{
        dg.removeAll();
        var states:Vector.<AutomationStep> = Automation.instance.states;
        for (var i:int = 0; i < states.length; i++) {
           dg.addItem(states[i]);
           updateStyle(dg, i, 0);
           updateStyle(dg, i, 1);
           updateStyle(dg, i, 2);
           updateStyle(dg, i, 3);
           updateStyle(dg, i, 4);
           updateStyle(dg, i, 5);
           updateStyle(dg, i, 6);
        }

    }

    private function updateStyle(dg:DataGrid, i:int, j:int):void {
        if(dg.getCellRendererAt(i, j)!=null){
            (CellRenderer(dg.getCellRendererAt(i, j))).setStyle("textPadding", 0);
            var format:TextFormat = new TextFormat();
            format.align="center";
            (CellRenderer(dg.getCellRendererAt(i, j))).setStyle("textFormat", format);
        }
    }

    private function addColumn(dg:DataGrid, header:String, property:String, editable:Boolean = true):DataGridColumn {
        var column:DataGridColumn = new DataGridColumn(header);
        //var renderer:CellRenderer = new CellRenderer();
        //column.cellRenderer = renderer;
        column.dataField = property;
        column.editable=editable;
        var format:TextFormat = new TextFormat();
        format.align="center";
        //renderer.setStyle("textPadding", 0);
        //renderer.setStyle("textFormat", format);
        dg.addColumn(column);
        return column;
    }
}

}