/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.text.TextField;

    public class SkyInfoPanel extends Sprite {

        private var txt:TextField;
        private var sky:StarrySkyView;

        public function SkyInfoPanel(sky:StarrySkyView) {
            this.sky = sky;
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
            txt = new TextField();
            txt.width = 160;
            txt.height = 70;
            txt.selectable = false;
            txt.text = "X coordinates: " + mouseX + ",\n" + "Y coordinates: " + mouseY;
        }
    }
}
