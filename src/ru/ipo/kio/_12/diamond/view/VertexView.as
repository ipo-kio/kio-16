/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 16.02.12
 * Time: 13:01
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import ru.ipo.kio._12.diamond.Vertex2D;

import spark.effects.Scale;

public class VertexView extends Sprite {

    private var scaler:Scaler;

    private var _x_min:int;
    private var _y_min:int;
    private var _x_max:int;
    private var _y_max:int;
    
    private var _v:Vertex2D;

    private var moving_point:Boolean = false;

    public static const VERTEX_MOVED:String = 'vertex moved';
    
    private var _current_view:DisplayObject = null;
    
    private const normal_view:Sprite = new Sprite();
    private const over_view:Sprite = new Sprite();
    private const down_view:Sprite = new Sprite();
    private const hit_test_view:Sprite = new Sprite();

    public function VertexView(v:Vertex2D, x_min:int, y_min:int, x_max:int, y_max:int, scaler:Scaler) {
        _v = v;
        _x_min = x_min;
        _y_min = y_min;
        _x_max = x_max;
        _y_max = y_max;

        this.scaler = scaler;
        
        _v.addEventListener(Vertex2D.MOVE, vertex_moved);

        vertex_moved();

        addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
        addEventListener(MouseEvent.ROLL_OVER, roll_over);
        addEventListener(MouseEvent.ROLL_OUT, roll_out);
        addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void {
            stage.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouse_move);
        });
        addEventListener(Event.REMOVED_FROM_STAGE, function(event:Event):void {
            stage.removeEventListener(MouseEvent.MOUSE_UP, mouse_up);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouse_move);
        });

        init_views();
        
        current_view = normal_view;
        
        hit_test_view.mouseEnabled = false;
        hitArea = hit_test_view;
        addChild(hit_test_view);
        hit_test_view.visible = false;
    }

    private function roll_over(event:MouseEvent):void {
        if (!moving_point)
            current_view = over_view;
    }
    
    private function roll_out(event:MouseEvent):void {
        if (!moving_point)
            current_view = normal_view;
    }

    private function init_views():void {
        hit_test_view.graphics.beginFill(0xFF00FF);
        hit_test_view.graphics.drawCircle(0, 0, 5);
        hit_test_view.graphics.endFill();

        over_view.graphics.beginFill(0x00FFFF);
        over_view.graphics.drawCircle(0, 0, 5);
        over_view.graphics.endFill();

        down_view.graphics.beginFill(0xFF0000);
        down_view.graphics.drawCircle(0, 0, 5);
        down_view.graphics.endFill();
        
        normal_view.graphics.lineStyle(1, 0x888888);
        normal_view.graphics.drawRect(-3, -3, 6, 6);
    }

    private function vertex_moved(event:Event = null):void {
        var p:Point = scaler.vertex2point(_v);
        x = p.x;
        y = p.y;
    }

    private function mouse_move(e:MouseEvent):void {
        if (!moving_point)
            return;

        var v2d:Vertex2D = scaler.point2vertex(new Point(x, y));
        var _x:Number = v2d.x;
        var _y:Number = v2d.y;
        
        _x = Math.max(_x, _x_min);
        _y = Math.max(_y, _y_min);
        _x = Math.min(_x, _x_max);
        _y = Math.min(_y, _y_max);
        
        _v.setXY(_x, _y);
    }

    private function mouse_down(e:MouseEvent):void {
        
        var p_min:Point = scaler.vertex2point(new Vertex2D(_x_min, _y_min));
        var p_max:Point = scaler.vertex2point(new Vertex2D(_x_max, _y_max));

        current_view = down_view;
        startDrag(false, new Rectangle(p_min.x, p_min.y, p_max.x - p_min.x, p_max.y - p_min.y));
        moving_point = true;
    }

    private function mouse_up(e:MouseEvent):void {
        if (!moving_point)
            return;

        stopDrag();
        moving_point = false;
        current_view = over_view;
    }
    
    public function get vertex():Vertex2D {
        return _v;
    }

    public function get screenPoint():Point {
        return new Point(x, y);
    }
    
    public function get current_view():DisplayObject {
        return _current_view;
    }

    public function set current_view(view:DisplayObject):void {
        if (_current_view == view)
            return;

        if (_current_view != null)
            removeChild(_current_view);
        addChild(view);
        _current_view = view;
    }
}
}
