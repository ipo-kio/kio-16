/**
 * Created by ilya on 05.02.14.
 */
package ru.ipo.kio._14.peterhof {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._14.peterhof.model.Consts;
import ru.ipo.kio._14.peterhof.model.Hill;

public class PhysicsPanel extends Sprite {
    private var _hill:Hill;

    private var ds_editor:NumberEditor = new NumberEditor(200, 40, 0.001, 10, Consts.D, "м", 3);
    private var rho_editor:NumberEditor = new NumberEditor(200, 40, 0.01, 100000, Consts.RHO, "кг/м^3", 2);
    private var eta_editor:NumberEditor = new NumberEditor(200, 40, 0.0001, 100, 1000 * Consts.ETA, "г/м с", 4);
    private var g_editor:NumberEditor = new NumberEditor(200, 40, 0, 1000, Consts.G, "м/c^2", 3);
    private var k_editor:NumberEditor = new NumberEditor(200, 40, 0, 100, Consts.K, "*", 6);

    public function PhysicsPanel(hill:Hill) {
        _hill = hill;

        var to1:TitledObject = new TitledObject("Диаметр трубы", 14, 0xaaaaff, ds_editor);
        addChild(to1);
        ds_editor.addEventListener(Event.CHANGE, ds_editor_changeHandler);

        var to2:TitledObject = new TitledObject("Плотность воды", 14, 0xaaaaff, rho_editor);
        addChild(to2);
        to2.x = 250;
        rho_editor.addEventListener(Event.CHANGE, rho_editor_changeHandler);

        var to3:TitledObject = new TitledObject("Вязкость воды", 14, 0xaaaaff, eta_editor);
        addChild(to3);
        to3.x = 250;
        to3.y = to2.height;
        eta_editor.addEventListener(Event.CHANGE, eta_editor_changeHandler);

        var to4:TitledObject = new TitledObject("Ускорение свободного падения", 14, 0xaaaaff, g_editor);
        addChild(to4);
        to4.x = 500;
        to4.y = 0;
        g_editor.addEventListener(Event.CHANGE, g_editor_changeHandler);

        var to5:TitledObject = new TitledObject("Сопротивление воздуха", 14, 0xaaaaff, k_editor);
        addChild(to5);
        to5.x = 500;
        to5.y = to4.height;
        k_editor.addEventListener(Event.CHANGE, k_editor_changeHandler);
    }

    private function ds_editor_changeHandler(event:Event):void {
        Consts.D = ds_editor.value;
        Consts.S = Consts.D * Consts.D / 4 * Math.PI;
        _hill.invalidate_streams();
    }

    private function rho_editor_changeHandler(event:Event):void {
        Consts.RHO = rho_editor.value;
        _hill.invalidate_streams();
    }

    private function eta_editor_changeHandler(event:Event):void {
        Consts.ETA = eta_editor.value / 1000;
        _hill.invalidate_streams();
    }

    private function g_editor_changeHandler(event:Event):void {
        Consts.G = g_editor.value;
        _hill.invalidate_streams();
    }

    private function k_editor_changeHandler(event:Event):void {
        Consts.K = k_editor.value;
        _hill.invalidate_streams();
    }
}
}
