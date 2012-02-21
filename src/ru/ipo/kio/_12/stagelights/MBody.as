package ru.ipo.kio._12.stagelights 
{
	
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ovv
	 */
	public class MBody extends EventDispatcher implements IBody {
		
		private var _red: int;
		private var _green: int;
		private var _blue: int;
		
		public function MBody(red: int, green: int, blue: int) {
			_red = red;
			_green = green;
			_blue = blue;
		}
	
		public function get red(): int {
			return _red;
		}	
		public function set red(value: int): void {
			_red = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get green(): int {
			return _green;
		}	
		public function set green(value: int): void {
			_green = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get blue(): int {
			return _blue;
		}	
		public function set blue(value: int): void {
			_blue = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	}

}