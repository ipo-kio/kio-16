/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 26.02.12
 * Time: 14:00
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.futurama.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.futurama.FuturamaProblem;

import ru.ipo.kio._12.futurama.model.Permutation;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.displays.ShellButton;

public class FuturamaField extends Sprite {
    private var _forbiddenBases:ForbiddenMovesView;
    private var _forbiddenValues:ForbiddenMovesView;

    public function FuturamaField() {
        
        var api:KioApi = KioApi.instance(FuturamaProblem.ID);
        
        var problem:FuturamaProblem = FuturamaProblem(api.problem);

        var perm:Permutation = new Permutation(problem.n);

        var moves:PermutationPanel = new PermutationPanel(perm);
        moves.x = FuturamaGlobalMetrics.LEFT_PANEL_WIDTH;
        moves.y = 0;
        addChild(moves);
        
        _forbiddenBases = new ForbiddenMovesView(perm, true);
        _forbiddenValues = new ForbiddenMovesView(perm, false);
        
        _forbiddenBases.x = 0;
        _forbiddenBases.y = 0;
        _forbiddenValues.x = 0;
        _forbiddenValues.y = FuturamaGlobalMetrics.LEFT_PANEL_HEIGHT;

        addChild(_forbiddenBases);
        addChild(_forbiddenValues);
        
        //permutations list view
        var list_view_base:PermutationListView = new PermutationListView(perm, true);
        var list_view_values:PermutationListView = new PermutationListView(perm, false);
        
        list_view_base.x = FuturamaGlobalMetrics.LEFT_PANEL_WIDTH + 1;
        list_view_base.y = FuturamaGlobalMetrics.RIGHT_PANEL_HEIGHT + 1;
        list_view_values.x = list_view_base.x + list_view_base.width + 1;
        list_view_values.y = list_view_base.y;
        
        addChild(list_view_base);
        addChild(list_view_values);

        var backButton:ShellButton = new ShellButton('Назад');
        var forwardButton:ShellButton = new ShellButton('Вперед');
        
        backButton.x = list_view_values.x + list_view_base.width + 1;
        backButton.y = list_view_values.y;
        addChild(backButton);

        forwardButton.x = backButton.x;
        forwardButton.y = backButton.y + backButton.height + 3;
        addChild(forwardButton);
        
        backButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
            perm.undo();
        });
        forwardButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
            perm.redo();
        });
    }


    public function get forbiddenBases():ForbiddenMovesView {
        return _forbiddenBases;
    }

    public function get forbiddenValues():ForbiddenMovesView {
        return _forbiddenValues;
    }
}
}
