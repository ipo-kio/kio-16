/**
 * Created by Vasiliy on 21.02.2015.
 */
package ru.ipo.kio._15.markov {
import com.nerdbucket.ToolTip;

import flash.display.DisplayObjectContainer;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

import ru.ipo.kio.api.controls.TextButton;

public class ImageHolder {

    [Embed(source="_resources/buttons/edit.png")]
    public static const EDIT:Class;

    [Embed(source="_resources/buttons/edit_Disable.png")]
    public static const EDIT_DIS:Class;

    [Embed(source="_resources/buttons/edit_Over.png")]
    public static const EDIT_OVER:Class;

    [Embed(source="_resources/buttons/edit_Press.png")]
    public static const EDIT_PRESS:Class;


    [Embed(source="_resources/buttons/del_min.png")]
    public static const DELMIN:Class;

    [Embed(source="_resources/buttons/del_min_Press.png")]
    public static const DELMIN_DIS:Class;

    [Embed(source="_resources/buttons/del_min_Over.png")]
    public static const DELMIN_OVER:Class;

    [Embed(source="_resources/buttons/del_min_Over_2.png")]
    public static const DELMIN_OVER2:Class;


    [Embed(source="_resources/buttons/del_min_Press.png")]
    public static const DELMIN_PRESS:Class;



    [Embed(source="_resources/buttons/fast.png")]
    public static const EXEC:Class;

    [Embed(source="_resources/buttons/fast_Disable.png")]
    public static const EXEC_DIS:Class;

    [Embed(source="_resources/buttons/fast_Over.png")]
    public static const EXEC_OVER:Class;

    [Embed(source="_resources/buttons/fast_Press.png")]
    public static const EXEC_PRESS:Class;



    [Embed(source="_resources/buttons/reset.png")]
    public static const RESET:Class;

    [Embed(source="_resources/buttons/reset_Disable.png")]
    public static const RESET_DIS:Class;

    [Embed(source="_resources/buttons/reset_Over.png")]
    public static const RESET_OVER:Class;

    [Embed(source="_resources/buttons/reset_Press.png")]
    public static const RESET_PRESS:Class;


    [Embed(source="_resources/buttons/next.png")]
    public static const NEXT:Class;

    [Embed(source="_resources/buttons/next_Disable.png")]
    public static const NEXT_DIS:Class;

    [Embed(source="_resources/buttons/next_Over.png")]
    public static const NEXT_OVER:Class;

    [Embed(source="_resources/buttons/next_Press.png")]
    public static const NEXT_PRESS:Class;


    [Embed(source="_resources/buttons/prev.png")]
    public static const PREV:Class;

    [Embed(source="_resources/buttons/prev_Disable.png")]
    public static const PREV_DIS:Class;

    [Embed(source="_resources/buttons/prev_Over.png")]
    public static const PREV_OVER:Class;

    [Embed(source="_resources/buttons/prev_Press.png")]
    public static const PREV_PRESS:Class;


    [Embed(source="_resources/buttons/play.png")]
    public static const PLAY:Class;

    [Embed(source="_resources/buttons/play_Disable.png")]
    public static const PLAY_DIS:Class;

    [Embed(source="_resources/buttons/play_Over.png")]
    public static const PLAY_OVER:Class;

    [Embed(source="_resources/buttons/play_Press.png")]
    public static const PLAY_PRESS:Class;


    [Embed(source="_resources/buttons/pause.png")]
    public static const PAUSE:Class;

    [Embed(source="_resources/buttons/pause_Disable.png")]
    public static const PAUSE_DIS:Class;

    [Embed(source="_resources/buttons/pause_Over.png")]
    public static const PAUSE_OVER:Class;

    [Embed(source="_resources/buttons/pause_Press.png")]
    public static const PAUSE_PRESS:Class;


    [Embed(source="_resources/buttons/delete.png")]
    public static const DELETE:Class;

    [Embed(source="_resources/buttons/delete_Disable.png")]
    public static const DELETE_DIS:Class;

    [Embed(source="_resources/buttons/delete_Over.png")]
    public static const DELETE_OVER:Class;

    [Embed(source="_resources/buttons/delete_Press.png")]
    public static const DELETE_PRESS:Class;


    [Embed(source="_resources/buttons/add.png")]
    public static const PLUS:Class;

    [Embed(source="_resources/buttons/add_Disable.png")]
    public static const PLUS_DIS:Class;

    [Embed(source="_resources/buttons/add_Over.png")]
    public static const PLUS_OVER:Class;

    [Embed(source="_resources/buttons/add_Press.png")]
    public static const PLUS_PRESS:Class;




    [Embed(source="_resources/level0/vegetable_1.png")]
    public static const EMPTY:Class;

    [Embed(source="_resources/level0/vegetable_1_Over.png")]
    public static const EMPTY_OVER:Class;

    [Embed(source="_resources/level0/vegetable_1_Press.png")]
    public static const EMPTY_PRESS:Class;

    [Embed(source="_resources/level0/vegetable_1_Selected.png")]
    public static const EMPTY_SELECT:Class;

    [Embed(source="_resources/level0/vegetable_2.png")]
    public static const CARROT:Class;

    [Embed(source="_resources/level0/vegetable_2_Over.png")]
    public static const CARROT_OVER:Class;

    [Embed(source="_resources/level0/vegetable_2_Press.png")]
    public static const CARROT_PRESS:Class;

    [Embed(source="_resources/level0/vegetable_2_Selected.png")]
    public static const CARROT_SELECT:Class;

    [Embed(source="_resources/level0/vegetable_4.png")]
    public static const FLOWER:Class;

    [Embed(source="_resources/level0/vegetable_4_Over.png")]
    public static const FLOWER_OVER:Class;

    [Embed(source="_resources/level0/vegetable_4_Press.png")]
    public static const FLOWER_PRESS:Class;

    [Embed(source="_resources/level0/vegetable_4_Selected.png")]
    public static const FLOWER_SELECT:Class;

    [Embed(source="_resources/level0/vegetable_5.png")]
    public static const WEED:Class;

    [Embed(source="_resources/level0/vegetable_5_Over.png")]
    public static const WEED_OVER:Class;

    [Embed(source="_resources/level0/vegetable_5_Press.png")]
    public static const WEED_PRESS:Class;

    [Embed(source="_resources/level0/vegetable_5_Selected.png")]
    public static const WEED_SELECT:Class;


    [Embed(source="_resources/level0/bg.png")]
    public static const LEVEL0_BG:Class;



    [Embed(source="_resources/level1/bg.png")]
    public static const LEVEL1_BG:Class;


    [Embed(source="_resources/level1/lad_white.png")]
    public static const LADW:Class;

    [Embed(source="_resources/level1/lad_white_Over.png")]
    public static const LADW_OVER:Class;

    [Embed(source="_resources/level1/lad_white_Selected.png")]
    public static const LADW_PRESS:Class;

    [Embed(source="_resources/level1/lad_white_Selected.png")]
    public static const LADW_SELECT:Class;

    [Embed(source="_resources/level1/lad_black.png")]
    public static const LADB:Class;

    [Embed(source="_resources/level1/lad_black_Over.png")]
    public static const LADB_OVER:Class;

    [Embed(source="_resources/level1/lad_black_Selected.png")]
    public static const LADB_PRESS:Class;

    [Embed(source="_resources/level1/lad_black_Selected.png")]
    public static const LADB_SELECT:Class;




    [Embed(source="_resources/level1/king_white.png")]
    public static const KINGW:Class;

    [Embed(source="_resources/level1/king_white_Over.png")]
    public static const KINGW_OVER:Class;

    [Embed(source="_resources/level1/king_white_Selected.png")]
    public static const KINGW_PRESS:Class;

    [Embed(source="_resources/level1/king_white_Selected.png")]
    public static const KINGW_SELECT:Class;

    [Embed(source="_resources/level1/king_black.png")]
    public static const KINGB:Class;

    [Embed(source="_resources/level1/king_black_Over.png")]
    public static const KINGB_OVER:Class;

    [Embed(source="_resources/level1/king_black_Selected.png")]
    public static const KINGB_PRESS:Class;

    [Embed(source="_resources/level1/king_black_Selected.png")]
    public static const KINGB_SELECT:Class;



    [Embed(source="_resources/level1/bishop.png")]
    public static const BISHOP:Class;

    [Embed(source="_resources/level1/bishop_Over.png")]
    public static const BISHOP_OVER:Class;

    [Embed(source="_resources/level1/bishop_Selected.png")]
    public static const BISHOP_PRESS:Class;

    [Embed(source="_resources/level1/bishop_Selected.png")]
    public static const BISHOP_SELECT:Class;



    [Embed(source="_resources/level1/pawn.png")]
    public static const PAWN:Class;

    [Embed(source="_resources/level1/pawn_Over.png")]
    public static const PAWN_OVER:Class;

    [Embed(source="_resources/level1/pawn_Selected.png")]
    public static const PAWN_PRESS:Class;

    [Embed(source="_resources/level1/pawn_Selected.png")]
    public static const PAWN_SELECT:Class;


    [Embed(source="_resources/level1/knight.png")]
    public static const KNIGHT:Class;

    [Embed(source="_resources/level1/knight_Over.png")]
    public static const KNIGHT_OVER:Class;

    [Embed(source="_resources/level1/knight_Selected.png")]
    public static const KNIGHT_PRESS:Class;

    [Embed(source="_resources/level1/knight_Selected.png")]
    public static const KNIGHT_SELECT:Class;


    [Embed(source="_resources/level1/x_Over.png")]
    public static const X_1:Class;

    [Embed(source="_resources/level1/x_Over_Over.png")]
    public static const X_1_OVER:Class;

    [Embed(source="_resources/level1/x_Selected.png")]
    public static const X_1_PRESS:Class;

    [Embed(source="_resources/level1/x_Selected.png")]
    public static const X_1_SELECT:Class;

    [Embed(source="_resources/level1/start_Over.png")]
    public static const ST_1:Class;

    [Embed(source="_resources/level1/start_Over_Over.png")]
    public static const ST_1_OVER:Class;

    [Embed(source="_resources/level1/start_Selected.png")]
    public static const ST_1_PRESS:Class;

    [Embed(source="_resources/level1/start_Selected.png")]
    public static const ST_1_SELECT:Class;



    [Embed(source="_resources/level2/bg.png")]
    public static const LEVEL2_BG:Class;

    [Embed(source="_resources/level2/1.png")]
    public static const ONE:Class;

    [Embed(source="_resources/level2/1_Over.png")]
    public static const ONE_OVER:Class;

    [Embed(source="_resources/level2/1_Selected.png")]
    public static const ONE_PRESS:Class;

    [Embed(source="_resources/level2/1_Selected.png")]
    public static const ONE_SELECT:Class;

    [Embed(source="_resources/level2/plus.png")]
    public static const PLUSS:Class;

    [Embed(source="_resources/level2/plus_Over.png")]
    public static const PLUSS_OVER:Class;

    [Embed(source="_resources/level2/plus_Selected.png")]
    public static const PLUSS_PRESS:Class;

    [Embed(source="_resources/level2/plus_Selected.png")]
    public static const PLUSS_SELECT:Class;

    [Embed(source="_resources/level2/minus.png")]
    public static const MINUS:Class;

    [Embed(source="_resources/level2/minus_Over.png")]
    public static const MINUS_OVER:Class;

    [Embed(source="_resources/level2/minus_Selected.png")]
    public static const MINUS_PRESS:Class;

    [Embed(source="_resources/level2/minus_Selected.png")]
    public static const MINUS_SELECT:Class;

    [Embed(source="_resources/level2/open.png")]
    public static const OPEN:Class;

    [Embed(source="_resources/level2/open_Over.png")]
    public static const OPEN_OVER:Class;

    [Embed(source="_resources/level2/open_Selected.png")]
    public static const OPEN_PRESS:Class;

    [Embed(source="_resources/level2/open_Selected.png")]
    public static const OPEN_SELECT:Class;

    [Embed(source="_resources/level2/close.png")]
    public static const CLOSE:Class;

    [Embed(source="_resources/level2/close_Over.png")]
    public static const CLOSE_OVER:Class;

    [Embed(source="_resources/level2/close_Selected.png")]
    public static const CLOSE_PRESS:Class;

    [Embed(source="_resources/level2/close_Selected.png")]
    public static const CLOSE_SELECT:Class;

    [Embed(source="_resources/level2/2.png")]
    public static const TWO:Class;

    [Embed(source="_resources/level2/2_Over.png")]
    public static const TWO_OVER:Class;

    [Embed(source="_resources/level2/2_Selected.png")]
    public static const TWO_PRESS:Class;

    [Embed(source="_resources/level2/2_Selected.png")]
    public static const TWO_SELECT:Class;


    [Embed(source="_resources/level2/0.png")]
    public static const ZERO:Class;

    [Embed(source="_resources/level2/0_Over.png")]
    public static const ZERO_OVER:Class;

    [Embed(source="_resources/level2/0_Selected.png")]
    public static const ZERO_PRESS:Class;

    [Embed(source="_resources/level2/0_Selected.png")]
    public static const ZERO_SELECT:Class;

    [Embed(source="_resources/level2/A.png")]
    public static const A:Class;

    [Embed(source="_resources/level2/A_Over.png")]
    public static const A_OVER:Class;

    [Embed(source="_resources/level2/A_Selected.png")]
    public static const A_PRESS:Class;

    [Embed(source="_resources/level2/A_Selected.png")]
    public static const A_SELECT:Class;



    [Embed(source="_resources/level2/B.png")]
    public static const B:Class;

    [Embed(source="_resources/level2/B_Over.png")]
    public static const B_OVER:Class;

    [Embed(source="_resources/level2/B_Selected.png")]
    public static const B_PRESS:Class;

    [Embed(source="_resources/level2/B_Selected.png")]
    public static const B_SELECT:Class;


    [Embed(source="_resources/level2/x.png")]
    public static const X:Class;

    [Embed(source="_resources/level2/x_Over.png")]
    public static const X_OVER:Class;

    [Embed(source="_resources/level2/x_Selected.png")]
    public static const X_PRESS:Class;

    [Embed(source="_resources/level2/x_Selected.png")]
    public static const X_SELECT:Class;

    [Embed(source="_resources/level2/start.png")]
    public static const ST:Class;

    [Embed(source="_resources/level2/start_Over.png")]
    public static const ST_OVER:Class;

    [Embed(source="_resources/level2/start_Selected.png")]
    public static const ST_PRESS:Class;

    [Embed(source="_resources/level2/start_Selected.png")]
    public static const ST_SELECT:Class;


    public function ImageHolder() {
    }

    public static function getVegetable(code:String) {
     if(code=="c"){
         return new CARROT();
     }else if(code=="w"){
         return new WEED();
     }else if(code=="f"){
         return new FLOWER();
     } else if(code=="1"){
         return new ONE();
     } else if(code=="+"){
         return new PLUSS();
     } else if(code=="-"){
         return new MINUS();
     } else if(code=="("){
         return new OPEN();
     } else if(code==")"){
         return new CLOSE();
     }else if(code=="0"){
         return new ZERO();
     }else if(code=="A"){
         return new A();
     }else if(code=="B"){
         return new B();
     }else if(code=="X"){
         return new X();
     }else if(code=="S"){
         return new ST();
     }else if(code=="2"){
         return new TWO();
     }else if(code=="s"){
         return new ST_1();
     }else if(code=="x"){
         return new X_1();
     }else if(code=="k"){
         return new KINGB();
     }else if(code=="K"){
         return new KINGW();
     }else if(code=="l"){
         return new LADB();
     }else if(code=="L"){
         return new LADW();
     }else if(code=="p"){
         return new PAWN();
     }else if(code=="b"){
         return new BISHOP();
     }else if(code=="n"){
         return new KNIGHT();
     }else {
         return new EMPTY();
     }
    }

    public static function getVegetableSelected(code:String) {
        if(code=="c"){
            return new CARROT_SELECT();
        }else if(code=="w"){
            return new WEED_SELECT();
        }else if(code=="f"){
            return new FLOWER_SELECT();
         } else if(code=="1"){
            return new ONE_SELECT();
        } else if(code=="+"){
            return new PLUSS_SELECT();
        } else if(code=="-"){
            return new MINUS_SELECT();
        } else if(code=="("){
            return new OPEN_SELECT();
        } else if(code==")"){
            return new CLOSE_SELECT();
        }else if(code=="0"){
            return new ZERO_SELECT();
        }else if(code=="2"){
            return new TWO_SELECT();
        }else if(code=="A"){
            return new A_SELECT();
        }else if(code=="B"){
            return new B_SELECT();
        }else if(code=="X"){
            return new X_SELECT();
        }else if(code=="S"){
            return new ST_SELECT();
        }else if(code=="s"){
            return new ST_1_SELECT();
        }else if(code=="x"){
            return new X_1_SELECT();
        }else if(code=="k"){
            return new KINGB_SELECT();
        }else if(code=="K"){
            return new KINGW_SELECT();
        }else if(code=="l"){
            return new LADB_SELECT();
        }else if(code=="L"){
            return new LADW_SELECT();
        }else if(code=="p"){
            return new PAWN_SELECT();
        }else if(code=="b"){
            return new BISHOP_SELECT();
        }else if(code=="n"){
            return new KNIGHT_SELECT();
        }else {
            return new EMPTY_SELECT();
        }
    }

    public static function getVegetableOver(code:String) {
        if(code=="c"){
            return new CARROT_OVER();
        }else if(code=="w"){
            return new WEED_OVER();
        }else if(code=="f"){
            return new FLOWER_OVER();
        } else if(code=="1"){
            return new ONE_OVER();
        } else if(code=="+"){
            return new PLUSS_OVER();
        } else if(code=="-"){
            return new MINUS_OVER();
        } else if(code=="("){
            return new OPEN_OVER();
        } else if(code==")"){
            return new CLOSE_OVER();
        }else if(code=="0"){
            return new ZERO_OVER();
        }else if(code=="2"){
            return new TWO_OVER();
        }else if(code=="A"){
            return new A_OVER();
        }else if(code=="B"){
            return new B_OVER();
        }else if(code=="X"){
            return new X_OVER();
        }else if(code=="S"){
            return new ST_OVER();
        }else if(code=="s"){
            return new ST_1_OVER();
        }else if(code=="x"){
            return new X_1_OVER();
        }else if(code=="k"){
            return new KINGB_OVER();
        }else if(code=="K"){
            return new KINGW_OVER();
        }else if(code=="l"){
            return new LADB_OVER();
        }else if(code=="L"){
            return new LADW_OVER();
        }else if(code=="p"){
            return new PAWN_OVER();
        }else if(code=="b"){
            return new BISHOP_OVER();
        }else if(code=="n"){
            return new KNIGHT_OVER();
        }else {
            return new EMPTY_OVER();
        }
    }


    public static function getVegetablePress(code:String) {
        if(code=="c"){
            return new CARROT_PRESS();
        }else if(code=="w"){
            return new WEED_PRESS();
        }else if(code=="f"){
            return new FLOWER_PRESS();
        } else if(code=="1"){
            return new ONE_PRESS();
        } else if(code=="+"){
            return new PLUSS_PRESS();
        } else if(code=="-"){
            return new MINUS_PRESS();
        } else if(code=="("){
            return new OPEN_PRESS();
        } else if(code==")"){
            return new CLOSE_PRESS();
        }else if(code=="0"){
            return new ZERO_PRESS();
        }else if(code=="2"){
            return new TWO_PRESS();
        }else if(code=="A"){
            return new A_PRESS();
        }else if(code=="B"){
            return new B_PRESS();
        }else if(code=="X"){
            return new X_PRESS();
        }else if(code=="S"){
            return new ST_PRESS();
        }else if(code=="s"){
            return new ST_1_PRESS();
        }else if(code=="x"){
            return new X_1_PRESS();
        }else if(code=="k"){
            return new KINGB_PRESS();
        }else if(code=="K"){
            return new KINGW_PRESS();
        }else if(code=="l"){
            return new LADB_PRESS();
        }else if(code=="L"){
            return new LADW_PRESS();
        }else if(code=="p"){
            return new PAWN_PRESS();
        }else if(code=="b"){
            return new BISHOP_PRESS();
        }else if(code=="n"){
            return new KNIGHT_PRESS();
        }else {
            return new EMPTY_PRESS();
        }
    }

    public static function createButton(parent:DisplayObjectContainer, label:String, x:int, y:int, func, tip:String):SimpleButton {
        var button:SimpleButton = new TextButton(label, 50);

        if(label=="x") {
            button = new NormalButton(new ImageHolder.DELMIN(), new ImageHolder.DELMIN_OVER(), new ImageHolder.DELMIN_PRESS(), new ImageHolder.DELMIN_DIS());
        }


        if(label=="X") {
            button = new NormalButton(new ImageHolder.DELMIN_OVER(), new ImageHolder.DELMIN_OVER2(), new ImageHolder.DELMIN_PRESS(), new ImageHolder.DELMIN_DIS());
        }

        if(label=="+") {
            button = new NormalButton(new ImageHolder.PLUS(), new ImageHolder.PLUS_OVER(), new ImageHolder.PLUS_PRESS(), new ImageHolder.PLUS_DIS());
        }

        if(label=="anim") {
            button = new NormalButton(new ImageHolder.PLAY(), new ImageHolder.PLAY_OVER(), new ImageHolder.PLAY_PRESS(), new ImageHolder.PLAY_DIS());
        }

        if(label=="stop") {
            button = new NormalButton(new ImageHolder.PAUSE(), new ImageHolder.PAUSE_OVER(), new ImageHolder.PAUSE_PRESS(), new ImageHolder.PAUSE_DIS());
        }


        if(label==">") {
            button = new NormalButton(new ImageHolder.NEXT(), new ImageHolder.NEXT_OVER(), new ImageHolder.NEXT_PRESS(), new ImageHolder.NEXT_DIS());
        }

        if(label=="<") {
            button = new NormalButton(new ImageHolder.PREV(), new ImageHolder.PREV_OVER(), new ImageHolder.PREV_PRESS(), new ImageHolder.PREV_DIS());
        }

        if(label=="exec") {
            button = new NormalButton(new ImageHolder.EXEC(), new ImageHolder.EXEC_OVER(), new ImageHolder.EXEC_PRESS(), new ImageHolder.EXEC_DIS());
        }

        if(label=="reset") {
            button = new NormalButton(new ImageHolder.RESET(), new ImageHolder.RESET_OVER(), new ImageHolder.RESET_PRESS(), new ImageHolder.RESET_DIS());
        }

        if(label=="edit") {
            button = new NormalButton(new ImageHolder.EDIT(), new ImageHolder.EDIT_OVER(), new ImageHolder.EDIT_PRESS(), new ImageHolder.EDIT_DIS());
        }



        button.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            func();
        });
        button.x = x;
        button.y = y;
        parent.addChild(button);
        ToolTip.attach(button,tip);
        return button;
    }
}
}
