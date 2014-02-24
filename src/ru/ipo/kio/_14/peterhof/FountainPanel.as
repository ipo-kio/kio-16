/**
 * Created by ilya on 31.01.14.
 */
package ru.ipo.kio._14.peterhof {
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio._14.peterhof.model.Consts;

import ru.ipo.kio._14.peterhof.model.Fountain;
import ru.ipo.kio._14.peterhof.view.Sprayer;
import ru.ipo.kio.api.KioApi;

public class FountainPanel extends Sprite {

    private var _fountain:Fountain = null;

    private var _alphaEditor:NumberEditor;
    private var _phiEditor:NumberEditor;
    private var _sprayerWidthEditor:NumberEditor;
    private var _sprayerLengthEditor:NumberEditor;

    private var _streamLengthInfo:TextField;

    private var _sprayer:Sprayer;

    private var _api:KioApi;
    private var _showSprayer:Boolean;

    public function FountainPanel(width:int, api:KioApi, showSprayer:Boolean) {
        _api = api;
        _showSprayer = showSprayer;

        const skip:int = 200;

        _alphaEditor = new NumberEditor(width, 18, 0, 90, 45, "°", 0);
        var alphaEditor:TitledObject = new TitledObject("Наклон", 24, 0x000000, _alphaEditor, skip);
        addChild(alphaEditor);

        _phiEditor = new NumberEditor(width, 18, -180, 180, 0, "°", 0);
        var phiEditor:TitledObject = new TitledObject("Поворот", 24, 0x000000, _phiEditor, skip);
        addChild(phiEditor);
        phiEditor.y = alphaEditor.height - 4;

        _sprayerWidthEditor = new NumberEditor(width, 18, 0.1, 5, 0.1, "см", 1);
        var sprayerWidthEditor:TitledObject = new TitledObject(showSprayer ? "Диаметр форсунки" : "", 24, 0x000000, _sprayerWidthEditor, skip);
        addChild(sprayerWidthEditor);
        sprayerWidthEditor.y = phiEditor.y + phiEditor.height - 4;

        _sprayerLengthEditor = new NumberEditor(width, 18, 5, 10, 5, "см", 1);
        var sprayerLengthEditor:TitledObject = new TitledObject(showSprayer ? "Длина форсунки" : "", 24, 0x000000, _sprayerLengthEditor, skip);
        addChild(sprayerLengthEditor);
        sprayerLengthEditor.y = sprayerWidthEditor.y + sprayerWidthEditor.height - 4;

        _streamLengthInfo = new TextField();
        _streamLengthInfo.selectable = false;
        _streamLengthInfo.defaultTextFormat = new TextFormat("KioArial", 18, 0xFFFFFF);
        _streamLengthInfo.autoSize = TextFieldAutoSize.LEFT;
        _streamLengthInfo.multiline = true;
        addChild(_streamLengthInfo);
        _streamLengthInfo.x = sprayerWidthEditor.x + sprayerWidthEditor.width + 20;

        _alphaEditor.addEventListener(Event.CHANGE, alphaEditor_changeHandler);
        _phiEditor.addEventListener(Event.CHANGE, phiEditor_changeHandler);
        _sprayerWidthEditor.addEventListener(Event.CHANGE, sprayerWidthEditor_changeHandler);
        _sprayerLengthEditor.addEventListener(Event.CHANGE, sprayerLengthEditor_changeHandler);

        //setup sprayer
        _sprayer = new Sprayer(100, 90, Consts.D, 60);
        addChild(_sprayer);

        _sprayer.x = _streamLengthInfo.x;
        _sprayer.y = 25;

        //hide all initially
        _alphaEditor.visible = false;
        _phiEditor.visible = false;
        _sprayerWidthEditor.visible = false;
        _sprayerLengthEditor.visible = false;
        _streamLengthInfo.visible = false;
        _sprayer.visible = false;
    }


    public function get fountain():Fountain {
        return _fountain;
    }

    public function set fountain(value:Fountain):void {
        if (_fountain != null)
            _fountain.removeEventListener(Event.CHANGE, fountainChangeHandler);

        _fountain = value;

        if (_fountain != null)
            _fountain.addEventListener(Event.CHANGE, fountainChangeHandler);

        var show:Boolean = _fountain != null;

        _alphaEditor.visible = show;
        _phiEditor.visible = show;
        _sprayerWidthEditor.visible = show && _showSprayer;
        _sprayerLengthEditor.visible = show && _showSprayer;
        _streamLengthInfo.visible = show;
        _sprayer.visible = show;

        fountainChangeHandler(null);
    }

    private function fountainChangeHandler(event:Event):void {
        _alphaEditor.value = _fountain.alphaGr;
        _phiEditor.value = _fountain.phiGr;
        _sprayerWidthEditor.value = _fountain.d * 100;
        _sprayerLengthEditor.value = _fountain.l * 100;

        _streamLengthInfo.text = _fountain.stream.goes_out ?
                "Длина: выходит наружу" :
                "Длина: " + _fountain.stream.length.toFixed(3);
    }

    private function alphaEditor_changeHandler(event:Event):void {
        if (_fountain != null && !_alphaEditor.has_error()) {
            _fountain.alphaGr = _alphaEditor.value;
            _sprayer.rotate(_alphaEditor.value * Math.PI / 180);
            _api.autoSaveSolution();
        }
    }

    private function phiEditor_changeHandler(event:Event):void {
        if (_fountain != null && !_phiEditor.has_error()) {
            _fountain.phiGr = _phiEditor.value;
            _api.autoSaveSolution();
        }
    }

    private function sprayerWidthEditor_changeHandler(event:Event):void {
        if (_fountain != null && !_sprayerWidthEditor.has_error()) {
            var newValue:Number = _sprayerWidthEditor.value / 100;

            _sprayer.f_width = newValue;
            _fountain.d = newValue;
            _api.autoSaveSolution();
        }
    }

    private function sprayerLengthEditor_changeHandler(event:Event):void {
        if (_fountain != null && !_sprayerLengthEditor.has_error()) {
            var newValue:Number = _sprayerLengthEditor.value / 100;

            _sprayer.f_length = newValue;
            _fountain.l = newValue;
            _api.autoSaveSolution();
        }
    }
}
}
