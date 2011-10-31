package ru.ipo.kio._11_students.CrossedCountry {
/**
 * ...
 * @author Anna
 */

import flash.display.*;

public class button extends Sprite {
    public var butt:CustomButton = new CustomButton();

    public function button() {
        addChild(butt);
    }

}

}

import flash.display.*;

class CustomButton extends SimpleButton {

    private var upColor:uint = 0xC1FFC1;
    private var overColor:uint = 0x98FB98;
    private var downColor:uint = 0x98FB98;
    private var size:uint = 100;

    public function CustomButton() {
        downState = new ButtonDisplayState(downColor, size);
        overState = new ButtonDisplayState(overColor, size);
        upState = new ButtonDisplayState(upColor, size);
        hitTestState = new ButtonDisplayState(upColor, size * 2);
        hitTestState.x = -(size / 4);
        hitTestState.y = hitTestState.x;
        useHandCursor = true;
    }
}

class ButtonDisplayState extends Shape {
    private var bgColor:uint;
    private var size:uint;

    public function ButtonDisplayState(bgColor:uint, size:uint) {
        this.bgColor = bgColor;
        this.size = size;
        draw();
    }

    private function draw():void {
        graphics.beginFill(bgColor);
        graphics.drawRoundRect(0, 0, size, size / 2, 20);
        graphics.endFill();
    }
}