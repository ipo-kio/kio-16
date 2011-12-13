package
{
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
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
		private var startButton : StartButton;
		private var resetButton : StartButton;
		private var checkSolutionButton : StartButton;
		private var stageController: StageController;
		//private var button : Button;
		
		private var code:String;
		private static var count:int = 0;
		private var timer : Timer;
		
		public function init(stage : Stage):void
		{
			makeTextField(stage);
			stageController = new StageController(stage);
			startButton = new StartButton(900, 680, "Запуск!");
			resetButton = new StartButton(980, 680, "Сброс!");
			checkSolutionButton = new StartButton(0, 680, "Check!");
			
			timer = new Timer(250);
			startButton.addToStage(stage);
			resetButton.addToStage(stage);
			checkSolutionButton.addToStage(stage);
			
			startButton.addEventListener(MouseEvent.CLICK, execute);
			resetButton.addEventListener(MouseEvent.CLICK, reset);
			checkSolutionButton.addEventListener(MouseEvent.CLICK, checkSolution);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		public function keyHandler(event:KeyboardEvent):void {
			switch (event.keyCode)
			{
				case 39: //Right Arrow
				{
					txtField.appendText("R");
					stageController.moveRight();
					break;
				}
				case 37: //Left Arrow
				{
					txtField.appendText("L");
					stageController.moveLeft();
					break;
				}
				case 40: //Down Arrow
				{
					txtField.appendText("D");
					stageController.moveDown();
					break;
				}
				case 38: //Up Arrow
				{
					txtField.appendText("U");
					stageController.moveUp();
					break;
				}
				case 67: //'C' Close
				{
					txtField.appendText("C");
					stageController.close();
					break;
				}
				case 82: //'R' Release
				{
					txtField.appendText("O");
					stageController.release();
				}
			}
		}	
		private function execute(event:MouseEvent):void
		{
			code = txtField.text;
			startButton.disable();
			startButton.removeEventListener(MouseEvent.CLICK, execute);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}	
		
		private function onTimer(event:TimerEvent):void
		{
			var a:String = code.charAt(count);
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
			//если код кончился;
			if (a == "")
			{
				timer.stop();
				count = 0;
				startButton.enable();
				startButton.addEventListener(MouseEvent.CLICK, execute);
			}
		}
		
		private function makeTextField(stage:Stage):void
		{
			txtField = new TextField();
			txtField.type = TextFieldType.INPUT;
			txtField.x = 80;
			txtField.y = 680;
			txtField.width = 800;
			txtField.height = 30;
			txtField.border = true;
			txtField.selectable = true;
			txtField.restrict = "R|C|L|O|D|U";
			txtField.multiline = true;
			txtFormat = new TextFormat("arial", 20, 0x000000, true);
			txtField.text = "";
			txtField.setTextFormat(txtFormat);
			stage.addChild(txtField);
			code = txtField.text;
		}
		
		private function reset(e: MouseEvent):void
		{
			startButton.enable();
			if (timer.running)
			{
				timer.stop();
				startButton.addEventListener(MouseEvent.CLICK, execute);
			}
			stageController.reset();
			count = 0;
		}
		
		private function checkSolution(e:MouseEvent):void
		{
			stageController.checkSolution();
		}
	}
}
