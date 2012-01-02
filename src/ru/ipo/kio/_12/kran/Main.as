package ru.ipo.kio._12.kran
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.net.URLRequest;
	import ru.ipo.kio._12.kran.controllers.Executor;
	/**
	 * ...
	 * @author Eddiw
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
			//var b: Background = new Background();
			//stage.addChild(b);
			var Exec:Executor = new Executor; 
			Exec.init(stage);		
 		}
		
	}
	
}