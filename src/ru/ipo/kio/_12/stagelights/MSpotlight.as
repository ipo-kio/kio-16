package ru.ipo.kio._12.stagelights 
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	/**
	 * ...
	 * @author ovv
	 */
	public class MSpotlight extends EventDispatcher implements ISpotlight {
		
		private var _color: uint;
		private var _intensity: int;
		
		public function MSpotlight(color: uint) {
			_color = color;
			_intensity = 255;
		}
		
		public function getColor(intensity: int = -1): uint {
			if (intensity == -1) {
				return _color;
			} else {	
				var red: uint = Math.round((_color >> 16 & 0xFF) * _intensity / 255);
				var green: uint = Math.round((_color >> 8 & 0xFF) * _intensity / 255);
				var blue: uint = Math.round((_color & 0xFF) * _intensity / 255);
				return (red << 16 & 0xFF0000) | (green << 8 & 0xFF00) | (blue & 0xFF);
			}
		}
		public function setColor(value: uint): void {
			_color = value;
		}
		
		public function get intensity(): int {
			return _intensity;
		}	
		public function set intensity(value: int): void {
			_intensity = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}

}