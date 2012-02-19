package ru.ipo.kio._12.stagelights 
{
	
	import fl.controls.Slider;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ovv
	 */
	public class CIndensityHandler {
		
		private var _spotlight: ISpotlight;
		
		public function CIndensityHandler(spotlight: ISpotlight) {
			_spotlight = spotlight;
		}
		
		public function handler(e: Event = null): void {
			if (e.target is Slider) {
				_spotlight.intensity = e.target.value;
			} else {
				_spotlight.intensity = e.target.text;
			}
		}
		
		public function add(e: Event = null): void {
			if (_spotlight.intensity < 255) _spotlight.intensity++;
		}
		
		public function dec(e: Event = null): void {
			if (_spotlight.intensity > 0) _spotlight.intensity--;
		}
		
		public function get spotlight(): ISpotlight {
			return _spotlight;
		}
		
	}

}