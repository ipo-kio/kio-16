/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

public class SkyInfoPanel extends Sprite {

        private var txt:TextField;
        private var sky:StarrySkyView;

        public function SkyInfoPanel(sky:StarrySkyView) {
            this.sky = sky;
            var tf:TextFormat = new TextFormat();
            txt = new TextField();
            tf.color = 0xfffff;
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
            txt.width = 160;
            txt.height = 50;
            txt.selectable = false;
        }
    }
}
