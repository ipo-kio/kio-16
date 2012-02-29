package ru.ipo.kio._12.stagelights 
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ovv
	 */
	public class VSpotlight extends Sprite {
		
		private const MOVE_SPEED: int = 5;
		private const LIGHT_RADIUS: int = 170;
		
		private var _spotlight: ISpotlight;
		private var _source: MovieClip;
		private var _osource: MovieClip;
		private var _light: MovieClip;
		private var _workspace: IWorkspace;
		
		private var _dragging: Boolean;
		
		public function VSpotlight(spotlight: ISpotlight, source: MovieClip, workspace: IWorkspace, light: int, movable: Boolean = true) {
			_spotlight = spotlight;
			_spotlight.addEventListener(Event.CHANGE, refresh);
			
			_osource = new Off();
	
			if (light == 0) {
				_light = new MovieClip();
				_light.graphics.beginFill(_spotlight.getColor(-1));
				_light.graphics.drawCircle(0, 0, LIGHT_RADIUS);
				_light.graphics.endFill();
			} else if (light == 1) {
				_light = new MovieClip();
				_light.graphics.beginFill(_spotlight.getColor(-1));
				_light.graphics.drawCircle(0, 0, 0);
				_light.graphics.endFill();
			}
			_light.blendMode = BlendMode.ADD;
			if (movable) {
				_light.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				_light.addEventListener(Event.ENTER_FRAME, dragg);
				_dragging = false;
			}
			addChild(_light);
			
			_source =  source;
			_source.addEventListener(Event.CHANGE, refresh);
			
			_workspace = workspace;
		}
	
		private function refresh(e: Event = null): void {
			var angleNew: Number = 180 * Math.atan((_source.y - _light.y) / (_light.x - _source.x)) / Math.PI;
				if (_light.x == _source.x) {
					_source.rotation = 180 * Math.atan((_source.y - _light.y) / (_light.x - _source.x)) / Math.PI + 90;
				} else {
					if (_light.x < _source.x) {
						_source.rotation = -angleNew + 90;
					} else {
						_source.rotation = -angleNew - 90;
					}
				}
			_osource.rotation = _source.rotation;
			_light.transform.colorTransform = new ColorTransform(e.target.intensity / 255, e.target.intensity / 255, e.target.intensity / 255);
		}
		
		private function dragg(e: Event = null): void {
			if (_dragging) {
				trace(mouseX);
				trace(mouseY);
				var distanceX: Number = mouseX - _light.x;
				var distanceY: Number = mouseY - _light.y;
				var distance: Number = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
				if (_workspace.inSpace(_light.x, _light.y, LIGHT_RADIUS)) {
					if (distance > 2) {
						var angle: Number = Math.atan2(distanceY, distanceX);
					
						var speedX: Number = Math.cos(angle) * MOVE_SPEED;
						var speedY: Number = Math.sin(angle) * MOVE_SPEED;
					
						_light.x += speedX;
						_light.y += speedY;
					}
				} else {
					_light.x += _workspace.dx(_light.x, _light.y, LIGHT_RADIUS);
					_light.y -= _workspace.dy(_light.x, _light.y, LIGHT_RADIUS);
				}
				var angleNew: Number = 180 * Math.atan((_source.y - _light.y) / (_light.x - _source.x)) / Math.PI;
				if (_light.x == _source.x) {
					_source.rotation = 0;
				} else {
					if (_light.x < _source.x) {
						_source.rotation = -angleNew + 90;
					} else {
						_source.rotation = -angleNew - 90;
					}
				}
			}
		}
		
		public function mouseDown(e: Event = null): void {
			_dragging = true;
		}
		
		public function get spotlight(): ISpotlight {
			return _spotlight;
		}
		public function get source(): MovieClip {
			return _source;
		}
		public function get light(): MovieClip {
			return _light;
		}
		public function get workspace(): IWorkspace {
			return _workspace;
		}
		
		public function get dragging(): Boolean{
			return _dragging;
		}
		public function set dragging(value: Boolean): void {
			_dragging = value;
		}
		
		public function get osource(): MovieClip{
			return _osource;
		}
		public function set osource(value: MovieClip): void {
			_osource = value;
		}
	
	}

}