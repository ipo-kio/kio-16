package ru.ipo.kio._16.mars {

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._16.mars.model.Consts;

import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.ShipAction;
import ru.ipo.kio._16.mars.model.Vector2D;

import ru.ipo.kio._16.mars.view.SolarSystem;
import ru.ipo.kio._16.mars.view.VectorView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.controls.GraphicsButton;

public class MarsWorkspace extends Sprite {

    [Embed(source="res/plus.png")]
    public static const ADD_BUTTON_CLASS:Class;
    public static const ADD_BUTTON_IMG:BitmapData = (new ADD_BUTTON_CLASS).bitmapData;
    [Embed(source="res/plus_o.png")]
    public static const ADD_BUTTON_O_CLASS:Class;
    public static const ADD_BUTTON_O_IMG:BitmapData = (new ADD_BUTTON_O_CLASS).bitmapData;
    [Embed(source="res/plus_d.png")]
    public static const ADD_BUTTON_D_CLASS:Class;
    public static const ADD_BUTTON_D_IMG:BitmapData = (new ADD_BUTTON_D_CLASS).bitmapData;
    [Embed(source="res/minus.png")]
    public static const REMOVE_BUTTON_CLASS:Class;
    public static const REMOVE_BUTTON_IMG:BitmapData = (new REMOVE_BUTTON_CLASS).bitmapData;
    [Embed(source="res/minus_o.png")]
    public static const REMOVE_BUTTON_O_CLASS:Class;
    public static const REMOVE_BUTTON_O_IMG:BitmapData = (new REMOVE_BUTTON_O_CLASS).bitmapData;
    [Embed(source="res/minus_d.png")]
    public static const REMOVE_BUTTON_D_CLASS:Class;
    public static const REMOVE_BUTTON_D_IMG:BitmapData = (new REMOVE_BUTTON_D_CLASS).bitmapData;

    public static const TOTAL_CIRCLES:int = 7;

    private var background:Sprite = new Sprite();

    private var _problem:KioProblem;
    private var _api:KioApi;

    private var ss:SolarSystem;
    private var timeSlider:Slider;

    private var bAdd:GraphicsButton = new GraphicsButton('', ADD_BUTTON_IMG, ADD_BUTTON_O_IMG, ADD_BUTTON_O_IMG, '', 10, 10);
    private var bRemove:GraphicsButton = new GraphicsButton('', REMOVE_BUTTON_IMG, REMOVE_BUTTON_O_IMG, REMOVE_BUTTON_O_IMG, '', 10, 10);
    private var bAdd_dis:GraphicsButton = new GraphicsButton('', ADD_BUTTON_D_IMG, ADD_BUTTON_D_IMG, ADD_BUTTON_D_IMG, '', 10, 10);
    private var bRemove_dis:GraphicsButton = new GraphicsButton('', REMOVE_BUTTON_D_IMG, REMOVE_BUTTON_D_IMG, REMOVE_BUTTON_D_IMG, '', 10, 10);

    public function MarsWorkspace(problem:KioProblem) {
//        trace(Orbit.solveKeplerEquation(2.8453268117053505, 0.5084113241345426)); //newtown fails here

        _problem = problem;
        _api = KioApi.instance(problem);

        background.graphics.beginFill(0xFFFFFF);
        background.graphics.drawRect(0, 0, 780, 600);
        background.graphics.endFill();

        addChild(background);

        background.graphics.lineStyle(0);
        background.graphics.beginFill(0xFFFF00);
        background.graphics.drawCircle(300, 300, 280 / 1.524924921 / 100);
        background.graphics.endFill();

//        background.graphics.lineStyle(1, 0xFF0000);
//        background.graphics.drawCircle(300, 300, 280);
//        background.graphics.drawCircle(300, 300, 280 / 1.524924921);

        var speedView:VectorView = new VectorView(180, 40, 10000, 80);
        addChild(speedView);
        speedView.x = 680;
        speedView.y = 100;

//        speedView.value = Vector2D.createPolar(400, Math.PI / 3);
        speedView.visible = false;

        ss = new SolarSystem(speedView);
        addChild(ss);
        ss.x = 300;
        ss.y = 300;

        var history:ShipHistory = new ShipHistory(Vector2D.create(Consts.EARTH_R, 0), Vector2D.create(0, Consts.EARTH_Vt));
        history.push(new ShipAction(60, Vector2D.create(0, Consts.EARTH_Vt / 20)));
        history.push(new ShipAction(120, Vector2D.create(0, Consts.EARTH_Vt / 20)));
        history.push(new ShipAction(180, Vector2D.create(0, Consts.EARTH_Vt / 20)));
        ss.history = history;

        timeSlider = new Slider(0, Consts.MAX_TIME, 700, 0x000000, 0x000000);
        timeSlider.x = 20;
        timeSlider.y = 570;
        addChild(timeSlider);
        timeSlider.addEventListener(Slider.VALUE_CHANGED, slider_value_changedHandler);
        timeSlider.value_no_fire = 0;

        //init add remove buttons
        addChild(bAdd);
        addChild(bRemove);
        addChild(bAdd_dis);
        addChild(bRemove_dis);

        bAdd.x = 600;
        bRemove.x = 650;
        bAdd.y = 400;
        bRemove.y = 400;

        bAdd_dis.x = 600;
        bRemove_dis.x = 650;
        bAdd_dis.y = 400;
        bRemove_dis.y = 400;

        bAdd_dis.visible = false;
        bRemove_dis.visible = false;

        update_add_remove_buttons_state();
    }

    private function update_add_remove_buttons_state():void {
        var actions:Vector.<ShipAction> = ss.history.actions;

        if (actions.length == 0) {
            bAdd.visible = true;
            bAdd_dis.visible = false;
            bAdd.visible = false;
            bAdd_dis.visible = true;
            return;
        }

        var lastAction:ShipAction = actions[actions.length - 1];
        var addEnable:Boolean = timeSlider.value > lastAction.time;

        var removeEnable:Boolean = false;
        for each (var sa:ShipAction in actions)
            if (sa.time == timeSlider.value) {
                removeEnable = true;
                break;
            }

        bAdd.visible = addEnable;
        bAdd_dis.visible = !addEnable;
        bRemove.visible = removeEnable;
        bRemove_dis.visible = !removeEnable;
    }

    private function slider_value_changedHandler(event:Event):void {
        ss.time = Math.round(timeSlider.value);

        update_add_remove_buttons_state();
    }
}
}
