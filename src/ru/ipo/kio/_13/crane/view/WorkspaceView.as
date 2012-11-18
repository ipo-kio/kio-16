/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 18.11.12
 * Time: 2:25
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.view {
import flash.display.Sprite;

import ru.ipo.kio._13.crane.model.FieldModel;

public class WorkspaceView extends Sprite{
        public var crane: CraneView = new CraneView();
        public var cubeArray: Array = new Array();
        public static const BORDER_X: int = 20;
        public static const BORDER_Y = 20;
        public static const SpaceBetweenRows = 10;
        public static const SpaceBetweenCubes = 20;
        public static const StartX = 100;
        public static const StartY = 100;
        public static var x: int = 10;

        public function WorkspaceView() {
            for (var i = 0; i < FieldModel.fieldHeight; i++){
                cubeArray[i] = new Array(FieldModel.fieldLength);
            }
            graphics.beginFill(0xDDDDDD);
            graphics.drawRect(0, 0, BORDER_X + FieldModel.fieldLength * (CubeView.WIDTH + SpaceBetweenCubes), BORDER_Y + FieldModel.fieldHeight * CubeView.HEIGHT);
            graphics.endFill();
            graphics.lineStyle(2, 0x000000, .3);
            for (var i = 1; i < FieldModel.fieldHeight; i++){
                graphics.moveTo(0, i * CubeView.HEIGHT);
                graphics.lineTo(BORDER_X + FieldModel.fieldLength * (CubeView.WIDTH + SpaceBetweenCubes), i * CubeView.HEIGHT);
            }

            for (var i = 1; i < FieldModel.fieldLength; i++){
                graphics.moveTo(i * (CubeView.WIDTH + SpaceBetweenCubes), 0);
                graphics.lineTo(i * (CubeView.WIDTH + SpaceBetweenCubes), BORDER_Y + FieldModel.fieldHeight * CubeView.HEIGHT)
            }

            this.x = StartX;
            this.y = StartY;

        }

    public function addCrane(row: int,  col: int): void{
        addChild(crane);
        crane.y = row * CubeView.HEIGHT - CraneView.DY;
        crane.x = col * (CubeView.WIDTH + SpaceBetweenCubes) + SpaceBetweenCubes / 2 - CraneView.DX;
    }

    public function addCube(row: int,  col: int, color: String): void{
        cubeArray[row][col] = new CubeView(color);
        addChild(cubeArray[row][col]);
        cubeArray[row][col].y = row * CubeView.HEIGHT;
        cubeArray[row][col].x = col * (CubeView.WIDTH + SpaceBetweenCubes) + SpaceBetweenCubes / 2;
    }

}
}
