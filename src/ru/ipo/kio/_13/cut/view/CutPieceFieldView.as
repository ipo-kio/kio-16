/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 01.02.13
 * Time: 14:25
 */
package ru.ipo.kio._13.cut.view {

import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._13.cut.CutProblem;
import ru.ipo.kio._13.cut.model.Cut;

import ru.ipo.kio._13.cut.model.CutsField;
import ru.ipo.kio._13.cut.model.FieldCords;

import ru.ipo.kio._13.cut.model.PiecesField;
import ru.ipo.kio.api.KioApi;

public class CutPieceFieldView extends Sprite {

    private var _piecesField:PiecesField;
    private var _cutsField:CutsField;
    private var _cuts:Array; //array of cuts
    private var _cutsRegime:Boolean = true; //TODO report can not assign null to Boolean

    private var field:Sprite = null;

    public function CutPieceFieldView(m:int, n:int, cuts:Array) {
        _piecesField = new PiecesField(m, n);
        _cuts = cuts;

        //is is true by default
        this.cutsRegime = false;
    }

    public function get m():int {
        return _piecesField.m;
    }

    public function get n():int {
        return _piecesField.n;
    }

    public function get cutsRegime():Boolean {
        return _cutsRegime;
    }

    public function get piecesField():PiecesField {
        return _piecesField;
    }

    public function get cutsField():CutsField {
        return _cutsField;
    }

    public function get cuts():Array {
        return _cuts;
    }

    /**
     * returns array of error messages with the empty array if there are no errors
     */
    public function validatePiecesConfiguration():Array {
        var messages:Array = [];
        var api:KioApi = KioApi.instance(CutProblem.ID);
        if (_piecesField.hasInnerBlocks)
            messages.push(api.localization.errors.has_inner);
        if (_piecesField.hasOuterBlocks)
            messages.push(api.localization.errors.has_outer);
        if (_piecesField.blocksCount == 0)
            messages.push(api.localization.errors.no_elements);
        if (_piecesField.thinPoly)
            messages.push(api.localization.errors.thin_poly);
        return messages;
    }

    public function piecesConfigurationIsValid():Boolean {
        return validatePiecesConfiguration().length == 0;
    }

    public function set cutsRegime(value:Boolean):void {
        if (value == _cutsRegime)
            return;

        if (value && ! piecesConfigurationIsValid()) //if we set cuts regime
            return;

        _cutsRegime = value;

        if (field != null)
            removeChild(field);

        if (_cutsRegime) {
            if (_piecesField != null)
                _piecesField.removeEventListener(PiecesField.PIECES_CHANGED, piecesChanged);
            _cutsField = new CutsField(_cuts, _piecesField);

            _cutsField.addEventListener(CutsField.CUTS_CHANGED, cutsChanged);
            field = new CutsFieldView(m, n, cutsField);
        } else {
            if (_cutsField != null)
                _cutsField.removeEventListener(CutsField.CUTS_CHANGED, cutsChanged);
            _cutsField = null;

            _piecesField.addEventListener(PiecesField.PIECES_CHANGED, piecesChanged);
            field = new PiecesFieldViewSinglePieces(_piecesField);
        }

        addChild(field);

        if (_cutsRegime)
            dispatchEvent(new Event(CutsField.CUTS_CHANGED));
        else
            dispatchEvent(new Event(PiecesField.PIECES_CHANGED));
    }

    private function piecesChanged(event:Event):void {
        dispatchEvent(new Event(PiecesField.PIECES_CHANGED));
    }

    private function cutsChanged(event:Event):void { //TODO report create event handler fails to devise event type
        dispatchEvent(new Event(CutsField.CUTS_CHANGED));
    }

    public function resetCuts(x1:int, x2:int, y1:int, dy:int):void {
        for each (var cut:Cut in _cuts) {
            cut.p1 = new FieldCords(x1, y1);
            cut.p2 = new FieldCords(x2, y1);

            y1 += dy;
        }
    }

    public function get numPolys():int {
        return _cutsField == null ? 0 : _cutsField.polygons.length;
    }

    public function loadCuts(cuts:Array):void {
        for (var i:int = 0; i < cuts.length; i++) {
            var cutCords:Array = cuts[i];
            var cut:Cut = _cuts[i];
            cut.p1 = new FieldCords(cutCords[0], cutCords[1]);
            cut.p2 = new FieldCords(cutCords[2], cutCords[3]);
        }
    }
}
}
