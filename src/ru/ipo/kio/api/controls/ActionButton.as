/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 08.02.13
 * Time: 20:30
 */
package ru.ipo.kio.api.controls {
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;

public class ActionButton extends SimpleButton {

    private var _action:String;

    private var grayer:Shape;

    public function ActionButton(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) {
        //TODO report two super are not reported
        useHandCursor = true;

        grayer = new Shape();
        grayer.graphics.beginFill(0x888888, 0.75);
        grayer.graphics.drawRect(0, 0, upState.width + 1, upState.height + 1);
        grayer.graphics.endFill();
        grayer.visible = false;

        var newUp:Sprite = new Sprite();
        newUp.addChild(upState);
        newUp.addChild(grayer);

        super(newUp, overState, downState, hitTestState);
    }

    public function set action(value:String):void {
        _action = value;
    }

    public function get action():String {
        return _action;
    }

    override public function set enabled(value:Boolean):void {
        super.enabled = value;
        grayer.visible = ! enabled;
    }
}
}
