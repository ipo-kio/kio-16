package ru.ipo.kio._16.mower {
import ru.ipo.kio._16.mars.*;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._16.mower.model.Field;
import ru.ipo.kio._16.mower.model.Mower;
import ru.ipo.kio._16.mower.model.Program;
import ru.ipo.kio._16.mower.model.ProgramTrace;
import ru.ipo.kio._16.mower.model.State;
import ru.ipo.kio._16.mower.view.ProgramView;
import ru.ipo.kio._16.mower.view.StateView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.controls.GraphicsButton;
import ru.ipo.kio.api.controls.InfoPanel;

public class MowerWorkspace extends Sprite {

    private var _problem:KioProblem;
    private var _api:KioApi;

    private var timeSlider:Slider;
    private var programTrace:ProgramTrace;
    private var stateView:StateView;
    private var program_view:ProgramView;
    private var initial_state:State;

    private var animating:Boolean = false;

    private var animate:GraphicsButton;
    private var pauseAnimation:GraphicsButton;

    private var _info:InfoPanel;
    private var _record:InfoPanel;

    public function MowerWorkspace(problem:KioProblem) {
        _problem = problem;
        _api = KioApi.instance(problem);

        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0, 0, 780, 600);
        graphics.endFill();

        var cells:String =
                "&&&&&&&&&&&&&&&&&&&&" +
                "&..................&" +
                "&...........*......&" +
                "&..................&" +
                "&..................&" +
                "&......*...........&" +
                "&......*...........&" +
                "&......*...........&" +
                "&.............*....&" +
                "&..................&" +
                "&..................&" +
                "&............***...&" +
                "&.....*........*...&" +
                "&..............*...&" +
                "&..................&" +
                "&........***.......&" +
                "&..................&" +
                "&....*.............&" +
                "&..................&" +
                "&&&&&&&&&&&&&&&&&&&&";
        var initial_field:Field = new Field(20, 20, cells);

        var initial_mowers:Vector.<Mower> = new <Mower>[
            new Mower(3, 4, -1, 0, false),
            new Mower(6, 8, 0, 1, false),
            new Mower(6, 11, 0, -1, false)
        ];

        for each (var mower:Mower in initial_mowers)
            initial_field.setAt(mower.i, mower.j, Field.FIELD_GRASS_MOWED);

        initial_state = new State(initial_field, initial_mowers);

//        var fieldView:FieldView = new FieldView(CellsDrawer.SIZE_SMALL, initial_field);
        stateView = new StateView(initial_state);

        addChild(stateView);
        stateView.x = 10;
        stateView.y = 10;

        var program:Program = new Program(initial_mowers.length >= 2);
        program_view = new ProgramView(program);
        addChild(program_view.view);
        program_view.view.x = 520;
        program_view.view.y = 10;
        program_view.addEventListener(ProgramView.PROGRAM_CHANGED, program_changed_eventHandler);

        programTrace = new ProgramTrace(program, initial_state);
        programTrace.run();

        timeSlider = new Slider(0, programTrace.fullTrace.length - 1, 700, 0x000000, 0x000000);
        timeSlider.x = 20;
        timeSlider.y = 570;
        addChild(timeSlider);
        timeSlider.addEventListener(Slider.VALUE_CHANGED, slider_value_changedHandler);
        timeSlider.value_no_fire = 0;

        stateView.addEventListener(StateView.ANIMATION_FINISHED, stateView_animation_finishedHandler);

        initButtons();

        initInfo();
    }

    private function initInfo():void {
        var titles:Array = ["Скошено", "Шагов"];
        _info = new InfoPanel('KioArial', true, 16, 0x000000, 0x000000, 0xAAAA00, 1.2, 'Результат', titles, 160);
        _record = new InfoPanel('KioArial', true, 16, 0x000000, 0x000000, 0xAAAA00, 1.2, 'Рекорд', titles, 160);
        addChild(_info);
        addChild(_record);
        _info.x = 520;
        _info.y = 320;
        _record.x = 520;
        _record.y = _info.y + _info.height + 20;

        setInfo(_info, null);
        setInfo(_record, null);

        _api.addEventListener(KioApi.RECORD_EVENT, function (e:Event):void {
            setInfo(_record, result);
        });
    }

    private static function setInfo(info:InfoPanel, result:Object):void {
        if (result == null) {
            info.setValue(0, '-');
            info.setValue(1, '-');
        } else {
            info.setValue(0, result.m);
            info.setValue(1, result.s);
        }
    }

    private function initButtons():void {
        var toStart:GraphicsButton = new GraphicsButton('<<', BTN_TO_START_BMP, BTN_TO_START_O_BMP, BTN_TO_START_P_BMP, 'KioArial', 14, 14);
        var toEnd:GraphicsButton = new GraphicsButton('>>', BTN_TO_END_BMP, BTN_TO_END_O_BMP, BTN_TO_END_P_BMP, 'KioArial', 14, 14);
        var stepForward:GraphicsButton = new GraphicsButton('>', BTN_STEP_FORWARD_BMP, BTN_STEP_FORWARD_O_BMP, BTN_STEP_FORWARD_P_BMP, 'KioArial', 14, 14);
        var stepBack:GraphicsButton = new GraphicsButton('<', BTN_STEP_BACK_BMP, BTN_STEP_BACK_O_BMP, BTN_STEP_BACK_P_BMP, 'KioArial', 14, 14);
        animate = new GraphicsButton('~>', BTN_ANIMATE_BMP, BTN_ANIMATE_O_BMP, BTN_ANIMATE_P_BMP, 'KioArial', 14, 14);
        pauseAnimation = new GraphicsButton('||', BTN_PAUSE_ANIMATION_BMP, BTN_PAUSE_ANIMATION_O_BMP, BTN_PAUSE_ANIMATION_P_BMP, 'KioArial', 14, 14);

        addChild(toStart);
        addChild(toEnd);
        addChild(stepForward);
        addChild(stepBack);
        addChild(animate);
        addChild(pauseAnimation);

        var buttonsY:int = 260;
        var buttonsX:int = 560;
        toStart.x = buttonsX;
        toStart.y = buttonsY;
        stepBack.x = buttonsX + toStart.width + 2;
        stepBack.y = buttonsY;
        animate.x = stepBack.x + stepBack.width + 2;
        animate.y = buttonsY;
        pauseAnimation.x = animate.x;
        pauseAnimation.y = buttonsY;
        stepForward.x = pauseAnimation.x + pauseAnimation.width + 2;
        stepForward.y = buttonsY;
        toEnd.x = stepForward.x + stepForward.width + 2;
        toEnd.y = buttonsY;

        pauseAnimation.visible = false;

        toStart.addEventListener(MouseEvent.CLICK, function (event:Event):void {
            timeSlider.value = 0;
        });
        toEnd.addEventListener(MouseEvent.CLICK, function (event:Event):void {
            timeSlider.value = 10000;
        });
        stepForward.addEventListener(MouseEvent.CLICK, function (event:Event):void {
            timeSlider.value += 1;
        });
        stepBack.addEventListener(MouseEvent.CLICK, function (event:Event):void {
            timeSlider.value -= 1;
        });
        animate.addEventListener(MouseEvent.CLICK, function (event:Event):void {
            doStartAnimation();
        });
        pauseAnimation.addEventListener(MouseEvent.CLICK, function (event:Event):void {
            doPauseAnimation();
        });
    }

    private function doStartAnimation():void {
        if (animating)
            return;
        animating = true;
        stateView.beginAnimation(program_view.program);

        animate.visible = false;
        pauseAnimation.visible = true;
    }

    private function doPauseAnimation():void {
        if (!animating)
            return;
        animating = false;

        pauseAnimation.visible = false;
        animate.visible = true;
    }

    private function slider_value_changedHandler(event:Event):void {
        var time:int = timeSlider.valueRounded;
        if (time < 0)
            time = 0;
        if (time >= programTrace.fullTrace.length)
            time = programTrace.fullTrace.length - 1;

        var wasAnimating:Boolean = animating;

        if (wasAnimating)
            doPauseAnimation();
        stateView.state = programTrace.fullTrace[time];
        if (wasAnimating)
            doStartAnimation();
    }

    private function program_changed_eventHandler(event:Event):void {
        programTrace = new ProgramTrace(program_view.program, initial_state);
        programTrace.run();
        timeSlider.reInit(0, programTrace.fullTrace.length - 1, 0);
    }

    private function stateView_animation_finishedHandler(event:Event):void {
        if (animating) {
            if (timeSlider.value == timeSlider.to_)
                doPauseAnimation();
            else {
                timeSlider.value += 1;
                stateView.beginAnimation(program_view.program);
            }
        }
    }

    public function get solution():Object {
        return program_view.program.as_object;
    }

    public function set solution(value:Object):void {
        program_view.program.as_object = value;
    }

    public function get result():Object {
        var state:State = programTrace.lastState;
        if (state == null)
            return {m: 0, s: 0};
        return {m: state.field.countCells(Field.FIELD_GRASS_MOWED), s: programTrace.statesCount - 1};
    }

    //embed images
    [Embed(source="res/animate.png")]
    public static const BTN_ANIMATE:Class;
    public static const BTN_ANIMATE_BMP:BitmapData = (new BTN_ANIMATE).bitmapData;

    [Embed(source="res/animate_o.png")]
    public static const BTN_ANIMATE_O:Class;
    public static const BTN_ANIMATE_O_BMP:BitmapData = (new BTN_ANIMATE_O).bitmapData;

    [Embed(source="res/animate_p.png")]
    public static const BTN_ANIMATE_P:Class;
    public static const BTN_ANIMATE_P_BMP:BitmapData = (new BTN_ANIMATE_P).bitmapData;


    [Embed(source="res/pauseAnimation.png")]
    public static const BTN_PAUSE_ANIMATION:Class;
    public static const BTN_PAUSE_ANIMATION_BMP:BitmapData = (new BTN_PAUSE_ANIMATION).bitmapData;

    [Embed(source="res/pauseAnimation_o.png")]
    public static const BTN_PAUSE_ANIMATION_O:Class;
    public static const BTN_PAUSE_ANIMATION_O_BMP:BitmapData = (new BTN_PAUSE_ANIMATION_O).bitmapData;

    [Embed(source="res/pauseAnimation_p.png")]
    public static const BTN_PAUSE_ANIMATION_P:Class;
    public static const BTN_PAUSE_ANIMATION_P_BMP:BitmapData = (new BTN_PAUSE_ANIMATION_P).bitmapData;


    [Embed(source="res/stepBack.png")]
    public static const BTN_STEP_BACK:Class;
    public static const BTN_STEP_BACK_BMP:BitmapData = (new BTN_STEP_BACK).bitmapData;

    [Embed(source="res/stepBack_o.png")]
    public static const BTN_STEP_BACK_O:Class;
    public static const BTN_STEP_BACK_O_BMP:BitmapData = (new BTN_STEP_BACK_O).bitmapData;

    [Embed(source="res/stepBack_p.png")]
    public static const BTN_STEP_BACK_P:Class;
    public static const BTN_STEP_BACK_P_BMP:BitmapData = (new BTN_STEP_BACK_P).bitmapData;


    [Embed(source="res/stepForward.png")]
    public static const BTN_STEP_FORWARD:Class;
    public static const BTN_STEP_FORWARD_BMP:BitmapData = (new BTN_STEP_FORWARD).bitmapData;

    [Embed(source="res/stepForward_o.png")]
    public static const BTN_STEP_FORWARD_O:Class;
    public static const BTN_STEP_FORWARD_O_BMP:BitmapData = (new BTN_STEP_FORWARD_O).bitmapData;

    [Embed(source="res/stepForward_p.png")]
    public static const BTN_STEP_FORWARD_P:Class;
    public static const BTN_STEP_FORWARD_P_BMP:BitmapData = (new BTN_STEP_FORWARD_P).bitmapData;


    [Embed(source="res/toEnd.png")]
    public static const BTN_TO_END:Class;
    public static const BTN_TO_END_BMP:BitmapData = (new BTN_TO_END).bitmapData;

    [Embed(source="res/toEnd_o.png")]
    public static const BTN_TO_END_O:Class;
    public static const BTN_TO_END_O_BMP:BitmapData = (new BTN_TO_END_O).bitmapData;

    [Embed(source="res/toEnd_p.png")]
    public static const BTN_TO_END_P:Class;
    public static const BTN_TO_END_P_BMP:BitmapData = (new BTN_TO_END_P).bitmapData;

    
    [Embed(source="res/toStart.png")]
    public static const BTN_TO_START:Class;
    public static const BTN_TO_START_BMP:BitmapData = (new BTN_TO_START).bitmapData;

    [Embed(source="res/toStart_o.png")]
    public static const BTN_TO_START_O:Class;
    public static const BTN_TO_START_O_BMP:BitmapData = (new BTN_TO_START_O).bitmapData;

    [Embed(source="res/toStart_p.png")]
    public static const BTN_TO_START_P:Class;
    public static const BTN_TO_START_P_BMP:BitmapData = (new BTN_TO_START_P).bitmapData;
}
}