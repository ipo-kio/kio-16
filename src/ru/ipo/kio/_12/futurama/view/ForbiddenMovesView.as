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

import ru.ipo.kio._12.futurama.FuturamaProblem;

import ru.ipo.kio._12.futurama.model.Permutation;
import ru.ipo.kio._12.futurama.model.Transposition;
import ru.ipo.kio.api.KioApi;

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
    
    private var arrows_sprite:Sprite = new Sprite();

    private static const angles_permute_0:Array = [1, 2, 3, 5, 6, 8, 7, 4];
    private static const angles_permute_1:Array = [1, 2, 5, 3, 7, 9, 8, 6, 4];
    private static const delta0_0:Number = - Math.PI * 0.85;
    private static const delta0_1:Number = - Math.PI * 0.78;

    public function ForbiddenMovesView(perm:Permutation, is_base:Boolean) {
        _is_base = is_base;
        _perm = perm;
        var n:int = perm.n;

        var api:KioApi = KioApi.instance(FuturamaProblem.ID);

        var angles_permute:Array = api.problem.level == 2 ? angles_permute_1 : angles_permute_0;
        var delta0:Number = api.problem.level == 2 ? delta0_1 : delta0_0;
        
        angles = new Array(n);
        for (var i:int = 0; i < n; i++)
            angles[angles_permute[i] - 1] = 2 * i * Math.PI / n + delta0;

        perm.addEventListener(Permutation.PERMUTATION_CHANGED, permutation_changed);
        permutation_changed();
        
        if (is_base) {
            if (api.problem.level == 2)
                addChild(new LEFT_BODIES_1);
            else
                addChild(new LEFT_BODIES_0);
        } else {
            if (api.problem.level == 2)
                addChild(new LEFT_SOULS_1);
            else
                addChild(new LEFT_SOULS_0);
        }

        addChild(arrows_sprite);
    }

    private function permutation_changed(event:Event = null):void {
        arrows_sprite.graphics.clear();

        var forbidden_trans:Array = _is_base ? _perm.base_transpositions : _perm.value_transpositions;

        arrows_sprite.graphics.lineStyle(6, 0xFFFF33);
        for (var i:int = 0; i < forbidden_trans.length; i++) {
            var tr:Transposition = forbidden_trans[i];
            draw_tr(tr);
        }

        arrows_sprite.graphics.lineStyle(8, 0xFF2233);
        for (i = 0; i < forbidden_trans.length; i++) {
            tr = forbidden_trans[i];
            if (tr.e1 == _e1 && tr.e2 == _e2 || tr.e1 == _e2 && tr.e2 == _e1)
                draw_tr(tr);
        }
    }

    private function draw_tr(tr:Transposition):void {
        var x1:Number = FuturamaGlobalMetrics.LEFT_PANEL_INNER_RADIUS * Math.cos(angles[tr.e1]);
        var y1:Number = FuturamaGlobalMetrics.LEFT_PANEL_INNER_RADIUS * Math.sin(angles[tr.e1]);

        var x2:Number = FuturamaGlobalMetrics.LEFT_PANEL_INNER_RADIUS * Math.cos(angles[tr.e2]);
        var y2:Number = FuturamaGlobalMetrics.LEFT_PANEL_INNER_RADIUS * Math.sin(angles[tr.e2]);

        x1 += FuturamaGlobalMetrics.LEFT_PANEL_WIDTH / 2;
        y1 += FuturamaGlobalMetrics.LEFT_PANEL_HEIGHT / 2;
        x2 += FuturamaGlobalMetrics.LEFT_PANEL_WIDTH / 2;
        y2 += FuturamaGlobalMetrics.LEFT_PANEL_HEIGHT / 2;

        arrows_sprite.graphics.moveTo(x1, y1);
        arrows_sprite.graphics.lineTo(x2, y2);
    }

    public function highlight(e1:int, e2:int):void {
        _e1 = e1;
        _e2 = e2;
        permutation_changed();
    }

    public function unhighlight():void {
        _e1 = -1;
        _e2 = -1;
        permutation_changed();
    }
}
}