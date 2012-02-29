/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 26.02.12
 * Time: 14:02
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.futurama.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

import ru.ipo.kio._12.futurama.model.Permutation;
import ru.ipo.kio._12.futurama.model.Transposition;
import ru.ipo.kio.api.TextUtils;

public class ForbiddenMovesView extends Sprite {
    
    [Embed(source='../resources/Level0/Level0_left_bodies.png')]
    private static const LEFT_BODIES_0:Class;

    [Embed(source='../resources/Level0/Level0_left_souls.png')]
    private static const LEFT_SOULS_0:Class;

    [Embed(source='../resources/Level1/Level1_left_bodies.png')]
    private static const LEFT_BODIES_1:Class;

    [Embed(source='../resources/Level1/Level1_left_souls.png')]
    private static const LEFT_SOULS_1:Class;
    
    private var angles:Array;
//    private var images:Array;
    private var _is_base:Boolean;
    private var _perm:Permutation;

    private var _e1:int = -1;
    private var _e2:int = -1;
    private var _highlight_move_possible:Boolean = false;
    
    private var arrows_sprite:Sprite = new Sprite();

    private static const angles_permute_0:Array = [1, 2, 3, 5, 6, 8, 7, 4];
    private static const angles_permute_1:Array = [1, 2, 5, 3, 7, 9, 8, 6, 4];
    private static const delta0_0:Number = - Math.PI * 0.85;
    private static const delta0_1:Number = - Math.PI * 0.78;

    public function ForbiddenMovesView(perm:Permutation, is_base:Boolean, level:int) {
        _is_base = is_base;
        _perm = perm;
        var n:int = perm.n;

        var angles_permute:Array = level == 2 ? angles_permute_1 : angles_permute_0;
        var delta0:Number = level == 2 ? delta0_1 : delta0_0;
        
        angles = new Array(n);
        for (var i:int = 0; i < n; i++)
            angles[angles_permute[i] - 1] = 2 * i * Math.PI / n + delta0;

        perm.addEventListener(Permutation.PERMUTATION_CHANGED, permutation_changed);
        permutation_changed();
        
        if (is_base) {
            if (level == 2)
                addChild(new LEFT_BODIES_1);
            else
                addChild(new LEFT_BODIES_0);
        } else {
            if (level == 2)
                addChild(new LEFT_SOULS_1);
            else
                addChild(new LEFT_SOULS_0);
        }

        addChild(arrows_sprite);

        for (i = 0; i < n; i++) {
            var tf:TextField = TextUtils.createTextFieldWithFont('KioTahoma', 16, false, true);
            if (_is_base)
                tf.text = String.fromCharCode('a'.charCodeAt() + i);
            else
                tf.text = '' + (i + 1);

            tf.x = -6 + FuturamaGlobalMetrics.LEFT_PANEL_WIDTH / 2 + FuturamaGlobalMetrics.LEFT_PANEL_DELTA * Math.cos(angles[i]) * FuturamaGlobalMetrics.LEFT_PANEL_OUTER_RADIUS;
            tf.y = -18 + FuturamaGlobalMetrics.LEFT_PANEL_HEIGHT / 2 + Math.sin(angles[i]) * FuturamaGlobalMetrics.LEFT_PANEL_OUTER_RADIUS;
            addChild(tf);
        }
    }

    private function permutation_changed(event:Event = null):void {
        arrows_sprite.graphics.clear();

        var forbidden_trans:Array = _is_base ? _perm.base_transpositions : _perm.value_transpositions;

        arrows_sprite.graphics.lineStyle(1, 0xFFFF33);
        for (var i:int = 0; i < forbidden_trans.length; i++) {
            var tr:Transposition = forbidden_trans[i];
            draw_tr(tr);
        }

        if (_e1 >= 0 && _e2 >= 0) {
            if (_highlight_move_possible)
                arrows_sprite.graphics.lineStyle(2, 0x22AA33);
            else
                arrows_sprite.graphics.lineStyle(2, 0xFF2233);
            draw_tr(new Transposition(_e1, _e2));
        }
    }

    private function draw_tr(tr:Transposition):void {
        var x1:Number = -6 + FuturamaGlobalMetrics.LEFT_PANEL_DELTA * FuturamaGlobalMetrics.LEFT_PANEL_INNER_RADIUS * Math.cos(angles[tr.e1]);
        var y1:Number = -18 + FuturamaGlobalMetrics.LEFT_PANEL_INNER_RADIUS * Math.sin(angles[tr.e1]);

        var x2:Number = -6 + FuturamaGlobalMetrics.LEFT_PANEL_DELTA * FuturamaGlobalMetrics.LEFT_PANEL_INNER_RADIUS * Math.cos(angles[tr.e2]);
        var y2:Number = -18 + FuturamaGlobalMetrics.LEFT_PANEL_INNER_RADIUS * Math.sin(angles[tr.e2]);

        x1 += 8 + FuturamaGlobalMetrics.LEFT_PANEL_WIDTH / 2;
        y1 += 16 + FuturamaGlobalMetrics.LEFT_PANEL_HEIGHT / 2;
        x2 += 8 + FuturamaGlobalMetrics.LEFT_PANEL_WIDTH / 2;
        y2 += 16 + FuturamaGlobalMetrics.LEFT_PANEL_HEIGHT / 2;

        arrows_sprite.graphics.moveTo(x1, y1);
        arrows_sprite.graphics.lineTo(x2, y2);
    }

    public function highlight(e1:int, e2:int, possible:Boolean):void {
        _e1 = e1;
        _e2 = e2;
        _highlight_move_possible = possible;
        permutation_changed();
    }

    public function unhighlight():void {
        _e1 = -1;
        _e2 = -1;
        permutation_changed();
    }
}
}