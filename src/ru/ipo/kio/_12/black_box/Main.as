package 
{
	import com.blackbox.Box;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import com.blackbox.*;
	
	/**
	 * ...
	 * @author rnby.mike
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var box:Box = Box.getInstance();
		}
		
	}
	
}