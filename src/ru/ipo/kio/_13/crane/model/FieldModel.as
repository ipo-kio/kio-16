/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 14.11.12
 * Time: 1:01
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.model {
import flash.media.Camera;

import ru.ipo.kio._13.crane.model.Crane;

import ru.ipo.kio._13.crane.view.WorkspaceView;

public class FieldModel {
    public static var fieldLength: int = 10;
    public static var fieldHeight: int = 4;
    private static var _field: Array = new Array();



    public function getArray(): Array{
        return _field;
    }

    public function FieldModel() {
        for (var i = -1; i < fieldHeight + 1; i++){
            _field[i] = new Array(fieldLength);
        }
        for (var j = 0; j < fieldLength; j++){
            _field[fieldHeight][j] = new Cube(-1);
        }

    }
    public function deleteCube(i, j: int): void{
       _field[i][j] = null;
    }
    public function forTests(i, j: int): void{
        trace(_field[i][j]);
    }
    public function test(i, j): void{
        _field[i][j] = 5;
    }

    public function addCrane( i: int, j: int): Crane{
        return new Crane(i,  j,  false);
    }

    public function addCube(i: int, j: int, color: int): void{
        _field[i][j] = new Cube(color);
    }

    public static function craneMoveRight(crane: Crane): Boolean{
       if (((crane.pos.j + 1) < fieldLength)
             && ((crane.hasCube == false && _field[crane.pos.i - 1][crane.pos.j + 1] == null
                    || crane.hasCube == true && _field[crane.pos.i][crane.pos.j + 1] == null))){
           if (crane.hasCube){
               _field[crane.pos.i][crane.pos.j + 1] = new Cube(_field[crane.pos.i][crane.pos.j].color);
               _field[crane.pos.i][crane.pos.j] = null;
           }
           crane.pos.j++;
           return true;
       } else{
           return false;
       }
    }

    public static function craneMoveLeft(crane: Crane): Boolean{
        if (((crane.pos.j - 1) >= 0)
            && ((crane.hasCube == false && _field[crane.pos.i - 1][crane.pos.j - 1] == null
                || crane.hasCube == true && _field[crane.pos.i][crane.pos.j - 1] == null))){
            if (crane.hasCube){
                _field[crane.pos.i][crane.pos.j - 1] = new Cube(_field[crane.pos.i][crane.pos.j].color);
                _field[crane.pos.i][crane.pos.j] = null;
            }
            crane.pos.j--;
            return true;
        } else{
            return false;
        }
    }

    public static function craneMoveDown(crane: Crane): Boolean{
        if (((crane.pos.i + 1) < fieldHeight)
               && ((crane.hasCube == true && _field[crane.pos.i + 1][crane.pos.j] == null)
                    || (crane.hasCube == false && _field[crane.pos.i][crane.pos.j] == null) )){
            //если внизу есть клетка И  ЛИБО когда у крана есть кубик и под ним нет кубика, ЛИБО когда кубика нет
            if (crane.hasCube){
                _field[crane.pos.i + 1][crane.pos.j] = new Cube(_field[crane.pos.i][crane.pos.j].color);
                _field[crane.pos.i][crane.pos.j] = null;
            }
            crane.pos.i++;
            return true;
        } else{
            return false;
        }
    }
    public static function craneMoveUp(crane: Crane): Boolean{
        if ((crane.pos.i - 1) >= 0) {
            if (crane.hasCube){
                _field[crane.pos.i - 1][crane.pos.j] = new Cube(_field[crane.pos.i][crane.pos.j].color);
                _field[crane.pos.i][crane.pos.j] = null;
            }
            crane.pos.i--;
            return true
        } else{
            return false;
        }

    }

    public static function craneTakeCube(crane: Crane): Boolean{
        if (_field[crane.pos.i][crane.pos.j] != null){
            crane.hasCube = true;
            return true;
        } else {
            return false;
        }
    }

    public static function cranePutCube(crane: Crane): Boolean{
        if ((crane.hasCube == true) && (_field[crane.pos.i + 1][crane.pos.j] != null)){
            crane.hasCube = false;
            return true;
        } else{
            return false;
        }
    }

    public function toString(crane: Crane):String {
        var temp: String = '';
        for (var i = 0; i < fieldHeight; i++){
            temp += _field[i].toString() + "\n";
        }

        return "Scene{field= \n" + temp +"hasCube= " + String(crane.hasCube) + "  posCrane=" + String(crane.pos) + "}\n\n";
    }


    public function setCubesDefault(data:Array):void {
         for (var i: int = 0; i < data.length; i++)
           for (var j: int = 0; j < data[i].length; j++){
               _field[i][j] = data[i][j];
           }
    }
}
}
