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

import ru.ipo.kio._12.futurama.model.Permutation;
import ru.ipo.kio._12.futurama.model.Transposition;

public class ForbiddenMovesView extends Sprite {
    
//    private var angles:Array;
//    private var images:Array;
    private var _is_base:Boolean;
    private var _perm:Permutation;

    private var _e1:int = -1;
    private var _e2:int = -1;
    private var _highlight_move_possible:Boolean = false;
    
    private var arrows_sprite:Sprite = new Sprite();

//    private static const angles_permute_0:Array = [1, 2, 3, 5, 6, 8, 7, 4];
//    private static const angles_permute_1:Array = [1, 2, 5, 3, 7, 9, 8, 6, 4];
//    private static const delta0_0:Number = - Math.PI * 0.85;
//    private static const delta0_1:Number = - Math.PI * 0.78;

    private static const coords_base_0:Array = [
        [105, 120],
        [136, 106],
        [175, 107],
        [100, 152],
        [194, 130],
        [194, 164],
        [122, 178],
        [163, 180]
    ];
    
    private static const coords_vals_0:Array = [
        [104, 120],
        [133, 111],
        [169, 112],
        [99, 154],
        [192, 130],
        [193, 160],
        [121, 176],
        [166, 181]
    ];

    private static const coords_base_1:Array = [
        [106, 103],
        [140, 92],
        [197, 120],
        [89, 133],
        [178, 98],
        [103, 164],
        [199, 151],
        [135, 176],
        [174, 169]
    ];

    private static const coords_vals_1:Array = [
        [107, 113],
        [143, 104],
        [199, 125],
        [91, 134],
        [175, 110],
        [103, 164],
        [199, 154],
        [132, 173],
        [169, 169]
    ];
    
    private var _level:int;

    public function ForbiddenMovesView(perm:Permutation, is_base:Boolean, level:int) {
        _is_base = is_base;
        _perm = perm;
        _level = level;
//        var n:int = perm.n;

//        var angles_permute:Array = level == 2 ? angles_permute_1 : angles_permute_0;
//        var delta0:Number = level == 2 ? delta0_1 : delta0_0;
        
//        angles = new Array(n);
//        for (var i:int = 0; i < n; i++)
//            angles[angles_permute[i] - 1] = 2 * i * Math.PI / n + delta0;

        perm.addEventListener(Permutation.PERMUTATION_CHANGED, permutation_changed);
        permutation_changed();

        addChild(arrows_sprite);
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
    
    private function get_coords(ind:int):Array {
        if (_level == 2 && _is_base)
            return coords_base_1[ind];
        else if (_level == 2 && !_is_base)
            return coords_vals_1[ind];
        else if (_is_base)
            return coords_base_0[ind];
        else
            return coords_vals_0[ind];
    }

    private function draw_tr(tr:Transposition):void {
        var c1:Array = get_coords(tr.e1);
        var c2:Array = get_coords(tr.e2);
        var x1:int = c1[0];
        var y1:int = c1[1];
        var x2:int = c2[0];
        var y2:int = c2[1];

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