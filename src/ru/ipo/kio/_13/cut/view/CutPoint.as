/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 27.01.13
 * Time: 21:57
 */
package ru.ipo.kio._13.cut.view {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio._13.cut.CutProblem;

import ru.ipo.kio._13.cut.model.Cut;
import ru.ipo.kio._13.cut.model.FieldCords;
import ru.ipo.kio.api.KioApi;

public class CutPoint extends Sprite {

    private static const POINT_COLOR:uint = 0xFF0000;
    private static const POINT_RADIUS:int = 4;

    private static const POINT_HIT_COLOR:uint = 0xFFFF00;
    private static const POINT_HIT_RADIUS:int = 6;

    private var _field:CutsFieldView;
    private var _cut:Cut;
    private var _ind:int;

    private var moving:Boolean = false;

    private var _level:int;

    public function CutPoint(field:CutsFieldView, cut:Cut, ind:int, level:int) {
        _field = field;
        _cut = cut;
        _ind = ind;
        _level = level;

        draw();
        createHitArea();

        addEventListener(MouseEvent.ROLL_OVER, rollOver);
        addEventListener(MouseEvent.ROLL_OUT, rollOut);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        //mouse up throw stage

        addEventListener(Event.ADDED_TO_STAGE, addedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);

        place();
    }

    private function addedToStage(event:Event):void {
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
    }

    private function removedFromStage(event:Event):void {
        stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
    }

    private function mouseUp(event:MouseEvent):void {
        if (!moving)
            return;

        if (!hitTestPoint(event.stageX, event.stageY))
            hitArea.visible = false;

        KioApi.log(CutProblem.ID, 'cut point mouse up');
        moving = false;
    }

    private function mouseDown(event:MouseEvent):void {
        moving = true;
        KioApi.log(CutProblem.ID, 'cut point mouse down');
    }

    private function mouseMove(event:MouseEvent):void {
        if (!moving)
            return;

        var fieldOrigin:Point = _field.localToGlobal(new Point(0, 0));
        var localX:Number = event.stageX - fieldOrigin.x;
        var localY:Number = event.stageY - fieldOrigin.y;

        var x:int = _field.screen2logicX(localX);
        var y:int = _field.screen2logicY(localY);

        if (_level == 0) {
            var otherP:FieldCords = _ind == 1 ? _cut.p2 : _cut.p1;
            var otherSideNum:int = sideNum(otherP.x, otherP.y);
            var thisSideNum:int = sideNum(x, y, otherSideNum);
            switch (thisSideNum) {
                case 1: x = 0; break;
                case 2: y = _field.maxY; break;
                case 3: x = _field.maxX; break;
                case 4: y = 0; break;
            }
        }

        var p:FieldCords = _ind == 1 ? _cut.p1 : _cut.p2;
        var newP:FieldCords = new FieldCords(x, y);

        if (p.equals(newP))
            return;

        if (_ind == 1)
            _cut.p1 = newP;
        else
            _cut.p2 = newP;

        place();
    }

    private function sideNum(x:int, y:int, excludeSide:int = -1):int {
        //1 - left, 2 - top, 3 - right, 4 - bottom
        var xMax:int = _field.maxX;
        var yMax:int = _field.maxY;

        var dx:int = x < xMax / 2 ? x : xMax - x;
        var dy:int = y < yMax / 2 ? y : yMax - y;
        var _1st:int;
        var _2nd:int;
        if (x < xMax / 2) {
            if (y < yMax / 2) { //1 4
                _1st = dx < dy ? 1 : 4;
                _2nd = dx < dy ? 4 : 1;
            } else { //1 2
                _1st = dx < dy ? 1 : 2;
                _2nd = dx < dy ? 2 : 1;
            }
        } else {
            if (y < yMax / 2) { //3 4
                _1st = dx < dy ? 3 : 4;
                _2nd = dx < dy ? 4 : 3;
            } else { //3 2
                _1st = dx < dy ? 3 : 2;
                _2nd = dx < dy ? 2 : 3;
            }
        }

        return excludeSide != _1st ? _1st : _2nd;
    }

    private function place():void {
        var p:FieldCords = _ind == 1 ? _cut.p1 : _cut.p2;
        x = _field.logic2screenX(p.x);
        y = _field.logic2screenY(p.y);
    }

    private function rollOver(event:MouseEvent):void {
        hitArea.visible = true;
    }

    private function rollOut(event:MouseEvent):void {
        if (! moving)
            hitArea.visible = false;
    }

    private function draw():void {
        graphics.lineStyle(1, 0x000000);
        graphics.beginFill(POINT_COLOR);
        graphics.drawCircle(0, 0, POINT_RADIUS);
        graphics.endFill();
    }

    private function createHitArea():void {
        hitArea = new Sprite();
        var g:Graphics = hitArea.graphics;

        g.lineStyle(1, 0x000000);
        g.beginFill(POINT_HIT_COLOR);
        g.drawCircle(0, 0, POINT_HIT_RADIUS);
        g.endFill();

        hitArea.visible = false;
        addChild(hitArea);
    }
}
}
