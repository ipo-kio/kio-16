/**
 *
 * @author: Vasily Akimushkin
 * @since: 28.02.12
 */
package ru.ipo.kio._12.train.model {
import Untitled_fla.MainTimeline;

import flash.utils.Dictionary;

import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.view.TrainView;

public class FirstLevelTrainPlacer{
    public function FirstLevelTrainPlacer() {
    }

    private static var dict:Dictionary = new Dictionary();

    private static var next:Dictionary = new Dictionary();

    private static var initial:Boolean = false;

    public static function init() {
        
        initial = true;
        dict = new Dictionary();

        dict[RailType.ROUND_TOP_RIGHT.name + "0" + "true"] = {x:11, y:35, r:-75};
        dict[RailType.ROUND_TOP_RIGHT.name + "1" + "true"] = {x:48, y:9, r:0};
        dict[RailType.ROUND_TOP_RIGHT.name + "2" + "true"] = {x:84, y:50, r:90};
        dict[RailType.ROUND_TOP_RIGHT.name + "3" + "true"] = {x:66, y:78, r:150};

        dict[RailType.ROUND_TOP_LEFT.name + "0" + "true"] = {x:27, y:77, r:-150};
        dict[RailType.ROUND_TOP_LEFT.name + "1" + "true"] = {x:10, y:47, r:-90};
        dict[RailType.ROUND_TOP_LEFT.name + "2" + "true"] = {x:27, y:15, r:-30};
        dict[RailType.ROUND_TOP_LEFT.name + "3" + "true"] = {x:70, y:19, r:45};

        dict[RailType.ROUND_BOTTOM_LEFT.name + "0" + "true"] = {x:28, y:16, r:150};
        dict[RailType.ROUND_BOTTOM_LEFT.name + "1" + "true"] = {x:12, y:58, r:75};
        dict[RailType.ROUND_BOTTOM_LEFT.name + "2" + "true"] = {x:44, y:83, r:0};
        dict[RailType.ROUND_BOTTOM_LEFT.name + "3" + "true"] = {x:77, y:68, r:-60};

        dict[RailType.ROUND_BOTTOM_RIGHT.name + "0" + "true"] = {x:14, y:64, r:60};
        dict[RailType.ROUND_BOTTOM_RIGHT.name + "1" + "true"] = {x:48, y:83, r:0};
        dict[RailType.ROUND_BOTTOM_RIGHT.name + "2" + "true"] = {x:84, y:48, r:-90};
        dict[RailType.ROUND_BOTTOM_RIGHT.name + "3" + "true"] = {x:66, y:16, r:-150};

        dict[RailType.SEMI_ROUND_BOTTOM.name + "0" + "true"] = {x:37, y:30, r:30};
        dict[RailType.SEMI_ROUND_BOTTOM.name + "1" + "true"] = {x:81, y:29, r:-45};
        dict[RailType.SEMI_ROUND_BOTTOM.name + "0" + "false"] = {x:84, y:26, r:135};
        dict[RailType.SEMI_ROUND_BOTTOM.name + "1" + "false"] = {x:35, y:28, r:-135};

        dict[RailType.SEMI_ROUND_TOP.name + "0" + "true"] = {x:29, y:23, r:-45};
        dict[RailType.SEMI_ROUND_TOP.name + "1" + "true"] = {x:84, y:19, r:45};
        dict[RailType.SEMI_ROUND_TOP.name + "0" + "false"] = {x:86, y:22, r:-135};
        dict[RailType.SEMI_ROUND_TOP.name + "1" + "false"] = {x:34, y:21, r:135};

        dict[RailType.SEMI_ROUND_LEFT.name + "0" + "true"] = {x:20, y:33, r:135};
        dict[RailType.SEMI_ROUND_LEFT.name + "1" + "true"] = {x:22, y:84, r:45};
        dict[RailType.SEMI_ROUND_LEFT.name + "0" + "false"] = {x:22, y:86, r:-135};
        dict[RailType.SEMI_ROUND_LEFT.name + "1" + "false"] = {x:19, y:36, r:-45};

        dict[RailType.SEMI_ROUND_RIGHT.name + "0" + "true"] = {x:25, y:32, r:45};
        dict[RailType.SEMI_ROUND_RIGHT.name + "1" + "true"] = {x:27, y:82, r:135};
        dict[RailType.SEMI_ROUND_RIGHT.name + "0" + "false"] = {x:24, y:85, r:-45};
        dict[RailType.SEMI_ROUND_RIGHT.name + "1" + "false"] = {x:24, y:33, r:-135};

        dict[RailType.HORIZONTAL.name + "0" + "true"] = {x:17, y:21, r:0};
        dict[RailType.HORIZONTAL.name + "0" + "false"] = {x:16, y:21, r:-180};

        dict[RailType.VERTICAL.name + "0" + "true"] = {x:21, y:19, r:90};
        dict[RailType.VERTICAL.name + "0" + "false"] = {x:21, y:16, r:-90};


        next = new Dictionary();
        //----------------------
        //Horizontal direct
        //----------------------
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:34, y:22, r:0},
            {x:53, y:22, r:0},
            {x:74, y:21, r:0}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "true"] = [
            {x:34, y:22, r:0},
            {x:53, y:22, r:0},
            {x:74, y:21, r:0}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "false"] = [
            {x:34, y:22, r:0},
            {x:53, y:22, r:0},
            {x:74, y:21, r:0}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:37, y:21, r:0},
            {x:49, y:13, r:-45},
            {x:53, y:-3, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_TOP.name + "true"] = [
            {x:37, y:21, r:0},
            {x:49, y:13, r:-45},
            {x:53, y:-3, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_TOP.name + "false"] = [
            {x:37, y:21, r:0},
            {x:49, y:13, r:-45},
            {x:53, y:-3, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:37, y:21, r:0},
            {x:49, y:13, r:-45},
            {x:53, y:-3, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:35, y:20, r:0},
            {x:51, y:26, r:45},
            {x:55, y:42, r:90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "true"] = [
            {x:35, y:20, r:0},
            {x:51, y:26, r:45},
            {x:55, y:42, r:90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "false"] = [
            {x:35, y:20, r:0},
            {x:51, y:26, r:45},
            {x:55, y:42, r:90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.ROUND_BOTTOM_RIGHT.name + "true"] = [
            {x:35, y:20, r:0},
            {x:51, y:26, r:45},
            {x:55, y:42, r:90}
        ];
        //----------------------
        //Horizontal reverse
        //----------------------
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:-1, y:21, r:-180},
            {x:-18, y:21, r:-180},
            {x:-34, y:21, r:-180}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "true"] = [
            {x:-1, y:21, r:-180},
            {x:-18, y:21, r:-180},
            {x:-34, y:21, r:-180}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "false"] = [
            {x:-1, y:21, r:-180},
            {x:-18, y:21, r:-180},
            {x:-34, y:21, r:-180}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:-1, y:21, r:-180},
            {x:-18, y:21, r:-180},
            {x:-34, y:21, r:-180}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.ROUND_TOP_LEFT.name + "true"] = [
            {x:-1, y:21, r:-180},
            {x:-18, y:21, r:-180},
            {x:-34, y:21, r:-180}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:-1, y:21, r:-180},
            {x:-13, y:16, r:-135},
            {x:-19, y:1, r:-105}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "true"] = [
            {x:-1, y:21, r:-180},
            {x:-13, y:16, r:-135},
            {x:-19, y:1, r:-105}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "false"] = [
            {x:-1, y:21, r:-180},
            {x:-13, y:16, r:-135},
            {x:-19, y:1, r:-105}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.VERTICAL.name + "true"] = [
            {x:5, y:21, r:-180},
            {x:-13, y:27, r:135},
            {x:-19, y:41, r:105}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_BOTTOM.name + "true"] = [
            {x:5, y:21, r:-180},
            {x:-13, y:27, r:135},
            {x:-19, y:41, r:105}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_BOTTOM.name + "false"] = [
            {x:5, y:21, r:-180},
            {x:-13, y:27, r:135},
            {x:-19, y:41, r:105}
        ];
        //----------------------
        //Vertical direct
        //----------------------
        next[RailType.VERTICAL.name + "0" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:17, y:21, r:90},
            {x:21, y:37, r:90},
            {x:22, y:55, r:90}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "true"] = [
            {x:17, y:21, r:-180},
            {x:21, y:37, r:90},
            {x:22, y:55, r:90}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "false"] = [
            {x:17, y:21, r:-180},
            {x:21, y:37, r:90},
            {x:22, y:55, r:90}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.ROUND_BOTTOM_RIGHT.name + "true"] = [
            {x:17, y:21, r:-180},
            {x:21, y:37, r:90},
            {x:22, y:55, r:90}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:21, y:32, r:90},
            {x:15, y:49, r:135},
            {x:2, y:53, r:180}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_LEFT.name + "true"] = [
            {x:21, y:32, r:90},
            {x:15, y:49, r:135},
            {x:2, y:53, r:180}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_LEFT.name + "false"] = [
            {x:21, y:32, r:90},
            {x:15, y:49, r:135},
            {x:2, y:53, r:180}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:21, y:32, r:90},
            {x:15, y:49, r:135},
            {x:2, y:53, r:180}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:20, y:34, r:90},
            {x:29, y:50, r:45},
            {x:40, y:52, r:15}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "true"] = [
            {x:20, y:34, r:90},
            {x:29, y:50, r:45},
            {x:40, y:52, r:15}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "false"] = [
            {x:20, y:34, r:90},
            {x:29, y:50, r:45},
            {x:40, y:52, r:15}
        ];
        //----------------------
        //Vertical reverse
        //----------------------
        next[RailType.VERTICAL.name + "0" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:21, y:-3, r:-90},
            {x:22, y:-16, r:-90},
            {x:22, y:-41, r:-90}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "true"] = [
            {x:21, y:-3, r:-90},
            {x:22, y:-16, r:-90},
            {x:22, y:-41, r:-90}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "false"] = [
            {x:21, y:-3, r:-90},
            {x:22, y:-16, r:-90},
            {x:22, y:-41, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:21, y:-3, r:-90},
            {x:22, y:-16, r:-90},
            {x:22, y:-41, r:-90}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:21, y:3, r:-90},
            {x:17, y:-15, r:-135},
            {x:9, y:-19, r:-165}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "true"] = [
            {x:21, y:3, r:-90},
            {x:17, y:-15, r:-135},
            {x:9, y:-19, r:-165}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "false"] = [
            {x:21, y:3, r:-90},
            {x:17, y:-15, r:-135},
            {x:9, y:-19, r:-165}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.ROUND_TOP_LEFT.name + "true"] = [
            {x:21, y:3, r:-90},
            {x:17, y:-15, r:-135},
            {x:9, y:-19, r:-165}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.HORIZONTAL.name + "true"] = [
            {x:22, y:1, r:-90},
             {x:29, y:-15, r:-45},
             {x:45, y:-20, r:-15}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_RIGHT.name + "true"] = [
            {x:22, y:1, r:-90},
            {x:29, y:-15, r:-45},
            {x:45, y:-20, r:-15}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_RIGHT.name + "false"] = [
            {x:22, y:1, r:-90},
            {x:29, y:-15, r:-45},
            {x:45, y:-20, r:-15}
        ];

        //----------------------
        //Top
        //----------------------
        next[RailType.SEMI_ROUND_TOP.name + "0" + "true" + RailType.SEMI_ROUND_TOP.name + "true"] = [
            {x:38, y:17, r:-30},
            {x:60, y:9, r:0},
            {x:86, y:22, r:30}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "false"] = [
            {x:86, y:21, r:-135},
            {x:60, y:9, r:-180},
            {x:29, y:23, r:120}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:96, y:38, r:90},
             {x:97, y:60, r:90},
             {x:97, y:73, r:90}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "false" + RailType.VERTICAL.name + "true"] = [
            {x:23, y:38, r:90},
            {x:21, y:52, r:90},
            {x:22, y:67, r:90}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:96, y:40, r:90},
            {x:104, y:57, r:45},
            {x:118, y:63, r:0}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "false" + RailType.HORIZONTAL.name + "true"] = [
            {x:23, y:45, r:90},
             {x:28, y:57, r:45},
             {x:41, y:61, r:0}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:97, y:43, r:90},
            {x:90, y:57, r:135},
            {x:77, y:62, r:165}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:22, y:42, r:90},
            {x:18, y:58, r:150},
            {x:7, y:63, r:180}
        ];
        //----------------------
        //Bottom
        //----------------------
        next[RailType.SEMI_ROUND_BOTTOM.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "true"] = [
            {x:32, y:25, r:45},
            {x:60, y:37, r:0},
            {x:88, y:21, r:-45}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "0" + "false" + RailType.SEMI_ROUND_BOTTOM.name + "false"] = [
            {x:87, y:24, r:135},
            {x:61, y:36, r:180},
            {x:32, y:25, r:-135}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:95, y:3, r:-90},
            {x:95, y:-17, r:-90},
            {x:97, y:-40, r:-90}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:21, y:5, r:-90},
            {x:21, y:-14, r:-90},
            {x:21, y:-30, r:-90}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:97, y:5, r:-90},
            {x:104, y:-15, r:-45},
            {x:130, y:-20, r:0}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "false" + RailType.HORIZONTAL.name + "true"] = [
            {x:24, y:5, r:-90},
            {x:29, y:-12, r:-45},
            {x:47, y:-20, r:0}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:96, y:2, r:-90},
            {x:88, y:-17, r:-150},
            {x:77, y:-21, r:180}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:23, y:-5, r:-90},
            {x:14, y:-14, r:-150},
            {x:5, y:-18, r:165}
        ];
        //----------------------
        //Left
        //----------------------
        next[RailType.SEMI_ROUND_LEFT.name + "0" + "true" + RailType.SEMI_ROUND_LEFT.name + "true"] = [
            {x:13, y:42, r:120},
            {x:9, y:58, r:90},
             {x:25, y:86, r:45}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "false"] = [
            {x:25, y:89, r:-150},
            {x:10, y:59, r:-90},
             {x:25, y:27, r:-45}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:45, y:95, r:0},
            {x:63, y:95, r:0},
            {x:77, y:96, r:0}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "false" + RailType.HORIZONTAL.name + "true"] = [
            {x:41, y:21, r:0},
            {x:61, y:19, r:0},
            {x:74, y:21, r:0}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:43, y:95, r:0},
            {x:59, y:99, r:45},
            {x:64, y:114, r:90}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "false" + RailType.VERTICAL.name + "true"] = [
            {x:46, y:23, r:0},
            {x:59, y:26, r:45},
            {x:64, y:41, r:90}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:41, y:93, r:0},
            {x:58, y:91, r:-45},
            {x:63, y:77, r:-90}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:48, y:21, r:0},
            {x:64, y:15, r:-30},
            {x:62, y:5, r:-75}
        ];
        //----------------------
        //Right
        //----------------------
        next[RailType.SEMI_ROUND_RIGHT.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "true"] = [
            {x:30, y:39, r:60},
            {x:37, y:58, r:90},
            {x:24, y:86, r:135}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "0" + "false" + RailType.SEMI_ROUND_RIGHT.name + "false"] = [
            {x:25, y:86, r:-45},
            {x:36, y:58, r:-90},
            {x:28, y:32, r:-120}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:2, y:96, r:-180},
            {x:-19, y:96, r:-180},
            {x:-37, y:95, r:-180}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:0, y:21, r:-180},
            {x:-22, y:20, r:-180},
            {x:-34, y:20, r:-180}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:-1, y:21, r:-180},
            {x:-15, y:28, r:135},
            {x:-19, y:36, r:90}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "false" + RailType.VERTICAL.name + "true"] = [
            {x:3, y:93, r:180},
            {x:-15, y:103, r:135},
            {x:-20, y:116, r:90}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:-5, y:22, r:180},
            {x:-16, y:14, r:-135},
            {x:-21, y:1, r:-90}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:5, y:95, r:-180},
            {x:-14, y:92, r:-135},
            {x:-20, y:78, r:-90}
        ];


        next[RailType.ROUND_TOP_RIGHT.name + "0" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:17, y:26, r:-60},
            {x:24, y:19, r:-45},
            {x:35, y:12, r:-30}
        ];
        next[RailType.ROUND_TOP_RIGHT.name + "1" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:66, y:15, r:30},
            {x:75, y:23, r:45},
            {x:83, y:37, r:60}
        ];
        next[RailType.ROUND_TOP_RIGHT.name + "2" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:82, y:62, r:105},
            {x:74, y:74, r:135},
            {x:61, y:81, r:165}
        ];
        next[RailType.ROUND_TOP_RIGHT.name + "3" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:31, y:84, r:180},
            {x:16, y:88, r:135},
            {x:11, y:111, r:90}
        ];
        next[RailType.ROUND_TOP_RIGHT.name + "3" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:32, y:85, r:180},
            {x:15, y:85, r:180},
            {x:2, y:85, r:180}
        ];


        next[RailType.ROUND_BOTTOM_LEFT.name + "0" + "true" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:20, y:22, r:120},
            {x:13, y:30, r:105},
            {x:12, y:36, r:90}
        ];
        next[RailType.ROUND_BOTTOM_LEFT.name + "1" + "true" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:10, y:50, r:75},
            {x:16, y:64, r:60},
            {x:27, y:76, r:45}
        ];
        next[RailType.ROUND_BOTTOM_LEFT.name + "2" + "true" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:57, y:82, r:-15},
            {x:73, y:71, r:-30},
            {x:81, y:63, r:-60}
        ];
        next[RailType.ROUND_BOTTOM_LEFT.name + "3" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:84, y:42, r:-90},
            {x:83, y:16, r:-90},
            {x:84, y:-11, r:-90}
        ];
        next[RailType.ROUND_BOTTOM_LEFT.name + "3" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:85, y:36, r:-90},
            {x:89, y:18, r:-60},
            {x:104, y:12, r:-15}
        ];



        next[RailType.ROUND_BOTTOM_RIGHT.name + "0" + "true" + RailType.ROUND_BOTTOM_RIGHT.name + "true"] = [
            {x:24, y:75, r:45},
            {x:32, y:79, r:15},
            {x:45, y:82, r:0}
        ];
        next[RailType.ROUND_BOTTOM_RIGHT.name + "1" + "true" + RailType.ROUND_BOTTOM_RIGHT.name + "true"] = [
            {x:67, y:79, r:0},
            {x:75, y:73, r:-45},
            {x:81, y:63, r:-60}
        ];
        next[RailType.ROUND_BOTTOM_RIGHT.name + "2" + "true" + RailType.ROUND_BOTTOM_RIGHT.name + "true"] = [
            {x:84, y:36, r:-105},
            {x:76, y:22, r:-135},
            {x:63, y:16, r:-150}
        ];
        next[RailType.ROUND_BOTTOM_RIGHT.name + "3" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:32, y:10, r:-180},
            {x:15, y:1, r:-120},
            {x:9, y:-17, r:-90}
        ];
        next[RailType.ROUND_BOTTOM_RIGHT.name + "3" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:34, y:9, r:-180},
            {x:11, y:8, r:-180},
            {x:-5, y:8, r:-180}
        ];



        next[RailType.ROUND_TOP_LEFT.name + "0" + "true" + RailType.ROUND_TOP_LEFT.name + "true"] = [
            {x:22, y:75, r:-135},
            {x:16, y:67, r:-120},
            {x:11, y:54, r:-105}
        ];
        next[RailType.ROUND_TOP_LEFT.name + "1" + "true" + RailType.ROUND_TOP_LEFT.name + "true"] = [
            {x:11, y:41, r:-90},
            {x:12, y:31, r:-75},
            {x:19, y:24, r:-45}
        ];
        next[RailType.ROUND_TOP_LEFT.name + "2" + "true" + RailType.ROUND_TOP_LEFT.name + "true"] = [
            {x:78, y:30, r:60},
            {x:81, y:37, r:75},
            {x:84, y:43, r:90}
        ];
        next[RailType.ROUND_TOP_LEFT.name + "3" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:84, y:65, r:90},
            {x:85, y:84, r:90},
            {x:86, y:98, r:90}
        ];
        next[RailType.ROUND_TOP_LEFT.name + "3" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:84, y:57, r:90},
            {x:91, y:79, r:45},
            {x:102, y:82, r:0}
        ];




    }


    public static function place(train:Train, view:TrainView, width:int, height:int) {
        if(!initial){
            init();
        }
        var tick:int = train.tick;
        var innerTick:int = TrafficNetwork.instance.inner;
        var nextRail:Rail = train.getNextRail();

        var obj:Object = dict[train.rail.type.name + String(train.tick) + train.isDirect()];
        
        if(obj == null)
            return;

        view.rotation = obj.r;
        view.x += obj.x;
        view.y += obj.y;

        if (nextRail != null) {
            var arr:Array = null;
            var nxt:Object = null;

            if (nextRail == train.rail) {
                arr = next[train.rail.type.name + String(train.tick) + train.isDirect() + train.rail.type.name + train.isDirect()];
                nxt = dict[train.rail.type.name + String(train.tick + 1) + train.isDirect()];
            }
            else {
                var dir:Boolean = nextRail.firstEnd.isConnected(train.rail);
                if(train.rail.firstEnd.connectedE(nextRail.firstEnd) && train.rail.secondEnd.connectedE(nextRail.secondEnd)){
                    dir = !train.isDirect();
                }
                arr = next[train.rail.type.name + String(train.tick) + train.isDirect() + nextRail.type.name + dir];
                nxt = dict[nextRail.type.name + String(0) + dir];
            }

            var iter:int = 8;

            if (nxt != null && arr != null) {
                var finalx:int = nextRail.view.x + nxt.x;
                var finaly:int = nextRail.view.y + nxt.y;
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

                if (innerTick >= 0 && innerTick < 8) {
                    minx = inx;
                    miny = iny;
                    minr = inr;
                    maxx = clx + arr[0].x;
                    maxy = cly + arr[0].y;
                    maxr = (arr[0].r);
                } else if (innerTick >= 8 && innerTick < 16) {
                    minx = clx + arr[0].x;
                    miny = cly + arr[0].y;
                    minr = (arr[0].r);
                    maxx = clx + arr[1].x;
                    maxy = cly + arr[1].y;
                    maxr = (arr[1].r);
                } else if (innerTick >= 16 && innerTick < 24) {
                    minx = clx + arr[1].x;
                    miny = cly + arr[1].y;
                    minr = (arr[1].r);
                    maxx = clx + arr[2].x;
                    maxy = cly + arr[2].y;
                    maxr = (arr[2].r);
                } else if (innerTick >= 24 && innerTick < 32) {
                    minx = clx + arr[2].x;
                    miny = cly + arr[2].y;
                    minr = (arr[2].r);
                    maxx = finalx;
                    maxy = finaly;
                    maxr = finalr;
                }

                var o:Object = preprocess(minr, maxr);
                minr = o.a;
                maxr = o.b;


                view.x = minx + innerTick % 8 * (maxx - minx) / iter;
                view.y = miny + innerTick % 8 * (maxy - miny) / iter;
                view.rotation = minr + innerTick % 8 * (maxr - minr) / iter;
            }
        }
    }

    public static function preprocess(a:int,b:int):Object{
        var d_fi:int =   a-b;
        while (d_fi < -90) {a += 360; d_fi += 360}
        while (d_fi > 90) {b += 360; d_fi -= 360}
        return {a:a, b:b};

    }


}
}
