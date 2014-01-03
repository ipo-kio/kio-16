package ru.ipo.kio.api_example {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.*;

import ru.ipo.kio.api.*;
import ru.ipo.kio.api.controls.GraphicsButton;
import ru.ipo.kio.api.controls.TextButton;

/**
 * Это спрайт для отображения задачи из примера API
 * @author Ilya
 */
public class ExampleProblemSprite extends Sprite {

    //Для примера укажем три картинки с кнопками. Взяты из задачи 11 года
    [Embed(source="resources/Button_01.png")]
    private static const BUTTON_1:Class;
    private static const BUTTON_1_BMP:BitmapData = new BUTTON_1().bitmapData;
    [Embed(source="resources/Button_02.png")]
    private static const BUTTON_2:Class;
    private static const BUTTON_2_BMP:BitmapData = new BUTTON_2().bitmapData;
    [Embed(source="resources/Button_03.png")]
    private static const BUTTON_3:Class;
    private static const BUTTON_3_BMP:BitmapData = new BUTTON_3().bitmapData;

    //текстовое поле - единственный видимый объект задачи
    private var textField:TextField;

    //конструктор спрайта, инициализация всех объектов
    public function ExampleProblemSprite(problem:KioProblem) {
        //получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
        var api:KioApi = KioApi.instance(problem);

        textField = new TextField();
        //в качестве текста для первоначального отображения устанавливаем текст, взятый из объекта локализации.
        //Далее он автоматически заменится на последний сохраненный вариант
        textField.text = api.localization.message;
        textField.autoSize = TextFieldAutoSize.LEFT;
        addChild(textField);
        textField.setTextFormat(new TextFormat(null, 16));
        textField.textColor = 0xFFFFFF;

        //разрешаем пользователю изменять текст
        textField.type = TextFieldType.INPUT;

        //устанавливаем слушатель на изменение текста
        textField.addEventListener(Event.CHANGE, function (e:Event):void {
            //просим api сохранить текущее решение, т.е. содержимое текстового поля (см. описание класса Pr1)
            api.autoSaveSolution();
            api.submitResult(currentResult());
        });

        api.addEventListener(KioApi.RECORD_EVENT, function (e:Event):void {
            trace(api.localization.record, api.record_result.length);
        });

        //для примера добвим две кнопки

        //TextButton - это простая текстовая кнопка только для целей отладки
        var textButton:TextButton = new TextButton(api.localization.buttons.but1, 100, 30);
        textButton.x = 300;
        textButton.y = 300;
        addChild(textButton);

        //GraphicsButton - это кнопка из картинок, такие постоянно используются, их рисуют художники
        var gButton:GraphicsButton = new GraphicsButton(
                api.localization.buttons.but2,
                BUTTON_1_BMP,
                BUTTON_2_BMP,
                BUTTON_3_BMP,
                KioApi.KIO_FONT, //здесь можно использовать только внедренные шрифты. Поэтому внедряйте сами или пользуйтесь этим
                16, 16, 2, 2
        );
        gButton.x = 300;
        gButton.y = 400;
        addChild(gButton);

        //вешаем на кнопки события, чтобы логгировать нажатия на кнопки
        textButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
            api.log('button 1 pressed @iIbBt', -123, 3000000000, 200, 200, 'aфывафыва');
            api.log('button 1 pressed extra log');
        });

        gButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
            api.log('button 2 pressed @sSsS', -10000, 40000, 40000, -10000);
        });
    }

    public function currentResult():Object {
        return {
            length: text.length
        };
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