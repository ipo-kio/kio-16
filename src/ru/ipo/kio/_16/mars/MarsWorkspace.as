package ru.ipo.kio._16.mars {
import flash.display.Sprite;

import ru.ipo.kio._16.mars.model.Consts;

import ru.ipo.kio._16.mars.model.Orbit;
import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.ShipHistoryEntry;
import ru.ipo.kio._16.mars.model.Vector2D;

import ru.ipo.kio._16.mars.view.OrbitView;
import ru.ipo.kio._16.mars.view.SolarSystem;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;

public class MarsWorkspace extends Sprite {

    public static const TOTAL_CIRCLES:int = 7;

    private var background:Sprite = new Sprite();

    private var _problem:KioProblem;
    private var _api:KioApi;

    public function MarsWorkspace(problem:KioProblem) {
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

        var ss:SolarSystem = new SolarSystem();
        addChild(ss);
        ss.x = 300;
        ss.y = 300;

        var history:ShipHistory = new ShipHistory(Vector2D.create(Consts.EARTH_R, 0), Vector2D.create(0, Consts.EARTH_Vt));
        history.push(new ShipHistoryEntry(60, Vector2D.create(0, -Consts.EARTH_Vt / 20)));
        ss.history = history;

        var slider:Slider = new Slider(0, 100, 700, 0x000000, 0x000000);
        slider.x = 20;
        slider.y = 570;
        addChild(slider);

        trace('earth vt = ', Consts.EARTH_Vt);
    }
}
}
