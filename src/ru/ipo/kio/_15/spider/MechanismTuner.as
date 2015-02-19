/**
 * Created by ilya on 18.02.15.
 */
package ru.ipo.kio._15.spider {

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio.api.controls.GraphicsButton;

import ru.ipo.kio.base.GlobalMetrics;

public class MechanismTuner extends Sprite {

    [Embed(source="resources/btn.png")]
    public static const ANIMATE_BUTTON_ON:Class;
    public static const ANIMATE_BUTTON_ON_IMG:BitmapData = (new ANIMATE_BUTTON_ON).bitmapData;

    [Embed(source="resources/btn.png")]
    public static const ANIMATE_BUTTON_OFF:Class;
    public static const ANIMATE_BUTTON_OFF_IMG:BitmapData = (new ANIMATE_BUTTON_OFF).bitmapData;

    public static const MUL:Number = 3;

    private var _m:Mechanism;
    private var _center:Point;

    private var curveLayer:Sprite = new Sprite();

    private var broken:Boolean = false;
    private var animation:Boolean = true;

    private var a_button_on:GraphicsButton;
    private var a_button_off:GraphicsButton;
    private var err_button:GraphicsButton;

    private var last_working_ls:Vector.<Number>;

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
        last_working_ls = _m.ls;
        _center = _m.p1_p.add(_m.p2_p).add(_m.p3_p);
        _center.setTo(_center.x * MUL / 3, _center.y * MUL / 3);

        _m.addEventListener(Mechanism.EVENT_ANGLE_CHANGED, function (e:Event):void {
            positionSticks();
        });

        addChild(curveLayer);

        addChild(s[1]);
        addChild(s[3]);
        addChild(s[6]);
        addChild(s[2]);
        addChild(s[4]);
        addChild(s[5]);
        addChild(s[7]);

        for (var i:int = 1; i < s.length; i++) {
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

                    var value:Number = lengthByIndex(ind);
                    _changingInd = ind;
                    _slider.reInit(4, 30, value);
                    _slider.visible = true;

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

        //place animation button
        a_button_on = new GraphicsButton('ON', ANIMATE_BUTTON_ON_IMG, ANIMATE_BUTTON_ON_IMG, ANIMATE_BUTTON_ON_IMG, 'KioArial', 12, 12);
        a_button_off = new GraphicsButton('OFF', ANIMATE_BUTTON_OFF_IMG, ANIMATE_BUTTON_OFF_IMG, ANIMATE_BUTTON_OFF_IMG, 'KioArial', 12, 12);

        addChild(a_button_on);
        addChild(a_button_off);
        a_button_on.x = 100;
        a_button_on.y = -110;
        a_button_off.x = 100;
        a_button_off.y = -110;

        a_button_on.visible = false;
        addEventListener(Event.ENTER_FRAME, animate_handler);

        a_button_on.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            if (broken)
                return;
            animation = true;
            turnAnimationOn();
            a_button_on.visible = false;
            a_button_off.visible = true;
        });

        a_button_off.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            animation = false;
            turnAnimationOff();
            a_button_off.visible = false;
            a_button_on.visible = true;
        });

        err_button = new GraphicsButton('Сломано! Восстановить', ANIMATE_BUTTON_ON_IMG, ANIMATE_BUTTON_ON_IMG, ANIMATE_BUTTON_ON_IMG, 'KioArial', 12, 12);
        err_button.visible = false;
        err_button.x = -220;
        err_button.y = -110;

        err_button.addEventListener(MouseEvent.CLICK, function (e:Event):void {
            _m.ls = last_working_ls;
            if (animation)
                turnAnimationOn();
            positionSticks();
            err_button.visible = false;
            drawCurve();

            if (_changingInd >= 0)
                _slider.value = lengthByIndex(_changingInd);
        });

        addChild(err_button);
    }

    private function animate_handler(e:Event):void {
        _m.angle += 0.1;
    }

    private function turnAnimationOff():void {
        removeEventListener(Event.ENTER_FRAME, animate_handler);
    }

    private function turnAnimationOn():void {
        addEventListener(Event.ENTER_FRAME, animate_handler);
    }

    private function positionStick(s:Stick, p1:Point, p2:Point):void {
        s.setCoordinates(p1.x * MUL - _center.x, p1.y * MUL - _center.y, p2.x * MUL - _center.x, p2.y * MUL - _center.y);
    }

    private function positionSticks():void {
        //s[1] is always visible
        for (var i:int = 2; i < s.length; i++)
            s[i].visible = !_m.broken;
        s[2].visible ||= _m.brokenStep == 2;
        s[3].visible ||= _m.brokenStep == 2;
        s[4].visible ||= _m.brokenStep == 2;

        positionStick(s[1], _m.p1_p, _m.m_p);
        positionStick(s[2], _m.m_p, _m.n_p);
        positionStick(s[3], _m.n_p, _m.p2_p);
        positionStick(s[4], _m.n_p, _m.k_p);
        positionStick(s[5], _m.l_p, _m.k_p);
        positionStick(s[6], _m.p3_p, _m.l_p);
        positionStick(s[7], _m.k_p, _m.s_p);
    }

    private function slider_value_changedHandler(event:Event = null):void {
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

        var broken:Boolean = drawCurve();

        if (broken) {
            this.broken = true;
            //rotate until not broken
            var ind:int = -1;
            var curve:Vector.<Point> = _m.curve(100);
            for (var i:int = 0; i < curve.length; i++)
                if (curve[i] != null) {
                    ind = i;
                    break;
                }
            if (ind != -1) {
                var a:Number = Math.PI * 2 * ind / curve.length;
                _m.angle = a;
                positionSticks();
            }
            turnAnimationOff();
            err_button.visible = true;
        } else {
            this.broken = false;
            if (animation)
                turnAnimationOn();
            positionSticks();
            last_working_ls = _m.ls;
            err_button.visible = false;
        }
    }

    private function lengthByIndex(ind:int):Number {
        switch (ind) {
            case 1:
                return _m.l1;
            case 2:
                return _m.l2;
            case 3:
                return _m.l3;
            case 4:
                return _m.l4;
            case 5:
                return _m.l5;
            case 6:
                return _m.l6;
            case 7:
                return _m.l7;
        }
        return NaN;
    }

    private function drawCurve():Boolean {
        var curve:Vector.<Point> = _m.curve(100);
        var g:Graphics = curveLayer.graphics;
        g.clear();
        g.lineStyle(0.5, 0xF44336);

        var broken:Boolean = false;

        for (var i:int = 0; i < curve.length; i++) {
            var j:int = i - 1;
            if (j < 0)
                j = curve.length - 1;

            var p1:Point = curve[j];
            var p2:Point = curve[i];

            if (p1 == null || p2 == null) {
                broken = true;
                continue;
            }
            g.moveTo(p1.x * MUL - _center.x, p1.y * MUL - _center.y);
            g.lineTo(p2.x * MUL - _center.x, p2.y * MUL - _center.y);
        }

        return broken;
    }
}
}
