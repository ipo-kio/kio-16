package 
{
	import ColorModels.RGB;
	import flash.display.Sprite;
	import flash.events.Event;
	import GeometricSamples.Point;
	import GeometricSamples.Section;
	import ModelComponents.Spotlight.Spotlight;
	import ModelComponents.Stage.Stage;
	
	/**
	 * ...
	 * @author ovv
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
			var stage: Stage = new Stage(new Point(300, 300), 100, 5, 150, new RGB());
			stage.init(this);
		}
		
	}
	
}