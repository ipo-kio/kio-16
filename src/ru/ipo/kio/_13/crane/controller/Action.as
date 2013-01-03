/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 03.01.13
 * Time: 15:02
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.controller {
import ru.ipo.kio._13.crane.controller.MovingModel;

public class Action extends Commands {
    private var _action:String; //'L', 'R'

    public function Action(action:String) {
        _action = action;
    }

    public override function exec(controller:MovingModel):void {
        //move kran depending on _action
        switch (_action) {
            case 'L':
                controller.CraneLeft();
                break;
            case 'R':
                controller.CraneRight();
                break;
            case 'D':
                controller.CraneDown();
                break;
            case 'U':
                controller.CraneUp();
                break;
            case 'T':
                controller.CraneTakeCube();
                break;
            case 'P':
                controller.CranePutCube();
                break;


        }
    }

    public function get action():String {
        return _action;
    }

    public function set action(value:String):void {
        _action = value;
    }


}
}
