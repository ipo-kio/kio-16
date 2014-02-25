/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 24.02.14
 */
package ru.ipo.kio._14.tarski.utils {
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.operation.AndOperation;
import ru.ipo.kio._14.tarski.model.operation.Brace;
import ru.ipo.kio._14.tarski.model.operation.EquivalenceOperation;
import ru.ipo.kio._14.tarski.model.operation.ImplicationOperation;
import ru.ipo.kio._14.tarski.model.operation.NotOperation;
import ru.ipo.kio._14.tarski.model.operation.OrOperation;
import ru.ipo.kio._14.tarski.model.predicates.BasePredicate;
import ru.ipo.kio._14.tarski.model.predicates.BasePredicate;
import ru.ipo.kio._14.tarski.model.predicates.ColorPredicate;
import ru.ipo.kio._14.tarski.model.predicates.LefterPredicate;
import ru.ipo.kio._14.tarski.model.predicates.LefterPredicateOneRow;
import ru.ipo.kio._14.tarski.model.predicates.NearPredicate;
import ru.ipo.kio._14.tarski.model.predicates.ShapePredicate;
import ru.ipo.kio._14.tarski.model.predicates.SizePredicate;
import ru.ipo.kio._14.tarski.model.predicates.UpperPredicate;
import ru.ipo.kio._14.tarski.model.predicates.UpperPredicateOneRow;
import ru.ipo.kio._14.tarski.model.predicates.Variable;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;
import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;

public class LogicItemUtils {

    public static function createItemList(part:String):Vector.<LogicItem> {
        var items:Vector.<LogicItem> = new Vector.<LogicItem>();
        var parts:Array = part.split(" ");
        for(var i:int=0;i<parts.length;i++){
            var ch:String=parts[i];
            if(ch=="&"){
                items.push(new AndOperation());
            }else if(ch=="=>"){
                items.push(new ImplicationOperation());
            }else if(ch=="<=>"){
                items.push(new EquivalenceOperation());
            }else if(ch=="|"){
                items.push(new OrOperation());
            }else if(ch=="!"){
                items.push(new NotOperation());
            }else if(ch=="("){
                items.push(new Brace(true));
            }else if(ch==")"){
                items.push(new Brace(false));
            }else if(ch.indexOf("color")>=0){
                items.push(new ColorPredicate(ValueHolder.getColor("temp1")).parseString(ch));
            }else if(ch.indexOf("shape")>=0){
                items.push(new ShapePredicate(ValueHolder.getShape("temp2")).parseString(ch));
            }else if(ch.indexOf("size")>=0){
                items.push(new SizePredicate(ValueHolder.getSize("temp3")).parseString(ch));
            }else if(ch.indexOf("leftrow")>=0){
                items.push(new LefterPredicateOneRow().parseString(ch));
            }else if(ch.indexOf("left")>=0){
                items.push(new LefterPredicate().parseString(ch));
            }else if(ch.indexOf("uprow")>=0){
                items.push(new UpperPredicateOneRow().parseString(ch));
            }else if(ch.indexOf("up")>=0){
                items.push(new UpperPredicate().parseString(ch));
            }else if(ch.indexOf("near")>=0){
                items.push(new NearPredicate().parseString(ch));
            }else if(ch=="X"){
                items.push(new Variable("X"));
            }else if(ch=="Y"){
                items.push(new Variable("Y"));
            }else if(ch=="Z"){
                items.push(new Variable("Z"));
            }else{
                items.push(new Quantifier("exist").parse(ch));
            }
        }
        return items;
    }


    public static function createString(items:Vector.<LogicItem>):String {
        var result:String = "";
        for(var i:int=0;i<items.length;i++){
            var item:LogicItem=items[i];
            if(result!=""){
                result+=" ";
            }
            if(item is AndOperation){
                result += "&";
            }else if(item is ImplicationOperation){
                result += "=>";
            }else if(item is EquivalenceOperation){
                result += "<=>";
            }else if(item is OrOperation){
                result += "|";
            }else if(item is NotOperation){
                result+="!";
            }else if(item is Brace){
                result+=Brace(item).open?"(":")";
            }else if(item is BasePredicate){
                result+=BasePredicate(item).toString();
            }else if(item is Variable){
                result+=Variable(item).code;
            }
        }
        return result;
    }
}
}
