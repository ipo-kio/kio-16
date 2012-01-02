package ru.ipo.kio._12.kran.controllers
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
	import ru.ipo.kio._12.kran.display.StartButton;

	
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
		private var level: int;

		private var code:String;
		private static var count:int = 0;
		private var timer : Timer;
		private var depth:int; //глубина погружения level2
		private var iterCount:String; //количество итераций level2
		private var codesVect:Vector.<String>//Вектор кодов level2

		
		public function init(stage : Stage):void
		{
			makeTextField(stage);
			stageController = new StageController(stage);
			startButton = new StartButton(900, 680, "Запуск!");
			resetButton = new StartButton(970, 680, "Сброс!");
			checkSolutionButton = new StartButton(0, 680, "Check!");
			
			timer = new Timer(500);
			startButton.addToStage(stage);
			resetButton.addToStage(stage);
			checkSolutionButton.addToStage(stage);
			
			startButton.addEventListener(MouseEvent.CLICK, execute);
			resetButton.addEventListener(MouseEvent.CLICK, reset);
			checkSolutionButton.addEventListener(MouseEvent.CLICK, checkSolution);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			iterCount = new String("");
			depth = 0;	
			codesVect = new Vector.<String>;
		}
		
		public function keyHandler(event:KeyboardEvent):void {
		/*	switch (event.keyCode)
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
			}*/
		}	
		private function execute(event:MouseEvent):void
		{
			code = txtField.text;
			makeVector(code);
			codesVect.reverse();
			startButton.disable();
			startButton.removeEventListener(MouseEvent.CLICK, execute);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onTimerLevel2);
		}	
		
		private function makeVector(code:String):void
		{
			var vcount:int = 0;
			var a:String = code.charAt(vcount);
			while (a != "")
			{
			a = code.charAt(vcount);
			if (parseInt(a) <= 9 && parseInt(a) >= 0)
				iterCount = iterCount.concat(a);
			if (isLetter(a))
			{
				var debug:String = code.slice(vcount - iterCount.length, vcount);
				if (iterCount == "")
					codesVect.push(a);
				else if (debug == iterCount)
				{
					var tmp:int = parseInt(iterCount);
					iterCount = "";
					for (var i:int = 0; i < tmp; i++)
					{
						codesVect.push(a);
					}
				}
			}
			if (a == "(")
			{
				try{
				var closeBraceIndex : int = findCorrespondingBrace(code,vcount);
				}catch (e:String) {
					trace(e);
				}
				var subCode:String = code.slice(vcount + 1, closeBraceIndex);
				if (code.slice(vcount - iterCount.length, vcount) == iterCount)
				{
					var tmp:int = parseInt(iterCount);
					iterCount = "";
					for (var i:int = 0; i < tmp; i++ )
						makeVector(subCode);
				}
				else
				{
					makeVector(subCode);
				}
				vcount += subCode.length + 1;
			}
			++vcount;
			}
		}
		
		private function isLetter(a:String):Boolean
		{
			return (a == "C") ||
				   (a == "O") ||
				   (a == "R") ||
				   (a == "L") ||
				   (a == "U") ||
				   (a == "D");
		}
		private function findCorrespondingBrace(incode:String, incount:int):int
		{
			var beg:String = incode.charAt(count);
			var i:int = incount + 1;
			var braces:int = 0;
			for (; i < incode.length - incount + 1; i++ )
			{
				var tmp:String = incode.charAt(i);
				if (tmp == "(")
					++braces;
				else if (tmp == ")" && braces != 0)
					--braces;
				else if (tmp == ")" && braces == 0)
					return i;
			}
			return -1;
		}
		
		private function onTimerLevel2(event:TimerEvent):void
		{
			var a:String = codesVect.pop();
			stageController.execCommand(a);
		}
			
		private function onTimerLevel1(event:TimerEvent):void
		{
			var a:String = code.charAt(count);
			if (a == "")
			{
				timer.stop();
				count = 0;
				startButton.enable();
				startButton.addEventListener(MouseEvent.CLICK, execute);
				return;
			}
			stageController.execCommand(a);
			++count;
		}
		
		private function makeTextField(stage:Stage):void
		{
			txtField = new TextField();
			txtField.type = TextFieldType.INPUT;
			txtField.x = 80;
			txtField.y = 680;
			txtField.width = 800;
			txtField.height = 60;
			txtField.border = true;
			txtField.selectable = true;
			txtField.restrict = "R|C|L|O|D|U|[0-9]|(|)";
			txtField.multiline = true;
			txtField.wordWrap = true;
			txtFormat = new TextFormat("arial", 20, 0x000000, true);
			txtField.text = "";
			txtField.setTextFormat(txtFormat);
			stage.addChild(txtField);
			code = txtField.text;
		}
		
		private function reset(e: MouseEvent):void
		{
			startButton.enable();
			codesVect.splice(0, codesVect.length);
			if (timer.running)
			{
				timer.stop();
				startButton.addEventListener(MouseEvent.CLICK, execute);
			}
			stageController.reset();
			count = 0;
			iterCount = "";
		}
		
		private function checkSolution(e:MouseEvent):void
		{
			stageController.checkSolution();
		}
	}
}
