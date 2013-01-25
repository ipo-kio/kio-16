package ru.ipo.kio._13.cut {
import ru.ipo.kio._13.cut.model.Piece;
import ru.ipo.kio._13.cut.model.PiecesField;
import ru.ipo.kio._13.cut.view.PiecesFieldView;
import ru.ipo.kio.api_example.*;

import flash.display.Sprite;

import ru.ipo.kio.api.*;

/**
 * Это спрайт для отображения задачи из примера API
 * @author Ilya
 */
public class CutWorkspace extends Sprite {

    public function CutWorkspace() {
        //получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
        var api:KioApi = KioApi.instance(ExampleProblem.ID);

        var piecesField:PiecesField = new PiecesField(20, 20);

        var p1:Piece = new Piece(Piece.PIECE_1);
        var p2:Piece = new Piece(Piece.PIECE_2);
        var p3:Piece = new Piece(Piece.PIECE_3);
        var p4:Piece = new Piece(Piece.PIECE_4);

        p1.move(2, 2);
        p2.move(2, 5);
        p3.move(4, 3);
        p4.move(10, 10);
        piecesField.addPiece(p1);
        piecesField.addPiece(p2);
        piecesField.addPiece(p3);
        piecesField.addPiece(p4);

        addChild(new PiecesFieldView(piecesField));
    }

    public function currentResult():Object {
        return {};
    }

}

}