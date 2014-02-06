/**
 * Created by ilya on 14.01.14.
 */
package ru.ipo.kio._14.peterhof.view {
import away3d.containers.ObjectContainer3D;
import away3d.materials.ColorMaterial;
import away3d.primitives.CylinderGeometry;
import away3d.primitives.LineSegment;

import flash.geom.Vector3D;

import flash.utils.Dictionary;

import away3d.entities.Mesh;
import away3d.materials.MaterialBase;
import away3d.materials.TextureMaterial;
import away3d.utils.Cast;

import ru.ipo.kio._14.peterhof.model.Consts;
import ru.ipo.kio._14.peterhof.model.Fountain;
import ru.ipo.kio._14.peterhof.model.FountainEvent;
import ru.ipo.kio._14.peterhof.model.Hill;

public class HillView extends ObjectContainer3D {

    [Embed(source="../resources/hill_texture_old.jpg")]
    public static var FloorDiffuse:Class;

    [Embed(source="../resources/sky_texture.jpg")]
    public static var SkyTexture:Class;

    private var _fountains:Dictionary = new Dictionary(); //Fountain -> FountainView
    private var _selected_fountain:Fountain = null;

    private var _mouse_over_fountain:FountainView = null;

    private var _hill:Hill;

    private var close_segments:ObjectContainer3D = new ObjectContainer3D();
//    private var close_segments:SegmentSet = new SegmentSet();

    public function HillView(hill:Hill) {
        _hill = hill;

        draw();

        hill.addEventListener(FountainEvent.ADDED, fountainAdded);
        hill.addEventListener(FountainEvent.REMOVED, fountainRemoved);

        for each (var fountain:Fountain in hill.fountains)
            addFountain(fountain);

        addChild(close_segments);
        _hill.addEventListener(FountainEvent.CHANGED, hillChanged);
        hillChanged(null);
    }

    private function hillChanged(event:FountainEvent):void {
//        close_segments.removeAllSegments();
        while (close_segments.numChildren > 0)
            close_segments.removeChildAt(0);

        for each (var a:Array in hill.close_fountains) {
            var f1:Fountain = a[0];
            var f2:Fountain = a[1];
            var dist:Number = a[2];

            var s:LineSegment = new LineSegment(
                    new Vector3D(f1.x * Consts.PIXELS_IN_METER, 30 + f1.y * Consts.PIXELS_IN_METER, f1.z * Consts.PIXELS_IN_METER, 1),
                    new Vector3D(f2.x * Consts.PIXELS_IN_METER, 30 + f2.y * Consts.PIXELS_IN_METER, f2.z * Consts.PIXELS_IN_METER, 1),
                    0xFF0000,
                    0xFFFF00,
                    1
            );

//            close_segments.addSegment(s);

            var line:Mesh = new Mesh(new CylinderGeometry(0.5, 0.5, 2 * dist, 4, 1), new ColorMaterial(0xff0000));

//            line.rotationZ = 90;
//            var m:Matrix3D = line.transform;
//            line.rotationZ = 0;
//            line.rotateTo(f1.x - f2.x, f1.y - f2.y, f1.z - f2.z);
//            line.transform.append(m);
//            line.transform = line.transform;
            rotateLineTo(line, new Vector3D(f2.x - f1.x, f2.y - f1.y, f2.z - f1.z));

            line.x = (f1.x + f2.x) / 2 * Consts.PIXELS_IN_METER;
            line.y = (f1.y + f2.y) / 2 * Consts.PIXELS_IN_METER;
            line.z = (f1.z + f2.z) / 2 * Consts.PIXELS_IN_METER;

            close_segments.addChild(line);
        }
    }

    private static function rotateLineTo(line:Mesh, dir:Vector3D):void {
        if (dir.x == 0 && dir.y == 0 && dir.z == 0)
            return;

        var pr_xz:Vector3D = new Vector3D(dir.x, 0, dir.z);
        var rot:Vector3D = pr_xz.crossProduct(dir);
        var sin_alf:Number = rot.length / (pr_xz.length * dir.length);
        var alf:Number = Math.asin(sin_alf);

        var phi:Number = Math.atan2(dir.z, dir.x);

        line.yaw(-phi * 180 / Math.PI);
        if (dir.y < 0)
            line.roll(90 - alf * 180 / Math.PI);
        else
            line.roll(alf * 180 / Math.PI - 90);
    }

    private function addFountain(fountain:Fountain):void {
        var view:FountainView = new FountainView(fountain, this);
        _fountains[fountain] = view;
        addChild(view);

        view.addEventListener(FountainEvent.SELECTION_CHANGED, fountainSelectionChanged);
    }

    private function removeFountain(fountain:Fountain):void {
        var view:FountainView = _fountains[fountain];
        removeChild(view);
        view.removeEventListener(FountainEvent.SELECTION_CHANGED, fountainSelectionChanged);
    }

    private function fountainAdded(event:FountainEvent):void {
        addFountain(event.fountain);
    }

    private function fountainRemoved(event:FountainEvent):void {
        removeFountain(event.fountain);
    }

    private function fountainSelectionChanged(event:FountainEvent):void {
        if (_selected_fountain != null) {
            var view:FountainView = _fountains[_selected_fountain];
            view.selected = false;
        }

        _selected_fountain = event.fountain;

        dispatchEvent(new FountainEvent(FountainEvent.SELECTION_CHANGED, _selected_fountain));
    }

    private function draw():void {
        var material:MaterialBase = new TextureMaterial(Cast.bitmapTexture(FloorDiffuse));
        var _plane:Mesh = new Mesh(new HillGeometry(25, Consts.HILL_LENGTH1, Consts.HILL_LENGTH2, Consts.HILL_WIDTH, Consts.HILL_HEIGHT, 10), material);

//        var sun:DirectionalLight = new DirectionalLight(-1, -1, 0);

        addChild(_plane);
//        scene.addChild(sun);
    }

    public function get selected_fountain():Fountain {
        return _selected_fountain;
    }

    public function get fountains():Dictionary {
        return _fountains;
    }

    public function get mouse_over_fountain():FountainView {
        return _mouse_over_fountain;
    }

    public function set mouse_over_fountain(value:FountainView):void {
        _mouse_over_fountain = value;
    }

    public function get hill():Hill {
        return _hill;
    }
}
}
