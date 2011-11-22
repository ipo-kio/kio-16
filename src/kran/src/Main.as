package 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	
	
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
			
			var txtField : TextField = new TextField();
			var button :SimpleButton = new SimpleButton();
			
			txtField.x = 50;
			txtField.y = 500;
			txtField.width = 500;
			txtField.height = 30;
			
			button.x = 600;
			button.y = 500;
			button.width = 100;
		
			stage.addChild(txtField);
			stage.addChild(button);
			
 		}
		
	}
	
}