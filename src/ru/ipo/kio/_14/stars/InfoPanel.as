/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

    public class InfoPanel extends Sprite {

        private var txt:TextField;
        private var sky:StarrySkyView;

        public function InfoPanel(sky:StarrySkyView) {
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
            txt.width = 500;
            txt.height = 50;
            txt.x = 0;
            txt.y = sky.height;
            txt.selectable = false;
        }
    }
}
