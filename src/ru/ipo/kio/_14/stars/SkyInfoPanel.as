/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.base.KioBase;
import ru.ipo.kio.api.TextUtils;

public class SkyInfoPanel extends Sprite {

        private var txt:TextField;
        private var _skyView:StarrySkyView;

        [Embed(source='resources/segoepr.ttf', embedAsCFF="false", fontName="Segoe Print", mimeType='application/x-font-truetype')]
        private static var MyFont:Class;

        public function SkyInfoPanel(sky:StarrySkyView) {
            TextUtils.embedFonts();

            this._skyView = sky;
            var tf:TextFormat = new TextFormat(KioApi.language == "th" ? "KioTahoma" : "Segoe Print", 16, 0xfffff);
            txt = new TextField();
            txt.embedFonts = true;
            txt.defaultTextFormat = tf;
            drawPanel();
            addChild(txt);
            txt.autoSize = TextFieldAutoSize.LEFT;

            mouseEnabled = false;
            mouseChildren = false;
        }

        public function set text(value:String):void {
            txt.text = value;
        }

        public function get text():String {
            return txt.text;
        }

        private function drawPanel():void {
            txt.width = 300;
            txt.height = 100;
            txt.selectable = false;
        }
    }
}
