/**
 * @author: Vasily Akimushkin
 * @since: 05.02.14
 */
package ru.ipo.kio._14.tarski.view.statement {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.TarskiProblemFirst;
import ru.ipo.kio._14.tarski.model.predicates.OnePlacePredicate;
import ru.ipo.kio._14.tarski.model.predicates.TwoPlacePredicate;
import ru.ipo.kio._14.tarski.model.predicates.Variable;
import ru.ipo.kio._14.tarski.view.*;

import flash.display.Sprite;

import ru.ipo.kio._14.tarski.model.Statement;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.view.statement.Delimiter;

public class StatementViewFree extends BasicView {

    [Embed(source="../../_resources/level0/ok.png")]
    private static const OK:Class;

    [Embed(source="../../_resources/level0/not_ok.png")]
    private static const NOTOK:Class;

    private var statement:Statement;

    public function StatementViewFree(statement:Statement) {
        this.statement = statement;
    }

    public override function update():void{
        graphics.clear();

        if(statement.active){
            graphics.beginFill(0xddddff);
            graphics.drawRect(100,0,Math.max(width,568),height);
            graphics.endFill();
        }

        clearAll();

        if(statement.finished){
            addChildTo(new OK, 2,7);
        }else{
            addChildTo(new NOTOK, 2,7);
        }

        var dict:Dictionary = new Dictionary();
        for(var i:int=0; i<statement.logicItems.length; i++){
            if(statement.logicItems[i] is OnePlacePredicate && OnePlacePredicate(statement.logicItems[i]).placeHolder.variable!=null){
                dict[(OnePlacePredicate(statement.logicItems[i]).placeHolder.variable.code)]=(OnePlacePredicate(statement.logicItems[i]).placeHolder.variable.code);
            }
            if(statement.logicItems[i] is TwoPlacePredicate && TwoPlacePredicate(statement.logicItems[i]).placeHolder1.variable!=null){
                dict[(TwoPlacePredicate(statement.logicItems[i]).placeHolder1.variable.code)]=(TwoPlacePredicate(statement.logicItems[i]).placeHolder1.variable.code);
            }
            if(statement.logicItems[i] is TwoPlacePredicate && TwoPlacePredicate(statement.logicItems[i]).placeHolder2.variable!=null){
                dict[(TwoPlacePredicate(statement.logicItems[i]).placeHolder2.variable.code)]=(TwoPlacePredicate(statement.logicItems[i]).placeHolder2.variable.code);
            }
            if(statement.logicItems[i] is Variable){
                dict[(Variable(statement.logicItems[i]).code)]=(Variable(statement.logicItems[i]).code);
            }
        }

        var vars:String = "";
        for (var k:Object in dict) {
            if(vars != "" ){
                vars +=",";
            }
            vars+=dict[k];
        }

        if(vars!=""){
            addChildTo(createField("Для всех "+vars),18,5);
        }




        var list:Vector.<LogicItem>  = statement.logicItems;
        var predelimiter:Delimiter = new Delimiter(statement);
        var aftdelimiter:Delimiter = new Delimiter(statement);
        var x:int = 100;
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





        if(TarskiProblemFirst.instance.statementManager!=null){
            TarskiProblemFirst.instance.statementManager.scrollPane.refreshPane();
        }
    }


}
}
