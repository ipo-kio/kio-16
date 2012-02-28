/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 26.02.12
 * Time: 18:45
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.futurama.view {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.futurama.FuturamaProblem;
import ru.ipo.kio._12.futurama.model.Permutation;

import ru.ipo.kio.api.KioApi;

public class PermutationPanel extends Sprite {

    [Embed(source='../resources/Level0/Background.png')]
    private static const BG_0:Class;

    [Embed(source='../resources/Level1/Background.png')]
    private static const BG_1:Class;

    private static const head_positions_0:Array = [
        [35, 54],
        [144, 1],
        [267, 19],
        [12, 189],
        [167, 160],
        [361, 147],
        [130, 285],
        [276, 301]
    ];
    private static const head_positions_1:Array = [
        [9, 30],
        [145, 2],
        [355, 2],
        [108, 148],
        [243, 105],
        [13, 215],
        [358, 188],
        [140, 298],
        [254, 276]
    ];

    [Embed(source='../resources/Level0/Head_1.png')]
    private static const HEAD_0_1:Class;
    [Embed(source='../resources/Level0/Head_2.png')]
    private static const HEAD_0_2:Class;
    [Embed(source='../resources/Level0/Head_3.png')]
    private static const HEAD_0_3:Class;
    [Embed(source='../resources/Level0/Head_4.png')]
    private static const HEAD_0_4:Class;
    [Embed(source='../resources/Level0/Head_5.png')]
    private static const HEAD_0_5:Class;
    [Embed(source='../resources/Level0/Head_6.png')]
    private static const HEAD_0_6:Class;
    [Embed(source='../resources/Level0/Head_7.png')]
    private static const HEAD_0_7:Class;
    [Embed(source='../resources/Level0/Head_8.png')]
    private static const HEAD_0_8:Class;

    [Embed(source='../resources/Level1/Head_1.png')]
    private static const HEAD_1_1:Class;
    [Embed(source='../resources/Level1/Head_2.png')]
    private static const HEAD_1_2:Class;
    [Embed(source='../resources/Level1/Head_3.png')]
    private static const HEAD_1_3:Class;
    [Embed(source='../resources/Level1/Head_4.png')]
    private static const HEAD_1_4:Class;
    [Embed(source='../resources/Level1/Head_5.png')]
    private static const HEAD_1_5:Class;
    [Embed(source='../resources/Level1/Head_6.png')]
    private static const HEAD_1_6:Class;
    [Embed(source='../resources/Level1/Head_7.png')]
    private static const HEAD_1_7:Class;
    [Embed(source='../resources/Level1/Head_8.png')]
    private static const HEAD_1_8:Class;
    [Embed(source='../resources/Level1/Head_9.png')]
    private static const HEAD_1_9:Class;

    [Embed(source='../resources/Level0/Soul_1_60%.png')]
    private static const SOUL_0_1:Class;
    [Embed(source='../resources/Level0/Soul_2_60%.png')]
    private static const SOUL_0_2:Class;
    [Embed(source='../resources/Level0/Soul_3_60%.png')]
    private static const SOUL_0_3:Class;
    [Embed(source='../resources/Level0/Soul_4_60%.png')]
    private static const SOUL_0_4:Class;
    [Embed(source='../resources/Level0/Soul_5_60%.png')]
    private static const SOUL_0_5:Class;
    [Embed(source='../resources/Level0/Soul_6_60%.png')]
    private static const SOUL_0_6:Class;
    [Embed(source='../resources/Level0/Soul_7_60%.png')]
    private static const SOUL_0_7:Class;
    [Embed(source='../resources/Level0/Soul_8_60%.png')]
    private static const SOUL_0_8:Class;

    [Embed(source='../resources/Level1/Soul_1_60%.png')]
    private static const SOUL_1_1:Class;
    [Embed(source='../resources/Level1/Soul_2_60%.png')]
    private static const SOUL_1_2:Class;
    [Embed(source='../resources/Level1/Soul_3_60%.png')]
    private static const SOUL_1_3:Class;
    [Embed(source='../resources/Level1/Soul_4_60%.png')]
    private static const SOUL_1_4:Class;
    [Embed(source='../resources/Level1/Soul_5_60%.png')]
    private static const SOUL_1_5:Class;
    [Embed(source='../resources/Level1/Soul_6_60%.png')]
    private static const SOUL_1_6:Class;
    [Embed(source='../resources/Level1/Soul_7_60%.png')]
    private static const SOUL_1_7:Class;
    [Embed(source='../resources/Level1/Soul_8_60%.png')]
    private static const SOUL_1_8:Class;
    [Embed(source='../resources/Level1/Soul_9_60%.png')]
    private static const SOUL_1_9:Class;

    private var _head_positions:Array;
    private var _perm:Permutation;
    private var _heads:Array;
    private var _souls:Array;
    private var _n:int;
    private var _selected_head_index:int = -1;
    private var _mouse_over_index:int = -1;
    private var _moving_soul:Sprite = null;
    private var _api:KioApi;

    private var _highlight_rectangle:Sprite;
    private var _signs_layers:Sprite;

    public function PermutationPanel(perm:Permutation) {
        _api = KioApi.instance(FuturamaProblem.ID);

        _perm = perm;
        _n = _perm.n;

        if (_api.problem.level == 2) {
            var bg:DisplayObject = new BG_1;
            _head_positions = head_positions_1;
            _heads = [
                new HEAD_1_1,
                new HEAD_1_2,
                new HEAD_1_3,
                new HEAD_1_4,
                new HEAD_1_5,
                new HEAD_1_6,
                new HEAD_1_7,
                new HEAD_1_8,
                new HEAD_1_9
            ];
            _souls = [
                new SOUL_1_1,
                new SOUL_1_2,
                new SOUL_1_3,
                new SOUL_1_4,
                new SOUL_1_5,
                new SOUL_1_6,
                new SOUL_1_7,
                new SOUL_1_8,
                new SOUL_1_9
            ];
        } else {
            bg = new BG_0;
            _head_positions = head_positions_0;
            _heads = [
                new HEAD_0_1,
                new HEAD_0_2,
                new HEAD_0_3,
                new HEAD_0_4,
                new HEAD_0_5,
                new HEAD_0_6,
                new HEAD_0_7,
                new HEAD_0_8
            ];
            _souls = [
                new SOUL_0_1,
                new SOUL_0_2,
                new SOUL_0_3,
                new SOUL_0_4,
                new SOUL_0_5,
                new SOUL_0_6,
                new SOUL_0_7,
                new SOUL_0_8
            ];
        }

        addChild(bg);
        
        //concert heads and souls to sprites
        for (var i:int = 0; i < _heads.length; i++) {
            _heads[i] = wrap(_heads[i]);
            _souls[i] = wrap(_souls[i]);
        }

        for (i = 0; i < _heads.length; i++) {
            addChild(_heads[i]);
            
            var ht:Sprite = new Sprite();
            ht.graphics.beginFill(0x000000);
            ht.graphics.drawRect(0, 0, _heads[i].width, 2 * _heads[i].height);
            ht.graphics.endFill();
            ht.mouseEnabled = false;
            ht.visible = false;
            _heads[i].hitArea = ht;

            addChild(ht);

            add_event_listeners_for_head(i);
        }

        _perm.addEventListener(Permutation.PERMUTATION_CHANGED, perm_changed);
        perm_changed();

        //highlight rectangle
        _highlight_rectangle = new Sprite();
        _highlight_rectangle.graphics.lineStyle(2, 0xFFFFFF, 0.5);
        _highlight_rectangle.graphics.drawRect(0, 0, _heads[0].width, 2 * _heads[0].height);
        
        //signs layer
//        _signs_layers = new Sprite();
//        for (i = 0; i < _heads.length; i++) {
//
//        }
    }

    private static function wrap(o:DisplayObject):Sprite {
        var s:Sprite = new Sprite();
        s.addChild(o);
        return s;
    }

    private function add_event_listeners_for_head(i:int):void {
        _heads[i].addEventListener(MouseEvent.ROLL_OVER, function (event:MouseEvent):void {
            var head:DisplayObject = DisplayObject(event.target);

            trace('rolling over ' + i);

            var need_highlight:Boolean = false;

            if (_selected_head_index >= 0) {
                //test permutation possible
                var stat:int = _perm.permute_values(i, _selected_head_index, true);

                if (stat == Permutation.STATUS_OK) {
                    need_highlight = true;
                } else if (_selected_head_index >= 0) {
                    var futuramaField:FuturamaField = FuturamaField(_api.problem.display);

                    if (stat == Permutation.STATUS_BASE_COLLISION)
                        futuramaField.forbiddenBases.highlight(
                                _perm.inv_permutation[i],
                                _perm.inv_permutation[_selected_head_index]
                        );
                    else
                        futuramaField.forbiddenValues.highlight(
                                i,
                                _selected_head_index
                        );
                }
            } else {
                need_highlight = true;
            }

            if (need_highlight) {
//            head.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 20, 20, 20);
                highlight_head(head);
                _mouse_over_index = i;
            }
        });
        _heads[i].addEventListener(MouseEvent.ROLL_OUT, function (event:MouseEvent):void {
//            var head:DisplayObject = DisplayObject(event.target);
//            head.transform.colorTransform = new ColorTransform();
            var futuramaField:FuturamaField = FuturamaField(_api.problem.display);
            futuramaField.forbiddenBases.unhighlight();
            futuramaField.forbiddenValues.unhighlight();
            if (_mouse_over_index >= 0)
                removeChild(_highlight_rectangle);
            _mouse_over_index = -1;
        });
        _heads[i].addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void {
            _selected_head_index = i;
            _moving_soul = _souls[i];
            _moving_soul.x = _heads[i].x;
            _moving_soul.y = _heads[i].y;
            _moving_soul.mouseEnabled = false;
            addChild(_moving_soul);
            _moving_soul.startDrag();
        });
        _heads[i].addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void {
            stage.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
        });
        _heads[i].addEventListener(Event.REMOVED_FROM_STAGE, function(event:Event):void {
            stage.removeEventListener(MouseEvent.MOUSE_UP, mouse_up);
        });
    }

    private function highlight_head(head:DisplayObject):void {
        _highlight_rectangle.x = head.x;
        _highlight_rectangle.y = head.y;
        addChild(_highlight_rectangle);
    }

    private function mouse_up(event:MouseEvent):void {
        if (_selected_head_index < 0)
            return;
        
        trace(_selected_head_index);
        _moving_soul.stopDrag();
        removeChild(_moving_soul);

        if (_mouse_over_index >= 0)
        _perm.permute_values(_mouse_over_index, _selected_head_index);

        _moving_soul = null;
        _selected_head_index = -1;

        for (var i:int = 0; i < _heads.length; i++)
            if (_heads[i].hitTestPoint(event.stageX, event.stageY, false))
                highlight_head(_heads[i]);
    }

    private function perm_changed(event:Event = null):void {
        for (var i:int = 0; i < _n; i++) {
            //move _head[i] to _perm.permutation[i] point
            var j:int = _perm.permutation[i];
            var point:Array = _head_positions[i];
            _heads[j].x = point[0];
            _heads[j].y = point[1];
            _heads[j].hitArea.x = point[0];
            _heads[j].hitArea.y = point[1];
        }
    }

}
}
