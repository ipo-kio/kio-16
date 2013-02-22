package ru.ipo.kio._13.cut {

import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._13.blocks.view.Button2;

import ru.ipo.kio._13.cut.model.ColoredPoly;

import ru.ipo.kio._13.cut.model.Cut;
import ru.ipo.kio._13.cut.model.CutsField;
import ru.ipo.kio._13.cut.model.PiecesField;
import ru.ipo.kio._13.cut.view.CutPieceFieldView;
import ru.ipo.kio._13.cut.view.InfoPanel;
import ru.ipo.kio._13.cut.view.PiecesFieldView;
import ru.ipo.kio.api.*;

public class CutWorkspace extends Sprite {

    [Embed(source='resources/ARICYR.TTF',
            embedAsCFF="false",
            fontName="KioArial",
            mimeType="application/x-font-truetype",
            unicodeRange="U+0000-U+FFFF")]
    private static var ARIAL_FONT:Class;

    [Embed(source='resources/ARICYRB.TTF',
            embedAsCFF="false",
            fontName="KioArial",
            fontWeight="bold",
            mimeType="application/x-font-truetype",
            unicodeRange="U+0000-U+FFFF")]
    private static var ARIAL_FONT_B:Class;

    private static const CONTROLS_WIDTH:int = 200;
    private static const CUTS_COUNT:int = 6;

    private static const M:int = 10;
    private static const N:int = 10;

    private var field:CutPieceFieldView;
    private var cutControls:CutControls;

    private static const api:KioApi = KioApi.instance(CutProblem.ID);

    public function CutWorkspace() {
        Button2.UPPER_COLOR = 0x00EE00;
        Button2.DOWN_COLOR = 0x00AA00;
        Button2.BORDER_COLOR = 0x004400;
        Button2.INNER_BORDER_COLOR = 0x88AA88;

        var cuts:Array = [];

        for (var i:int = 0; i < CUTS_COUNT; i++)
            cuts.push(new Cut);

        field = new CutPieceFieldView(M, N, cuts);

        cutControls = new CutControls(CONTROLS_WIDTH, M * PiecesFieldView.CELL_HEIGHT, field);
        addChild(cutControls);

        field.x = CONTROLS_WIDTH;
        addChild(field);

        field.addEventListener(CutsField.CUTS_CHANGED, cutsChangeHandler);
        field.addEventListener(PiecesField.PIECES_CHANGED, piecesChangeHandler);
        api.addEventListener(KioApi.RECORD_EVENT, recordChanged);

        cutControls.resetCuts();
    }

    private function cutsChangeHandler(event:Event):void {
        updateCurrentResult();
    }

    private function piecesChangeHandler(event:Event):void {
        updateCurrentResult();
    }

    public function updateCurrentResult(isRecord:Boolean = false):void {
        var result:Object = currentResult(); //TODO report extract variable with the same name as an extracted expression

        var infoPanel:InfoPanel = isRecord ? cutControls.recordsInfo : cutControls.currentResultsInfo;

        infoPanel.setValue(CutControls.POLYS_IND, result.polys);
        infoPanel.setValue(CutControls.PIECES_IND, result.pieces);

        if (!isRecord)
            api.submitResult(result);
    }

    public function currentResult():Object {
        var result:Object = {
            'pieces': field.piecesField.piecesCount
        };

        var cutField:CutsField = field.cutsField;
        if (cutField == null) {
            result.polys = 0;
            return result;
        }

        var normNontriangles:int = 0;

        //count normal and small polygons
        var normal:int = 0;
        for each (var coloredPoly:ColoredPoly in cutField.polygons)
            if (coloredPoly.isNormal) {
                normal++;
                if (coloredPoly.poly.getNumPoints() > 3)
                    normNontriangles++;
            }

        if (api.problem.level == 2)
            result.polys = normNontriangles;
        else
            result.polys = normal;

        return result;
    }

    private function recordChanged(event:Event):void {
        updateCurrentResult(true);
    }

    public function get solution():Object {
        return {};
    }
}

}