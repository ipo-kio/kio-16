/**
 * @author: Vasily Akimushkin
 * @since: 05.02.14
 */
package ru.ipo.kio._14.tarski.view.statement {
import ru.ipo.kio._14.tarski.TarskiProblemFirst;
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

        if(statement.active){
            graphics.beginFill(0xddddff);
            graphics.drawRect(0,0,Math.max(width,700),height);
            graphics.endFill();
        }

        if(statement.finished){
            graphics.lineStyle(2,0x99FF99);
        }else{
            graphics.lineStyle(2,0xFF9999);
        }

        clearAll();
        var list:Vector.<LogicItem>  = statement.logicItems;
        var predelimiter:Delimiter = new Delimiter(statement);
        var aftdelimiter:Delimiter = new Delimiter(statement);
        var x:int = 0;
        if(statement.lastItem==null){
            statement.activeDelimiter=predelimiter;
        }
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
            aftdelimiter = new Delimiter(statement);
        }
        predelimiter.x = x;
        addChild(predelimiter);

        if(list.length==0){
            statement.activeDelimiter=predelimiter;
        }

        graphics.drawRect(0,0,Math.max(width,700),height);



        if(TarskiProblemFirst.instance.statementManager!=null){
            TarskiProblemFirst.instance.statementManager.scrollPane.refreshPane();
        }
    }


}
}
