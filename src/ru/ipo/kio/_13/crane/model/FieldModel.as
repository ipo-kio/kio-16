/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 14.11.12
 * Time: 1:01
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.model {
import flash.media.Camera;

public class FieldModel {
    private var fieldLength: int = 5;
    private var fieldHeight: int = 2;
    private var field: Array = new Array();
    private var posCrane: Position;
    private var cubeOnCrane: Cube = new Cube(-1);
    public function FieldModel() {
        for (var i = 0; i < fieldHeight; i++){
            field[i] = new Array(fieldLength);
        }

    }
    public function test(i, j): void{
        field[i][j] = 5;
    }
    public function addCrane(i: int, j: int): void{
        field[i][j] = new Crane(false);
        posCrane = new Position(i, j);
    }
    public function addCube(i: int, j: int, color: int): void{
        field[i][j] = new Cube(color);
    }

    public function craneMoveRight(): Boolean{
       if (((posCrane.j + 1) < fieldLength) && (field[posCrane.i][posCrane.j + 1] == null)){
           field[posCrane.i][posCrane.j + 1] = new Crane(field[posCrane.i][posCrane.j].hasCube);
           field[posCrane.i][posCrane.j] = null;
           posCrane.j++;
           return true;
       } else{
           return false;
       }
//        ДОБАВИТЬ ПРОВЕРКУ ПРО ТО ЕСЛИ ЕСТЬ КУБИК И ЧТО ДВИГАТЬ С НИМ
    }

    public function craneMoveLeft(): Boolean{
        if (((posCrane.j - 1) >= 0) && (field[posCrane.i][posCrane.j - 1] == null)){
            field[posCrane.i][posCrane.j - 1] = new Crane(field[posCrane.i][posCrane.j].hasCube);
            field[posCrane.i][posCrane.j] = null;
            posCrane.j--;
            return true;
        } else{
            return false;
        }
//        ДОБАВИТЬ ПРОВЕРКУ ПРО ТО ЕСЛИ ЕСТЬ КУБИК И ЧТО ДВИГАТЬ С НИМ
    }

    public function craneMoveDown(): Boolean{
        if (((posCrane.i + 1) < fieldHeight) && (field[posCrane.i + 1][posCrane.j] == null
                 || (field[posCrane.i + 1][posCrane.j] != null && field[posCrane.i][posCrane.j].hasCube == false)) ){
            field[posCrane.i + 1][posCrane.j] =  new Crane(field[posCrane.i][posCrane.j].hasCube);
            field[posCrane.i][posCrane.j] = null;
            posCrane.i++;
            return true
        } else{
            return false;
        }
                       // тестировать когда есть кубики на поле
//      ДУМАТЬ ПРО КУБИК
    }
    public function craneMoveUp(): Boolean{
        if ((posCrane.i - 1) >= 0) {
            field[posCrane.i -1][posCrane.j] =  new Crane(field[posCrane.i][posCrane.j].hasCube);
            field[posCrane.i][posCrane.j] = null;
            posCrane.i--;
            return true
        } else{
            return false;
        }

//      ДУМАТЬ ПРО КУБИК
    }

    public function craneTakeCube(): Boolean{
        if (field[posCrane.i + 1][posCrane.j] != null){
            field[posCrane.i][posCrane.j].hasCube = true;
            cubeOnCrane.color = field[posCrane.i + 1][posCrane.j].color;
            field[posCrane.i + 1][posCrane.j] = null;
            return true;
        } else {
            return false;
        }
    }

    public function toString():String {
        var temp: String = '';
        for (var i = 0; i < fieldHeight; i++){
            temp += field[i].toString() + "\n";
        }

        return "Scene{field= \n" + temp +"cubeOnCrane=" + String(cubeOnCrane) + "posCrane=" + String(posCrane) + "}\n\n";
    }
}
}
