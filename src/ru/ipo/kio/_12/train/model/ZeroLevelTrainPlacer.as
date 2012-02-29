/**
 *
 * @author: Vasily Akimushkin
 * @since: 28.02.12
 */
package ru.ipo.kio._12.train.model {
import Untitled_fla.MainTimeline;

import flash.utils.Dictionary;

import ru.ipo.kio._11_students.CrossedCountry.landscape;

import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.view.TrainView;

public class ZeroLevelTrainPlacer {
    public function ZeroLevelTrainPlacer() {
    }

    private static var dict:Dictionary = new Dictionary();

    private static var next:Dictionary = new Dictionary();

    public static function init() {
        dict = new Dictionary();

        dict[RailType.ROUND_TOP_RIGHT.name + "0" + "true"] = {x:30, y:48, r:-75};
        dict[RailType.ROUND_TOP_RIGHT.name + "1" + "true"] = {x:82, y:10, r:0};
        dict[RailType.ROUND_TOP_RIGHT.name + "2" + "true"] = {x:128, y:69, r:105};
        dict[RailType.ROUND_TOP_RIGHT.name + "3" + "true"] = {x:91, y:107, r:165};

        dict[RailType.ROUND_BOTTOM_LEFT.name + "0" + "true"] = {x:45, y:31, r:165};
        dict[RailType.ROUND_BOTTOM_LEFT.name + "1" + "true"] = {x:5, y:80, r:90};
        dict[RailType.ROUND_BOTTOM_LEFT.name + "2" + "true"] = {x:73, y:130, r:-15};
        dict[RailType.ROUND_BOTTOM_LEFT.name + "3" + "true"] = {x:111, y:79, r:-90};

        dict[RailType.SEMI_ROUND_BOTTOM.name + "0" + "true"] = {x:36, y:34, r:60};
        dict[RailType.SEMI_ROUND_BOTTOM.name + "1" + "true"] = {x:124, y:31, r:-60};
        dict[RailType.SEMI_ROUND_BOTTOM.name + "0" + "false"] = {x:125, y:28, r:120};
        dict[RailType.SEMI_ROUND_BOTTOM.name + "1" + "false"] = {x:34, y:32, r:-120};

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
        dict[RailType.HORIZONTAL.name + "0" + "false"] = {x:31, y:25, r:180};

        dict[RailType.VERTICAL.name + "0" + "true"] = {x:26, y:30, r:90};
        dict[RailType.VERTICAL.name + "0" + "false"] = {x:26, y:30, r:-90};


        next = new Dictionary();
        //----------------------
        //Horizontal direct
        //----------------------
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:53, y:25, r:0},
            {x:82, y:26, r:0},
            {x:111, y:26, r:0}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "true"] = [
            {x:51, y:25, r:0},
            {x:82, y:26, r:0},
            {x:109, y:24, r:0}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "false"] = [
            {x:51, y:25, r:0},
            {x:82, y:26, r:0},
            {x:109, y:24, r:0}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:56, y:26, r:0},
            {x:74, y:18, r:-45},
            {x:81, y:-2, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_TOP.name + "true"] = [
            {x:56, y:26, r:0},
            {x:74, y:18, r:-45},
            {x:81, y:-2, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_TOP.name + "false"] = [
            {x:56, y:26, r:0},
            {x:74, y:18, r:-45},
            {x:81, y:-2, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:56, y:26, r:0},
            {x:74, y:18, r:-45},
            {x:81, y:-2, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:50, y:25, r:0},
            {x:72, y:33, r:45},
            {x:83, y:49, r:90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "true"] = [
            {x:50, y:25, r:0},
            {x:72, y:33, r:45},
            {x:83, y:49, r:90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "false"] = [
            {x:50, y:25, r:0},
            {x:72, y:33, r:45},
            {x:83, y:49, r:90}
        ];
        //----------------------
        //Horizontal reverse
        //----------------------
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:10, y:25, r:180},
            {x:-20, y:25, r:180},
            {x:-41, y:26, r:180}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "true"] = [
            {x:10, y:25, r:180},
            {x:-20, y:25, r:180},
            {x:-41, y:26, r:180}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "false"] = [
            {x:10, y:25, r:180},
            {x:-20, y:25, r:180},
            {x:-41, y:26, r:180}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:10, y:25, r:180},
            {x:-20, y:25, r:180},
            {x:-41, y:26, r:180}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:5, y:25, r:180},
            {x:-16, y:16, r:-135},
            {x:-26, y:-1, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "true"] = [
            {x:5, y:25, r:180},
            {x:-16, y:16, r:-135},
            {x:-26, y:-1, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "false"] = [
            {x:5, y:25, r:180},
            {x:-16, y:16, r:-135},
            {x:-26, y:-1, r:-90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.VERTICAL.name + "true"] = [
            {x:10, y:25, r:180},
            {x:-15, y:33, r:135},
            {x:-25, y:48, r:90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_BOTTOM.name + "true"] = [
            {x:10, y:25, r:180},
            {x:-15, y:33, r:135},
            {x:-25, y:48, r:90}
        ];
        next[RailType.HORIZONTAL.name + "0" + "false" + RailType.SEMI_ROUND_BOTTOM.name + "false"] = [
            {x:10, y:25, r:180},
            {x:-15, y:33, r:135},
            {x:-25, y:48, r:90}
        ];
        //----------------------
        //Vertical direct
        //----------------------
        next[RailType.VERTICAL.name + "0" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:26, y:48, r:90},
            {x:27, y:78, r:90},
            {x:26, y:99, r:90}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "true"] = [
            {x:26, y:48, r:90},
            {x:27, y:78, r:90},
            {x:26, y:99, r:90}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "false"] = [
            {x:26, y:48, r:90},
            {x:27, y:78, r:90},
            {x:26, y:99, r:90}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:26, y:44, r:90},
            {x:15, y:66, r:135},
            {x:1, y:78, r:180}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_LEFT.name + "true"] = [
            {x:26, y:44, r:90},
            {x:15, y:66, r:135},
            {x:1, y:78, r:180}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_LEFT.name + "false"] = [
            {x:26, y:44, r:90},
            {x:15, y:66, r:135},
            {x:1, y:78, r:180}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:26, y:44, r:90},
            {x:15, y:66, r:135},
            {x:1, y:78, r:180}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:27, y:48, r:90},
            {x:35, y:69, r:45},
            {x:55, y:79, r:0}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "true"] = [
            {x:27, y:48, r:90},
            {x:35, y:69, r:45},
            {x:55, y:79, r:0}
        ];
        next[RailType.VERTICAL.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "false"] = [
            {x:27, y:48, r:90},
            {x:35, y:69, r:45},
            {x:55, y:79, r:0}
        ];
        //----------------------
        //Vertical reverse
        //----------------------
        next[RailType.VERTICAL.name + "0" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:25, y:10, r:-90},
            {x:26, y:-22, r:-90},
            {x:25, y:-44, r:-90}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "true"] = [
            {x:25, y:10, r:-90},
            {x:26, y:-22, r:-90},
            {x:25, y:-44, r:-90}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "false"] = [
            {x:25, y:10, r:-90},
            {x:26, y:-22, r:-90},
            {x:25, y:-44, r:-90}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:25, y:8, r:-90},
            {x:19, y:-14, r:-135},
            {x:-2, y:-24, r:-180}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "true"] = [
            {x:25, y:8, r:-90},
            {x:19, y:-14, r:-135},
            {x:-2, y:-24, r:-180}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "false"] = [
            {x:25, y:8, r:-90},
            {x:19, y:-14, r:-135},
            {x:-2, y:-24, r:-180}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.HORIZONTAL.name + "true"] = [
            {x:24, y:8, r:-90},
            {x:33, y:-13, r:-45},
            {x:54, y:-25, r:0}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_RIGHT.name + "true"] = [
            {x:24, y:8, r:-90},
            {x:33, y:-13, r:-45},
            {x:54, y:-25, r:0}
        ];
        next[RailType.VERTICAL.name + "0" + "false" + RailType.SEMI_ROUND_RIGHT.name + "false"] = [
            {x:24, y:8, r:-90},
            {x:33, y:-13, r:-45},
            {x:54, y:-25, r:0}
        ];
        next[RailType.HORIZONTAL.name + "0" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:24, y:8, r:-90},
            {x:33, y:-13, r:-45},
            {x:54, y:-25, r:0}
        ];
        //----------------------
        //Top
        //----------------------
        next[RailType.SEMI_ROUND_TOP.name + "0" + "true" + RailType.SEMI_ROUND_TOP.name + "true"] = [
            {x:52, y:14, r:-30},
            {x:78, y:7, r:0},
            {x:105, y:14, r:30}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "0" + "false" + RailType.SEMI_ROUND_TOP.name + "false"] = [
            {x:105, y:14, r:-150},
            {x:78, y:6, r:180},
            {x:47, y:17, r:150}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:131, y:48, r:90},
            {x:133, y:70, r:90},
            {x:133, y:92, r:90}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "false" + RailType.VERTICAL.name + "true"] = [
            {x:27, y:49, r:90},
            {x:27, y:76, r:90},
            {x:26, y:100, r:90}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:130, y:47, r:90},
            {x:141, y:66, r:45},
            {x:155, y:74, r:0}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "false" + RailType.HORIZONTAL.name + "true"] = [
            {x:26, y:46, r:90},
            {x:35, y:66, r:45},
            {x:55, y:75, r:0}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:130, y:47, r:90},
            {x:121, y:64, r:135},
            {x:103, y:73, r:180}
        ];
        next[RailType.SEMI_ROUND_TOP.name + "1" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:26, y:46, r:90},
            {x:17, y:66, r:150},
            {x:0, y:74, r:-180}
        ];
        //----------------------
        //Bottom
        //----------------------
        next[RailType.SEMI_ROUND_BOTTOM.name + "0" + "true" + RailType.SEMI_ROUND_BOTTOM.name + "true"] = [
            {x:50, y:52, r:30},
            {x:74, y:58, r:0},
            {x:111, y:47, r:-30}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "0" + "false" + RailType.SEMI_ROUND_BOTTOM.name + "false"] = [
            {x:113, y:47, r:135},
            {x:81, y:59, r:180},
            {x:51, y:51, r:-150}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:132, y:3, r:-90},
            {x:132, y:-25, r:-90},
            {x:131, y:-49, r:-90}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:27, y:4, r:-90},
            {x:27, y:-27, r:-90},
            {x:27, y:-60, r:-90}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:133, y:9, r:-90},
            {x:142, y:-15, r:-45},
            {x:166, y:-24, r:0}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "false" + RailType.HORIZONTAL.name + "true"] = [
            {x:27, y:9, r:-90},
            {x:36, y:-19, r:-45},
            {x:57, y:-23, r:0}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:134, y:5, r:-90},
            {x:124, y:-14, r:-135},
            {x:104, y:-22, r:-180}
        ];
        next[RailType.SEMI_ROUND_BOTTOM.name + "1" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:27, y:6, r:-90},
            {x:12, y:-16, r:-135},
            {x:-6, y:-22, r:-180}
        ];
        //----------------------
        //Left
        //----------------------
        next[RailType.SEMI_ROUND_LEFT.name + "0" + "true" + RailType.SEMI_ROUND_LEFT.name + "true"] = [
            {x:11, y:55, r:120},
            {x:6, y:74, r:90},
            {x:10, y:100, r:60}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "0" + "false" + RailType.SEMI_ROUND_LEFT.name + "false"] = [
            {x:12, y:104, r:-120},
            {x:5, y:80, r:-90},
            {x:12, y:52, r:-60}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:49, y:130, r:0},
            {x:75, y:130, r:0},
            {x:100, y:130, r:0}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "false" + RailType.HORIZONTAL.name + "true"] = [
            {x:52, y:26, r:0},
            {x:73, y:24, r:0},
            {x:104, y:27, r:0}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:52, y:134, r:0},
            {x:69, y:141, r:45},
            {x:77, y:163, r:90}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "false" + RailType.VERTICAL.name + "true"] = [
            {x:52, y:27, r:0},
            {x:68, y:33, r:45},
            {x:75, y:55, r:90}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:49, y:133, r:0},
            {x:65, y:125, r:-45},
            {x:73, y:98, r:-90}
        ];
        next[RailType.SEMI_ROUND_LEFT.name + "1" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:49, y:28, r:0},
            {x:68, y:16, r:-45},
            {x:74, y:-5, r:-90}
        ];
        //----------------------
        //Right
        //----------------------
        next[RailType.SEMI_ROUND_RIGHT.name + "0" + "true" + RailType.SEMI_ROUND_RIGHT.name + "true"] = [
            {x:45, y:46, r:45},
            {x:56, y:80, r:90},
            {x:43, y:113, r:135}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "0" + "false" + RailType.SEMI_ROUND_RIGHT.name + "false"] = [
            {x:46, y:114, r:-45},
            {x:58, y:88, r:-90},
            {x:48, y:47, r:-135}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:5, y:131, r:180},
            {x:-21, y:133, r:180},
            {x:-39, y:132, r:180}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "false" + RailType.HORIZONTAL.name + "false"] = [
            {x:8, y:26, r:180},
            {x:-21, y:26, r:180},
            {x:-42, y:26, r:180}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:13, y:134, r:180},
            {x:-13, y:140, r:135},
            {x:-24, y:162, r:90}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "false" + RailType.VERTICAL.name + "true"] = [
            {x:7, y:28, r:180},
            {x:-13, y:35, r:135},
            {x:-23, y:56, r:90}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:15, y:128, r:-180},
            {x:-14, y:122, r:-135},
            {x:-22, y:99, r:-90}
        ];
        next[RailType.SEMI_ROUND_RIGHT.name + "1" + "false" + RailType.VERTICAL.name + "false"] = [
            {x:11, y:28, r:-180},
            {x:-16, y:15, r:-135},
            {x:-24, y:-11, r:-90}
        ];


        next[RailType.ROUND_TOP_RIGHT.name + "0" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:35, y:34, r:-60},
            {x:45, y:20, r:-45},
            {x:61, y:13, r:-30}
        ];
        next[RailType.ROUND_TOP_RIGHT.name + "1" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:102, y:13, r:15},
            {x:118, y:24, r:45},
            {x:124, y:33, r:60}
        ];
        next[RailType.ROUND_TOP_RIGHT.name + "2" + "true" + RailType.ROUND_TOP_RIGHT.name + "true"] = [
            {x:130, y:75, r:105},
            {x:123, y:89, r:120},
            {x:107, y:100, r:150}
        ];
        next[RailType.ROUND_TOP_RIGHT.name + "3" + "true" + RailType.VERTICAL.name + "true"] = [
            {x:60, y:111, r:180},
            {x:39, y:122, r:135},
            {x:27, y:140, r:90}
        ];
        next[RailType.ROUND_TOP_RIGHT.name + "3" + "true" + RailType.HORIZONTAL.name + "false"] = [
            {x:61, y:113, r:180},
            {x:32, y:112, r:180},
            {x:12, y:112, r:180}
        ];


        next[RailType.ROUND_BOTTOM_LEFT.name + "0" + "true" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:27, y:37, r:150},
            {x:14, y:51, r:120},
            {x:8, y:63, r:105}
        ];
        next[RailType.ROUND_BOTTOM_LEFT.name + "1" + "true" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:15, y:109, r:60},
            {x:23, y:117, r:45},
            {x:31, y:126, r:30}
        ];
        next[RailType.ROUND_BOTTOM_LEFT.name + "2" + "true" + RailType.ROUND_BOTTOM_LEFT.name + "true"] = [
            {x:81, y:129, r:-15},
            {x:100, y:114, r:-45},
            {x:107, y:104, r:-60}
        ];
        next[RailType.ROUND_BOTTOM_LEFT.name + "3" + "true" + RailType.VERTICAL.name + "false"] = [
            {x:114, y:70, r:-90},
            {x:113, y:35, r:-90},
            {x:111, y:9, r:-90}
        ];
        next[RailType.ROUND_BOTTOM_LEFT.name + "3" + "true" + RailType.HORIZONTAL.name + "true"] = [
            {x:111, y:72, r:-90},
            {x:119, y:38, r:-45},
            {x:140, y:28, r:0}
        ];



        
    }


    public static function place(train:Train, view:TrainView, width:int, height:int) {
        init();
        var tick:int = train.tick;
        var innerTick:int = TrafficNetwork.instance.inner;
        var nextRail:Rail = train.getNextRail();

        var obj:Object = dict[train.rail.type.name + String(train.tick) + train.isDirect()];
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
