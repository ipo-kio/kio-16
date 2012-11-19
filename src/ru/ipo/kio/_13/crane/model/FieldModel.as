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
    public static var fieldLength: int = 6;
    public static var fieldHeight: int = 4;
    public static var field: Array = new Array();

    public function FieldModel() {
        for (var i = -1; i < fieldHeight + 1; i++){
            field[i] = new Array(fieldLength);
        }
        for (var j = 0; j < fieldLength; j++){
            field[fieldHeight][j] = new Cube(-1);
        }

    }
    public function test(i, j): void{
        field[i][j] = 5;
    }
    public function addCrane( i: int, j: int): Crane{
        return new Crane(i,  j,  false);
    }
    public function addCube(i: int, j: int, color: int): void{
        field[i][j] = new Cube(color);
    }

    public static function craneMoveRight(crane: Crane): Boolean{
       if (((crane.pos.j + 1) < fieldLength)
             && ((crane.hasCube == false && field[crane.pos.i - 1][crane.pos.j + 1] == null
                    || crane.hasCube == true && field[crane.pos.i][crane.pos.j + 1] == null))){
           if (crane.hasCube){
               field[crane.pos.i][crane.pos.j + 1] = new Cube(field[crane.pos.i][crane.pos.j].color);
               field[crane.pos.i][crane.pos.j] = null;
           }
           crane.pos.j++;
           return true;
       } else{
           return false;
       }
    }

    public static function craneMoveLeft(crane: Crane): Boolean{
        if (((crane.pos.j - 1) >= 0)
            && ((crane.hasCube == false && field[crane.pos.i - 1][crane.pos.j - 1] == null
                || crane.hasCube == true && field[crane.pos.i][crane.pos.j - 1] == null))){
            if (crane.hasCube){
                field[crane.pos.i][crane.pos.j - 1] = new Cube(field[crane.pos.i][crane.pos.j].color);
                field[crane.pos.i][crane.pos.j] = null;
            }
            crane.pos.j--;
            return true;
        } else{
            return false;
        }
    }

    public static function craneMoveDown(crane: Crane): Boolean{
        if (((crane.pos.i + 1) < fieldHeight)
               && ((crane.hasCube == true && field[crane.pos.i + 1][crane.pos.j] == null)
                    || (crane.hasCube == false && field[crane.pos.i][crane.pos.j] == null) )){
            //если внизу есть клетка И  ЛИБО когда у крана есть кубик и под ним нет кубика, ЛИБО когда кубика нет
            if (crane.hasCube){
                field[crane.pos.i + 1][crane.pos.j] = new Cube(field[crane.pos.i][crane.pos.j].color);
                field[crane.pos.i][crane.pos.j] = null;
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
                field[crane.pos.i - 1][crane.pos.j] = new Cube(field[crane.pos.i][crane.pos.j].color);
                field[crane.pos.i][crane.pos.j] = null;
            }
            crane.pos.i--;
            return true
        } else{
            return false;
        }

    }

    public static function craneTakeCube(crane: Crane): Boolean{
        if (field[crane.pos.i][crane.pos.j] != null){
            crane.hasCube = true;
            return true;
        } else {
            return false;
        }
    }

    public static function cranePutCube(crane: Crane): Boolean{
        if ((crane.hasCube == true) && (field[crane.pos.i + 1][crane.pos.j] != null)){
            crane.hasCube = false;
            return true;
        } else{
            return false;
        }
    }

    public function toString(crane: Crane):String {
        var temp: String = '';
        for (var i = 0; i < fieldHeight; i++){
            temp += field[i].toString() + "\n";
        }

        return "Scene{field= \n" + temp +"hasCube= " + String(crane.hasCube) + "  posCrane=" + String(crane.pos) + "}\n\n";
    }



}
}
