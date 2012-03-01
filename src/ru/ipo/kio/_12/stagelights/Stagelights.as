package ru.ipo.kio._12.stagelights  
{
	
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextArea;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.core.BitmapAsset;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class Stagelights extends Sprite {
		
		
		[Embed (source = "_resources/background1.png" )] var backgroundLoad1: Class;
		private var background1: BitmapAsset =  new backgroundLoad1();
		[Embed (source = "_resources/background2.png" )] var backgroundLoad2: Class;
		private var background2: BitmapAsset =  new backgroundLoad2();
		
		private var _spotlights: Array = [];
		private var _intensitySliders: Array = [];
		private var _bodies: Array = [];
		private var _workspace: IWorkspace;
		private var _level: int;
		
		public function Stagelights(level: int) {
			_level = level;
			
			if (level == 0) {
				_workspace = new MRectWorkspace(0, 20, 780, 480);
				_spotlights[0] = new VSpotlight(new MSpotlight(0xFF0000), new Red(), _workspace, 0);
				_spotlights[0].light.x = 440;
				_spotlights[0].light.y = 300;
				_spotlights[0].source.x = 200;
				_spotlights[0].source.y = 80;
				_spotlights[0].osource.x = 200;
				_spotlights[0].osource.y = 80;
				_spotlights[0].osource.visible = false;
				_spotlights[0].spotlight.intensity = Math.random() * 30 + 55;
				_spotlights[0].light.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				_spotlights[1] = new VSpotlight(new MSpotlight(0x00FF00), new Green(), _workspace, 0);
				_spotlights[1].light.x = 390;
				_spotlights[1].light.y = 250;
				_spotlights[1].source.x = 390;
				_spotlights[1].source.y = 80;
				_spotlights[1].osource.x = 390;
				_spotlights[1].osource.y = 80;
				_spotlights[1].osource.visible = false;
				_spotlights[1].spotlight.intensity = Math.random() * 30 + 55;
				_spotlights[1].light.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				_spotlights[2] = new VSpotlight(new MSpotlight(0x0000FF), new Blue(), _workspace, 0);
				_spotlights[2].light.x = 340;
				_spotlights[2].light.y = 300;
				_spotlights[2].source.x = 580;
				_spotlights[2].source.y = 80;
				_spotlights[2].osource.x = 580;
				_spotlights[2].osource.y = 80;
				_spotlights[2].osource.visible = false;
				_spotlights[2].spotlight.intensity = Math.random() * 30 + 55;
				addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				_intensitySliders[0] = new VIntensitySlider(new CIndensityHandler(_spotlights[0].spotlight));
				_intensitySliders[0].x = 102;
				_intensitySliders[0].y = 554;
				_intensitySliders[1] = new VIntensitySlider(new CIndensityHandler(_spotlights[1].spotlight));
				_intensitySliders[1].x = 358;
				_intensitySliders[1].y = 554;
				_intensitySliders[2] = new VIntensitySlider(new CIndensityHandler(_spotlights[2].spotlight));
				_intensitySliders[2].x = 613;
				_intensitySliders[2].y = 554;
				_bodies[0] = new VBody(new MBody(Math.random()*60 + 140, Math.random()*60 + 140, Math.random()*60 + 140), new Body());
				_bodies[0].x = 384;
				_bodies[0].y = 309;
			} else  if (level == 1) {
				_workspace = new MRectWorkspace(0, 0, 780, 600);
				_spotlights[0] = new VSpotlight(new MSpotlight(0xFF0000), new Red(), _workspace, 1, false);
				_spotlights[0].light.x = 580;
				_spotlights[0].light.y = 210;
				_spotlights[0].source.x = 200;
				_spotlights[0].source.y = 450;
				_spotlights[0].osource.x = 200;
				_spotlights[0].osource.y = 450;
				_spotlights[0].osource.visible = false;
				_spotlights[0].spotlight.intensity = Math.random() * 30 + 55;
				_spotlights[0].spotlight.addEventListener(Event.CHANGE, update);
				_spotlights[1] = new VSpotlight(new MSpotlight(0x00FF00), new Green(), _workspace, 1, false);
				_spotlights[1].light.x = 390;
				_spotlights[1].light.y = 150;
				_spotlights[1].source.x = 390;
				_spotlights[1].source.y = 450;
				_spotlights[1].osource.x = 390;
				_spotlights[1].osource.y = 450;
				_spotlights[1].osource.visible = false;
				_spotlights[1].spotlight.intensity = Math.random() * 30 + 55;
				_spotlights[1].spotlight.addEventListener(Event.CHANGE, update);
				_spotlights[2] = new VSpotlight(new MSpotlight(0x0000FF), new Blue(), _workspace, 1, false);
				_spotlights[2].light.x = 200;
				_spotlights[2].light.y = 210;
				_spotlights[2].source.x = 580;
				_spotlights[2].source.y = 450;
				_spotlights[2].osource.x = 580;
				_spotlights[2].osource.y = 450;
				_spotlights[2].osource.visible = false;
				_spotlights[2].spotlight.intensity = Math.random() * 30 + 55;
				_spotlights[2].spotlight.addEventListener(Event.CHANGE, update);
				_intensitySliders[0] = new VIntensitySlider(new CIndensityHandler(_spotlights[0].spotlight));
				_intensitySliders[0].x = 102;
				_intensitySliders[0].y = 554;
				_intensitySliders[1] = new VIntensitySlider(new CIndensityHandler(_spotlights[1].spotlight));
				_intensitySliders[1].x = 358;
				_intensitySliders[1].y = 554;
				_intensitySliders[2] = new VIntensitySlider(new CIndensityHandler(_spotlights[2].spotlight));
				_intensitySliders[2].x = 613;
				_intensitySliders[2].y = 554;
				_bodies[0] = new VBody(new MBody(_spotlights[0].spotlight.intensity, 0, 0), new SRed(), true);
				_bodies[0].x = 390;
				_bodies[0].y = 300;
				_bodies[0].silhouette.height = 600;
				_bodies[1] = new VBody(new MBody(0, _spotlights[1].spotlight.intensity, 0), new SGreen(), true);
				_bodies[1].x = 390;
				_bodies[1].y = 300;
				_bodies[1].silhouette.height = 600;
				_bodies[2] = new VBody(new MBody(0, 0, _spotlights[2].spotlight.intensity), new SBlue(), true);
				_bodies[2].x = 390;
				_bodies[2].y = 300;
				_bodies[2].silhouette.height = 600;
				_bodies[3] = new VBody(new MBody(0, 0, 0), new SBody());
				_bodies[3].x = 390;
				_bodies[3].y = 300;
				_bodies[3].silhouette.height = 600;
				var bRed: int = Math.random()*65 + 180;
				var bBlue: int = Math.random()*65 + 180;
				var bGreen: int = Math.random()*65 + 180;
				_bodies[4] = new VBody(new MBody(bRed, bGreen, 0), new Rabbit());
				_bodies[4].x = 390;
				_bodies[4].y = 300;
				_bodies[5] = new VBody(new MBody(bRed, 0, bBlue), new Flowers());
				_bodies[5].x = 390;
				_bodies[5].y = 300;
				_bodies[6] = new VBody(new MBody(0, bGreen, bBlue), new Birds());
				_bodies[6].x = 390;
				_bodies[6].y = 300;
			}
			var black: Sprite = new Sprite();
			black.graphics.beginFill(0x000000);
			black.graphics.drawRect(0, 0, 780, 600);
			black.graphics.endFill();
			addChild(black);
			for (var i:int = 0; i < _spotlights.length; i++) {
				addChild(_spotlights[i]);
			}
			for (var k:int = 0; k < _bodies.length; k++) {
				addChild(_bodies[k]);
			}
			if (_level != 0) {
				addChild(background1);
			} else {
				addChild(background2);
			}
			for (var j:int = 0; j < _spotlights.length; j++) {
				addChild(_spotlights[j].source);
				addChild(_spotlights[j].osource);
			}
			for (var n:int = 0; n < _intensitySliders.length; n++) {
				addChild(_intensitySliders[n]);
			}
			this.x = 5;
			this.y = 5;
			this.width = 770;
			this.height = 590;
		}
		
		public function mouseUp(e: Event = null): void {
			for (var j:int = 0; j < _spotlights.length; j++) {
				_spotlights[j].dragging = false;
			}
		}
		/*
		public function refresh(e: Event = null): void {
			_spotlights[0].spotlight.intensity = Math.random() * 50 + 155;
			_spotlights[1].spotlight.intensity = Math.random() * 50 + 155;
			_spotlights[2].spotlight.intensity = Math.random() * 50 + 155;
			if (_level == 0) {
				_spotlights[0].light.x = 470;
				_spotlights[0].light.y = 280;
				_spotlights[1].light.x = 390;
				_spotlights[1].light.y = 230;
				_spotlights[2].light.x = 310;
				_spotlights[2].light.y = 280;
				_bodies[0].body.red = Math.random() * 255;
				_bodies[0].body.green = Math.random() * 255; 
				_bodies[0].body.blue = Math.random() * 255;
				//trace(_bodies[0].body.red + " " + _bodies[0].body.green + " " +_bodies[0].body.blue);
			} else {
				_spotlights[0].light.x = 325;
				_spotlights[0].light.y = 395;
				_spotlights[1].light.x = 390;
				_spotlights[1].light.y = 290;
				_spotlights[2].light.x = 455;
				_spotlights[2].light.y = 395;	
				_bodies[0].body.red = _spotlights[0].spotlight.intensity;
				_bodies[1].body.green = _spotlights[1].spotlight.intensity; 
				_bodies[2].body.blue = _spotlights[2].spotlight.intensity;
				var bRed: int = Math.random() * 100 + 155;
				var bBlue: int = Math.random() * 100 + 155;
				var bGreen: int = Math.random() * 100 + 155;
				//trace(bRed + " " + bBlue + " " + bGreen);
				_bodies[4].body.red = bRed;
				_bodies[4].body.green = bGreen 
				_bodies[4].body.blue = 0;
				_bodies[5].body.red = bRed;
				_bodies[5].body.green = 0; 
				_bodies[5].body.blue = bBlue;
				_bodies[6].body.red = 0;
				_bodies[6].body.green = bGreen 
				_bodies[6].body.blue = bBlue;
			}
		}*/
		
		public function update(e: Event = null): void {
			_bodies[0].body.red = _spotlights[0].spotlight.intensity;
			_bodies[1].body.green = _spotlights[1].spotlight.intensity; 
			_bodies[2].body.blue = _spotlights[2].spotlight.intensity;
		}
		
		
		public function get spotlights(): Array {
			return _spotlights;
		}
		public function get bodies(): Array {
			return _bodies;
		}
		
		public function get intensitySliders(): Array {
			return _intensitySliders;
		}
	}

}