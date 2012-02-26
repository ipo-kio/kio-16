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
import ru.ipo.kio.base.displays.ShellButton;

public class TrainSprite extends Sprite {

    [Embed(source='_resources/bg_left.png')]
    private static const LEFT_BACKGROUNG:Class;

    [Embed(source='_resources/zero/Background_01.png')]
    private static const LEVEL_0_BACKGROUNG:Class;

    [Embed(source='_resources/one/Background.png')]
    private static const LEVEL_1_BACKGROUNG:Class;

    public function TrainSprite(level:int, readonly:Boolean, id:String = null) {
        var api:KioApi = KioApi.instance(id ? id : TrainProblem.ID);

        var leftBackground = new LEFT_BACKGROUNG;
        addChild(leftBackground);

        var background;
        if (level == 1 || level == 2) {
            background = new LEVEL_1_BACKGROUNG;
        } else if (level == 0) {
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


        if(level == 0 || level ==1){
            addButtonsForZeroFirstLevel();
        }else{
           addButtonsForSecondLevel();
           addGrid();
        }

    }

    private function addButtonsForZeroFirstLevel():void {
        var loc:Object = KioApi.getLocalization(TrainProblem.ID);

        createButton(loc.buttons.clear_routes, 15, 68, function (event:MouseEvent) {
            TrafficNetwork.instance.clearRoutes();
        });

        createButton(loc.buttons.remove_last, 15, 118, function (event:MouseEvent) {
            TrafficNetwork.instance.removeLastFromActive();
        });

        createButton(loc.buttons.play, 15, 205, function (event:MouseEvent) {
            TrafficNetwork.instance.play();
        });

        createButton(loc.buttons.step, 15, 254, function (event:MouseEvent) {
            TrafficNetwork.instance.step();
        });

        createButton(loc.buttons.result, 15, 305, function (event:MouseEvent) {
            TrafficNetwork.instance.calc();
        });

        createButton(loc.buttons.init, 15, 354, function (event:MouseEvent) {
            TrafficNetwork.instance.initial();
        });

        var tf:TextField = new TextField();
        tf.backgroundColor = 0xffffff;
        tf.background = true;
        tf.x = 15;
        tf.y = 400;
        tf.width = 100;
        addChild(tf);
        TrafficNetworkCreator.instance.result = tf;
    }

    private function addButtonsForSecondLevel():void {
        var loc:Object = KioApi.getLocalization(TrainProblem.ID);

        createButton(loc.buttons.play, 15, 250, function (event:MouseEvent) {
            TrafficNetwork.instance.play();
        });

        createButton(loc.buttons.step, 15, 304, function (event:MouseEvent) {
            TrafficNetwork.instance.step();
        });

        createButton(loc.buttons.result, 15, 355, function (event:MouseEvent) {
            TrafficNetwork.instance.calc();
        });

        createButton(loc.buttons.init, 15, 404, function (event:MouseEvent) {
            TrafficNetwork.instance.initial();
        });

        var tf:TextField = new TextField();
        tf.backgroundColor = 0xffffff;
        tf.background = true;
        tf.x = 15;
        tf.y = 400;
        tf.width = 100;
        //addChild(tf);
        TrafficNetworkCreator.instance.result = tf;
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
        dg.y = 20;

        createButton(loc.buttons.expand, 15, 120, function (event:MouseEvent) {
            dg.width =110;
            dg.height =400;
            collapse.visible=true;
            add.visible=true;
            remove.visible=true;
        },false);

        var add:ShellButton = createButton(loc.buttons.add, 15, 450, function (event:MouseEvent) {
            Automation.instance.states.push(new AutomationStep(10));
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

        var collapse:ShellButton = createButton(loc.buttons.collapse, 15, 420, function (event:MouseEvent) {
            dg.width = 110;
            dg.height = 100;
            collapse.visible=false;
            add.visible=false;
            remove.visible=false;
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