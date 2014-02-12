/**
 * @author: Vasily Akimushkin
 * @since: 05.02.14
 */
package ru.ipo.kio._14.tarski.view.statement {
import ru.ipo.kio._14.tarski.view.*;

import flash.display.Sprite;

import ru.ipo.kio._14.tarski.model.Statement;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.view.statement.Delimiter;

public class StatementViewFree extends BasicView {

    private var statement:Statement;

    public function StatementViewFree(statement:Statement) {
        this.statement = statement;
    }

    public override function update():void{
        graphics.clear();
        if(statement.finished){
            graphics.lineStyle(2,0x99FF99);
        }else{
            graphics.lineStyle(2,0xFF9999);
        }
        graphics.drawRect(0,0,700,40);
        clearAll();
        var list:Vector.<LogicItem>  = statement.logicItems;
        var predelimiter:Delimiter = new Delimiter();
        var aftdelimiter:Delimiter = new Delimiter();
        var x:int = 0;
        for(var i:int = 0;i<list.length; i++){
            predelimiter.afterItem=list[i];
            aftdelimiter.beforeItem=list[i];

            predelimiter.x = x;
            x+=predelimiter.width;
            addChild(predelimiter);
            list[i].getView().x = x;
            list[i].getView().update();
            x+=list[i].getView().width;
            addChild(list[i].getView());

            if(statement.activePlaceHolder==null && statement.activeVariable==null && statement.lastItem==list[i]){
                statement.activeDelimiter=aftdelimiter;
            }

            predelimiter=aftdelimiter;
            aftdelimiter = new Delimiter();
        }
        predelimiter.x = x;
        addChild(predelimiter);

        if(list.length==0){
            statement.activeDelimiter=predelimiter;
        }
    }


}
}
