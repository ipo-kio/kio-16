package ru.ipo.kio._16.mower {
import ru.ipo.kio._16.mars.*;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._16.mars.model.Consts;

import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.ShipAction;
import ru.ipo.kio._16.mars.model.Vector2D;

import ru.ipo.kio._16.mars.view.SolarSystem;
import ru.ipo.kio._16.mars.view.VectorView;
import ru.ipo.kio._16.mower.model.Field;
import ru.ipo.kio._16.mower.model.Mower;
import ru.ipo.kio._16.mower.model.Program;
import ru.ipo.kio._16.mower.model.State;
import ru.ipo.kio._16.mower.view.CellsDrawer;
import ru.ipo.kio._16.mower.view.FieldView;
import ru.ipo.kio._16.mower.view.ProgramView;
import ru.ipo.kio._16.mower.view.StateView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.controls.GraphicsButton;

public class MowerWorkspace extends Sprite {
    private var background:Sprite = new Sprite();

    private var _problem:KioProblem;
    private var _api:KioApi;

    private var timeSlider:Slider;

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
                new Mower(6, 8, 0, 1, false)
        ];

        var initial_state:State = new State(initial_field, initial_mowers);

//        var fieldView:FieldView = new FieldView(CellsDrawer.SIZE_SMALL, initial_field);
        var stateView:StateView = new StateView(initial_state);

        addChild(stateView);
        stateView.x = 10;
        stateView.y = 10;

        var program:Program = new Program(true);
        var program_view:ProgramView = new ProgramView(program);
        addChild(program_view.view);
        program_view.view.x = 420;
        program_view.view.y = 10;
//        program_view.view.visible = false;

        stateView.beginAnimation(program);
    }

}
}