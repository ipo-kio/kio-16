package ru.ipo.kio._3x_pl_1 {

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import ru.ipo.kio.api.*;
import ru.ipo.kio.api.controls.GraphicsButton;

/**
 * Это спрайт для отображения задачи из примера API
 * @author Ilya
 */
public class X3Plus1ProblemSprite extends Sprite {

    //Для примера укажем три картинки с кнопками
    [Embed(source="computebutton/near.png")]
    private static const BUTTON_1:Class;
    private static const BUTTON_1_BMP:BitmapData = new BUTTON_1().bitmapData;
    [Embed(source="computebutton/above.png")]
    private static const BUTTON_2:Class;
    private static const BUTTON_2_BMP:BitmapData = new BUTTON_2().bitmapData;
    [Embed(source="computebutton/pessed.png")]
    private static const BUTTON_3:Class;
    private static const BUTTON_3_BMP:BitmapData = new BUTTON_3().bitmapData;
	//загрузка фона
	[Embed(source="resources/tetradnii_list_origami_yourorigami_info_0.2.png")]
	private static const BACKGROUND:Class;
    private static const BACKGROUND_BMP:BitmapData = new BACKGROUND().bitmapData;
		
    //текстовое поле - единственный видимый объект задачи
	private var api:KioApi;
	private var textField:InputTextField;
	private var stepsTextField:GraphicsTextField;
	private var countOfSteps:GraphicsResultField;
	private var maxStepOfSteps:GraphicsResultField;

	private var stepsCount:int;

    //создадим массив Array, в котором будет хранить результат каждого шага, (в методе cjmpute(x))
    //затем вычислим в массиве максимальный элемент
    //и отправим вторым параметром в качестве решения
    private var maxStepsResult:int;

    [Embed(source='resources/fontscore.com_s-segoe-print-bold.ttf', embedAsCFF="false", fontName="Segoe Print", mimeType='application/x-font-truetype')]
    private static var MyFont:Class;

    //конструктор спрайта, инициализация всех объектов
    public function X3Plus1ProblemSprite(problem:KioProblem) {
        //получаем доступ к API, для этого передаем в качестве параметра id нашей задачи
        api = KioApi.instance(problem);

        graphics.beginBitmapFill(BACKGROUND_BMP, null, false);
        graphics.drawRect(0, 0, 780, 600);
        graphics.endFill();

        textField = new InputTextField("Введите число");
        stepsTextField = new GraphicsTextField("Вычисление", 500, 200);
        countOfSteps = new GraphicsResultField("Число шагов");
        maxStepOfSteps = new GraphicsResultField("Максимальный шаг");
        var resultLabel:TextField = new TextField();
        var recordLabel:TextField = new TextField();
        var recordCountOfSteps:GraphicsResultField = new GraphicsResultField("Число шагов");
        var maxRecordStepOfSteps:GraphicsResultField = new GraphicsResultField("Максимальный шаг");

        resultLabel.selectable = false;
        resultLabel.width = 280;
        resultLabel.height = 60;
        resultLabel.text = api.localization.result;
        resultLabel.embedFonts = true;
        resultLabel.setTextFormat(new TextFormat("Segoe Print", 24, 0x08457e));
        resultLabel.x = 9;
        resultLabel.y = 168;

        recordLabel.selectable = false;
        recordLabel.width = 150;
        recordLabel.height = 60;
        recordLabel.text = api.localization.record;
        recordLabel.embedFonts = true;
        recordLabel.setTextFormat(new TextFormat("Segoe Print", 24, 0x08457e));
        recordLabel.x = 426;
        recordLabel.y = 168;

        recordCountOfSteps.x = 426;
        recordCountOfSteps.y = 205;
        maxRecordStepOfSteps.x = 426;
        maxRecordStepOfSteps.y = recordCountOfSteps.y + recordCountOfSteps.height;

        textField.x = 9;
        textField.y = 30;
        countOfSteps.x = 9;
        countOfSteps.y = 205;
        maxStepOfSteps.x = 9;
        maxStepOfSteps.y = countOfSteps.y + countOfSteps.height;
        stepsTextField.x = 9;
        stepsTextField.y = 325;

        api.addEventListener(KioApi.RECORD_EVENT, function (e:Event):void {
            recordCountOfSteps.text = api.record_result.totalsteps;
            maxRecordStepOfSteps.text = api.record_result.maxstep;
            // пусть новый рекорд появляется медленно (альфа меняется, а табличак "Рекорд" на время исчезает)
            var myRecordEffect:MyRecordEffect = new MyRecordEffect(api.localization.recordeffect, recordLabel);
            myRecordEffect.x = 426;
            myRecordEffect.y = 175;
            addChild(myRecordEffect);
            myRecordEffect.go();

            //trace("!!!!! NEW RECORD !!!!!", api.record_result.totalsteps + " " + api.record_result.maxstep);
        });

        //TextButton - это простая текстовая кнопка только для целей отладки
        var textButton:GraphicsButton = new GraphicsButton(
                api.localization.buttons.but1,
                BUTTON_1_BMP,
                BUTTON_2_BMP, //'\u21e8' →
                BUTTON_3_BMP,
                /*KioApi.KIO_FONT*/"Segoe Print", //здесь можно использовать только внедренные шрифты. Поэтому внедряйте сами или пользуйтесь этим
                20, 20, 0, 0
        );

        textButton.x = 360;
        textButton.y = textField.y + 7;

        //вешаем на кнопки события, чтобы логгировать нажатия на кнопки
        textButton.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            var numb:int = int(textField.text);
            currentSolutionChanged(numb);
            api.autoSaveSolution();
            api.submitResult(currentResult());
        });

        addChild(textField);
        addChild(stepsTextField);
        addChild(countOfSteps);
        addChild(maxStepOfSteps);
        addChild(recordCountOfSteps);
        addChild(maxRecordStepOfSteps);
        addChild(textButton);
        addChild(resultLabel);
        addChild(recordLabel);
    }
	
	public static function compute(x:Number):Array {
		var step:int = 0;
		var resultStr:String = "";
		var stepsResult:Array = [];

        while (x != 1) {
            if (x % 2 == 0) {
                x = divide2(x);
				stepsResult.push(x);
                step++;
            } else {
                x = make3TimesAndAdd1(x);
				stepsResult.push(x);
                step++;
            }
			resultStr = resultStr + " → " + x + "";
        }
        var maximum:int = maxResultOfSteps(stepsResult);

		return [step, resultStr, maximum];
	}
	
	private static function maxResultOfSteps(arr:Array):int {
		var max:int = 0;
		for (var k:int = 0; k < arr.length; k++) {
			if (arr[k] > max)
			max = arr[k];
		}
		return max;
	}

	private static function make3TimesAndAdd1(x:int):int {
        x = x * 3 + 1;
        return x;
    }

    private static function divide2(x:int):int {
        x = x / 2;
        return x;
    }
	
    public function currentResult():Object {
		return {
			totalsteps: stepsCount,
			maxstep: maxStepsResult
		};
    }
	
	public function currentSolutionChanged(numb:int):void {
		
        if (numb < 0) {
            countOfSteps.text = "";
            stepsTextField.text = api.localization.number_less_than_zero;
        } else if (numb == 0) {
            countOfSteps.text = "";
            stepsTextField.text = api.localization.number_equals_zero;
        } else {
            var computeResult:Array = compute(numb);
            stepsTextField.text = numb + computeResult[1];
            stepsCount = computeResult[0];
            maxStepsResult = computeResult[2];
            countOfSteps.text = "" + stepsCount;
            maxStepOfSteps.text = "" + maxStepsResult;
        }
        stepsTextField.updateScrollBar();
	}

    //разрешаем устанавливать и читать содержимое текстового поля
    public function set inputtext(t:String):void {
        textField.text = t;
    }

    public function get inputtext():String {
        return textField.text;
    }
	
//	public function set stepstext(t:String):void {
//        stepsTextField.myTextField.text = t;
//    }
//
//    public function get stepstext():String {
//        return stepsTextField.myTextField.text;
//    }
//
//	public function set counttext(t:String):void {
//        countOfSteps.myTextField.text = t;
//    }
//
//    public function get counttext():String {
//        return countOfSteps.myTextField.text;
//    }
}

}