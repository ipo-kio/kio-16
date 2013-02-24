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

    public static const SMALL_MINUTE_ARROW_LENGTH:int = 30;

    public static const SMALL_HOUR_ARROW_LENGTH:int = 20;

    protected function drawArrows(bigCenterX:int,bigCenterY:int,smallCenterX:int,smallCenterY:int):void {
        var holst:Sprite = new Sprite();
        productSprite.addChild(holst);
        holst.graphics.lineStyle(1, 0x000000);

        var hourArrow:Sprite = new HourArrow();
        productSprite.addChild(hourArrow);
        hourArrow.x = bigCenterX;
        hourArrow.y = bigCenterY;
        rotateAroundCenter(hourArrow, TransmissionMechanism.instance.leadingSimpleGear.alpha);

        if (TransmissionMechanism.instance.isFinished()) {
            var minuteArrow:Sprite = new MinuteArrow();
            productSprite.addChild(minuteArrow);
            minuteArrow.x = bigCenterX;
            minuteArrow.y = bigCenterY;
            rotateAroundCenter(minuteArrow, TransmissionMechanism.instance.leadingSimpleGear.other.alpha);

            drawArrow(smallCenterX, smallCenterY, SMALL_MINUTE_ARROW_LENGTH, TransmissionMechanism.instance.leadingSimpleGear.other.alpha, holst);
            drawArrow(smallCenterX, smallCenterY, SMALL_HOUR_ARROW_LENGTH, TransmissionMechanism.instance.leadingSimpleGear.alpha, holst);
        } else {
            drawArrow(smallCenterX, smallCenterY, SMALL_MINUTE_ARROW_LENGTH, TransmissionMechanism.instance.lastDrivenSimpleGear.alpha, holst);
        }
    }

    protected function drawTwoImageFromArray(alpha:Number, angleToImages:Array):void {
        for (var i:int = 0; i < angleToImages.length; i++) {
            if (alpha < angleToImages[i][0] &&
                    alpha > angleToImages[i][0] - angleToImages[i][2]) {
                var diff:Number = (alpha - (angleToImages[i][0] - angleToImages[i][2])) / (angleToImages[i][2]);
                var firstImage:Sprite = angleToImages[i][1];
                var secondImage:Sprite = (i == angleToImages.length - 1) ? angleToImages[0][1] : angleToImages[i + 1][1];
                secondImage.alpha = 1 - diff;
                firstImage.alpha = 1;
                productSprite.addChild(firstImage);
                productSprite.addChild(secondImage);
                break;
            }
        }
    }
}
}
