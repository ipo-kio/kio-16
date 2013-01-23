package ru.ipo.kio.api_example{
import flash.display.Sprite;
import flash.events.Event;
import flash.text.*;

import ru.ipo.kio.api.*;

/**
	 * Это заглушка для задач, которые не готовы. Она находится в пакете с примером случайно. Читать не нужно
	 * @author Ilya
	 */
	public class StubProblemSprite extends Sprite
	{
		
		//текстовое поле - единственный видимый объект задачи
		private var textField:TextField;
		
		//конструктор спрайта, инициализация всех объектов
		//!!!! Важно. Параметры readonly и id необходимы для работы заглушек конкурса, в котором были выданы не все задачи
        //при разборе примера можно считать, что readonly = false, id = null
		public function StubProblemSprite(readonly:Boolean, id:String = null)
		{
			//получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
			var api:KioApi = KioApi.instance(id ? id : ExampleProblem.ID);
			
			textField = new TextField();
			//в качестве текста для отображения устанавливаем текст, взятый из объекта локализации
			textField.text = api.localization.message;
            textField.autoSize = TextFieldAutoSize.LEFT;
			addChild(textField);
			//разрешаем пользователю изменять текст
            if (!readonly)
			    textField.type = TextFieldType.INPUT;

            textField.setTextFormat(new TextFormat(null, 16));
            textField.textColor = 0xFFFFFF;

			//устанавливаем слушатель на изменение текста
			textField.addEventListener(Event.CHANGE, function(e:Event):void {
				//просим api сохранить текущее решение, т.е. содержимое текстового поля (см. описание класса Pr1)
				api.autoSaveSolution();
			});
		}
		
		//разрешаем устанавливать и читать содержимое текстового поля
		
		public function set text(t:String):void {
			textField.text = t;
		}
		
		public function get text():String {
			return textField.text;
		}
		
	}

}