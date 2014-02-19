/**
 * Created by ilya on 19.01.14.
 */
package ru.ipo.kio._14.peterhof.view {

import away3d.containers.ObjectContainer3D;
import away3d.core.pick.PickingColliderType;
import away3d.entities.Mesh;
import away3d.entities.Sprite3D;
import away3d.events.MouseEvent3D;
import away3d.materials.ColorMaterial;
import away3d.primitives.CylinderGeometry;

import flash.events.Event;
import flash.geom.Matrix3D;

import ru.ipo.kio._14.peterhof.model.Consts;

import ru.ipo.kio._14.peterhof.model.Fountain;
import ru.ipo.kio._14.peterhof.model.FountainEvent;
import ru.ipo.kio._14.peterhof.model.Hill;
import ru.ipo.kio._14.peterhof.model.Point3D;
import ru.ipo.kio._14.peterhof.model.Stream;

public class FountainView extends ObjectContainer3D {

    public static const RADIUS:Number = 2;
    public static const SELECTED_RADIUS:Number = 2.2;
    public static const HEIGHT:Number = 10;
    public static const SELECTED_HEIGHT:Number = 12;
    public static const FOUNTAIN_COLOR:uint = 0xAA0000;
    public static const FOUNTAIN_SELECTED_COLOR:uint = 0xFFa200;
    public static const WATER_COLOR:uint = 0x0c3fa7; //0x4288BB;
    public static const ERROR_WATER_COLOR:uint = 0xFF42AA;
    public static const WATER_SIZE:int = 1;

    private var _fountain:Fountain;
    private var _hillView:HillView;
    private var _fountainMesh:Mesh;
    private var _fountainSelectedMesh:Mesh;
    private var _streamView:Vector.<Sprite3D> = new Vector.<Sprite3D>();

    private var _selected:Boolean = false;

    private var drops:Vector.<Sprite3D>;
    private var dropsIndices:Vector.<int> = new <int>[];

    public function FountainView(fountain:Fountain, hillView:HillView) {
        _fountain = fountain;
        _hillView = hillView;

        var normalMaterial:ColorMaterial = new ColorMaterial(FOUNTAIN_COLOR);
        var selectedMaterial:ColorMaterial = new ColorMaterial(FOUNTAIN_SELECTED_COLOR);
        _fountainMesh = new Mesh(new CylinderGeometry(RADIUS, RADIUS, HEIGHT, 16, 1), normalMaterial);
        _fountainSelectedMesh = new Mesh(new CylinderGeometry(SELECTED_RADIUS, SELECTED_RADIUS, SELECTED_HEIGHT, 16, 1), selectedMaterial);

        if (Consts.QUALITY) {
            normalMaterial.lightPicker = hillView.lightPicker;
            selectedMaterial.lightPicker = hillView.lightPicker;
        }

        _fountainMesh.mouseEnabled = true;
        _fountainMesh.pickingCollider = PickingColliderType.BOUNDS_ONLY;
        _fountainMesh.addEventListener(MouseEvent3D.MOUSE_OVER, onMeshMouseOver);
        _fountainMesh.addEventListener(MouseEvent3D.MOUSE_OUT, onMeshMouseOut);
        _fountainMesh.addEventListener(MouseEvent3D.MOUSE_DOWN, onMeshMouseDown);

        addChild(_fountainMesh);
        addChild(_fountainSelectedMesh);

        _fountainSelectedMesh.visible = false;

        _fountain.addEventListener(Event.CHANGE, fountainChanged);

        fountainChanged();
    }

    public function get selected():Boolean {
        return _selected;
    }

    public function set selected(value:Boolean):void {
        var oldValue:Boolean = _selected;

        _selected = value;

        if (oldValue != value) {
//            _fountainMesh.visible = !_selected;
            _fountainSelectedMesh.visible = _selected;

            dispatchEvent(new FountainEvent(FountainEvent.SELECTION_CHANGED, _fountain));
        }
    }

    private function onMeshMouseOver(event:MouseEvent3D):void {
        _fountainSelectedMesh.visible = true;

        _hillView.mouse_over_fountain = this;
    }

    private function onMeshMouseOut(event:MouseEvent3D):void {
        if (!_selected)
            _fountainSelectedMesh.visible = false;

        _hillView.mouse_over_fountain = null;
    }

    private function onMeshMouseDown(event:MouseEvent3D):void {
        selected = true;
    }

    private function positionMesh(m:Mesh):void {
        var ay:Number = _fountain.phiGr;
        var az:Number = _fountain.alphaGr - 90;

        m.transform = new Matrix3D();
        m.yaw(-ay);
        m.roll(az);
    }

    private function fountainChanged(event:Event = null):void {
        var x:Number = _fountain.x * Consts.PIXELS_IN_METER;
        var y:Number = Hill.xz2y(_fountain.x, _fountain.z) * Consts.PIXELS_IN_METER;
        var z:Number = _fountain.z * Consts.PIXELS_IN_METER;

        moveTo(x, y, z);

        positionMesh(_fountainMesh);
        positionMesh(_fountainSelectedMesh);

        //remove old stream
        for each (var s:Sprite3D in _streamView)
            removeChild(s);

        //add stream
        _streamView = new Vector.<Sprite3D>();

        var stream:Stream = _fountain.stream;

        var waterColor:uint = stream.goes_out ? ERROR_WATER_COLOR : WATER_COLOR;

        var waterMaterial:ColorMaterial = new ColorMaterial(waterColor);

        drops = new <Sprite3D>[];
        dropsIndices = new <int>[];

        var ind:int = 0;
        for each (var point3D:Point3D in stream.points) {
            if (ind % Consts.SKIP_DROPS != 0) {//draw every seventh and the last
                ind++;
                continue;
            }

            var size:Number = WATER_SIZE;// * Math.exp(2 * ind / points);
            var newSprite:Sprite3D = new Sprite3D(waterMaterial, size, size);
            _streamView.push(newSprite);
            newSprite.x = point3D.x * Consts.PIXELS_IN_METER;
            newSprite.y = point3D.y * Consts.PIXELS_IN_METER;
            newSprite.z = point3D.z * Consts.PIXELS_IN_METER;
            addChild(newSprite);

            drops.push(newSprite);
            dropsIndices.push(ind);

            ind++;
        }
    }

    public function updateDrops():void {
        var points:Vector.<Point3D> = _fountain.stream.points;
        var pointsN:uint = points.length;
        var dropsN:uint = drops.length;

        for (var i:int = 0; i < dropsN; i++) {
            var s:Sprite3D = drops[i];
            var ind:int = dropsIndices[i];
            ind = (ind + 1) % pointsN;
            var p:Point3D = points[ind];
            s.x = p.x * Consts.PIXELS_IN_METER;
            s.y = p.y * Consts.PIXELS_IN_METER;
            s.z = p.z * Consts.PIXELS_IN_METER;
            dropsIndices[i] = ind;
        }
    }

    public function get fountain():Fountain {
        return _fountain;
    }
}
}
