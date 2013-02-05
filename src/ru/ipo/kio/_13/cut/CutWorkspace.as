package ru.ipo.kio._13.cut {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._13.cut.model.Cut;
import ru.ipo.kio._13.cut.model.CutsField;
import ru.ipo.kio._13.cut.model.Piece;
import ru.ipo.kio._13.cut.view.CutPieceFieldView;
import ru.ipo.kio._13.cut.view.CutsFieldView;
import ru.ipo.kio._13.cut.view.PiecesFieldView;
import ru.ipo.kio.api.*;
import ru.ipo.kio.api_example.*;

/**
 * Это спрайт для отображения задачи из примера API
 * @author Ilya
 */
public class CutWorkspace extends Sprite {

    private static const CONTROLS_WIDTH:int = 200;
    private static const CUTS_COUNT:int = 6;

    private static const M:int = 10;
    private static const N:int = 10;

    private var field:CutPieceFieldView;

    public function CutWorkspace() {
        //получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
        var api:KioApi = KioApi.instance(ExampleProblem.ID);

        var controls:CutControls = new CutControls(CONTROLS_WIDTH, M * PiecesFieldView.CELL_HEIGHT);
        addChild(controls);

//        var p1:Piece = new Piece(Piece.PIECE_1);
//        var p2:Piece = new Piece(Piece.PIECE_2);
//        var p3:Piece = new Piece(Piece.PIECE_3);
//        var p4:Piece = new Piece(Piece.PIECE_4);

//        p2.move(2, 2);
//        p1.move(2, 4);
//        p3.move(4, 3);
//        p4.move(4, 6);

        var cuts:Array = [];

        for (var i:int = 0; i < CUTS_COUNT; i++)
            cuts.push(new Cut);

        field = new CutPieceFieldView(M, N, cuts);

        field.resetCuts(5, M * CutsFieldView.SCALE - 5, 2, 2);

//        field.piecesField.addPiece(p1);
//        field.piecesField.addPiece(p2);
//        field.piecesField.addPiece(p3);
//        field.piecesField.addPiece(p4);
//
        field.x = CONTROLS_WIDTH;
        addChild(field);

        controls.switchFieldsButton.addEventListener(MouseEvent.CLICK, switchFieldsHandler);

        field.addEventListener(CutsField.CUTS_CHANGED, function (event:Event):void {
            controls.numPolys = field.numPolys;
        });
    }

    public function currentResult():Object {
        return {};
    }

    private function switchFieldsHandler(event:MouseEvent):void {
        field.cutsRegime = ! field.cutsRegime;
    }
}

}