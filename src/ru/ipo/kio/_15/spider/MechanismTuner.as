/**
 * Created by ilya on 18.02.15.
 */
package ru.ipo.kio._15.spider {

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

import ru.ipo.kio.base.GlobalMetrics;

public class MechanismTuner extends Sprite {

    public static const MUL:Number = 3;

    private var _m:Mechanism;
    private var _center:Point;

    private var curveLayer:Sprite = new Sprite();

    private var s:Vector.<Stick> = new <Stick>[
        null,
        new Stick(0xFFB86F),
        new Stick(0x73CC81),
        new Stick(0xDAE871),
        new Stick(0x483A58),
        new Stick(0x56203D),
        new Stick(0xE0BAD7),
        new Stick(0xD30C7B)
    ];

    private var _slider:Slider = new Slider(0, 100, 320, 0x212121, 0x727272);

    private var _changingInd:int = -1;

    public function MechanismTuner(m:Mechanism) {
        _m = m;
        _center = _m.p1_p.add(_m.p2_p).add(_m.p3_p);
        _center.setTo(_center.x * MUL / 3, _center.y * MUL / 3);

        _m.addEventListener(Mechanism.EVENT_ANGLE_CHANGED, function (e:Event):void {
            positionSticks();
        });

        addChild(curveLayer);

        for (var i:int = 1; i < s.length; i++) {
            addChild(s[i]);
            s[i].addEventListener(Stick.SELECTED_CHANGED_EVENT, function (ind:int):Function {
                return function(e:Event):void {
                    if (!s[ind].selected) {
                        //test nothing is selected
                        for (var jj:int = 1; jj < s.length; jj++)
                            if (s[jj].selected)
                                return;

                        _slider.visible = false;

                        return;
                    }

                    var value:Number = s[ind].size;
                    _slider.reInit(10, 300, value);
                    _slider.visible = true;
                    _changingInd = ind;

                    for (var j:int = 1; j < s.length; j++)
                        if (j != ind)
                            s[j].selected = false;
                };
            }(i));
        }

        _slider.addEventListener(Slider.VALUE_CHANGED, slider_value_changedHandler);

        positionSticks();

        //draw triangle
        graphics.lineStyle(2, 0xA5A5A5);
        graphics.beginFill(0xE8E8E8);
        graphics.drawTriangles(new <Number>[
                m.p1_p.x * MUL - _center.x,
                m.p1_p.y * MUL - _center.y,
                m.p2_p.x * MUL - _center.x,
                m.p2_p.y * MUL - _center.y,
                m.p3_p.x * MUL - _center.x,
                m.p3_p.y * MUL - _center.y
        ]);
        graphics.endFill();

        //draw border
        graphics.lineStyle(1, 0x727272);
        graphics.drawRect(-250, -150, 400, 400);

        x = GlobalMetrics.WORKSPACE_WIDTH - 150;
        y = 150;

        _slider.x = -250 + 40;
        _slider.y = -150 + 6;
        _slider.visible = false;
        addChild(_slider);

        drawCurve();
    }

    private function positionStick(s:Stick, p1:Point, p2:Point):void {
        s.setCoordinates(p1.x * MUL - _center.x, p1.y * MUL - _center.y, p2.x * MUL - _center.x, p2.y * MUL - _center.y);
    }

    private function positionSticks():void {
        for (var i:int = 1; i < s.length; i++)
            s[i].visible = !_m.broken;

        positionStick(s[1], _m.p1_p, _m.m_p);
        positionStick(s[2], _m.m_p, _m.n_p);
        positionStick(s[3], _m.n_p, _m.p2_p);
        positionStick(s[4], _m.n_p, _m.k_p);
        positionStick(s[5], _m.l_p, _m.k_p);
        positionStick(s[6], _m.p3_p, _m.l_p);
        positionStick(s[7], _m.k_p, _m.s_p);
    }

    private function slider_value_changedHandler(event:Event):void {
        switch (_changingInd) {
            case 1:
                _m.l1 = Math.round(_slider.value);
                break;
            case 2:
                _m.l2 = Math.round(_slider.value);
                break;
            case 3:
                _m.l3 = Math.round(_slider.value);
                break;
            case 4:
                _m.l4 = Math.round(_slider.value);
                break;
            case 5:
                _m.l5 = Math.round(_slider.value);
                break;
            case 6:
                _m.l6 = Math.round(_slider.value);
                break;
            case 7:
                _m.l7 = Math.round(_slider.value);
                break;
        }
    }

    private function drawCurve():void {
        var curve:Vector.<Point> = _m.curve(100);
        var g:Graphics = curveLayer.graphics;
        g.clear();
        g.lineStyle(0.5, 0xF44336);

        for (var i:int = 0; i < curve.length; i++) {
            var j:int = i - 1;
            if (j < 0)
                j = curve.length - 1;

            var p1:Point = curve[j];
            var p2:Point = curve[i];

            if (p1 == null || p2 == null)
                continue;
            g.moveTo(p1.x * MUL - _center.x, p1.y * MUL - _center.y);
            g.lineTo(p2.x * MUL - _center.x, p2.y * MUL - _center.y);
        }
    }
}
}
