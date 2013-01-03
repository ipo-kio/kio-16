/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 19.11.12
 * Time: 0:15
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.controller {
import fl.controls.listClasses.CellRenderer;

import ru.ipo.kio._11.digit.Workspace;

import ru.ipo.kio._13.crane.model.Crane;

import ru.ipo.kio._13.crane.model.FieldModel;
import ru.ipo.kio._13.crane.view.WorkspaceView;

public class MovingModel extends Commands{
    var _crane: Crane;
    var _view: WorkspaceView;
    var delay: DelayForActions = new DelayForActions();
    var _delayTime: int;
    public function MovingModel(crane: Crane, view: WorkspaceView, delayTime: int) {
        _crane = crane;
        _view = view;
        _delayTime = delayTime;
    }

    public function CraneRight(){//crane: Crane, view: WorkspaceView){
        if (FieldModel.craneMoveRight(_crane)){
            _view.craneMoveRight(_crane);
        }
    }
    public function CraneLeft(){//crane: Crane, view: WorkspaceView){
        if (FieldModel.craneMoveLeft(_crane)){
            _view.craneMoveLeft(_crane);

        }
    }

    public function CraneDown(){//crane: Crane, view: WorkspaceView){
        if (FieldModel.craneMoveDown(_crane)){
            _view.craneMoveDown(_crane);

        }
    }

    public function CraneUp(){//crane: Crane, view: WorkspaceView){
        if (FieldModel.craneMoveUp(_crane)){
            _view.craneMoveUp(_crane);

        }
    }

    public function CraneTakeCube(){//crane: Crane, view: WorkspaceView){
        if (FieldModel.craneTakeCube(_crane)){
            _view.craneTakeCube(_crane);

        }
    }

    public function CranePutCube(){//crane: Crane, view: WorkspaceView){
        if (FieldModel.cranePutCube(_crane)){
            _view.cranePutCube(_crane);

        }
    }
}
}
