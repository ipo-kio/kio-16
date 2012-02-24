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

public class SpectrumView extends Sprite {

    public static const COLOR_WIDTH:int = 5;
    public static const COLOR_HEIGHT:int = 5;

    [Embed(source='../resources/tick.png')]
    public static var TICK_IMAGE_CLASS:Class;
    public static var TICK_IMAGE_L:DisplayObject = new TICK_IMAGE_CLASS;
    public static var TICK_IMAGE_R:DisplayObject = new TICK_IMAGE_CLASS;
    
    private static const TICK_HEIGHT:int = TICK_IMAGE_L.height;

    private var _separate_colors:Boolean = true;
    private var _diamond:Diamond;
    private var _eye:Eye;

    private var _position:int = 0;

    private const POSITION_CHANGE:String = 'position change';
    private const POSITION_CHANGE_EVENT:Event = new Event(POSITION_CHANGE);
    
    public function SpectrumView(diamond:Diamond, eye:Eye) {
        _diamond = diamond;
        _eye = eye;
        
        take_position_from_eye();
        eye.addEventListener(Eye.ANGLE_CHANGED, function(event:Event):void {
            take_position_from_eye();
        });
        
        //rotate
        TICK_IMAGE_R.transform.matrix = new Matrix(1, 0, 0, -1, 0, 0);
        
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
        
        position = event.localX / COLOR_WIDTH;
        
        _eye.angle = Eye.MIN_ANGLE + position * (Eye.MAX_ANGLE - Eye.MIN_ANGLE) / Spectrum.TICKS_MAX;
    }

    public function get separate_colors():Boolean {
        return _separate_colors;
    }

    public function set separate_colors(value:Boolean):void {
        _separate_colors = value;
        update();
    }

    private function update():void {
        graphics.clear();
        
        var spectrum:Spectrum = _diamond.spectrum; //new Spectrum(_diamond, Eye.MIN_ANGLE, Eye.MAX_ANGLE);
        
        for (var tick:int = 0; tick <= Spectrum.TICKS_MAX; tick++) {
            if (_separate_colors) 
                draw_separate_colors(spectrum.table[tick], tick * COLOR_WIDTH, TICK_HEIGHT);
            else
                draw_blended_colors(spectrum.table[tick], tick * COLOR_WIDTH, TICK_HEIGHT);
        }
    }

    private function draw_blended_colors(color_data:Array, x0:int, y0:int):void {
        var color:uint = 0x000000;
        for (var col:int = 0; col < Spectrum.COLORS_COUNT; col++) {
            var add_color:uint = Spectrum.multiply_color(Spectrum.COLORS[col], color_data[col]);
            var r:uint = ((add_color >> 16) + (color >> 16)) & 0xFF;
            var g:uint = ((add_color >> 8) + (color >> 8)) & 0xFF;
            var b:uint = (add_color + color) & 0xFF;
            color = (r << 16) | (g << 8) | b;
        }

        graphics.beginFill(color);
        graphics.drawRect(x0, y0, COLOR_WIDTH, COLOR_HEIGHT * Spectrum.COLORS_COUNT);
        graphics.endFill();
    }

    private function draw_separate_colors(color_data:Array, x0:int, y0:int):void {
        for (var col:int = 0; col < Spectrum.COLORS_COUNT; col++) {
            graphics.beginFill(Spectrum.multiply_color(Spectrum.COLORS[col], color_data[col]));
            graphics.drawRect(x0, y0 + COLOR_HEIGHT * col, COLOR_WIDTH, COLOR_HEIGHT);
            graphics.endFill();
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
        TICK_IMAGE_L.x = (_position + 1 / 2) * COLOR_WIDTH - TICK_IMAGE_L.width / 2;
        TICK_IMAGE_L.y = 0;

        TICK_IMAGE_R.x = TICK_IMAGE_L.x;
        TICK_IMAGE_R.y = 2 * TICK_HEIGHT + COLOR_HEIGHT * Spectrum.COLORS_COUNT;
    }
}
}
