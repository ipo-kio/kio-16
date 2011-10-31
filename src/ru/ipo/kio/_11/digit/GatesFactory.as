/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 21.02.11
 * Time: 16:49
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.digit {
import flash.display.BitmapData;
import flash.text.TextField;

import ru.ipo.kio.api.TextUtils;

public class GatesFactory {

    public static const TYPE_OR:int = 0;
    public static const TYPE_AND:int = 1;
    public static const TYPE_NOT:int = 2;
    public static const TYPE_NOP:int = 3;
    public static const TYPE_OUTPUT:int = 4;

    [Embed(source="resources/elements/Or_01.png")]
    private static const OR_NORMAL:Class;
    private static const OR_NORMAL_BD:BitmapData = new OR_NORMAL().bitmapData;
    [Embed(source="resources/elements/Or_02.png")]
    private static const OR_OVER:Class;
    private static const OR_OVER_BD:BitmapData = new OR_OVER().bitmapData;
    private static const OR_OFFSETS:Array = [4, 16];

    [Embed(source="resources/elements/And_01.png")]
    private static const AND_NORMAL:Class;
    private static const AND_NORMAL_BD:BitmapData = new AND_NORMAL().bitmapData;
    [Embed(source="resources/elements/And_02.png")]
    private static const AND_OVER:Class;
    private static const AND_OVER_BD:BitmapData = new AND_OVER().bitmapData;
    private static const AND_OFFSETS:Array = [4, 16];

    [Embed(source="resources/elements/Not_01.png")]
    private static const NOT_NORMAL:Class;
    private static const NOT_NORMAL_BD:BitmapData = new NOT_NORMAL().bitmapData;
    [Embed(source="resources/elements/Not_02.png")]
    private static const NOT_OVER:Class;
    private static const NOT_OVER_BD:BitmapData = new NOT_OVER().bitmapData;
    private static const NOT_OFFSETS:Array = [10];

    [Embed(source="resources/elements/Empty_01.png")]
    private static const NOP_NORMAL:Class;
    private static const NOP_NORMAL_BD:BitmapData = new NOP_NORMAL().bitmapData;
    [Embed(source="resources/elements/Empty_02.png")]
    private static const NOP_OVER:Class;
    private static const NOP_OVER_BD:BitmapData = new NOP_OVER().bitmapData;
    private static const NOP_OFFSETS:Array = [5];

    [Embed(source="resources/elements/Enter_01.png")]
    private static const OUTPUT_NORMAL:Class;
    private static const OUTPUT_NORMAL_BD:BitmapData = new OUTPUT_NORMAL().bitmapData;
    [Embed(source="resources/elements/Enter_02.png")]
    private static const OUTPUT_OVER:Class;
    private static const OUTPUT_OVER_BD:BitmapData = new OUTPUT_OVER().bitmapData;
    private static const OUTPUT_OFFSETS:Array = [9];

    public static function createGate(type:int, ind:int = -1):Gate {
        var gate:Gate = createGateWithoutIndex(type);
        if (ind >= 0 && gate) {
            var tf:TextField = TextUtils.createTextFieldWithFont("KioDigits", 13, false);
            tf.text = '' + ind;
            tf.x = (gate.width - tf.width) / 2;
            tf.y = (gate.height - tf.height) / 2 + 1;
            gate.addChild(tf);
        }
        return gate;
    }

    private static function createGateWithoutIndex(type:int):Gate {
        switch (type) {
            case TYPE_AND:
                return new Gate(type, 2, and, AND_NORMAL_BD, AND_OVER_BD, AND_OFFSETS);
            case TYPE_OR:
                return new Gate(type, 2, or, OR_NORMAL_BD, OR_OVER_BD, OR_OFFSETS);
            case TYPE_NOT:
                return new Gate(type, 1, not, NOT_NORMAL_BD, NOT_OVER_BD, NOT_OFFSETS);
            case TYPE_NOP:
                return new Gate(type, 1, nop, NOP_NORMAL_BD, NOP_OVER_BD, NOP_OFFSETS);
            case TYPE_OUTPUT:
                return new Gate(type, 1, nop, OUTPUT_NORMAL_BD, OUTPUT_OVER_BD, OUTPUT_OFFSETS);
        }
        return null;
    }

    public static function and(x:int, y:int):int {
        return x * y;
    }

    public static function or(x:int, y:int):int {
        return x + y - x * y;
    }

    public static function not(x:int):int {
        return 1 - x;
    }

    public static function nop(x:int):int {
        return x;
    }
}
}
