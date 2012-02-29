/**
 *
 * @author: Vasily Akimushkin
 * @since: 28.02.12
 */
package ru.ipo.kio._12.train.model {
import flash.utils.Dictionary;

import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.view.TrainView;

public class FirstLevelTrainPlacer {
    public function FirstLevelTrainPlacer() {
    }

    private static var dict:Dictionary = new Dictionary();

    private static var next:Dictionary = new Dictionary();

    public static function init() {
        dict = new Dictionary();

        dict[RailType.ROUND_TOP_RIGHT.name + "0" + "true"] = {x:30, y:48, r:-75};
        dict[RailType.ROUND_TOP_RIGHT.name + "1" + "true"] = {x:82, y:10, r:0};
        dict[RailType.ROUND_TOP_RIGHT.name + "2" + "true"] = {x:128, y:69, r:105};
        dict[RailType.ROUND_TOP_RIGHT.name + "3" + "true"] = {x:91, y:107, r:165};

        dict[RailType.ROUND_TOP_LEFT.name + "0" + "true"] = {x:30, y:48, r:-75};
        dict[RailType.ROUND_TOP_LEFT.name + "1" + "true"] = {x:82, y:10, r:0};
        dict[RailType.ROUND_TOP_LEFT.name + "2" + "true"] = {x:128, y:69, r:105};
        dict[RailType.ROUND_TOP_LEFT.name + "3" + "true"] = {x:91, y:107, r:165};

        dict[RailType.ROUND_BOTTOM_LEFT.name + "0" + "true"] = {x:45, y:31, r:165};
        dict[RailType.ROUND_BOTTOM_LEFT.name + "1" + "true"] = {x:5, y:80, r:90};
        dict[RailType.ROUND_BOTTOM_LEFT.name + "2" + "true"] = {x:73, y:130, r:-15};
        dict[RailType.ROUND_BOTTOM_LEFT.name + "3" + "true"] = {x:111, y:79, r:-90};

        dict[RailType.ROUND_BOTTOM_RIGHT.name + "0" + "true"] = {x:45, y:31, r:165};
        dict[RailType.ROUND_BOTTOM_RIGHT.name + "1" + "true"] = {x:5, y:80, r:90};
        dict[RailType.ROUND_BOTTOM_RIGHT.name + "2" + "true"] = {x:73, y:130, r:-15};
        dict[RailType.ROUND_BOTTOM_RIGHT.name + "3" + "true"] = {x:111, y:79, r:-90};

        dict[RailType.SEMI_ROUND_BOTTOM.name + "0" + "true"] = {x:36, y:34, r:60};
        dict[RailType.SEMI_ROUND_BOTTOM.name + "1" + "true"] = {x:124, y:31, r:-60};
        dict[RailType.SEMI_ROUND_BOTTOM.name + "0" + "false"] = {x:36, y:35, r:-120};
        dict[RailType.SEMI_ROUND_BOTTOM.name + "1" + "false"] = {x:126, y:29, r:120};

        dict[RailType.SEMI_ROUND_TOP.name + "0" + "true"] = {x:38, y:27, r:-45};
        dict[RailType.SEMI_ROUND_TOP.name + "1" + "true"] = {x:121, y:29, r:60};
        dict[RailType.SEMI_ROUND_TOP.name + "0" + "false"] = {x:121, y:29, r:-120};
        dict[RailType.SEMI_ROUND_TOP.name + "1" + "false"] = {x:40, y:29, r:135};

        dict[RailType.SEMI_ROUND_LEFT.name + "0" + "true"] = {x:25, y:41, r:135};
        dict[RailType.SEMI_ROUND_LEFT.name + "1" + "true"] = {x:29, y:119, r:45};
        dict[RailType.SEMI_ROUND_LEFT.name + "0" + "false"] = {x:27, y:118, r:-135};
        dict[RailType.SEMI_ROUND_LEFT.name + "1" + "false"] = {x:25, y:41, r:-45};

        dict[RailType.SEMI_ROUND_RIGHT.name + "0" + "true"] = {x:31, y:35, r:30};
        dict[RailType.SEMI_ROUND_RIGHT.name + "1" + "true"] = {x:31, y:123, r:150};
        dict[RailType.SEMI_ROUND_RIGHT.name + "0" + "false"] = {x:31, y:124, r:-30};
        dict[RailType.SEMI_ROUND_RIGHT.name + "1" + "false"] = {x:31, y:35, r:-150};

        dict[RailType.HORIZONTAL.name + "0" + "true"] = {x:31, y:25, r:0};
        dict[RailType.HORIZONTAL.name + "0" + "false"] = {x:31, y:25, r:-180};

        dict[RailType.VERTICAL.name + "0" + "true"] = {x:26, y:30, r:90};
        dict[RailType.VERTICAL.name + "0" + "false"] = {x:26, y:30, r:-90};


        next = new Dictionary();

        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.VERTICAL.name+"false"] = [
            {x:52, y:26, r:0},
            {x:71, y:18, r:-45},
            {x:79, y:3, r:-75}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.VERTICAL.name+"true"] = [
            {x:51, y:26, r:0},
            {x:73, y:32, r:45},
            {x:79, y:52, r:75}
        ];

    }


    public static function place(train:Train, view:TrainView, width:int, height:int) {
        init();
        var tick:int = train.tick;
        var innerTick:int = TrafficNetwork.instance.inner;
        var nextRail:Rail = train.getNextRail();

        var obj:Object = dict[train.rail.type.name + String(train.tick) + train.isDirect()];
        if(obj == null)
            return;
        view.rotation = obj.r;
        view.x += obj.x;
        view.y += obj.y;

        if(nextRail!=null){
            var arr:Array = null;
            var nxt:Object = null;
            
            if(nextRail==train.rail){
                arr = next[train.rail.type.name + String(train.tick) + train.isDirect()+train.rail.type.name+train.isDirect()];
                nxt = dict[train.rail.type.name + String(train.tick+1) + train.isDirect()];
            }
            else{
                var dir:Boolean = nextRail.firstEnd.isConnected(train.rail);
                arr = next[train.rail.type.name + String(train.tick) + train.isDirect()+nextRail.type.name+dir];
                nxt = dict[nextRail.type.name + String(0) + dir];
            }

            var iter:int = 8;

            if(nxt!=null && arr!=null){
                var finalx:int = nextRail.view.x+nxt.x;
                var finaly:int = nextRail.view.y+nxt.y;
                var finalr:int = nxt.r;

                var inr:int = view.rotation;
                var inx:int = view.x;
                var iny:int = view.y;

                var clr:int = view.rotation;
                var clx:int = view.x - obj.x;
                var cly:int = view.y - obj.y;

                var minx:int;
                var miny:int;
                var minr:int;

                var maxx:int;
                var maxy:int;
                var maxr:int;

                if(innerTick>=0 && innerTick<8){
                   minx = inx;
                   miny = iny;
                   minr = inr;
                   maxx = clx+arr[0].x;
                   maxy = cly+arr[0].y;
                   maxr = clr+arr[0].r;
                }else if(innerTick>=8 && innerTick<16){
                    minx = clx+arr[0].x;
                    miny = cly+arr[0].y;
                    minr = clr+arr[0].r;
                    maxx = clx+arr[1].x;
                    maxy = cly+arr[1].y;
                    maxr = clr+arr[1].r;
                }else if(innerTick>=16 && innerTick<24){
                    minx = clx+arr[1].x;
                    miny = cly+arr[1].y;
                    minr = clr+arr[1].r;
                    maxx = clx+arr[2].x;
                    maxy = cly+arr[2].y;
                    maxr = clr+arr[2].r;
                }else if(innerTick>=24 && innerTick<32){
                    minx = clx+arr[2].x;
                    miny = cly+arr[2].y;
                    minr = clr+arr[2].r;
                    maxx = finalx;
                    maxy = finaly;
                    maxr = finalr;
                }

                view.x = minx+innerTick%8*(maxx-minx)/iter;
                view.y = miny+innerTick%8*(maxy-miny)/iter;
                view.rotation = minr+innerTick%8*(maxr-minr)/iter;
                trace(view.rotation);
            }
        }
    }


}
}
