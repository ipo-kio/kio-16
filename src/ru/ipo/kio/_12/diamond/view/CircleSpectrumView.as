/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 23.02.12
 * Time: 1:26
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import ru.ipo.kio._12.diamond.model.Diamond;
import ru.ipo.kio._12.diamond.model.Spectrum;

public class CircleSpectrumView extends Sprite {

    public static const COLOR_WIDTH:int = 5;
    public static const COLOR_HEIGHT:int = 5;
    public static const RADIUS:int = 100;

    [Embed(source='../resources/tick.png')]
    public static var TICK_IMAGE_CLASS:Class;
    public static var TICK_IMAGE_L:DisplayObject = new TICK_IMAGE_CLASS;
    public static var TICK_IMAGE_R:DisplayObject = new TICK_IMAGE_CLASS;
    
    private static const TICK_HEIGHT:int = TICK_IMAGE_L.height;

    private var _diamond:Diamond;
    private var _eye:Eye;

    private var _position:int = 0;

    private const POSITION_CHANGE:String = 'position change';
    private const POSITION_CHANGE_EVENT:Event = new Event(POSITION_CHANGE);
    
    public function CircleSpectrumView(diamond:Diamond, eye:Eye) {
        _diamond = diamond;
        _eye = eye;
        
        take_position_from_eye();
        eye.addEventListener(Eye.ANGLE_CHANGED, function(event:Event):void {
            take_position_from_eye();
        });
        
        //rotate
//        TICK_IMAGE_R.transform.matrix = new Matrix(1, 0, 0, -1, 0, 0);
        
        //update

        update();
        _diamond.addEventListener(Diamond.UPDATE, function(event:Event):void {
            update();
        });
        
        //mouse move
        addChild(TICK_IMAGE_L);
        addChild(TICK_IMAGE_R);
        update_tick();
        addEventListener(MouseEvent.MOUSE_DOWN, mouse_tick_select);
        addEventListener(MouseEvent.MOUSE_MOVE, mouse_tick_select);
    }

    private function take_position_from_eye():void {
        position = Spectrum.TICKS_MAX * (_eye.angle - Eye.MIN_ANGLE) / (Eye.MAX_ANGLE - Eye.MIN_ANGLE);
    }

    private function mouse_tick_select(event:MouseEvent):void {
        if (!event.buttonDown)
            return;
        
        var angle:Number = Math.atan2(-event.localY, -event.localX);
        if (angle < Eye.MIN_ANGLE || angle > Eye.MAX_ANGLE)
            return;

        position = (angle - Eye.MIN_ANGLE) * Spectrum.TICKS_MAX / (Eye.MAX_ANGLE - Eye.MIN_ANGLE);
        
        _eye.angle = Eye.MIN_ANGLE + position * (Eye.MAX_ANGLE - Eye.MIN_ANGLE) / Spectrum.TICKS_MAX;
    }

    private function update():void {
        graphics.clear();
        
        var spectrum:Spectrum = _diamond.spectrum; //new Spectrum(_diamond, Eye.MIN_ANGLE, Eye.MAX_ANGLE);
        
        for (var tick:int = 0; tick <= Spectrum.TICKS_MAX; tick++) {
            var a:Number = Eye.MIN_ANGLE + tick * (Eye.MAX_ANGLE - Eye.MIN_ANGLE) / Spectrum.TICKS_MAX;
            var sn:Number = - Math.sin(a);
            var cs:Number = - Math.cos(a);
            var color_data:* = spectrum.table[tick];
            for (var col:int = 0; col < Spectrum.COLORS_COUNT; col++) {
                graphics.lineStyle(COLOR_WIDTH, Spectrum.multiply_color(Spectrum.COLORS[col], color_data[col]));
                var r1:Number = RADIUS + col * COLOR_HEIGHT;
                var r2:Number = RADIUS + (col + 1) * COLOR_HEIGHT;
                graphics.moveTo(cs * r1, sn * r1);
                graphics.lineTo(cs * r2, sn * r2);
            }
        }
    }

    public function get position():int {
        return _position;
    }

    public function set position(value:int):void {
        value = Math.max(value, 0);
        value = Math.min(value, Spectrum.TICKS_MAX);
        _position = value;
        update_tick();
        dispatchEvent(POSITION_CHANGE_EVENT);
    }

    private function update_tick():void {
        var a:Number = Eye.MIN_ANGLE + position * (Eye.MAX_ANGLE - Eye.MIN_ANGLE) / Spectrum.TICKS_MAX;
        var sn:Number = - Math.sin(a);
        var cs:Number = - Math.cos(a);
        var r1:Number = RADIUS /*- TICK_IMAGE_L.height*/;
        var r2:Number = RADIUS + 3 * COLOR_HEIGHT /*+ TICK_IMAGE_L.height*/;
        
        var m:Matrix = new Matrix();
        m.translate(-TICK_IMAGE_L.width / 2, -TICK_IMAGE_L.height / 2);
        m.rotate(a + Math.PI / 2);
        m.translate(cs * r1, sn * r1);
        TICK_IMAGE_L.transform.matrix = m;

        m = new Matrix();
        m.translate(-TICK_IMAGE_L.width / 2, -TICK_IMAGE_L.height / 2);
        m.rotate(a - Math.PI / 2);
        m.translate(cs * r2, sn * r2);
        TICK_IMAGE_R.transform.matrix = m;

        //TODO implement
//        TICK_IMAGE_L.x = (_position + 1 / 2) * COLOR_WIDTH - TICK_IMAGE_L.width / 2;
//        TICK_IMAGE_L.y = 0;
//
//        TICK_IMAGE_R.x = TICK_IMAGE_L.x;
//        TICK_IMAGE_R.y = 2 * TICK_HEIGHT + COLOR_HEIGHT * Spectrum.COLORS_COUNT;
    }
}
}
