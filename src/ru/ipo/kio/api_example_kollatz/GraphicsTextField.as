package ru.ipo.kio._3x_pl_1 
{
import fl.controls.ScrollBarDirection;
import fl.controls.UIScrollBar;

import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Darya
	 */
	public class GraphicsTextField extends Sprite 
	{
		private var _textField:TextField;
		private var nameTextFormat:TextFormat;
		private var textFormat:TextFormat;
        private var uiScrollBar:UIScrollBar;

        [Embed(source='resources/fontscore.com_s-segoe-print-bold.ttf', embedAsCFF='false', fontName="Segoe Print", mimeType='application/x-font-truetype')]
        private static var MyFont:Class;
		
		public function GraphicsTextField(name:String, widthOfDynamicField:Number = 60, heightOfDynamicField:Number = 35) {

            var nameTextField:TextField = new TextField();
            _textField = new TextField();
            nameTextFormat = new TextFormat("Segoe Print", 20, 0x2e8b57);
            textFormat = new TextFormat("Segoe Print", 20, 0x003366);

            nameTextFormat.bold = true;
            nameTextField.defaultTextFormat = nameTextFormat;
            _textField.defaultTextFormat = textFormat;

            _textField.multiline = true;
            _textField.wordWrap = true;
            _textField.selectable = false;

            name = name + ":";
            nameTextField.text = name;
            nameTextField.selectable = false;
            nameTextField.multiline = true;
            nameTextField.wordWrap = true;
            nameTextField.embedFonts = true;

            nameTextField.width = 135;
            nameTextField.height = 70;

            _textField.width = widthOfDynamicField;
            _textField.height = heightOfDynamicField;
            _textField.embedFonts = true;

            _textField.x = nameTextField.x + nameTextField.width + 20;

            uiScrollBar = new UIScrollBar();
            uiScrollBar.direction = ScrollBarDirection.VERTICAL;
            uiScrollBar.setSize(_textField.width, _textField.height);
            uiScrollBar.move(nameTextField.width + _textField.width + 38, _textField.y + 3);
            uiScrollBar.scrollTarget = _textField;

            addChild(nameTextField);
            addChild(_textField);
            addChild(uiScrollBar);
        }

        public function set text(text:String):void {
            _textField.text = text;
        }

        public function get text():String {
            return _textField.text;
        }

        public function updateScrollBar():void {
             uiScrollBar.update();
        }
	}
}