/**
 *
 * @author: Vasiliy
 * @date: 22.02.13
 */
package ru.ipo.kio._13.clock.model.level {
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.utils.MathUtils;
import ru.ipo.kio._13.clock.view.gui.HourArrow;
import ru.ipo.kio._13.clock.view.gui.MinuteArrow;

public class BasicProductDrawer {

    protected var productSprite:Sprite = new Sprite();

    public function BasicProductDrawer() {
    }

   public function getProductSprite():Sprite {
        return productSprite;
    }

    protected function rotateAroundCenter (sprite:Sprite, alpha:Number):void {
        var m:Matrix=sprite.transform.matrix;
        var point:Point = new Point(sprite.x, sprite.y);
        m.tx -= point.x;
        m.ty -= point.y;
        m.rotate (-alpha+Math.PI/2);
        m.tx += point.x;
        m.ty += point.y;
        sprite.transform.matrix=m;
    }

    protected function drawArrow(x:int, y:int, length:int, alpha:Number,holst:Sprite):void {
        var outerPoint:Point = new Point(0, length);
        outerPoint = MathUtils.rotate(outerPoint, alpha);
        holst.graphics.moveTo(x, y);
        holst.graphics.lineTo(outerPoint.x + x, outerPoint.y + y);
    }

    protected function clearProductSprite():void {
        productSprite.graphics.clear();
        while (productSprite.numChildren > 0) {
            productSprite.removeChildAt(0);
        }

        productSprite.graphics.beginFill(0x000000);
        productSprite.graphics.drawRect(0,0,675,400);
        productSprite.graphics.endFill();
    }

    protected function drawArrows():void {
        var holst:Sprite = new Sprite();
        productSprite.addChild(holst);
        holst.graphics.lineStyle(1, 0x000000);

        var hourArrow:Sprite = new HourArrow();
        productSprite.addChild(hourArrow);
        hourArrow.x = 340;
        hourArrow.y = 170;
        rotateAroundCenter(hourArrow, TransmissionMechanism.instance.firstGear.upperGear.alpha);

        if (TransmissionMechanism.instance.isFinished()) {
            var minuteArrow:Sprite = new MinuteArrow();
            productSprite.addChild(minuteArrow);
            minuteArrow.x = 340;
            minuteArrow.y = 170;
            rotateAroundCenter(minuteArrow, TransmissionMechanism.instance.firstGear.lowerGear.alpha);

            drawArrow(590, 180, 30, TransmissionMechanism.instance.firstGear.lowerGear.alpha, holst);
            drawArrow(590, 180, 20, TransmissionMechanism.instance.firstGear.upperGear.alpha, holst);
        } else {
            drawArrow(590, 180, 30, TransmissionMechanism.instance.getLastInChain().alpha, holst);
        }
    }
}
}
