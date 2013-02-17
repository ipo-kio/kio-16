/**
 *
 * @author: Vasiliy
 * @date: 16.01.13
 */
package ru.ipo.kio._13.clock.view {
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

import mx.utils.object_proxy;

import ru.ipo.kio._13.clock.ClockSprite;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.utils.MathUtils;

public class ResultSprite extends Sprite {

    [Embed(source='../_resources/level0/1.png')]
    private static const LEVEL0_1:Class;

    [Embed(source='../_resources/level0/2.png')]
    private static const LEVEL0_2:Class;

    [Embed(source='../_resources/level0/3.png')]
    private static const LEVEL0_3:Class;

    [Embed(source='../_resources/level0/4.png')]
    private static const LEVEL0_4:Class;

    [Embed(source='../_resources/level0/5.png')]
    private static const LEVEL0_5:Class;

    [Embed(source='../_resources/level0/6.png')]
    private static const LEVEL0_6:Class;


    [Embed(source='../_resources/level0/arrow.png')]
    private static const LEVEL0_ARR1:Class;

    [Embed(source='../_resources/level0/arrow_m.png')]
    private static const LEVEL0_ARR1M:Class;


    [Embed(source='../_resources/level0/arrow_small.png')]
    private static const LEVEL0_ARR2:Class;

    [Embed(source='../_resources/level0/arrow_small_m.png')]
    private static const LEVEL0_ARR2M:Class;


    public static var instance:ResultSprite;

    private var _holst01:Sprite = new Sprite();

    private var _holst02:Sprite = new Sprite();

    private var _holst03:Sprite = new Sprite();

    private var _holst04:Sprite = new Sprite();

    private var _holst05:Sprite = new Sprite();

    private var _holst06:Sprite = new Sprite();

    private var _holstARR1:Sprite = new HourArrow();

    private var _holstARR1M:Sprite = new MinuteArrow();

    private var _holstARR2:Sprite = new Sprite();

    private var _holstARR2M:Sprite = new Sprite();

    public function ResultSprite() {
        instance=this;

        var c01 = new LEVEL0_1;
        _holst01.addChild(c01);
        var c02 = new LEVEL0_2;
        _holst02.addChild(c02);
        var c03 = new LEVEL0_3;
        _holst03.addChild(c03);
        var c04 = new LEVEL0_4;
        _holst04.addChild(c04);
        var c05 = new LEVEL0_5;
        _holst05.addChild(c05);
        var c06 = new LEVEL0_6;
        _holst06.addChild(c06);

//        _holstARR1.addChild(new LEVEL0_ARR1);
//        _holstARR1M.addChild(new LEVEL0_ARR1M);
//        _holstARR2.addChild(new LEVEL0_ARR2);
//        _holstARR2M.addChild(new LEVEL0_ARR2M);
    }
    
    var _iter:int = 0;
    
    var first:Boolean=false;

    var second:Boolean=false;

    private var _holst:Sprite;

    public function update(){
        graphics.clear();
        while(numChildren>0){
            removeChildAt(0);
        }

        var alpha = TransmissionMechanism.instance.firstGear.upperGear.alpha;
        if(alpha<3*Math.PI/2 && alpha>Math.PI/2){
            if(!first){
                first=true;
                second = false;
                _iter=(_iter+1)%2;
            }
        }else{
            if(first && !second){
                first = false;
                second = true;
            }
        }

        if(ClockSprite.instanse.level==0){
            if(alpha>3*Math.PI/2){
                var diff = (alpha-Math.PI*3/2)/(Math.PI/2);
                if(_iter==1){
                  addChild(_holst01);
                  addChild(_holst02);
                 _holst02.alpha=1-diff;
                }else{
                    addChild(_holst04);
                    addChild(_holst05);
                    _holst05.alpha=1-diff;
                }
            }else if(alpha<Math.PI/2){
                var diff = (alpha)/(Math.PI/2);
                if(_iter==1){
                    addChild(_holst06);
                    addChild(_holst01);
                    _holst01.alpha=1-diff;
                }else{
                    addChild(_holst03);
                    addChild(_holst04);
                    _holst04.alpha=1-diff;
                }
            }else{
                var diff = (alpha-Math.PI/2)/(Math.PI);
                if(_iter==1){
                    addChild(_holst05);
                    addChild(_holst06);
                    _holst06.alpha=1-diff;

                }else{
                    addChild(_holst02);
                    addChild(_holst03);
                    _holst03.alpha=1-diff;
                }
            }
            
        }else if(ClockSprite.instanse.level==1){

        }else{

        }

        var holst:Sprite = new Sprite();
        addChild(holst);

        _holst = holst;
        _holst.graphics.lineStyle(1,0x000000);

        _holstARR1 = new HourArrow();
        addChild(_holstARR1);
        _holstARR1.x = 340;
        _holstARR1.y = 170;
        rotateAroundCenter(_holstARR1, TransmissionMechanism.instance.firstGear.upperGear.alpha);
        if(TransmissionMechanism.instance.isFinished()){
            _holstARR1M = new MinuteArrow();
            addChild(_holstARR1M);
            _holstARR1M.x = 340;
            _holstARR1M.y = 170;
            rotateAroundCenter(_holstARR1M, TransmissionMechanism.instance.firstGear.lowerGear.alpha);

            drawArrow(590,180,30,TransmissionMechanism.instance.firstGear.lowerGear.alpha);
            drawArrow(590,180,20,TransmissionMechanism.instance.firstGear.upperGear.alpha);
        }else{
            drawArrow(590,180,30,TransmissionMechanism.instance.getLastInChain().alpha);
        }


    }

    function rotateAroundCenter (ob:*, alpha) {
        var m:Matrix=ob.transform.matrix;
        var point:Point = new Point(ob.x, ob.y);
        m.tx -= point.x;
        m.ty -= point.y;
        m.rotate (-alpha+Math.PI/2);
        m.tx += point.x;
        m.ty += point.y;
        ob.transform.matrix=m;
    }

  private function drawArrow(x:int, y:int, length:int, alpha:Number):void {
    var outerPoint:Point = new Point(0, length);
    outerPoint = MathUtils.rotate(outerPoint, alpha);
    _holst.graphics.moveTo(x, y);
    _holst.graphics.lineTo(outerPoint.x + x, outerPoint.y + y);
  }
}
}
