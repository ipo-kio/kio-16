///**
// * Created by ilya on 08.03.16.
// */
//package ru.ipo.kio._16.mars.view {
//import flash.display.Sprite;
//import flash.text.TextField;
//import flash.text.TextFieldAutoSize;
//import flash.text.TextFormat;
//
//public class PlanetInfo extends Sprite {
//
//    private var title:TextField = new TextField();
//    private var r_info:TextField = new TextField();
//    private var phi_info:TextField = new TextField();
//
//    public function PlanetInfo(name:String) {
//        init_text_field(title);
//        init_text_field(r_info);
//        init_text_field(phi_info);
//
//        r_info.y = title.y + title.height;
//    }
//
//    private function init_text_field(tf:TextField):void {
//        tf.embedFonts = true;
//        tf.defaultTextFormat = new TextFormat('KioArial', 14, 0xFFFFFF);
//        tf.autoSize = TextFieldAutoSize.LEFT;
//        addChild(tf);
//        tf.x = 24;
//    }
//}
//}
