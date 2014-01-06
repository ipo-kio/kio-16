/**
 * Created by user on 06.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

public class InfoPanel extends Sprite {

        private var txt:TextField;

        public function InfoPanel() {

            txt = new TextField();
            txt.width = 500;
            txt.height = 50;

            addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent) {
                txt.text = "X coordinates: " + mouseX + "," + "Y coordinates: " + mouseY;
            });

            addChild(txt);
        }
    }
}
