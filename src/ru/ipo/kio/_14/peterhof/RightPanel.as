package ru.ipo.kio._14.peterhof {
import flash.display.DisplayObject;
import flash.display.Sprite;

import ru.ipo.kio.base.GlobalMetrics;

public class RightPanel extends Sprite {

    private var _fountainPanel:FountainPanel;

    public function RightPanel() {
        graphics.beginFill(0x222222);
        var width:int = GlobalMetrics.WORKSPACE_WIDTH - PeterhofWorkspace._3D_WIDTH;
        graphics.drawRect(0, 0, width, PeterhofWorkspace._3D_HEIGHT);
        graphics.endFill();

        _fountainPanel = new FountainPanel(width);
        addChild(_fountainPanel);
    }

    public function get fountainPanel():FountainPanel {
        return _fountainPanel;
    }
}
}
