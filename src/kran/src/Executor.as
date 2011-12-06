package
{
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.display.SimpleButton;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Eddiw
	 */
	
	public class Executor 
	{
		private var txtField : TextField;
		private var txtFormat: TextFormat;
		private var startButton : SimpleButton;
		private var stageController: StageController;
		
		private var code:String;
		private static var count:int = 0;
		public function init(stage : Stage):void
		{
			makeTextField(stage);
			stageController = new StageController(stage);
			execute(code);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		public function keyHandler(event:KeyboardEvent):void {
			switch (event.keyCode)
			{
				case 39: //Right Arrow
				{
					stageController.moveRight();
					break;
				}
				case 37: //Left Arrow
				{
					stageController.moveLeft();
					break;
				}
				case 40: //Down Arrow
				{
					stageController.moveDown();
					break;
				}
				case 38: //Up Arrow
				{
					stageController.moveUp();
					break;
				}
				case 67: //'C' Close
				{
					stageController.close();
					break;
				}
				case 82: //'R' Release
				{
					stageController.release();
				}
			}
		}	
		private function execute(source : String):void
		{
			var code : String = source;
			var timer : Timer = new Timer(100);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}	
		
		private function onTimer(event:TimerEvent):void
		{
			var a:String = code.substring(count, count+1);
				if ( a == "R") //Right Arrow
					stageController.moveRight();
				else if (a =="L") //Left Arrow
					stageController.moveLeft();
				else if (a == "D") //Down Arrow
					stageController.moveDown();
				else if (a == "U") //Up Arrow
					stageController.moveUp();
				else if (a == "C") //'C' Close
					stageController.close();
				else if (a == "O") //'R' Release
					stageController.release();
				++count;
		}
	
		
		private function makeFunction(stage:Stage):void
		{
			startButton = new SimpleButton;
		}
		
		private function makeTextField(stage:Stage):void
		{
			txtField = new TextField();
			txtFormat = new TextFormat("arial", 20, 0xFF0000, true);
			txtField.text = "RRODCURRDOULLLODCURRDOUDCURRDOULLLLDCURRRRRDOUC";
			
			txtField.x = 50;
			txtField.y = 680;
			txtField.width = 800;
			txtField.height = 30;
			txtField.border = true;
			txtField.type = TextFieldType.INPUT;
			txtField.selectable = true;
			txtField.restrict = "R|C|L|O|D|U";
			txtField.setTextFormat(txtFormat);
			stage.addChild(txtField);
			
			code = txtField.text;
		}
	}
}
