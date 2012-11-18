/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 19.11.12
 * Time: 0:15
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.controller {
import fl.controls.listClasses.CellRenderer;

import ru.ipo.kio._13.crane.model.Crane;

import ru.ipo.kio._13.crane.model.FieldModel;
import ru.ipo.kio._13.crane.view.WorkspaceView;

public class MovingModel {
    public function MovingModel() {
    }

    public function CraneRight(crane: Crane, view: WorkspaceView){
        if (FieldModel.craneMoveRight(crane)){
            view.craneMoveRight(crane);
        }
    }
    public function CraneLeft(crane: Crane, view: WorkspaceView){
        if (FieldModel.craneMoveLeft(crane)){
            view.craneMoveLeft(crane);
        }
    }

    public function CraneDown(crane: Crane, view: WorkspaceView){
        if (FieldModel.craneMoveDown(crane)){
            view.craneMoveDown(crane);
        }
    }

    public function CraneUp(crane: Crane, view: WorkspaceView){
        if (FieldModel.craneMoveUp(crane)){
            view.craneMoveUp(crane);
        }
    }

    public function CraneTakeCube(crane: Crane, view: WorkspaceView){
        if (FieldModel.craneTakeCube(crane)){
            view.craneTakeCube(crane);
        }
    }

    public function CranePutCube(crane: Crane, view: WorkspaceView){
        if (FieldModel.cranePutCube(crane)){
            view.cranePutCube(crane);
        }
    }


}
}
