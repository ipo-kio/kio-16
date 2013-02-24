/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 23.02.13
 * Time: 20:23
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api.controls {
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.GraphicsPathCommand;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class ButtonBuilder {

    private var _width:int = 0;
    private var _height:int = 0;

    private var _bgNormal:Class = null;
    private var _bgOver:Class = null;
    private var _bgPush:Class = null;

    private var _upColor:uint;
    private var _downColor:uint;
    private var _upHoverColor:uint;
    private var _downHoverColor:uint;
    private var _borderColor:uint;
    private var _innerBorderColor:uint;

    private var _font:String = 'KioArial';
    private var _fontSize:int = 14;
    private var _embedFont:Boolean = true;
    private var _bold:Boolean = false;
    private var _fontColor:uint = 0x000000;

    private var _title:String = null;
    private var _imgClass:Class = null;

    private var _diamondForm:Boolean = false;

    private var _action:String;

    public function ButtonBuilder(action:String = null) {
        _action = action;
    }

    public function build():SimpleButton { //TODO report var a:int = ... ? x() : y() then try to create x() and y(), return type is not devised
        if (_imgClass != null) {
            var img:DisplayObject = new _imgClass;

            _width = img.width;
            _height = img.height;
        }

        //TODO evaluate width if only text is given

        if (_bgNormal != null) {
            var up:DisplayObject = new _bgNormal;
            var over:DisplayObject = new _bgOver;
            var down:DisplayObject = new _bgPush;

            _width = up.width;
            _height = up.height;
        } else {
            up = twoColoredButton(width, height, _upColor, _downColor);
            over = twoColoredButton(width, height, _upHoverColor, _downHoverColor);
            down = twoColoredButton(width, height, _upHoverColor, _downHoverColor);
        }

        if (_imgClass != null) {
            up = mergeDisplayObjects(up, new _imgClass);
            over = mergeDisplayObjects(over, new _imgClass);
            down = mergeDisplayObjects(down, new _imgClass, 1, 1);
        }

        if (_title != null) {
            up = mergeDisplayObjectWithText(up);
            over = mergeDisplayObjectWithText(over);
            down = mergeDisplayObjectWithText(down, 1, 1);
        }

        var button:ActionButton = new ActionButton(up, over, down, _diamondForm ? createDiamond() : up);

        button.action = _action;

        return button;
    }

    public static function mergeDisplayObjects(do1:DisplayObject, do2:DisplayObject, dx:int = 0, dy:int = 0):Sprite {
        var s:Sprite = new Sprite();
        s.addChild(do1);
        do2.x = dx;
        do2.y = dy;
        s.addChild(do2);
        return s;
    }

    public function mergeDisplayObjectWithText(do1:DisplayObject, dx:int = 0, dy:int = 0):Sprite {
        var field:TextField = new TextField();

        field.autoSize = TextFieldAutoSize.CENTER;
        field.defaultTextFormat = new TextFormat(_font, _fontSize, null, _bold, null, null, null, null, TextFormatAlign.CENTER);
        field.selectable = false;
        field.multiline = true;
        field.embedFonts = _embedFont;
        field.width = width;
        field.x = dx + width / 2 - 1;
        field.text = _title;
        field.y = (height - field.textHeight - 4) / 2 + dy + 1;
        field.antiAliasType = AntiAliasType.ADVANCED;

        var s:Sprite = new Sprite();
        s.addChild(do1);
        s.addChild(field);
        return s;
    }

    private function createDiamond():Shape {
        var shape:Shape = new Shape();
        var g:Graphics = shape.graphics;
        g.beginFill(0x000000);
        var commands:Vector.<int> = new Vector.<int>(5, true);
        commands[0] = GraphicsPathCommand.MOVE_TO;
        commands[1] = GraphicsPathCommand.LINE_TO;
        commands[2] = GraphicsPathCommand.LINE_TO;
        commands[3] = GraphicsPathCommand.LINE_TO;
        commands[4] = GraphicsPathCommand.LINE_TO;

        var cords:Vector.<Number> = new Vector.<Number>(10, true);
        cords[0] = width / 2;
        cords[1] = 0;
        cords[2] = width;
        cords[3] = height / 2;
        cords[4] = width / 2;
        cords[5] = height;
        cords[6] = 0;
        cords[7] = height / 2;
        cords[8] = width / 2;
        cords[9] = 0;

        g.drawPath(commands, cords);
        g.endFill();

        return shape;
    }

    private function twoColoredButton(width:int, height:int, colorUp:uint, colorDown:uint):Shape {
        var s:Shape = new Shape();

        var g:Graphics = s.graphics;

        var m:Matrix = new Matrix();
        m.createGradientBox(width, height, Math.PI / 2);
        g.beginGradientFill(GradientType.LINEAR, [colorUp, colorDown], [1, 1], [0, 255], m);
        g.drawRect(0, 0, width, height);
        g.endFill();

        g.lineStyle(1, _innerBorderColor);
        g.drawRoundRect(1, 1, width - 2, height - 2, 2);
        g.lineStyle(1, _borderColor);
        g.drawRoundRect(0, 0, width, height, 2);

        return s;
    }

    //getters and setters

    public function get width():int {
        return _width;
    }

    public function set width(value:int):void {
        _width = value;
    }

    public function get height():int {
        return _height;
    }

    public function set height(value:int):void {
        _height = value;
    }

    public function get bgNormal():Class {
        return _bgNormal;
    }

    public function set bgNormal(value:Class):void {
        _bgNormal = value;
    }

    public function get bgOver():Class {
        return _bgOver;
    }

    public function set bgOver(value:Class):void {
        _bgOver = value;
    }

    public function get bgPush():Class {
        return _bgPush;
    }

    public function set bgPush(value:Class):void {
        _bgPush = value;
    }

    public function get upColor():uint {
        return _upColor;
    }

    public function set upColor(value:uint):void {
        _upColor = value;
    }

    public function get downColor():uint {
        return _downColor;
    }

    public function set downColor(value:uint):void {
        _downColor = value;
    }

    public function get upHoverColor():uint {
        return _upHoverColor;
    }

    public function set upHoverColor(value:uint):void {
        _upHoverColor = value;
    }

    public function get downHoverColor():uint {
        return _downHoverColor;
    }

    public function set downHoverColor(value:uint):void {
        _downHoverColor = value;
    }

    public function get action():String {
        return _action;
    }

    public function set action(value:String):void {
        _action = value;
    }

    public function get font():String {
        return _font;
    }

    public function set font(value:String):void {
        _font = value;
    }

    public function get fontSize():int {
        return _fontSize;
    }

    public function set fontSize(value:int):void {
        _fontSize = value;
    }

    public function get embedFont():Boolean {
        return _embedFont;
    }

    public function set embedFont(value:Boolean):void {
        _embedFont = value;
    }

    public function get bold():Boolean {
        return _bold;
    }

    public function set bold(value:Boolean):void {
        _bold = value;
    }

    public function get fontColor():uint {
        return _fontColor;
    }

    public function set fontColor(value:uint):void {
        _fontColor = value;
    }

    public function get diamondForm():Boolean {
        return _diamondForm;
    }

    public function set diamondForm(value:Boolean):void {
        _diamondForm = value;
    }

    public function get title():String {
        return _title;
    }

    public function set title(value:String):void {
        _title = value;
    }

    public function get imgClass():Class {
        return _imgClass;
    }

    public function set imgClass(value:Class):void {
        _imgClass = value;
    }

    public function get borderColor():uint {
        return _borderColor;
    }

    public function set borderColor(value:uint):void {
        _borderColor = value;
    }

    public function get innerBorderColor():uint {
        return _innerBorderColor;
    }

    public function set innerBorderColor(value:uint):void {
        _innerBorderColor = value;
    }
}
}
