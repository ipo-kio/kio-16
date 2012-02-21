package ru.ipo.kio._12.stagelights{
import fl.controls.Button;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.*;

import ru.ipo.kio.api.*;

/**
	 * Это спрайт с задачей, на нем рисуются все видимые объекты. В нашем случае единственный видимый объект - 
	 * это слово текстовое поле со сторокой текста
	 * @author Ilya
	 */
	public class StagelightsProblemSprite extends Sprite
	{
		
		//текстовое поле - единственный видимый объект задачи
		private var stagelight: Array = [];
		private var refreshButton: Button;
		private var nextButton: Button;
		private var crnt: int = 0;
		
		//конструктор спрайта, инициализация всех объектов
		//!!!! Важно. Параметры readonly и id необходимы для работы заглушек конкурса, в котором были выданы не все задачи
        //при разборе примера можно считать, что readonly = false, id = null
		public function StagelightsProblemSprite(readonly:Boolean, id:String = null)
		{
			//получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
			var api:KioApi = KioApi.instance(id ? id : StagelightsProblem.ID);
			
			stagelight[0] = new Stagelights(1);
			addChild(stagelight[0]);
			stagelight[1] = new Stagelights(0);
			addChild(stagelight[1]);
			
			stagelight[0].visible = true;
			stagelight[1].visible = false;  
			
			nextButton = new Button();
			nextButton.width = 160;
			nextButton.height = 26;
			nextButton.label = "Перейти ко второй части";
			nextButton.x = 680 - nextButton.width / 2;
			nextButton.y = 50; 
			nextButton.addEventListener(MouseEvent.CLICK, change);
			addChild(nextButton);
			
			refreshButton = new Button();
			refreshButton.width = 160;
			refreshButton.height = 26;
			refreshButton.label = "Новое условие задачи";
			refreshButton.x = 100 - refreshButton.width / 2;
			refreshButton.y = 50; 
			refreshButton.addEventListener(MouseEvent.CLICK, refresh);
			addChild(refreshButton);

			
			for (var i:int = 0; i < stagelights[0].spotlights.lenght; i++) {
				stagelights[0].spotlights[i].addEventListener(Event.CHANGE, function(e:Event):void {
				api.autoSaveSolution();
				});
			}
			for (var i:int = 0; i < stagelights[1].spotlights.lenght; i++) {
				stagelights[1].spotlights[i].addEventListener(Event.CHANGE, function(e:Event):void {
				api.autoSaveSolution();
				});
			}
		}
		
		public function get stagelights(): Array {
			return stagelight;
		}
		
		private function refresh(e: Event = null): void {
			stagelight[crnt].refresh();
		}
		
		private function change(e: Event = null): void {
			stagelight[0].visible = !stagelight[0].visible;
			stagelight[1].visible = !stagelight[1].visible;
			if (crnt == 0) {
				nextButton.label = "Перейти ко первой части";
				crnt = 1;
			} else {
				nextButton.label = "Перейти к второй части";
				crnt = 0;
			}
		}
	}

}