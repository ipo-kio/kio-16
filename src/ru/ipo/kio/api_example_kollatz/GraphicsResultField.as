package ru.ipo.kio.api_example_kollatz
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Darya
	 */
	public class GraphicsResultField extends Sprite 
	{
		private var _textField:TextField;
		private var nameTextFormat:TextFormat;
		private var textFormat:TextFormat;

        [Embed(source='resources/fontscore.com_s-segoe-print-bold.ttf', embedAsCFF='false', fontName="Segoe Print", mimeType='application/x-font-truetype')]
        private static var MyFont:Class;
		
		public function GraphicsResultField(name:String, width:int = 260, height:int = 30, textHeight:int = 30) {

            var nameTextField:TextField = new TextField();
            _textField = new TextField();
            nameTextFormat = new TextFormat("Segoe Print", 20, 0x2e8b57);
            textFormat = new TextFormat("Segoe Print", 20, 0x003366);

            nameTextFormat.bold = true;

            nameTextField.defaultTextFormat = nameTextFormat;
            _textField.defaultTextFormat = textFormat;

            name = name + ":";
            nameTextField.text = name;
            nameTextField.selectable = false;
            nameTextField.multiline = true;
            nameTextField.wordWrap = true;
            nameTextField.embedFonts = true;

            _textField.selectable = false;
            _textField.embedFonts = true;

            nameTextField.width = width;
            nameTextField.height = height;

            _textField.width = 88;
            _textField.height = textHeight;

            _textField.x = nameTextField.x + nameTextField.width;
            nameTextField.y = 0.5*(_textField.height - nameTextField.height);

            addChild(nameTextField);
            addChild(_textField);
        }

        public function set text(text:String):void {
            _textField.text = text;
        }

        public function get text():String {
            return _textField.text;
        }
	}

}