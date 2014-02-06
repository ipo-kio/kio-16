/**
 * Created by ilya on 31.01.14.
 */
package ru.ipo.kio._14.peterhof {
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio._14.peterhof.model.Fountain;

public class FountainPanel extends Sprite {

    private var _fountain:Fountain = null;

    private var _alphaEditor:NumberEditor;
    private var _phiEditor:NumberEditor;
    private var _sprayerWidthEditor:NumberEditor;
    private var _sprayerLengthEditor:NumberEditor;

    private var _streamLengthInfo:TextField;

    public function FountainPanel(width:int) {
        _alphaEditor = new NumberEditor(width, 40, 0, 90, 45, "°", 0);
        var alphaEditor:TitledObject = new TitledObject("Наклон", 20, 0x0FFFFF, _alphaEditor);
        addChild(alphaEditor);

        _phiEditor = new NumberEditor(width, 40, -180, 180, 0, "°", 0);
        var phiEditor:TitledObject = new TitledObject("Поворот", 20, 0x0FFFFF, _phiEditor);
        addChild(phiEditor);
        phiEditor.y = alphaEditor.height;

        _sprayerWidthEditor = new NumberEditor(width, 40, 0.1, 10, 0.1, "см", 1);
        var sprayerWidthEditor:TitledObject = new TitledObject("Ширина ф.", 20, 0x0FFFFF, _sprayerWidthEditor);
        addChild(sprayerWidthEditor);
        sprayerWidthEditor.y = phiEditor.y + phiEditor.height;

        _sprayerLengthEditor = new NumberEditor(width, 40, 0.1, 10, 5, "см", 1);
        var sprayerLengthEditor:TitledObject = new TitledObject("Длина ф.", 20, 0x0FFFFF, _sprayerLengthEditor);
        addChild(sprayerLengthEditor);
        sprayerLengthEditor.y = sprayerWidthEditor.y + sprayerWidthEditor.height;

        _streamLengthInfo = new TextField();
        _streamLengthInfo.selectable = false;
        _streamLengthInfo.defaultTextFormat = new TextFormat("KioArial", 18, 0xFFFFFF);
        _streamLengthInfo.autoSize = TextFieldAutoSize.LEFT;
        _streamLengthInfo.multiline = true;
        addChild(_streamLengthInfo);
        _streamLengthInfo.y = sprayerLengthEditor.y + sprayerLengthEditor.height;

        _alphaEditor.addEventListener(Event.CHANGE, alphaEditor_changeHandler);
        _phiEditor.addEventListener(Event.CHANGE, phiEditor_changeHandler);
        _sprayerWidthEditor.addEventListener(Event.CHANGE, sprayerWidthEditor_changeHandler);
        _sprayerLengthEditor.addEventListener(Event.CHANGE, sprayerLengthEditor_changeHandler);

        _alphaEditor.visible = false;
        _phiEditor.visible = false;
        _sprayerWidthEditor.visible = false;
        _sprayerLengthEditor.visible = false;
        _streamLengthInfo.visible = false;
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
        _sprayerWidthEditor.visible = show;
        _sprayerLengthEditor.visible = show;
        _streamLengthInfo.visible = show;

        fountainChangeHandler(null);
    }

    private function fountainChangeHandler(event:Event):void {
        _alphaEditor.value = _fountain.alphaGr;
        _phiEditor.value = _fountain.phiGr;
        _sprayerWidthEditor.value = _fountain.d * 100;
        _sprayerLengthEditor.value = _fountain.l * 100;

        _streamLengthInfo.text = _fountain.stream.goes_out ?
                "Длина:\nвыходит наружу" :
                "Длина:\n" + _fountain.stream.length.toFixed(3);
    }

    private function alphaEditor_changeHandler(event:Event):void {
        if (_fountain != null && !_alphaEditor.has_error())
            _fountain.alphaGr = _alphaEditor.value;
    }

    private function phiEditor_changeHandler(event:Event):void {
        if (_fountain != null && !_phiEditor.has_error())
            _fountain.phiGr = _phiEditor.value;
    }

    private function sprayerWidthEditor_changeHandler(event:Event):void {
        if (_fountain != null && !_sprayerWidthEditor.has_error())
            _fountain.d = _sprayerWidthEditor.value / 100;
    }

    private function sprayerLengthEditor_changeHandler(event:Event):void {
        if (_fountain != null && !_sprayerLengthEditor.has_error())
            _fountain.l = _sprayerLengthEditor.value / 100;
    }
}
}
