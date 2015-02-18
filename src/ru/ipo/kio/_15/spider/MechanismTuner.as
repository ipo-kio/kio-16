/**
 * Created by ilya on 18.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

public class MechanismTuner extends Sprite {

    private var _m:Mechanism;
    public static const MUL:Number = 3;

    private var s:Vector.<Stick> = new <Stick>[
        null,
        new Stick(0xFFB86F),
        new Stick(0x73CC81),
        new Stick(0xDAE871),
        new Stick(0x483A58),
        new Stick(0x56203D),
        new Stick(0xE0BAD7),
        new Stick(0xD30C7B)
    ];

    public function MechanismTuner(m:Mechanism) {
        _m = m;

        _m.addEventListener(Mechanism.EVENT_ANGLE_CHANGED, function (e:Event):void {
            positionSticks();
        });

        for (var i:int = 1; i < s.length; i++)
            addChild(s[i]);

        positionSticks();

        graphics.lineStyle(2, 0xA5A5A5);
        graphics.beginFill(0xE8E8E8);
        graphics.drawTriangles(new <Number>[
                m.p1_p.x * MUL,
                m.p1_p.y * MUL,
                m.p2_p.x * MUL,
                m.p2_p.y * MUL,
                m.p3_p.x * MUL,
                m.p3_p.y * MUL
        ]);
        graphics.endFill();
    }

    private static function positionStick(s:Stick, p1:Point, p2:Point):void {
        s.setCoordinates(p1.x * MUL, p1.y * MUL, p2.x * MUL, p2.y * MUL);
    }

    private function positionSticks():void {
        positionStick(s[1], _m.p1_p, _m.m_p);
        positionStick(s[2], _m.m_p, _m.n_p);
        positionStick(s[3], _m.n_p, _m.p2_p);
        positionStick(s[4], _m.n_p, _m.k_p);
        positionStick(s[5], _m.l_p, _m.k_p);
        positionStick(s[6], _m.p3_p, _m.l_p);
        positionStick(s[7], _m.k_p, _m.s_p);
    }
}
}
