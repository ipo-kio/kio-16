/**
 * Область с доступными операциями
 * @author: Vasily Akimushkin
 * @since: 31.01.14
 */
package ru.ipo.kio._14.tarski.view.toolbox {
import com.nerdbucket.ToolTip;

import fl.controls.Button;

import flash.events.MouseEvent;

import ru.ipo.kio._14.tarski.TarskiProblemFirst;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio.base.KioBase;

public class ToolboxView extends BasicView {

    private static const X_SPACE:int = 10;

    private static const Y_SPACE:int = 10;

    private var items:Vector.<LogicItem>;

    private var preferredWidth:int

    public function ToolboxView(items:Vector.<LogicItem>, preferredWidth:int) {
        this.items=items;
        this.preferredWidth=preferredWidth;
        update();
    }

    public override function update():void{
        clearAll();

        var x:int=X_SPACE;
        var y:int=Y_SPACE;

        var maxY:int = 0;

        for(var i:int=0; i<items.length; i++) {
            var button = createButton(items[i], x, y);
            x += button.width + X_SPACE;
            maxY = Math.max(maxY, button.height);
            if (x > preferredWidth) {
                x = X_SPACE;
                y += maxY + Y_SPACE;
                maxY = 0;
            }
            ToolTip.attach(button, items[i].getToolboxText());

        }

        graphics.clear();
        graphics.lineStyle(2,0x999999);
        graphics.drawRect(0,0,width+X_SPACE*2,height+Y_SPACE*2);

    }

    private function createButton(item:LogicItem, x:int, y:int):Object {
        var button:Button = new Button();
        button.label = item.getToolboxText();
        addChild(button);
        button.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            TarskiProblemFirst.instance.statement.addLogicItem(item.getCloned());
        });
        button.x = x;
        button.y = y;
        return button;
    }
}
}
