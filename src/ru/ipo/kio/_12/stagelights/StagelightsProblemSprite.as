package ru.ipo.kio._12.stagelights{
import fl.controls.Button;
import fl.controls.Label;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import fl.events.SliderEvent;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.display.Shape;
import mx.core.BitmapAsset;
import flash.text.*;

import ru.ipo.kio.api.*;

/**
	 * Это спрайт с задачей, на нем рисуются все видимые объекты. В нашем случае единственный видимый объект - 
	 * это слово текстовое поле со сторокой текста
	 * @author Ilya
	 */
	public class StagelightsProblemSprite extends Sprite
	{
		
		[Embed (source = "_resources/bg.png" )] var bgLoad: Class;
		private var bg: BitmapAsset =  new bgLoad();
		
		//текстовое поле - единственный видимый объект задачи
		private var stagelight: Array = [];
		public var two: MovieClip;
		public var one: MovieClip;
		public var max0: Label;
		public var max1: Label;
		public var result0: Label;
		public var result1: Label;
		public var firstMax: Number;
		public var secondMax: Number
		public var firstResult: Array = [];
		public var secondResult: Array = [];
		public var bandages: int;
		public var bandage: Array = [];
		public var flag: Boolean = true;
		public var crnt: int = 0;
		public var max: Object;
		private var _api: KioApi;
		
		//конструктор спрайта, инициализация всех объектов
		//!!!! Важно. Параметры readonly и id необходимы для работы заглушек конкурса, в котором были выданы не все задачи
        //при разборе примера можно считать, что readonly = false, id = null
		public function StagelightsProblemSprite(readonly:Boolean, id:String = null)
		{
			//получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
			var api:KioApi = KioApi.instance(id ? id : StagelightsProblem.ID);
			_api = api;
			
			//var _mask:Shape = new Shape(); 
			//_mask.graphics.beginFill(0x000000); 
			//_mask.graphics.drawRect(0, 20, 780, 600); 
			//_mask.graphics.endFill(); 
			//
			//this.mask = _mask;
			addChild(bg);
			
			stagelight[0] = new Stagelights(1);
			addChild(stagelight[0]);
			stagelight[1] = new Stagelights(0);
			addChild(stagelight[1]);
			
			bandage[1] = new Bandage10();
			bandage[2] = new Bandage9();
			bandage[3] = new Bandage8();
			bandage[4] = new Bandage7();
			bandage[5] = new Bandage6();
			bandage[6] = new Bandage5();
			bandage[7] = new Bandage4();
			bandage[8] = new Bandage3();
			bandage[9] = new Bandage2();
			bandage[10] = new Bandage1();
			for (var k:int = 1; k < 11; k++) {
				stagelight[1].addChild(bandage[k]);
				bandage[k].visible = false;
				bandage[k].x = 384;
				bandage[k].y = 309;
			}
			if (results(0) >= 0 && results(0) <= 60) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[1].visible = true;
				bandages = 1;
			}
			if (results(0) >= 60 && results(0) <= 70) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[2].visible = true;
				bandages = 2;
			}
			if (results(0) >= 70 && results(0) <= 77) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[3].visible = true;
				bandages = 3;
			}
			if (results(0) >= 77 && results(0) <= 83) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[4].visible = true;
				bandages = 4;
			}
			if (results(0) >= 83 && results(0) <= 88) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[5].visible = true;
				bandages = 5;
			}
			if (results(0) >= 88 && results(0) <= 92) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[6].visible = true;
				bandages = 6;
			}
			if (results(0) >= 92 && results(0) <= 95) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[7].visible = true;
				bandages = 7;
			}
			if (results(0) >= 95 && results(0) <= 97) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[8].visible = true;
				bandages = 8;
			}
			if (results(0) >= 97 && results(0) <= 98) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[9].visible = true;
				bandages = 9;
			}
			if (results(0) >= 98 && results(0) <= 99) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[10].visible = true;
				bandages = 10;
			}
			if (results(0) >= 99 && results(0) <= 100) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
			}
			
			stagelight[0].visible = true;
			stagelight[1].visible = false;  
			
			firstMax = 0;
			secondMax = 0;
			
			firstResult[0] = stagelights[0].spotlights[0].spotlight.intensity;
			firstResult[1] = stagelights[0].spotlights[1].spotlight.intensity;
			firstResult[2] = stagelights[0].spotlights[2].spotlight.intensity;
			firstResult[3] = stagelights[0].bodies[4].body.red;
			firstResult[5] = stagelights[0].bodies[5].body.blue;
			firstResult[4] = stagelights[0].bodies[6].body.green;
			secondResult[0] = stagelights[1].spotlights[0].spotlight.intensity;
			secondResult[1] = stagelights[1].spotlights[1].spotlight.intensity;
			secondResult[2] = stagelights[1].spotlights[2].spotlight.intensity;
			secondResult[3] = stagelights[1].bodies[0].body.red;
			secondResult[4] = stagelights[1].bodies[0].body.green;
			secondResult[5] = stagelights[1].bodies[0].body.blue;
			
			two = new Two();
			two.x = 690;
			two.y = 510; 
			two.addEventListener(MouseEvent.CLICK, change);
			addChild(two);
			
			one = new One();
			one.x = 690;
			one.y = 510; 
			one.visible = false;
			one.addEventListener(MouseEvent.CLICK, change);
			addChild(one);
				
			var format: TextFormat = new TextFormat();
            format.color = 0x000000;
			format.font = "Tahoma";
			format.bold = true;
            format.size = 11;
			
			result0 = new Label();
			result0.x = 20;
			result0.y = 576;
			result0.textField.autoSize = TextFieldAutoSize.LEFT;
			result0.text = "Ваш результат для I фокуса: исчезновение на " + round(results(1)) + "%";
			result0.setStyle("textFormat", format);
			addChild(result0);
			
			max0 = new Label();
			max0.textField.autoSize = TextFieldAutoSize.LEFT;
			max0.setStyle("textFormat", format);
			max0.text = "Лучший результат для I фокуса: исчезновение на " + round(firstMax) + "%";
			max0.x = 700 - max0.textField.textWidth;
			max0.y = 576;
			addChild(max0);
			
			result1 = new Label();
			result1.x = 20;
			result1.y = 576;
			result1.textField.autoSize = TextFieldAutoSize.LEFT;
			result1.setStyle("textFormat", format);
			result1.text = "Ваш результат для II фокуса: исчезновение на " + round(results(0)) + "%";
			result1.visible = false;
			addChild(result1);
			
			max1 = new Label();
			max1.textField.autoSize = TextFieldAutoSize.LEFT;
			max1.setStyle("textFormat", format);
			max1.text = "Лучший результат для II фокуса: исчезновение на " + round(secondMax) + "%";
			max1.visible = false;
			max1.x = 700 - max1.textField.textWidth;
			max1.y = 576;
			addChild(max1);
			
			for (var i:int = 0; i < 3; i++) {
				stagelights[0].spotlights[i].spotlight.addEventListener(Event.CHANGE, updt);
				stagelights[0].intensitySliders[i].addEventListener(SliderEvent.CHANGE, function(e:Event):void {
				api.autoSaveSolution();
				refreshResult();
				});
				stagelights[0].intensitySliders[i].plus.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				api.autoSaveSolution();
				refreshResult();
				});
				stagelights[0].intensitySliders[i].minus.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				api.autoSaveSolution();
				refreshResult();
				});
			}
			for (var j:int = 0; j < 3; j++) {
				stagelights[1].spotlights[j].spotlight.addEventListener(Event.CHANGE, updt);
				stagelights[1].intensitySliders[j].addEventListener(SliderEvent.CHANGE, function(e:Event):void {
				api.autoSaveSolution();
				refreshResult();
				});
				stagelights[1].intensitySliders[j].plus.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				api.autoSaveSolution();
				refreshResult();
				});
				stagelights[1].intensitySliders[j].minus.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				api.autoSaveSolution();
				refreshResult();
				});
			}
			
			if (firstMax < results(1)) firstMax = results(1);
			if (secondMax < results(0)) secondMax = results(0);
			updt();
			
		}
		
		public function get stagelights(): Array {
			return stagelight;
		}
		
		private function refresh(e: Event = null): void {
			stagelight[crnt].refresh();
		}
		
		public function refreshResult(e: Event = null): void {
			if (firstMax < results(1) && secondMax <= results(0)) {
				trace("SAVE MAX");
				max = solution;
			}
			if (firstMax < results(1)) {	
				var time: Timer = new Timer(251, 4);
				time.start();	
				time.addEventListener(TimerEvent.TIMER, blinker);
				firstResult[0] = stagelights[0].spotlights[0].spotlight.intensity;
				firstResult[1] = stagelights[0].spotlights[1].spotlight.intensity;
				firstResult[2] = stagelights[0].spotlights[2].spotlight.intensity;
				firstResult[3] = stagelights[0].bodies[4].body.red;
				firstResult[5] = stagelights[0].bodies[5].body.blue;
				firstResult[4] = stagelights[0].bodies[6].body.green;
				firstMax = results(1);
				trace(firstMax);
				_api.saveBestSolution();
			}
			if (secondMax < results(0)) {
				var time: Timer = new Timer(251, 4);
				time.start();	
				time.addEventListener(TimerEvent.TIMER, blinker);
				secondResult[0] = stagelights[1].spotlights[0].spotlight.intensity;
				secondResult[1] = stagelights[1].spotlights[1].spotlight.intensity;
				secondResult[2] = stagelights[1].spotlights[2].spotlight.intensity;
				secondResult[3] = stagelights[1].bodies[0].body.red;
				secondResult[4] = stagelights[1].bodies[0].body.green;
				secondResult[5] = stagelights[1].bodies[0].body.blue;
				secondMax = results(0);
				trace(secondMax);
				_api.saveBestSolution();
			}
			if (results(0) >= 0 && results(0) <= 60) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[1].visible = true;
				bandages = 1;
			}
			if (results(0) >= 60 && results(0) <= 70) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[2].visible = true;
				bandages = 2;
			}
			if (results(0) >= 70 && results(0) <= 77) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[3].visible = true;
				bandages = 3;
			}
			if (results(0) >= 77 && results(0) <= 83) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[4].visible = true;
				bandages = 4;
			}
			if (results(0) >= 83 && results(0) <= 88) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[5].visible = true;
				bandages = 5;
			}
			if (results(0) >= 88 && results(0) <= 92) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[6].visible = true;
				bandages = 6;
			}
			if (results(0) >= 92 && results(0) <= 95) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[7].visible = true;
				bandages = 7;
			}
			if (results(0) >= 95 && results(0) <= 97) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[8].visible = true;
				bandages = 8;
			}
			if (results(0) >= 97 && results(0) <= 98) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[9].visible = true;
				bandages = 9;
			}
			if (results(0) >= 98 && results(0) <= 99) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
				bandage[10].visible = true;
				bandages = 10;
			}
			if (results(0) >= 99 && results(0) <= 100) {
				for (var k:int = 1; k < 11; k++) {
					bandage[k].visible = false;
				}
			}
			result0.text = "Ваш результат для I фокуса: исчезновение на " + round(results(1)) + "%";
			max0.text = "Лучший результат для I фокуса: исчезновение на " + round(firstMax) + "%";
			result1.text = "Ваш результат для II фокуса: исчезновение на " + round(results(0)) + "%";
			max1.text = "Лучший результат для II фокуса: исчезновение на " + round(secondMax) + "%";
		}
		
		private function updt(e:Event =  null): void {
			result0.text = "Ваш результат для I фокуса: исчезновение на " + round(results(1)) + "%";
			max0.text = "Лучший результат для I фокуса: исчезновение на " + round(firstMax) + "%";
			result1.text = "Ваш результат для II фокуса: исчезновение на " + round(results(0)) + "%";
			max1.text = "Лучший результат для II фокуса: исчезновение на " + round(secondMax) + "%";
		}
		
		
		private function blinker(e:Event =  null): void {
			stagelight[1].spotlights[0].light.visible = !stagelight[1].spotlights[0].light.visible;
			stagelight[1].spotlights[1].light.visible = !stagelight[1].spotlights[1].light.visible;
			stagelight[1].spotlights[2].light.visible = !stagelight[1].spotlights[2].light.visible;
			stagelight[1].spotlights[0].source.visible = !stagelight[1].spotlights[0].source.visible;
			stagelight[1].spotlights[1].source.visible = !stagelight[1].spotlights[1].source.visible;
			stagelight[1].spotlights[2].source.visible = !stagelight[1].spotlights[2].source.visible;
			stagelight[1].spotlights[0].osource.visible = !stagelight[1].spotlights[0].osource.visible;
			stagelight[1].spotlights[1].osource.visible = !stagelight[1].spotlights[1].osource.visible;
			stagelight[1].spotlights[2].osource.visible = !stagelight[1].spotlights[2].osource.visible;
			stagelight[0].bodies[0].visible = !stagelight[0].bodies[0].visible;
			stagelight[0].bodies[1].visible = !stagelight[0].bodies[1].visible;
			stagelight[0].bodies[2].visible = !stagelight[0].bodies[2].visible;
			stagelight[0].spotlights[0].source.visible = !stagelight[0].spotlights[0].source.visible;
			stagelight[0].spotlights[1].source.visible = !stagelight[0].spotlights[1].source.visible;
			stagelight[0].spotlights[2].source.visible = !stagelight[0].spotlights[2].source.visible;
			stagelight[0].spotlights[0].osource.visible = !stagelight[0].spotlights[0].osource.visible;
			stagelight[0].spotlights[1].osource.visible = !stagelight[0].spotlights[1].osource.visible;
			stagelight[0].spotlights[2].osource.visible = !stagelight[0].spotlights[2].osource.visible;
		}
		
		private function change(e: Event = null): void {
			stagelight[0].visible = !stagelight[0].visible;
			stagelight[1].visible = !stagelight[1].visible;
			if (crnt == 0) {
				one.visible = true;
				max1.visible = true;
				result0.visible = false;
				result1.visible = true;
				max0.visible = false;
				two.visible = false;
				crnt = 1;
			} else {
				one.visible = false;
				max0.visible = true;
				result1.visible = false;
				result0.visible = true;
				max1.visible = false;
				two.visible = true;
				crnt = 0;
			}
		}
		
		public function results(ccn: int): Number {
			if (ccn == 0) {
				var r: int = stagelight[1].spotlights[0].spotlight.intensity;
				var g: int = stagelight[1].spotlights[1].spotlight.intensity;
				var b: int = stagelight[1].spotlights[2].spotlight.intensity;
				var r1: int = stagelight[1].bodies[0].body.red;
				var g1: int = stagelight[1].bodies[0].body.green;
				var b1: int = stagelight[1].bodies[0].body.blue;
				return (1 - calc(r, g, b, r1, g1, b1) / calc(0, 0, 0, 255, 255, 255)) * 100;
			} else {
				var r: int = stagelight[0].bodies[0].body.red;
				var g: int = stagelight[0].bodies[1].body.green;
				var b: int = stagelight[0].bodies[2].body.blue;
				var r1: int = stagelight[0].bodies[4].body.red;
				var g1: int = stagelight[0].bodies[6].body.green;
				var b1: int = stagelight[0].bodies[5].body.blue;
				return (1 - calc(r, g, b, r1, g1, b1) / calc(0, 0, 0, 255, 255, 255)) * 100;
			}
		}
		
		private function calc(r1: int, g1: int, b1: int, r2: int, g2: int, b2: int): Number {
			return Math.pow(r1 - r2, 2) + Math.pow(g1 - g2, 2) + Math.pow(b1 - b2, 2);
		}
		
		public function round(a: Number): Number {
			return Math.round(a * 100) / 100;
		}
		
		public function get solution():Object {
			var first: Array = [];
			var fmax: int = firstMax;
			var smax: int = secondMax;
			if (stagelights[0].visible) {
				first[0] = stagelights[0].spotlights[0].spotlight.intensity;
				first[1] = stagelights[0].spotlights[1].spotlight.intensity;
				first[2] = stagelights[0].spotlights[2].spotlight.intensity;
				first[3] = stagelights[0].bodies[4].body.red;
				first[5] = stagelights[0].bodies[5].body.blue;
				first[4] = stagelights[0].bodies[6].body.green;
			} else {
				first[0] = firstResult[0];
				first[1] = firstResult[1];
				first[2] = firstResult[2];
				first[3] = firstResult[3];
				first[5] = firstResult[5];
				first[4] = firstResult[4];	
			}
			var second: Array = [];
			if (stagelights[0].visible) {
				second[0] = secondResult[0];
				second[1] = secondResult[1];
				second[2] = secondResult[2];
				second[3] = secondResult[3];
				second[5] = secondResult[5];
				second[4] = secondResult[4];	
			} else {
				second[0] = stagelights[1].spotlights[0].spotlight.intensity;
				second[1] = stagelights[1].spotlights[1].spotlight.intensity;
				second[2] = stagelights[1].spotlights[2].spotlight.intensity;
				second[3] = stagelights[1].bodies[0].body.red;
				second[4] = stagelights[1].bodies[0].body.green;
				second[5] = stagelights[1].bodies[0].body.blue;	
			}
			return {
				first : first,
				second : second,
				firstMax: fmax,
				secondMax: smax,
				visible: stagelights[0].visible,
				bandages: bandages
			};
		}
	}

}