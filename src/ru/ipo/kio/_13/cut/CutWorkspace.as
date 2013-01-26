package ru.ipo.kio._13.cut {
import pl.bmnet.gpcas.geometry.Poly;
import pl.bmnet.gpcas.geometry.PolyDefault;
import pl.bmnet.gpcas.geometry.PolySimple;

import ru.ipo.kio._13.cut.model.Cut;
import ru.ipo.kio._13.cut.model.CutsField;
import ru.ipo.kio._13.cut.model.FieldCords;
import ru.ipo.kio._13.cut.model.Piece;
import ru.ipo.kio._13.cut.model.PiecesField;
import ru.ipo.kio._13.cut.view.CutsFieldView;
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

       /* var piecesField:PiecesField = new PiecesField(20, 20);

        var p1:Piece = new Piece(Piece.PIECE_1);
        var p2:Piece = new Piece(Piece.PIECE_2);
        var p3:Piece = new Piece(Piece.PIECE_3);
        var p4:Piece = new Piece(Piece.PIECE_4);

        p2.move(2, 2);
        p1.move(5, 3);
        p3.move(4, 3);
        p4.move(4, 6);
        piecesField.addPiece(p1);
        piecesField.addPiece(p2);
        piecesField.addPiece(p3);
        piecesField.addPiece(p4);

        addChild(new PiecesFieldView(piecesField));*/

        var cuts:Array = [
                new Cut(new FieldCords(15, 10), new FieldCords(15, 15)),
                new Cut(new FieldCords(20, 10), new FieldCords(10, 20)),
                new Cut(new FieldCords(0, 16), new FieldCords(5, 16))
        ];

        var poly:Poly = new PolyDefault();

        poly.addPointXY(10, 10);
        poly.addPointXY(10, 50);
        poly.addPointXY(30, 50);
        poly.addPointXY(30, 40);
        poly.addPointXY(20, 40);
        poly.addPointXY(20, 10);

        var cutField:CutsField = new CutsField(cuts, poly);

        var cutFieldView:CutsFieldView = new CutsFieldView(20, 20, cutField);

        addChild(cutFieldView);
    }

    public function currentResult():Object {
        return {};
    }

}

}