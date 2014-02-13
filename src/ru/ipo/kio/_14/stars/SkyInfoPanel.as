/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

public class SkyInfoPanel extends Sprite {

        private var txt:TextField;
        private var _skyView:StarrySkyView;

        public function SkyInfoPanel(sky:StarrySkyView) {
            this._skyView = sky;
            var tf:TextFormat = new TextFormat("Arial", 13, 0xfffff);
            txt = new TextField();
            txt.defaultTextFormat = tf;
            drawPanel();
            addChild(txt);
        }

        public function set text(value:String):void {
            txt.text = value;
        }

        public function get text():String {
            return txt.text;
        }

        private function drawPanel():void {
            txt.width = 200;
            txt.height = 100;
            txt.selectable = false;
            txt.text = "X coordinates: " + _skyView.mouseX + "\n" + "Y coordinates: " + _skyView.mouseY;
        }
    }
}
