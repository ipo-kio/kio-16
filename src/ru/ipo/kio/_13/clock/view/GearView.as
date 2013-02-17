/**
 *
 * @author: Vasiliy
 * @date: 01.01.13
 */
package ru.ipo.kio._13.clock.view {
import flash.crypto.generateRandomBytes;
import flash.geom.Point;
import flash.sampler.isGetterSetter;

import mx.utils.object_proxy;

import ru.ipo.kio._13.clock.model.SimpleGear;
import ru.ipo.kio._13.clock.model.SettingsHolder;
import ru.ipo.kio._13.clock.model.TransferGear;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.utils.MathUtils;

public class GearView extends BasicView {
    
    private var _gear:SimpleGear;
    
    public function GearView(gear:SimpleGear) {
       _gear = gear;
    }
    
    public override function update():void{
        graphics.clear();

        var alpha:Number = 2*Math.PI/gear.amountOfCogs;
        var startPoint:Point = new Point(0,gear.innerRadius);
        var markPoint:Point = new Point(0,gear.innerRadius-5);
        markPoint = MathUtils.rotate(markPoint, gear.alpha);
        graphics.beginFill(0x333333);
        graphics.drawCircle(markPoint.x,  markPoint.y, 3);
        graphics.endFill();
        startPoint = MathUtils.rotate(startPoint, gear.alpha);
        var startOuterPoint:Point = new Point(0,gear.outerRadius);
        startOuterPoint = MathUtils.rotate(startOuterPoint, gear.alpha+alpha/2);
        graphics.moveTo(startPoint.x,  startPoint.y);
        if (gear.canBeCrossed()){
            drawCogs(startPoint, alpha, startOuterPoint);
            graphics.lineStyle(gear.bigCrossRadius-gear.smallCrossRadius,0x888888);
            if(gear.isCrossed()){
                graphics.lineStyle(gear.bigCrossRadius-gear.smallCrossRadius,0xff8888);
            }
            graphics.drawCircle(0,0,(gear.smallCrossRadius+gear.bigCrossRadius)/2);              
            graphics.lineStyle(1,0x777777);
            graphics.drawCircle(0,0,gear.smallCrossRadius);
            graphics.drawCircle(0,0,gear.bigCrossRadius);

        }else{
            drawCogs(startPoint, alpha, startOuterPoint);  
        }
        if(_gear.transferGear==TransmissionMechanism.instance.firstGear){
            graphics.lineStyle(1,0x000000);
            graphics.moveTo(0,0);
            var endPoint:Point = new Point(0,gear.innerRadius);
            endPoint = MathUtils.rotate(endPoint, gear.alpha);
             graphics.lineTo(endPoint.x,endPoint.y);
        }
        if(_gear.transferGear==TransmissionMechanism.instance.getLastInChain() && _gear.part == SimpleGear.LOWER_PART){
            graphics.lineStyle(1,0x555555);
            graphics.moveTo(0,0);
            var endPoint:Point = new Point(0,gear.innerRadius);
            endPoint = MathUtils.rotate(endPoint, gear.alpha);
            graphics.lineTo(endPoint.x,endPoint.y);
        }
    }

    private function drawCogs(startPoint:Point, alpha:Number, startOuterPoint:Point):void {
        graphics.lineStyle(1,0x777777);
        if(gear.transferGear.isActive){
          graphics.lineStyle(2,0x000000);
        }
        graphics.beginFill(gear.color, 0.7);
        for (var i:int = 0; i < gear.amountOfCogs; i++) {
            var point:Point = MathUtils.rotate(startPoint, i * alpha);
            var outerPoint:Point = MathUtils.rotate(startOuterPoint, i * alpha);
            graphics.lineTo(point.x, point.y);
            graphics.lineTo(outerPoint.x, outerPoint.y);
        }
        graphics.endFill();
    }

    public function get gear():SimpleGear {
        return _gear;
    }
}
}
