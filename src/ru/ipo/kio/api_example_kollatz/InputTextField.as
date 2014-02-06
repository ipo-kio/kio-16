/**
 * Created with IntelliJ IDEA.
 * User: user
 * Date: 08.11.13
 * Time: 13:01
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api_example_kollatz {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

    public class InputTextField extends Sprite {

        private var _textField:TextField;
        private var nameTextFormat:TextFormat;
        private var textFormat:TextFormat;

        [Embed(source='resources/fontscore.com_s-segoe-print-bold.ttf', embedAsCFF='false', fontName="Segoe Print", mimeType='application/x-font-truetype')]
        private static var MyFont:Class;

        public function InputTextField(name:String) {

            var nameTextField:TextField = new TextField();
            _textField = new TextField();
            nameTextFormat = new TextFormat("Segoe Print", 23, 0x2e8b57);
            textFormat = new TextFormat("Segoe Print", 50, 0x003366);

            nameTextFormat.bold = true;

            nameTextField.defaultTextFormat = nameTextFormat;
            _textField.defaultTextFormat = textFormat;

            //разрешаем пользователю изменять текст
            _textField.type = TextFieldType.INPUT;

            name = name + ":";
            nameTextField.text = name;
            nameTextField.selectable = false;
            nameTextField.multiline = true;
            nameTextField.wordWrap = true;
            nameTextField.embedFonts = true;

            nameTextField.width = 135;
            nameTextField.height = 90;

            _textField.width = 180;
            _textField.height = 90;
            _textField.embedFonts = true;

            _textField.x = nameTextField.x + nameTextField.width + 20;
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
