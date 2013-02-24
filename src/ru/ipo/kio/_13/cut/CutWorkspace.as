package ru.ipo.kio._13.cut {

import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._13.cut.model.ColoredPoly;

import ru.ipo.kio._13.cut.model.Cut;
import ru.ipo.kio._13.cut.model.CutsField;
import ru.ipo.kio._13.cut.model.FieldCords;
import ru.ipo.kio._13.cut.model.Piece;
import ru.ipo.kio._13.cut.model.PiecesField;
import ru.ipo.kio._13.cut.view.CutPieceFieldView;
import ru.ipo.kio._13.cut.view.InfoPanel;
import ru.ipo.kio._13.cut.view.PiecesFieldView;
import ru.ipo.kio.api.*;

public class CutWorkspace extends Sprite {

    private static const CONTROLS_WIDTH:int = 200;
    private static const CUTS_COUNT:int = 6;

    private static const M:int = 10;
    private static const N:int = 10;

    private var field:CutPieceFieldView;
    private var cutControls:CutControls;

    private var loadingProcess:Boolean = false;

    private static const api:KioApi = KioApi.instance(CutProblem.ID);

    public function CutWorkspace() {
        TextUtils.embedFonts();

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
        infoPanel.setValue(CutControls.OFFCUTS_IND, result.offcuts);

        if (!isRecord) {
            api.submitResult(result);
            if (! loadingProcess)
                api.autoSaveSolution();
        }
    }

    public function currentResult():Object {
        var result:Object = {
            'pieces': field.piecesField.piecesCount
        };

        var cutField:CutsField = field.cutsField;
        if (cutField == null) {
            result.polys = 0;
            result.offcuts = 0;
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

        result.offcuts = cutField.polygons.length - normal;

        return result;
    }

    private function recordChanged(event:Event):void {
        var result:Object = currentResult();
        api.log('new record! @BBB', result.polys, result.pieces, result.offcuts);
        updateCurrentResult(true);
    }

    public function get solution():Object {
        //get pieces
        var pieces:Array = []; //TODO report it thinks contents of this array is never read
        for each (var piece:Piece in field.piecesField.pieces) {
            var block:FieldCords = piece.blocks[0];
            pieces.push([block.x, block.y]);
        }

        //get cuts
        var cuts:Array = [];
        for each (var cut:Cut in field.cuts)
            cuts.push([cut.p1.x, cut.p1.y, cut.p2.x, cut.p2.y]);

        return {
            pieces: pieces,
            cuts: cuts
        };
    }

    public function load(solution:Object):Boolean {
        if (solution == null)
            return true;

        try {
            loadingProcess = true; //don't save while loading

            field.cutsRegime = false;
            field.piecesField.loadPieces(solution.pieces);
            field.loadCuts(solution.cuts);
            field.cutsRegime = true;
        } catch (e:Error) {
            return false;
        } finally {
            loadingProcess = false;
        }

        return true;
    }
}

}