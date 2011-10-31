package ru.ipo.kio._11_students.CrossedCountry {
/**
 * ...
 * @author Anna
 */

import flash.display.Sprite;

public class gridObj extends Sprite {
    private var gridShape:Sprite;
    private var i:int;
    private var j:int;

    public function gridObj() {

        for (j = 0; j < 54; j++) {
            gridShape = new Sprite();
            gridShape.x = 20;
            gridShape.y = 25 + j * 10;

            gridShape.graphics.lineStyle(1, 0xffffff, 0.2);
            for (i = 0; i < 40; i++) {
                gridShape.graphics.lineTo(600, 0);
            }
            addChild(gridShape);
        }
        for (j = 0; j < 60; j++) {
            gridShape = new Sprite();
            gridShape.x = 25 + j * 10;
            gridShape.y = 20;

            gridShape.graphics.lineStyle(1, 0xffffff, 0.2);
            for (i = 0; i < 40; i++) {
                gridShape.graphics.lineTo(0, 540);
            }
            addChild(gridShape);
        }

    }

}
}