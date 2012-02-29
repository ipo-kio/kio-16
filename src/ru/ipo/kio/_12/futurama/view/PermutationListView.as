/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 27.02.12
 * Time: 18:30
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.futurama.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

import ru.ipo.kio._12.futurama.model.Permutation;
import ru.ipo.kio._12.futurama.model.Transposition;
import ru.ipo.kio.api.TextUtils;

public class PermutationListView extends Sprite {

    private static const COLUMN_ITEMS:int = 6;
    private static const ITEM_WIDTH:int = 28;
    private static const ITEM_HEIGHT:int = 18;

    private var _perm:Permutation;
    private var _texts:Array/*TextField*/ = [];
    private var _is_base:Boolean;
    private var _m:int;

    public function PermutationListView(perm:Permutation, is_base:Boolean) {
        _perm = perm;
        _is_base = is_base;

        perm.addEventListener(Permutation.PERMUTATION_CHANGED, perm_changed);

        var n:int = _perm.n;
        var m:int = n * (n - 1) / 2;

        _m = m;

        for (var i:int = 0; i < m; i++) {
            var col:int = i / COLUMN_ITEMS;
            var line:int = i % COLUMN_ITEMS;

            var tf:TextField = TextUtils.createTextFieldWithFont('Arial', 14, false, false);
            tf.embedFonts = false;
            tf.visible = false;
            tf.x = col * ITEM_WIDTH;
            tf.y = line * ITEM_HEIGHT;
            addChild(tf);

            _texts.push(tf);
        }

        graphics.lineStyle(1, 0x8A8A8A);
        graphics.beginFill(0xB3B3B3);
        graphics.drawRect(0, 0, Math.ceil(m / COLUMN_ITEMS) * ITEM_WIDTH, COLUMN_ITEMS * ITEM_HEIGHT);
        graphics.endFill();
    }

    private function perm_changed(event:Event = null):void {

        var trs:Array;
        var trs_h:Array;

        if (_is_base) {
            trs = _perm.base_transpositions;
            trs_h = _perm.base_transpositions_redo_history;
        } else {
            trs = _perm.value_transpositions;
            trs_h = _perm.value_transpositions_redo_history;
        }

        var j:int = 0;
        for (var i:int = 0; i < trs.length; i++, j++) {
            _texts[j].text = print_transposition(trs[i]);
            _texts[j].textColor = 0x000000;
            _texts[j].visible = true;
        }
        for (i = trs_h.length - 1; i >= 0; i--, j++) {
            _texts[j].text = print_transposition(trs_h[i]);
            _texts[j].textColor = 0x888888;
            _texts[j].visible = true;
        }
        for (i = j; i < _m; i++, j++) {
            _texts[j].visible = false;
        }
    }
    
    private function print_transposition(tr:Transposition):String {
        if (_is_base) {
            var ord_a:int = 'at'.charCodeAt();
            return String.fromCharCode(ord_a + tr.e1) + '-' + String.fromCharCode(ord_a + tr.e2);
        } else
            return (tr.e1 + 1) + '-' + (tr.e2 + 1);
    }
}
}
