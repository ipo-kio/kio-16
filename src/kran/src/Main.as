package 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;	
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
			
			var Exec:Executor = new Executor; Exec.init(stage);
			
			var arr:ArrayGraphic = new ArrayGraphic;
			arr.draw();
			arr.addToStage(stage);			
 		}
		
	}
	
}