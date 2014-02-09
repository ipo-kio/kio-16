/**
 * Конфигурация в мире - содержит множество фигур
 *
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model {
public class Configuration {

    private var _figures:Vector.<Figure> = new Vector.<Figure>();

    private var _width:int;

    private var _depth:int;

    private var _correct:Boolean=false;


    public function Configuration(width:int, depth:int) {
        _width = width;
        _depth = depth;
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
            result+="[";
            for(var i:int=0; i<_width; i++){
                result+=(getFigure(i,j)==null?"  ;":getFigure(i,j).toString()+";");
            }
            result+="]\n";
        }
        return result;
    }


    public function get width():int {
        return _width;
    }

    public function get depth():int {
        return _depth;
    }
}
}
