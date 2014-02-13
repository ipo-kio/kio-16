/**
 * Created by ilya on 14.01.14.
 */
package ru.ipo.kio._14.peterhof.view {

import away3d.cameras.lenses.LensBase;
import away3d.cameras.lenses.OrthographicLens;
import away3d.entities.Mesh;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio._14.peterhof.*;

import away3d.cameras.lenses.PerspectiveLens;
import away3d.containers.View3D;

import flash.events.Event;
import flash.geom.Vector3D;

import ru.ipo.kio._14.peterhof.model.Consts;
import ru.ipo.kio._14.peterhof.model.Fountain;

import ru.ipo.kio._14.peterhof.model.Hill;

public class Fountains3DView extends View3D {

    public static const CAMERA_RADIUS:Number = 900;

    private var _camera_pan:Number = 42;
    private var _camera_tilt:Number = 42;
    private var _camera_x:Number = (Consts.HILL_LENGTH1 + Consts.HILL_LENGTH2) / 2;
    private var _camera_z:Number = Consts.HILL_WIDTH / 2;
    private var _camera_lens:PerspectiveLens = new PerspectiveLens(30);

    private var move:Boolean = false;
    private var moveFountain:Boolean = false;
    private var fountainBeingMoved:FountainView = null;
    private var lastPanAngle:Number;
    private var lastTiltAngle:Number;
    private var lastMouseX:Number;
    private var lastMouseY:Number;

    private var _hill:Hill;
    private var _hillView:HillView;

    public function Fountains3DView() {
        _hill = new Hill();
        _hillView = new HillView(_hill);
        scene.addChild(_hillView);

//        mouse_debug_mesh = new Mesh();

        positionCamera();
        camera.lens = _camera_lens;

        addEventListener(Event.ENTER_FRAME, _onEnterFrame);

        width = PeterhofWorkspace._3D_WIDTH;
        height = PeterhofWorkspace._3D_HEIGHT;

        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    public function get hillView():HillView {
        return _hillView;
    }

    public function processKeyPress(event:KeyboardEvent):void {
        switch (event.keyCode) {
            case 37:
            case 65:
                _camera_z -= 1;
                positionCamera();
                break;
            case 39:
            case 68:
                _camera_z += 1;
                positionCamera();
                break;
            case 38:
            case 87:
                _camera_x -= 1;
                positionCamera();
                break;
            case 40:
            case 83:
                _camera_x += 1;
                positionCamera();
                break;
        }
    }

    private function onMouseWheel(event:MouseEvent):void {
        var scale:Number = _camera_lens.fieldOfView;

        scale -= event.delta * 0.5;
        if (scale < 1)
            scale = 1;
        else if (scale > 30)
            scale = 30;

        _camera_lens.fieldOfView = scale;

        camera.lens = _camera_lens;

        reRender();
    }

    private function onMouseDown(event:MouseEvent):void {
        fountainBeingMoved = _hillView.mouse_over_fountain;
        if (fountainBeingMoved) {
            //move fountain
            moveFountain = true;
        } else {
            //rotate camera

            move = true;
        //        lastPanAngle = cameraController.panAngle;
        //        lastTiltAngle = cameraController.tiltAngle;
            lastPanAngle = _camera_pan;
            lastTiltAngle = _camera_tilt;

            lastMouseX = stage.mouseX;
            lastMouseY = stage.mouseY;
        }

        stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);

        reRender();
    }

    private function onMouseMove(event:MouseEvent):void {
        if (!moveFountain)
            return;

        var nx:Number = (event.localX * 2 - 100) / 100;
        var ny:Number = (event.localY * 2 - 100) / 100;

        var intersection:Point = intersect(nx, ny);

        if (intersection == null)
            return;

        var f:Fountain = fountainBeingMoved.fountain;
        f.x = intersection.x;
        f.z = intersection.y; //Points have (x,y) fields, but we store x,z there

        reRender();
    }

    private function intersect(nx:Number, ny:Number):Point {
        var approx:Point = intersectApproximate(nx, ny);
        if (approx == null)
            return null;

        var x0:Number = Consts.FOUNTAIN_PRECISION * Math.round(approx.x / Consts.FOUNTAIN_PRECISION);
        var z0:Number = Consts.FOUNTAIN_PRECISION * Math.round(approx.y / Consts.FOUNTAIN_PRECISION);

        var bestX:Number = x0;
        var bestZ:Number = z0;
        var bestDist:Number = Number.POSITIVE_INFINITY;

        for (var i:int = -3; i <= 3; i++) {
            var x:Number = x0 + i * Consts.FOUNTAIN_PRECISION;
            if (x < 0 || x > Consts.HILL_LENGTH)
                continue;

            for (var j:int = -3; j <= 3; j++) {
                var z:Number = z0 + j * Consts.FOUNTAIN_PRECISION;
                if (z < 0 || z > Consts.HILL_WIDTH)
                    continue;

                //test x, y to be closer
                var pnt:Vector3D = _camera.project(new Vector3D(x * Consts.PIXELS_IN_METER, Hill.xz2y(x, z) * Consts.PIXELS_IN_METER, z * Consts.PIXELS_IN_METER));
                var dist:Number = Math.abs(pnt.x - nx) + Math.abs(pnt.y - ny);
                if (dist < bestDist) {
                    bestDist = dist;
                    bestX = x;
                    bestZ = z;
                }
            }
        }

        return new Point(bestX, bestZ);
    }

    //return a point _x, _z for the hill
    private function intersectApproximate(nx:Number, ny:Number):Point {
        var r:Point = intersect1(nx, ny);
        if (r != null)
            return r;

        return intersect2(nx, ny);
    }

    private function intersect1(nx:Number, ny:Number):Point {
        var vLT:Vector3D = _camera.project(new Vector3D(0, Consts.HILL_HEIGHT * Consts.PIXELS_IN_METER, Consts.HILL_WIDTH * Consts.PIXELS_IN_METER));
        var vLB:Vector3D = _camera.project(new Vector3D(0, Consts.HILL_HEIGHT * Consts.PIXELS_IN_METER, 0));
        var vRT:Vector3D = _camera.project(new Vector3D(Consts.HILL_LENGTH1 * Consts.PIXELS_IN_METER, 0, Consts.HILL_WIDTH * Consts.PIXELS_IN_METER));
        var vRB:Vector3D = _camera.project(new Vector3D(Consts.HILL_LENGTH1 * Consts.PIXELS_IN_METER, 0, 0));

        var i:Point = intersectRect(vLT, vLB, vRT, vRB, nx, ny);

        if (i.x < 0)
            i.x = 0;
        if (i.x > Consts.HILL_LENGTH1)
            return null;
        if (i.y < 0)
            i.y = 0;
        if (i.y > Consts.HILL_WIDTH)
            i.y = Consts.HILL_WIDTH;

        return i;
    }

    private function intersect2(nx:Number, ny:Number):Point {
        var vLT:Vector3D = _camera.project(new Vector3D(Consts.HILL_LENGTH1 * Consts.PIXELS_IN_METER, 0, Consts.HILL_WIDTH * Consts.PIXELS_IN_METER));
        var vLB:Vector3D = _camera.project(new Vector3D(Consts.HILL_LENGTH1 * Consts.PIXELS_IN_METER, 0, 0));
        var vRT:Vector3D = _camera.project(new Vector3D(Consts.HILL_LENGTH * Consts.PIXELS_IN_METER, 0, Consts.HILL_WIDTH * Consts.PIXELS_IN_METER));
        var vRB:Vector3D = _camera.project(new Vector3D(Consts.HILL_LENGTH * Consts.PIXELS_IN_METER, 0, 0));

        var i:Point = intersectRect(vLT, vLB, vRT, vRB, nx, ny);

        if (i.x < Consts.HILL_LENGTH1)
            return null;
        if (i.x > Consts.HILL_LENGTH)
            i.x = Consts.HILL_LENGTH;
        if (i.y < 0)
            i.y = 0;
        if (i.y > Consts.HILL_WIDTH)
            i.y = Consts.HILL_WIDTH;

        return i;
    }

    private function intersectRect(vLT:Vector3D, vLB:Vector3D, vRT:Vector3D, vRB:Vector3D, nx:Number, ny:Number):Point {
        var a:Vector3D = vRB.subtract(vLB);
        var b:Vector3D = vLT.subtract(vLB);

        var vRT2:Vector3D = new Vector3D(
                vLT.x + vRB.x - vLB.x,
                vLT.y + vRB.y - vLB.y,
                vLT.z + vRB.z - vLB.z
        );
//        trace('w', vLT.w, vLB.w, vRT.w, vRB.w);
//        trace('diff RT', vRT2.x - vRT.x, vRT2.y - vRT.y, vRT2.z - vRT.z);

        var n:Vector3D = a.crossProduct(b);
        //(nx - vLB.x)*n.x + (ny - vLB.y)*n.y + (nz - vLB.z)*n.z = 0

//        trace('z on plane', (vRT.x - vLB.x) * n.x + (vRT.y - vLB.y) * n.y + (vRT.z - vLB.z) * n.z);

        var nz:Number = -((nx - vLB.x) * n.x + (ny - vLB.y) * n.y) / n.z + vLB.z;

        var ans:Vector3D = camera.unproject(nx, ny, nz);

        var fx:Number = ans.x / Consts.PIXELS_IN_METER;
        var fz:Number = ans.z / Consts.PIXELS_IN_METER;

        if (isNaN(fx) || isNaN(fz))
            return null;

        return new Point(fx, fz);
    }

    private function onMouseUp(event:MouseEvent):void {
        move = false;
        moveFountain = false;
        stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    private function onStageMouseLeave(event:Event):void {
        move = false;
        moveFountain = false;
        stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

//    private function draw():void {
//        var skyTexture:BitmapData = (new SkyTexture).bitmapData;
//        var sky:SkyBox = new SkyBox(new BitmapCubeTexture(skyTexture, skyTexture, skyTexture, skyTexture, skyTexture, skyTexture));

//        var sun:DirectionalLight = new DirectionalLight(-1, -1, 0);
//        material.lightPicker = new StaticLightPicker([sun]);

//        scene.addChild(_plane);
//        scene.addChild(sky);
//        scene.addChild(sun);
//    }

    private function positionCamera():void {
        if (_camera_pan < 0)
            _camera_pan = 0;
        else if (_camera_pan > 90)
            _camera_pan = 90;
        if (_camera_tilt < 0)
            _camera_tilt = 0;
        else if (_camera_tilt > 85)
            _camera_tilt = 85;

        var p:Number = _camera_pan * Math.PI / 180;
        var t:Number = _camera_tilt * Math.PI / 180;

        camera.x = CAMERA_RADIUS * Math.cos(p) * Math.cos(t);
        camera.y = CAMERA_RADIUS * Math.sin(t);
        camera.z = -CAMERA_RADIUS * Math.sin(p) * Math.cos(t);

        if (_camera_x < 0)
            _camera_x = 0;
        else if (_camera_x > Consts.HILL_LENGTH1 + Consts.HILL_LENGTH2)
            _camera_x = Consts.HILL_LENGTH1 + Consts.HILL_LENGTH2;

        if (_camera_z < 0)
            _camera_z = 0;
        else if (_camera_z > Consts.HILL_WIDTH)
            _camera_z = Consts.HILL_WIDTH;

        var xv:Number = _camera_x * Consts.PIXELS_IN_METER;
        var yv:Number = (Hill.xz2y(_camera_x, _camera_z) + Consts.HILL_HEIGHT / 2) * Consts.PIXELS_IN_METER;
        var zv:Number = _camera_z * Consts.PIXELS_IN_METER;
        camera.lookAt(new Vector3D(xv, yv, zv));
    }

    private var _reRender:Boolean = true;

    public function reRender():void {
        _reRender = true;
    }

    /**
     * render loop
     */
    private function _onEnterFrame(e:Event):void
    {
        if (move) {
            _camera_pan = 0.3 * (stage.mouseX - lastMouseX) + lastPanAngle;
            _camera_tilt = 0.3 * (stage.mouseY - lastMouseY) + lastTiltAngle;

            positionCamera();

            _reRender = true;
        }

        for each (var fountain:FountainView in _hillView.fountains)
            fountain.frameHandler(e);

        if (_reRender) {
            render();
            _reRender = true;
        }
    }

    public function get hill():Hill {
        return _hill;
    }
}
}
