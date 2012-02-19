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
		
		
		[Embed (source = "_resources/background.png" )] var backgroundLoad: Class;
		private var background: BitmapAsset =  new backgroundLoad();
		
		private var _spotlights: Array = [];
		private var _intensitySliders: Array = [];
		private var _bodies: Array = [];
		private var enlargers: Array = [];
		private var reducers: Array = [];
		private var _workspace: IWorkspace;
		private var _level: int;
		private var _result: Label;
		
		public function Stagelights(level: int) {
			_level = level;
			
			if (level == 0) {
				_workspace = new MRectWorkspace(0, 20, 780, 440);
				_spotlights[0] = new VSpotlight(new MSpotlight(0xFF0000), new Red(), _workspace, 0);
				_spotlights[0].light.x = 470;
				_spotlights[0].light.y = 280;
				_spotlights[0].source.x = 200;
				_spotlights[0].source.y = 490;
				_spotlights[0].spotlight.intensity = Math.random() * 100 + 155;
				_spotlights[0].light.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				_spotlights[1] = new VSpotlight(new MSpotlight(0x00FF00), new Green(), _workspace, 0);
				_spotlights[1].light.x = 390;
				_spotlights[1].light.y = 230;
				_spotlights[1].source.x = 390;
				_spotlights[1].source.y = 500;
				_spotlights[1].spotlight.intensity = Math.random() * 100 + 155;
				_spotlights[1].light.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				_spotlights[2] = new VSpotlight(new MSpotlight(0x0000FF), new Blue(), _workspace, 0);
				_spotlights[2].light.x = 310;
				_spotlights[2].light.y = 280;
				_spotlights[2].source.x = 580;
				_spotlights[2].source.y = 490;
				_spotlights[2].spotlight.intensity = Math.random() * 100 + 155;
				addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				_intensitySliders[0] = new VIntensitySlider(new CIndensityHandler(_spotlights[0].spotlight));
				_intensitySliders[0].x = 85;
				_intensitySliders[0].y = 565;
				_intensitySliders[1] = new VIntensitySlider(new CIndensityHandler(_spotlights[1].spotlight));
				_intensitySliders[1].x = 335;
				_intensitySliders[1].y = 565;
				_intensitySliders[2] = new VIntensitySlider(new CIndensityHandler(_spotlights[2].spotlight));
				_intensitySliders[2].x = 585;
				_intensitySliders[2].y = 565;
				_bodies[0] = new VBody(new MBody(Math.random()*255, Math.random()*255, Math.random()*255), new Body());
				_bodies[0].x = 390;
				_bodies[0].y = 265;
				_result =  new Label;
				_result.width = 120;
				_result.height = 26;
				_result.x = 500;
				_result.y = 50;
				_result.text = "II часть: " + 100 + " %";
			} else  if (level == 1) {
				_workspace = new MRectWorkspace(0, 100, 780, 500);
				_spotlights[0] = new VSpotlight(new MSpotlight(0xFF0000), new Red(), _workspace, 1, false);
				_spotlights[0].light.x = 580;
				_spotlights[0].light.y = 210;
				_spotlights[0].source.x = 200;
				_spotlights[0].source.y = 490;
				_spotlights[0].spotlight.intensity = Math.random() * 100 + 155;
				_spotlights[0].spotlight.addEventListener(Event.CHANGE, update);
				_spotlights[1] = new VSpotlight(new MSpotlight(0x00FF00), new Green(), _workspace, 1, false);
				_spotlights[1].light.x = 390;
				_spotlights[1].light.y = 150;
				_spotlights[1].source.x = 390;
				_spotlights[1].source.y = 500;
				_spotlights[1].spotlight.intensity = Math.random() * 100 + 155;
				_spotlights[1].spotlight.addEventListener(Event.CHANGE, update);
				_spotlights[2] = new VSpotlight(new MSpotlight(0x0000FF), new Blue(), _workspace, 1, false);
				_spotlights[2].light.x = 200;
				_spotlights[2].light.y = 210;
				_spotlights[2].source.x = 580;
				_spotlights[2].source.y = 490;
				_spotlights[2].spotlight.intensity = Math.random() * 100 + 155;
				_spotlights[2].spotlight.addEventListener(Event.CHANGE, update);
				_intensitySliders[0] = new VIntensitySlider(new CIndensityHandler(_spotlights[0].spotlight));
				_intensitySliders[0].x = 85;
				_intensitySliders[0].y = 565;
				_intensitySliders[1] = new VIntensitySlider(new CIndensityHandler(_spotlights[1].spotlight));
				_intensitySliders[1].x = 335;
				_intensitySliders[1].y = 565;
				_intensitySliders[2] = new VIntensitySlider(new CIndensityHandler(_spotlights[2].spotlight));
				_intensitySliders[2].x = 585;
				_intensitySliders[2].y = 565;
				_bodies[0] = new VBody(new MBody(_spotlights[0].spotlight.intensity, _spotlights[1].spotlight.intensity, 0), new Cond());
				_bodies[0].x = _spotlights[2].light.x;
				_bodies[0].y = _spotlights[2].light.y;
				_bodies[1] = new VBody(new MBody(_spotlights[0].spotlight.intensity, 0, _spotlights[2].spotlight.intensity), new Cond());
				_bodies[1].x = _spotlights[1].light.x;
				_bodies[1].y = _spotlights[1].light.y;
				_bodies[2] = new VBody(new MBody(0, _spotlights[1].spotlight.intensity, _spotlights[2].spotlight.intensity), new Cond());
				_bodies[2].x = _spotlights[0].light.x;
				_bodies[2].y = _spotlights[0].light.y;
				_bodies[3] = new VBody(new MBody(_spotlights[0].spotlight.intensity, _spotlights[1].spotlight.intensity, _spotlights[2].spotlight.intensity), new SCond());
				_bodies[3].x = 390;
				_bodies[3].y = 320;
				var bRed: int = Math.random() * 100 + 155;
				var bBlue: int = Math.random() * 100 + 155;
				var bGreen: int = Math.random() * 100 + 155;
				_bodies[4] = new VBody(new MBody(bRed, bGreen, 0), new Clot());
				_bodies[4].x = _spotlights[2].light.x;
				_bodies[4].y = _spotlights[2].light.y;
				_bodies[5] = new VBody(new MBody(bRed, 0, bBlue), new Clot());
				_bodies[5].x = _spotlights[1].light.x;
				_bodies[5].y = _spotlights[1].light.y;
				_bodies[6] = new VBody(new MBody(0, bGreen, bBlue), new Clot());
				_bodies[6].x = _spotlights[0].light.x;
				_bodies[6].y = _spotlights[0].light.y;
				_result =  new Label;
				_result.width = 120;
				_result.height = 26;
				_result.x = 500;
				_result.y = 50;
				_result.text = "I часть: " + 100 + " %";
			}
			
			for (var i:int = 0; i < _spotlights.length; i++) {
				addChild(_spotlights[i]);
			}
			addChild(background);
			for (var j:int = 0; j < _spotlights.length; j++) {
				addChild(_spotlights[j].source);
			}
			for (var k:int = 0; k < _bodies.length; k++) {
				addChild(_bodies[k]);
			}
			for (var n:int = 0; n < _intensitySliders.length; n++) {
				addChild(_intensitySliders[n]);
			}
			
			for (var l:int = 0; l < _spotlights.length; l++) {
				var controller: CIndensityHandler = new CIndensityHandler(_spotlights[l].spotlight);
				enlargers[l] =  new Button();
				enlargers[l].width = 20;
				enlargers[l].height = 20;
				enlargers[l].label = "+";
				enlargers[l].addEventListener(MouseEvent.CLICK, controller.add);
				addChild(enlargers[l]);
				reducers[l] =  new Button();
				reducers[l].width = 20;
				reducers[l].height = 20;
				reducers[l].label = "-";
				reducers[l].addEventListener(MouseEvent.CLICK, controller.dec);
				addChild(reducers[l]);
			}
			enlargers[0].x = 5;
			enlargers[0].y = 542;
			reducers[0].x = 5;
			reducers[0].y = 567;
			enlargers[1].x = 255;
			enlargers[1].y = 542;
			reducers[1].x = 255;
			reducers[1].y = 567;
			enlargers[2].x = 505;
			enlargers[2].y = 542;
			reducers[2].x = 505;
			reducers[2].y = 567;
			addChild(_result);
		}
		
		public function mouseUp(e: Event = null): void {
			for (var j:int = 0; j < _spotlights.length; j++) {
				_spotlights[j].dragging = false;
			}
		}
		
		public function refresh(e: Event = null): void {
			_spotlights[0].spotlight.intensity = Math.random() * 100 + 155;
			_spotlights[1].spotlight.intensity = Math.random() * 100 + 155;
			_spotlights[2].spotlight.intensity = Math.random() * 100 + 155;
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
				trace(2);
			} else {
				trace(1);
				_spotlights[0].light.x = 325;
				_spotlights[0].light.y = 395;
				_spotlights[1].light.x = 390;
				_spotlights[1].light.y = 290;
				_spotlights[2].light.x = 455;
				_spotlights[2].light.y = 395;	
				_bodies[0].body.red = _spotlights[0].spotlight.intensity;
				_bodies[0].body.green = _spotlights[1].spotlight.intensity; 
				_bodies[0].body.blue = 0;
				_bodies[1].body.red = _spotlights[0].spotlight.intensity;
				_bodies[1].body.green = 0; 
				_bodies[1].body.blue = _spotlights[2].spotlight.intensity;
				_bodies[2].body.red = 0;
				_bodies[2].body.green = _spotlights[1].spotlight.intensity; 
				_bodies[2].body.blue = _spotlights[2].spotlight.intensity;
				_bodies[3].body.red = _spotlights[0].spotlight.intensity;
				_bodies[3].body.green = _spotlights[1].spotlight.intensity; 
				_bodies[3].body.blue = _spotlights[2].spotlight.intensity;
				var bRed: int = Math.random() * 100 + 155;
				var bBlue: int = Math.random() * 100 + 155;
				var bGreen: int = Math.random() * 100 + 155;
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
		}
		
		public function update(e: Event = null): void {
			_bodies[0].body.red = _spotlights[0].spotlight.intensity;
			_bodies[0].body.green = _spotlights[1].spotlight.intensity; 
			_bodies[0].body.blue = 0;
			_bodies[1].body.red = _spotlights[0].spotlight.intensity;
			_bodies[1].body.green = 0; 
			_bodies[1].body.blue = _spotlights[2].spotlight.intensity;
			_bodies[2].body.red = 0;
			_bodies[2].body.green = _spotlights[1].spotlight.intensity; 
			_bodies[2].body.blue = _spotlights[2].spotlight.intensity;
			_bodies[3].body.red = _spotlights[0].spotlight.intensity;
			_bodies[3].body.green = _spotlights[1].spotlight.intensity; 
			_bodies[3].body.blue = _spotlights[2].spotlight.intensity;
		}
		
		
		public function get spotlights(): Array {
			return _spotlights;
		}
		public function get bodies(): Array {
			return _bodies;
		}
		
		
	}

}