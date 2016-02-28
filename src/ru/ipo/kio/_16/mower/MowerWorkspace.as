package ru.ipo.kio._16.mower {
import flash.geom.Matrix;

import ru.ipo.kio._16.mars.*;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._16.mower.model.Command;

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

    private var timeSlider:MowerSlider;
    private var programTrace:ProgramTrace;
    private var stateView:StateView;
    private var program_view:ProgramView;
    private var initial_state:State;

    private var animating:Boolean = false;

    private var animate:GraphicsButton;
    private var pauseAnimation:GraphicsButton;

    private var _info:InfoPanel;
    private var _record:InfoPanel;

    private var _empty_solution:Object;

    public function MowerWorkspace(problem:KioProblem) {
        _problem = problem;
        _api = KioApi.instance(problem);

        graphics.lineStyle();
        graphics.beginBitmapFill((new BG_CLASS).bitmapData);
        graphics.drawRect(0, 0, 780, 600);
        graphics.endFill();

        var m:Matrix = new Matrix();
        m.translate(10, 10);
        var swamp_bmp:BitmapData = (new BG_SWAMP_CLASS).bitmapData;
        graphics.beginBitmapFill(swamp_bmp, m);
        graphics.drawRect(10, 10, swamp_bmp.width, swamp_bmp.height);
        graphics.endFill();

        var bottom_bmp:BitmapData = (new BG_BOTTOM_CLASS).bitmapData;
        m = new Matrix();
        m.translate(0, 600 - bottom_bmp.height);
        graphics.beginBitmapFill(bottom_bmp, m);
        graphics.drawRect(0, 600 - bottom_bmp.height, bottom_bmp.width, bottom_bmp.height);
        graphics.endFill();

        var cells:String =
                "&&&&&&&&&&&&&&&&&&&&&&" +
                "&................*...&" +
                "&...........*........&" +
                "&......*.............&" +
                "&......*.............&" +
                "&......*...........**&" +
                "&.............*...**.&" +
                "&*...................&" +
                "&....................&" +
                "&............***.....&" +
                "&.....*........*.....&" +
                "&..............*.....&" +
                "&....................&" +
                "&........***.........&" +
                "&....................&" +
                "&....*...............&" +
                "&....................&" +
                "&&&&&&&&&&&&&&&&&&&&&&";
        var initial_field:Field = new Field(18, 22, cells);

        var initial_mowers:Vector.<Mower> = new <Mower>[
            new Mower(1, 1, 0, 1, false),
            new Mower(16, 20, 0, -1, false)
//            new Mower(6, 11, 0, -1, false)
        ];

        for each (var mower:Mower in initial_mowers)
            initial_field.setAt(mower.i, mower.j, Field.FIELD_GRASS_MOWED);

        initial_state = new State(initial_field, initial_mowers);

        var program:Program = new Program(initial_mowers.length >= 2, _problem.level + 1);

//        var fieldView:FieldView = new FieldView(CellsDrawer.SIZE_SMALL, initial_field);
        stateView = new StateView(initial_state, program.states_num > 1);

        //TODO state is not shown initially

        addChild(stateView);
        stateView.x = 10;
        stateView.y = 10;

        program_view = new ProgramView(program);
        addChild(program_view);
        program_view.x = 580;
        program_view.y = 10;
        program_view.addEventListener(ProgramView.PROGRAM_CHANGED, program_changed_eventHandler);

        programTrace = new ProgramTrace(program, initial_state);
        programTrace.run();

        timeSlider = new MowerSlider(0, programTrace.fullTrace.length - 1, 700, 0x000000, 0x000000);
        timeSlider.x = 26;
        timeSlider.y = 570;
        addChild(timeSlider);
        timeSlider.addEventListener(Slider.VALUE_CHANGED, slider_value_changedHandler);
        timeSlider.value_no_fire = 0;

        stateView.addEventListener(StateView.ANIMATION_FINISHED, stateView_animation_finishedHandler);

        initButtons();

        initInfo();

        _empty_solution = solution;

        setInfo(_info, result);
        setInfo(_record, result);
    }

    private function initInfo():void {
        var titles:Array = ["Скошено", "Шагов"];
        _info = new InfoPanel('KioArial', true, 16, 0x000000, 0x000000, 0x000000, 1.2, 'Результат', titles, 100);
        _record = new InfoPanel('KioArial', true, 16, 0x000000, 0x000000, 0x000000, 1.2, 'Рекорд', titles, 100);
        addChild(_info);
        addChild(_record);
        var skip:int = 40;
        _info.x = 10 + 6; //560 - _info.width - _record.width - skip - 6;
        _info.y = 480;
//        _record.x = 520;
//        _record.y = _info.y + _info.height + 20;
        _record.x = _info.x + _info.width + skip;
        _record.y = _info.y;

        setInfo(_info, null);
        setInfo(_record, null);

        _api.addEventListener(KioApi.RECORD_EVENT, function (e:Event):void {
            setInfo(_record, result);
        });

        graphics.beginFill(0x008fc5, 0.6);

        graphics.drawRect(_info.x - 6, _info.y -6, _info.width + _record.width + skip + 12, _info.height + 12);

        graphics.drawRect(program_view.x - 6, program_view.y - 6, program_view.width + 12, program_view.height + 12);

        graphics.endFill();
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
        var toStart:GraphicsButton = new GraphicsButton('', BTN_TO_START_BMP, BTN_TO_START_O_BMP, BTN_TO_START_P_BMP, 'KioArial', 14, 14);
        var toEnd:GraphicsButton = new GraphicsButton('', BTN_TO_END_BMP, BTN_TO_END_O_BMP, BTN_TO_END_P_BMP, 'KioArial', 14, 14);
        var stepForward:GraphicsButton = new GraphicsButton('', BTN_STEP_FORWARD_BMP, BTN_STEP_FORWARD_O_BMP, BTN_STEP_FORWARD_P_BMP, 'KioArial', 14, 14);
        var stepBack:GraphicsButton = new GraphicsButton('', BTN_STEP_BACK_BMP, BTN_STEP_BACK_O_BMP, BTN_STEP_BACK_P_BMP, 'KioArial', 14, 14);
        animate = new GraphicsButton('', BTN_ANIMATE_BMP, BTN_ANIMATE_O_BMP, BTN_ANIMATE_P_BMP, 'KioArial', 14, 14);
        pauseAnimation = new GraphicsButton('', BTN_PAUSE_ANIMATION_BMP, BTN_PAUSE_ANIMATION_O_BMP, BTN_PAUSE_ANIMATION_P_BMP, 'KioArial', 14, 14);

        addChild(toStart);
        addChild(toEnd);
        addChild(stepForward);
        addChild(stepBack);
        addChild(animate);
        addChild(pauseAnimation);

        var buttonsY:int = 480;
        var buttonsX:int = 560 - 4 * 2 - toStart.width * 5;
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

        //highlight current move
        program_view.clearMowersHighlights();
        for each (var mower:Mower in stateView.state.mowers) {
            var c:Command = stateView.state.getCommand(program_view.program, mower);
            program_view.setMowerHighlight(mower.state, c.i_lookup, c.j_lookup);
        }
    }

    private function program_changed_eventHandler(event:Event):void {
        programTrace = new ProgramTrace(program_view.program, initial_state);
        programTrace.run();
        timeSlider.reInit(0, programTrace.fullTrace.length - 1, 0);

        var res:Object = result;
        setInfo(_info, res);
        _api.autoSaveSolution();
        _api.submitResult(res);
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
        program_view.redrawViews();
        program_changed_eventHandler(null);
    }

    public function get result():Object {
        var state:State = programTrace.lastState;
        if (state == null)
            return {m: 0, s: 0};
        return {m: state.field.countCells(Field.FIELD_GRASS_MOWED), s: programTrace.last_grass_change};
    }

    public function get empty_solution():Object {
        return _empty_solution;
    }

//embed images
    [Embed(source="res/bg.png")]
    public static const BG_CLASS:Class;

    [Embed(source="res/bg-swamp.png")]
    public static const BG_SWAMP_CLASS:Class;

    [Embed(source="res/bg-bottom.png")]
    public static const BG_BOTTOM_CLASS:Class;

    [Embed(source="res/buttons/animate.png")]
    public static const BTN_ANIMATE:Class;
    public static const BTN_ANIMATE_BMP:BitmapData = (new BTN_ANIMATE).bitmapData;

    [Embed(source="res/buttons/animate_o.png")]
    public static const BTN_ANIMATE_O:Class;
    public static const BTN_ANIMATE_O_BMP:BitmapData = (new BTN_ANIMATE_O).bitmapData;

    [Embed(source="res/buttons/animate_p.png")]
    public static const BTN_ANIMATE_P:Class;
    public static const BTN_ANIMATE_P_BMP:BitmapData = (new BTN_ANIMATE_P).bitmapData;


    [Embed(source="res/buttons/pauseAnimation.png")]
    public static const BTN_PAUSE_ANIMATION:Class;
    public static const BTN_PAUSE_ANIMATION_BMP:BitmapData = (new BTN_PAUSE_ANIMATION).bitmapData;

    [Embed(source="res/buttons/pauseAnimation_o.png")]
    public static const BTN_PAUSE_ANIMATION_O:Class;
    public static const BTN_PAUSE_ANIMATION_O_BMP:BitmapData = (new BTN_PAUSE_ANIMATION_O).bitmapData;

    [Embed(source="res/buttons/pauseAnimation_p.png")]
    public static const BTN_PAUSE_ANIMATION_P:Class;
    public static const BTN_PAUSE_ANIMATION_P_BMP:BitmapData = (new BTN_PAUSE_ANIMATION_P).bitmapData;


    [Embed(source="res/buttons/stepBack.png")]
    public static const BTN_STEP_BACK:Class;
    public static const BTN_STEP_BACK_BMP:BitmapData = (new BTN_STEP_BACK).bitmapData;

    [Embed(source="res/buttons/stepBack_o.png")]
    public static const BTN_STEP_BACK_O:Class;
    public static const BTN_STEP_BACK_O_BMP:BitmapData = (new BTN_STEP_BACK_O).bitmapData;

    [Embed(source="res/buttons/stepBack_p.png")]
    public static const BTN_STEP_BACK_P:Class;
    public static const BTN_STEP_BACK_P_BMP:BitmapData = (new BTN_STEP_BACK_P).bitmapData;


    [Embed(source="res/buttons/stepForward.png")]
    public static const BTN_STEP_FORWARD:Class;
    public static const BTN_STEP_FORWARD_BMP:BitmapData = (new BTN_STEP_FORWARD).bitmapData;

    [Embed(source="res/buttons/stepForward_o.png")]
    public static const BTN_STEP_FORWARD_O:Class;
    public static const BTN_STEP_FORWARD_O_BMP:BitmapData = (new BTN_STEP_FORWARD_O).bitmapData;

    [Embed(source="res/buttons/stepForward_p.png")]
    public static const BTN_STEP_FORWARD_P:Class;
    public static const BTN_STEP_FORWARD_P_BMP:BitmapData = (new BTN_STEP_FORWARD_P).bitmapData;


    [Embed(source="res/buttons/toEnd.png")]
    public static const BTN_TO_END:Class;
    public static const BTN_TO_END_BMP:BitmapData = (new BTN_TO_END).bitmapData;

    [Embed(source="res/buttons/toEnd_o.png")]
    public static const BTN_TO_END_O:Class;
    public static const BTN_TO_END_O_BMP:BitmapData = (new BTN_TO_END_O).bitmapData;

    [Embed(source="res/buttons/toEnd_p.png")]
    public static const BTN_TO_END_P:Class;
    public static const BTN_TO_END_P_BMP:BitmapData = (new BTN_TO_END_P).bitmapData;

    
    [Embed(source="res/buttons/toStart.png")]
    public static const BTN_TO_START:Class;
    public static const BTN_TO_START_BMP:BitmapData = (new BTN_TO_START).bitmapData;

    [Embed(source="res/buttons/toStart_o.png")]
    public static const BTN_TO_START_O:Class;
    public static const BTN_TO_START_O_BMP:BitmapData = (new BTN_TO_START_O).bitmapData;

    [Embed(source="res/buttons/toStart_p.png")]
    public static const BTN_TO_START_P:Class;
    public static const BTN_TO_START_P_BMP:BitmapData = (new BTN_TO_START_P).bitmapData;
}
}