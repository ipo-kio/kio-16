/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 25.01.13
 * Time: 16:14
 */
package ru.ipo.kio._13.cut.model {

public class Piece {

    public static const PIECE_1:Array = [ //   #
        new FieldCords(0, 0),             //  ###
        new FieldCords(0, 1),
        new FieldCords(1, 0),
        new FieldCords(-1, 0)
    ];

    public static const PIECE_2:Array = [ //  ###
        new FieldCords(0, 0),             //   #
        new FieldCords(0, -1),
        new FieldCords(1, 0),
        new FieldCords(-1, 0)
    ];

    public static const PIECE_3:Array = [ //   #
        new FieldCords(0, 0),             //  ##
        new FieldCords(0, 1),             //   #
        new FieldCords(0, -1),
        new FieldCords(-1, 0)
    ];

    public static const PIECE_4:Array = [ //   #
        new FieldCords(0, 0),             //   ##
        new FieldCords(0, 1),             //   #
        new FieldCords(0, -1),
        new FieldCords(1, 0)
    ];

    private var _x:int;
    private var _y:int;
    private var _elements:Array;
    private var _outline:Array;
    private var _blocks:Array;

    public function Piece(elements:Array) {
        _elements = elements;
        _outline = PiecesField.generateOutline(_elements)[0];
        evaluateBlocks();
    }

    public function intersects(that:Piece):Boolean {
        for each (var thisCords:FieldCords in _elements)
            for each (var thatCords:FieldCords in that._elements)
                if (_x + thisCords.x == that._x + thatCords.x && _y + thisCords.y == that._y + thatCords.y)
                    return true;

        return false;
    }

    public function move(x:int, y:int):void {
        _x = x;
        _y = y;
        evaluateBlocks();
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }

    public function get elements():Array {
        return _elements;
    }

    public function get outline():Array {
        return _outline;
    }

    public function get blocks():Array {
        return _blocks;
    }

    private function evaluateBlocks():void {
        _blocks = [];
        for each (var element:FieldCords in _elements)
            _blocks.push(new FieldCords(_x + element.x, _y + element.y));
    }
}
}
