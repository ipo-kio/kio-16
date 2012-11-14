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
    private var cubeOnCrane: Cube = new Cube(-1);
    private var _crane: Crane;
    public function FieldModel() {
        for (var i = 0; i < fieldHeight; i++){
            field[i] = new Array(fieldLength);
        }

    }
    public function test(i, j): void{
        field[i][j] = 5;
    }
    public function addCrane(i: int, j: int): void{
        _crane = new Crane(i,  j,  false);
    }
    public function addCube(i: int, j: int, color: int): void{
        field[i][j] = new Cube(color);
    }

    public function craneMoveRight(): Boolean{
       if (((_crane.pos.j + 1) < fieldLength) && (field[_crane.pos.i][_crane.pos.j + 1] == null)){
           _crane.pos.j++;
           return true;
       } else{
           return false;
       }
//        ДОБАВИТЬ ПРОВЕРКУ ПРО ТО ЕСЛИ ЕСТЬ КУБИК И ЧТО ДВИГАТЬ С НИМ
    }

    public function craneMoveLeft(): Boolean{
        if (((_crane.pos.j - 1) >= 0) && (field[_crane.pos.i][_crane.pos.j - 1] == null)){
            _crane.pos.j--;
            return true;
        } else{
            return false;
        }
//        ДОБАВИТЬ ПРОВЕРКУ ПРО ТО ЕСЛИ ЕСТЬ КУБИК И ЧТО ДВИГАТЬ С НИМ
    }

    public function craneMoveDown(): Boolean{
        if (((_crane.pos.i + 1) < fieldHeight) && (field[_crane.pos.i + 1][_crane.pos.j] == null
                 || (field[_crane.pos.i + 1][_crane.pos.j] != null && field[_crane.pos.i][_crane.pos.j].hasCube == false)) ){
            _crane.pos.i++;
            return true
        } else{
            return false;
        }
                       // тестировать когда есть кубики на поле
//      ДУМАТЬ ПРО КУБИК
    }
    public function craneMoveUp(): Boolean{
        if ((_crane.pos.i - 1) >= 0) {
            _crane.pos.i--;
            return true
        } else{
            return false;
        }

//      ДУМАТЬ ПРО КУБИК
    }

    public function craneTakeCube(): Boolean{
        if (field[_crane.pos.i + 1][_crane.pos.j] != null){
            _crane.hasCube = true;
            cubeOnCrane.color = field[_crane.pos.i + 1][_crane.pos.j].color;
            field[_crane.pos.i + 1][_crane.pos.j] = null;
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

        return "Scene{field= \n" + temp +"cubeOnCrane=" + String(cubeOnCrane) + "posCrane=" + String(_crane.pos) + "}\n\n";
    }
}
}
