package 
{
	import fl.controls.TextArea;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import sample.ModelController;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.None;
	
	import flash.display.GradientType
	
	import sample.colorModels.IColor;
	import sample.colorModels.colorControllers.RGBController;
	
	import sample.geometry.Point;
	import sample.geometry.Section;
	
	import sample.Model;
	import sample.Spotlight;
	
	/**
	 * ...
	 * @author ovv
	 */
	public class Main extends Sprite 
	{
		public const COUNT_SPOTLIGHTS: int = 3;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);	
			var modelSprite: Sprite = new Sprite();
			var a: Model =  new Model(modelSprite, COUNT_SPOTLIGHTS, 150, new Point(300, 300), 100);
			a.view();
			addChild(modelSprite);
			var modelControllerSprite: Sprite = new Sprite();
			var b: ModelController =  new  ModelController(modelControllerSprite, a, 2, 0, 100);
			b.init();
			addChild(modelControllerSprite);
		}
	}
	
}