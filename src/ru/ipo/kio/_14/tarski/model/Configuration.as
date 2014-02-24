/**
 * Конфигурация в мире - содержит множество фигур
 *
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model {
import mx.utils.StringUtil;

import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.construct.ConfigurationView;

public class Configuration {

    private var _figures:Vector.<Figure> = new Vector.<Figure>();

    private var _width:int;

    private var _depth:int;

    private var _correct:Boolean=false;

    private var _view:BasicView;


    public function Configuration(width:int, depth:int) {
        _width = width;
        _depth = depth;
        _view = new ConfigurationView(this);
    }


    public function get view():BasicView {
        return _view;
    }

    public function set correct(value:Boolean):void {
        _correct = value;
    }


    public function get correct():Boolean {
        return _correct;
    }

    public function get figures():Vector.<Figure> {
        return _figures;
    }

    public function addFigure(figure:Figure):void{
        if(figure.x>=0 && figure.y<_width&&
                figure.y>=0 && figure.y<_depth){
            _figures.push(figure);
        }else{
            throw new Error("Can't add figure: wrong plane position");
        }
    }

    public function getListFigure():Vector.<Figure>{
        return _figures;
    }

    public function removeFigure(figure:Figure):void{
        for(var i:int=0; i<_figures.length; i++){
            if(_figures[i]==figure){
                _figures.splice(i,1);
                return;
            }
        }
    }

    public function clear():void{
        _figures = new Vector.<Figure>();
    }

    public function getFigure(x:int,y:int):Figure{
        for(var i:int=0; i<_figures.length; i++){
            if(_figures[i].x==x && _figures[i].y==y){
                return _figures[i];
            }
        }
        return null;
    }

    public function toString():String {
        var result:String="";
        for(var j:int=_depth-1;j>=0;j--){
            result+="";
            for(var i:int=0; i<_width; i++){
                result+=(getFigure(i,j)==null?"__ ":getFigure(i,j).toString()+" ");
            }
            result+="\n";
        }
        return result;
    }

    public function loadFigures(result:String){
        _figures = new Vector.<Figure>();
        var lines:Array = result.split("\n");
        var figures:Array = result.split(" ");
        for(var i:int=0; i<lines.length; i++){
            lines[i] = StringUtil.trim(lines[i]);
            if(lines[i]==""){
                continue;
            }
            var figures:Array = lines[i].split(" ");
            for(var j:int=0; j<figures.length; j++){
                if(figures[j]!='__'){
                    addFigure(Figure.createFigureByCode(j, depth-i-1, figures[j]));
                }
            }
        }


    }


    public function get width():int {
        return _width;
    }

    public function get depth():int {
        return _depth;
    }


}
}
