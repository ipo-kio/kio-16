/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 01.02.13
 * Time: 13:30
 */
package ru.ipo.kio._13.cut {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import ru.ipo.kio.api.controls.ButtonBuilder;

import ru.ipo.kio._13.cut.model.PiecesField;
import ru.ipo.kio._13.cut.view.CutPieceFieldView;
import ru.ipo.kio._13.cut.view.CutsFieldView;
import ru.ipo.kio._13.cut.view.InfoPanel;
import ru.ipo.kio.api.KioApi;

public class CutControls extends Sprite {

    private var _w:int;
    private var _h:int;
    private var _switchFieldsButtonToCuts:SimpleButton;
    private var _switchFieldsButtonToPieces:SimpleButton;

    private var _currentResultsInfo:InfoPanel;
    private var _recordsInfo:InfoPanel;

    private const loc:Object = KioApi.getLocalization(CutProblem.ID);
    public static const POLYS_IND:int = 0;
    public static const PIECES_IND:int = 1;
    public static const OFFCUTS_IND:int = 2;
    private var _field:CutPieceFieldView;
    private var _errors:TextField;

    public function CutControls(w:int, h:int, field:CutPieceFieldView) {
        _w = w;
        _h = h;
        _field = field;

        drawBackground();

        var innerW:Number = _w * 0.9;
        var x0:Number = (_w - innerW) / 2;
        var y0:Number = 20;

        var buttonBuilder:ButtonBuilder = new ButtonBuilder();
        buttonBuilder.upColor = 0x00EE00;
        buttonBuilder.downColor = 0x00AA00;
        buttonBuilder.upHoverColor = 0xEEEE00;
        buttonBuilder.downHoverColor = 0xAAAA00;
        buttonBuilder.borderColor = 0x004400;
        buttonBuilder.innerBorderColor = 0x88AA88;
        buttonBuilder.font = "KioArial";
        buttonBuilder.embedFont = true;
        buttonBuilder.fontSize = 14;
        buttonBuilder.fontColor = 0x000000;
        buttonBuilder.bold = true;

        buttonBuilder.width = innerW;
        buttonBuilder.height = 44;

        buttonBuilder.title = loc.labels.switch_to_cuts;

        _switchFieldsButtonToCuts = buttonBuilder.build();
        _switchFieldsButtonToCuts.x = x0;
        _switchFieldsButtonToCuts.y = y0;
        addChild(_switchFieldsButtonToCuts);

        buttonBuilder.title = loc.labels.switch_to_poly;

        _switchFieldsButtonToPieces = buttonBuilder.build();
        _switchFieldsButtonToPieces.x = x0;
        _switchFieldsButtonToPieces.y = y0;
        addChild(_switchFieldsButtonToPieces);
        _switchFieldsButtonToPieces.visible = false;

        _currentResultsInfo = new InfoPanel(
                'KioArial', true, 16,
                0xDDFFDD, 0xFFFFFF, 0xFFFFFF, 1.5,
                loc.labels.results,
                [loc.labels.polys, loc.labels.area, loc.labels.offcuts],
                w * 0.9
        );
        _recordsInfo = new InfoPanel(
                'KioArial', true, 16,
                0xDDFFDD, 0xFFFFFF, 0xFFFFFF, 1.5,
                loc.labels.record,
                [loc.labels.polys, loc.labels.area, loc.labels.offcuts],
                w * 0.9
        );

        _currentResultsInfo.x = 0.05 * _w;
        _currentResultsInfo.y = 180;
        _recordsInfo.x = 0.05 * _w;
        _recordsInfo.y = 320;

        addChild(_currentResultsInfo);
        addChild(_recordsInfo);

        _errors = new TextField();
        _errors.x = 0.05 * _w;
        _errors.y = 100;
        _errors.width = innerW;
        _errors.multiline = true;
        _errors.wordWrap = true;
        _errors.defaultTextFormat = new TextFormat('KioArial', 12, 0xFFFFFF);
        _errors.text = "";
        addChild(_errors);

        buttonBuilder.width = _w * 0.5;
        buttonBuilder.title = loc.labels.clear;
        buttonBuilder.height = 30;

        var _clearButton:SimpleButton = buttonBuilder.build();
        _clearButton.x = x0;
        _clearButton.y = _h - 44;
        addChild(_clearButton);
        _clearButton.addEventListener(MouseEvent.CLICK, clearButtonHandler);

        _switchFieldsButtonToCuts.addEventListener(MouseEvent.CLICK, switchButtonClickHandler);
        _switchFieldsButtonToPieces.addEventListener(MouseEvent.CLICK, switchButtonClickHandler);
        _field.addEventListener(PiecesField.PIECES_CHANGED, piecesChangedHandler);
        _field.addEventListener(CutPieceFieldView.REGIME_CHANGE, fieldRegimeHandler);

        piecesChangedHandler();
    }

    private function drawBackground():void {
        graphics.beginFill(0x008800);
        graphics.drawRect(0, 0, _w, _h);
        graphics.endFill();
    }

    public function get currentResultsInfo():InfoPanel {
        return _currentResultsInfo;
    }

    public function get recordsInfo():InfoPanel {
        return _recordsInfo;
    }

    private function piecesChangedHandler(event:Event = null):void {
        if (_field.piecesConfigurationIsValid()) {
            _errors.text = "";
            _switchFieldsButtonToCuts.enabled = true;
        } else {
            var errorMessages:Array = _field.validatePiecesConfiguration();
            _errors.text = errorMessages.join('\n');
            _switchFieldsButtonToCuts.enabled = false;
        }
    }

    private function switchButtonClickHandler(event:MouseEvent):void {
        _field.cutsRegime = !_field.cutsRegime;
    }

    public function clickClearButton():void {
        clearButtonHandler();
    }

    private function clearButtonHandler(event:MouseEvent = null):void {
        _field.cutsRegime = false;
        _field.piecesField.clearPieces();

        resetCuts();
    }

    public function resetCuts():void {
        if (KioApi.instance(CutProblem.ID).problem.level == 0)
            _field.resetCuts(0, _field.piecesField.m * CutsFieldView.SCALE, 2, 2);
        else
            _field.resetCuts(5, _field.piecesField.m * CutsFieldView.SCALE - 5, 2, 2);
    }

    private function fieldRegimeHandler(event:Event):void {
        _switchFieldsButtonToCuts.visible = ! _field.cutsRegime;
        _switchFieldsButtonToPieces.visible = _field.cutsRegime;
    }
}
}
