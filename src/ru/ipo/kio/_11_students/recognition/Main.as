package ru.ipo.kio._11_students.recognition
{
import flash.display.*;
import flash.events.*;
import flash.text.*;
import flash.utils.Timer;

/**
	 * ...
	 * @author Dmitriy
	 */
	//[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public var andLeftResult: Array = new Array(); // массив, содержащий входящие значения в левые контакты блока
		public var andRightResult: Array = new Array(); //массив, содержащий входящие значения в правые контакты блока
		public var andAimResult: Array = new Array(); // массив , содержащий исходящие значения после блока
        public var andTull: Array = new Array()//массив тел блока и
		public var andLeft:Array = new Array();//массив левых контактов блока и
		public var andRight:Array = new Array();//массив правых контактов блокаи
		public var andAim:Array = new Array();//массив результирующих элементов блока и
		
		public var orLeftResult: Array = new Array(); // массив, содержащий входящие значения в левые контакты блока
		public var orRightResult: Array = new Array(); //массив, содержащий входящие значения в правые контакты блока
		public var orAimResult: Array = new Array(); // массив , содержащий исходящие значения после блока
        public var orTull: Array = new Array()//массив тел блока или
		public var orLeft:Array = new Array();//массив левых контактов блока или
		public var orRight:Array = new Array();//массив правых контактов блока или
		public var orAim:Array = new Array();//массив результирующих элементов блока или
		
		public var notRightResult: Array = new Array(); //массив, содержащий входящие значения в контакты блока
		public var notAimResult: Array = new Array(); // массив , содержащий исходящие значения после блока
        public var notTull: Array = new Array()//массив тел блока не
		public var notRight:Array = new Array();//массив левых контактов блока не
		public var notAim:Array = new Array();//массив результирующих элементов блока не
		
		public var nonRightResult: Array = new Array(); //массив, содержащий входящие значения в контакты блока
		public var nonAimResult: Array = new Array(); // массив , содержащий исходящие значения после блока
        public var nonTull: Array = new Array()//массив тел пустого блока 
		public var nonRight:Array = new Array();//массив левых контактов пустого блока 
		public var nonAim:Array = new Array();//массив результирующих элементов пустого блока 
		
		public var andLineAim:Array = new Array(); //массив линий соединяющих блок "и" и цель 
		public var andLineR:Array = new Array(); //массив линий соединяющих блок "и" и правый контакт 
		public var andLineL:Array = new Array(); //массив линий соединяющих блок "и" и левый контакт 
		
		public var orLineAim:Array = new Array(); //массив линий соединяющих блок "или" и цель
		public var orLineR:Array = new Array(); //массив линий соединяющих блок "или"  правый контакт
		public var orLineL:Array = new Array(); //массив линий соединяющих блок "или" левый контакт
		
		public var notLineAim:Array = new Array(); //массив линий соединяющих блок "не"и цель
		public var notLineR:Array = new Array(); //массив линий соединяющих блок "не" и правый контакт
		
		public var nonLineAim:Array = new Array(); //массив линий соединяющих блок "не"и цель
		public var nonLineR:Array = new Array(); //массив линий соединяющих блок "не" и правый контакт
		
		public var controlAnswer:Array = new Array();
			
		public var leftAndHit:Array = new Array();//показатель присоединения левого контакта блока И
		public var rightAndHit:Array = new Array();//показатель присоединения правого контакта блока И
		
		public var leftOrHit:Array = new Array();//показатель присоединения левого контакта блока ИЛИ
		public var rightOrHit:Array = new Array();//показатель присоединения правого контакта блока ИЛИ
		
		public var rightNotHit:Array = new Array();//показатель присоединения контакта блока НЕ
		
		public var rightNonHit:Array = new Array();//показатель присоединения контакта пустого блока
		
		public var additLineLAnd:Array = new Array();//линия выделения левого провода блока И 
		public var lineLAddAnd:Array = new Array;// показатель выделенности левой линии блока И
		
		public var lineLAddOr:Array = new Array;// показатель выделенности левой линии блока Или
		public var additLineLOr:Array = new Array();//линия выделения левого провода блока Или
		
		public var additLineRNot:Array = new Array();//линия выделения левого провода блока НЕ
		public var lineRAddNot:Array = new Array;// показатель выделенности левой линии блока Не
		
		public var additLineRNon:Array = new Array();//линия выделения левого провода пустого блока 
		public var lineRAddNon:Array = new Array;// показатель выделенности левой линии пустого блока 
		
		public var complite:int = 0;
		public var complite2:int = 0;
		public var complite3:int = 0;
		public var complite4:int = 0;
		
		public var additLineRAnd:Array = new Array();//линия выделения правого провода блока И
		public var lineRAddAnd:Array = new Array;// показатель выделенности правой линии блока И
		
		public var lineRAddOr:Array = new Array;// показатель выделенности правой линии блока Или
		public var additLineROr:Array = new Array();//линия выделения правого провода блока Или
		
		public var myVar:int = 0;// xитрая глобальная переменная(костыль для программы) 
		public var myVar2:int = 0;// xитрая глобальная переменная(костыль для программы)
		public var myVar3:int = 0;// xитрая глобальная переменная(костыль для программы)
		public var myVar4:int = 0;
		public var myVar5:int = 0;
		
		public var answerCon:Array = new Array();
		public var answerConAim:Array = new Array();
		public var answerConLine:Array = new Array();
				
		public var NumberBlokcs:int = 0;//количество используемых блоков
		public var Result:int = 0; // Переменная содержащая результат 
		public var Record_NumberBlokcs:int = 0;// Переменная содержащая рекорд количества блоков
		public var Record_Result:int = 0;// Переменная содержащая рекорд количества правильно рапознаных цифр
		public var t_result:TextField = new TextField();// Текстовое поле для результата
		public var t_nB:TextField = new TextField();//Текстовое поле для количествва блоков
		public var t_record_result:TextField = new TextField();// Текстовое поле для результата
		public var t_record_numberBlokcs:TextField = new TextField();//Текстовое поле для количествва блоков
		
		
		public var NUM_first_Break_lamp:int = 11; 
		public var NUM_second_Break_lamp:int = 11;
		
		public var numAnd:int = 0;
		public var numOr:int = 0;
		public var numNot:int = 0;
		public var numNon:int = 0;
		
		public var ButtonDown:Boolean;
		
		public var bin:Sprite = new Sprite(); //корзина		
		public var level:int = 1;
		public var NUM:int = 0;
		public var NUM_1:int = 0;
        public var circle_lamp_Green_prov:Array = new Array(); // массив содержащий все зеленые круглые лампочки конечной проверки
		public var circle_lamp_Red_prov:Array = new Array(); // массив содержащий все красные круглые лампочки конечной проверк
		public var circle_lamp_Green:Array = new Array(); // массив содержащий все зеленые круглые лампочки контакты
		public var circle_lamp_Red:Array = new Array(); // массив содержащий все красные круглые лампочки контакты
		public var rect_lamp_Green:Array = new Array(); // массив содержащий все зеленые лампочки
		public var rect_lamp_Green_Down:Array = new Array(); 
	
		public var timer:Timer = new Timer(4000, 10);
		
		
		[Embed(source="Background+Robot.jpg")]
		public static const INPUT_BG:Class; //заводим поле - константа
        [Embed(source="Lamp_H_01.png")]
		public static const Lamp_H_01:Class;
		[Embed(source="Lamp_H_03.png")]
		public static const Lamp_H_03:Class;
		[Embed(source="Big_Button_01.jpg")]
		public static const Big_Button_01:Class;
		[Embed(source="Wires_02.png")]
		public static const Wires_02:Class;
		[Embed(source="Big_Button_02.jpg")]
		public static const Big_Button_02:Class;
		[Embed(source="Big_Button_03.jpg")]
		public static const Big_Button_03:Class;
		[Embed(source="Small_Button_01.jpg")]
		public static const Small_Button_01:Class;
		[Embed(source="Small_Button_02.jpg")]
		public static const Small_Button_02:Class;
		[Embed(source="Small_Button_03.jpg")]
		public static const Small_Button_03:Class;
		
		[Embed(source="And_01.png")]
		public static const And_01:Class;
		[Embed(source="Or_01.png")]
		public static const Or_01:Class;
		[Embed(source="Not_01.png")]
		public static const Not_01:Class;
		
		[Embed(source="Basket_02.png")]
		public static const Basket_02:Class;
		public function Main():void 
		{
			
			var i:int;	
			var bg:Sprite = new Sprite();
			var bmp:* = new INPUT_BG;
			bg.addChild(bmp); //добавляем картинку на спрайт
			addChild(bg);
			
			var bmp_bin:* = new Basket_02;
			bin.addChild(bmp_bin); 
			bin.x = 670;
			bin.y = 410 ;
			addChild(bin);
			
			createNum();
			createCont();
			createCont_Prov();
			Buttons();			
			text_fields();
			for (i = 0; i < 10; i++)
			{
				createAnswer(i);
			}
			//--------------------------------------------------------
			addEventListener(Event.ENTER_FRAME, controlLamp);
		}
		//===================================================
		public function text_fields():void
		{
		
			
			
			//-----------------------------------------------------------
			// текстовые поля вывода результата
			var text_result:TextField = new TextField();
			text_result.autoSize = TextFieldAutoSize.LEFT;
			text_result.text = "Результат:";
			text_result.x = 440;
			text_result.y = 415;			
			addChild(text_result);
			
			var text_result_1:TextField = new TextField();
			text_result_1.autoSize = TextFieldAutoSize.LEFT;
			text_result_1.text = "Распознаются:";
			text_result_1.x = 435;
			text_result_1.y = 435;			
			addChild(text_result_1);
			
			
			t_result.autoSize = TextFieldAutoSize.LEFT;
			t_result.text = ''+Result+' цифр из 10';
			t_result.x = 435;
			t_result.y = 450;			
			addChild(t_result);				
			//-----------------------------------------------------------------
			// текстовые поля вывода количества блоков
			var text_numberBlokcs:TextField = new TextField();
			text_numberBlokcs.autoSize = TextFieldAutoSize.LEFT;
			text_numberBlokcs.text = "Элементов";
			text_numberBlokcs.x = 435;
			text_numberBlokcs.y = 465;			
			addChild(text_numberBlokcs);
			
			
			t_nB.autoSize = TextFieldAutoSize.LEFT;
			t_nB.text =  '  '+NumberBlokcs;
			t_nB.x = 490;
			t_nB.y = 465;			
			addChild(t_nB);	
			//-------------------------------------------------------------
			// текстовые поля вывода рекорда
			var text_record_result:TextField = new TextField();
			text_record_result.autoSize = TextFieldAutoSize.LEFT;
			text_record_result.text = "Рекорд:";
			text_record_result.x = 565;
			text_record_result.y = 415;			
			addChild(text_record_result);
			
			var text_result_2:TextField = new TextField();
			text_result_2.autoSize = TextFieldAutoSize.LEFT;
			text_result_2.text = "Распознаются:";
			text_result_2.x = 560;
			text_result_2.y = 435;			
			addChild(text_result_2);
			
			t_record_result.autoSize = TextFieldAutoSize.LEFT;
			t_record_result.text =  ''+Record_Result+' цифр из 10';
			t_record_result.x = 560;
			t_record_result.y =450;			
			addChild(t_record_result);				
			//-----------------------------------------------------------------
			// текстовые поля вывода рекорда
			var text_record_numberBlokcs:TextField = new TextField();
			text_record_numberBlokcs.autoSize = TextFieldAutoSize.LEFT;
			text_record_numberBlokcs.text = "Элементов";
			text_record_numberBlokcs.x = 560;
			text_record_numberBlokcs.y = 465;			
			addChild(text_record_numberBlokcs);
			
			
			t_record_numberBlokcs.autoSize = TextFieldAutoSize.LEFT;
			t_record_numberBlokcs.text =  '  '+Record_NumberBlokcs;
			t_record_numberBlokcs.x = 610;
			t_record_numberBlokcs.y = 465;			
			addChild(t_record_numberBlokcs);			
			//-------------------------------------------------------------			
			}
		//===================================================
public function test_continius(e:Event):void
{
			var i:int;	
			// блокировка скобок
						
	for (i = 0; i < 10 ; i++)
	{
				// цифра 0 на табло
		if (i == 0)
		{
			     if ( level == 2)
				{
					rect_lamp_Green[3].visible = false;
			        circle_lamp_Green[3].visible = false;
					rect_lamp_Green[7].visible = false;
			        circle_lamp_Green[7].visible = false;
					rect_lamp_Green[8].visible = false;
			        circle_lamp_Green[8].visible = false;
				}
				else
				{
				   rect_lamp_Green[3].visible = false;
			       circle_lamp_Green[3].visible = false;
				}
			// get_result(NUM);
		}
			 // цифра 1 на табло
		if (i == 1)
		{
				rect_lamp_Green[3].visible = true;
				circle_lamp_Green[3].visible = true;					
				rect_lamp_Green[7].visible = true;
				circle_lamp_Green[7].visible = true;
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;	
					
			if (level == 2)
			{
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;	
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;	
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;			 
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			}
			else
			{
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;	
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;	
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;	
			}
			// get_result(NUM);
		}		
			 // цифра 2 на табло
		if (i == 2)
		{						
				rect_lamp_Green[0].visible = true;
				circle_lamp_Green[0].visible = true;	
				rect_lamp_Green[1].visible = true;
				circle_lamp_Green[1].visible = true;	
				rect_lamp_Green[3].visible = true;
				circle_lamp_Green[3].visible = true;
				rect_lamp_Green[4].visible = true;
				circle_lamp_Green[4].visible = true;
				rect_lamp_Green[5].visible = true;
				circle_lamp_Green[5].visible = true;			 
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;			
			 
			 if (level == 2)
			 {
			   rect_lamp_Green[0].visible = false;
			   circle_lamp_Green[0].visible = false;			 
			   rect_lamp_Green[6].visible = false;
			   circle_lamp_Green[6].visible = false;
			   rect_lamp_Green[3].visible = false;
			   circle_lamp_Green[3].visible = false;
			   rect_lamp_Green[4].visible = false;
			   circle_lamp_Green[4].visible = false;
			   rect_lamp_Green[7].visible = false;
			   circle_lamp_Green[7].visible = false;
			 }
			 else
			 {
			   rect_lamp_Green[0].visible = false;
			   circle_lamp_Green[0].visible = false;			 
			   rect_lamp_Green[6].visible = false;
			   circle_lamp_Green[6].visible = false;
			 }
			// get_result(NUM);
		}
			 // цифра 3 на табло
	    if (i ==3)
		{		 
			   rect_lamp_Green[0].visible = true;
			   circle_lamp_Green[0].visible = true;			 
			   rect_lamp_Green[6].visible = true;
			   circle_lamp_Green[6].visible = true;
			   rect_lamp_Green[3].visible = true;
			   circle_lamp_Green[3].visible = true;
			   rect_lamp_Green[4].visible = true;
			   circle_lamp_Green[4].visible = true;
			   rect_lamp_Green[7].visible = true;
			   circle_lamp_Green[7].visible = true;	
			   
			 if (level == 2)
			 {
			   rect_lamp_Green[0].visible = false;
			   circle_lamp_Green[0].visible = false;			 
			   rect_lamp_Green[2].visible = false;
			   circle_lamp_Green[2].visible = false;
			   rect_lamp_Green[4].visible = false;
			   circle_lamp_Green[4].visible = false;
			   rect_lamp_Green[5].visible = false;
			   circle_lamp_Green[5].visible = false;
			   rect_lamp_Green[6].visible = false;
			   circle_lamp_Green[6].visible = false; 				 
			 }
			 else 
			 {			
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;				
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;
			 }
			// get_result(NUM);
		} 
			 // цифра 4 на табло
		if (i ==4)
		{		 
			   rect_lamp_Green[0].visible = true;
			   circle_lamp_Green[0].visible = true;			 
			   rect_lamp_Green[2].visible = true;
			   circle_lamp_Green[2].visible = true;
			   rect_lamp_Green[4].visible = true;
			   circle_lamp_Green[4].visible = true;
			   rect_lamp_Green[5].visible = true;
			   circle_lamp_Green[5].visible = true;
			   rect_lamp_Green[6].visible = true;
			   circle_lamp_Green[6].visible = true; 				
			 
			 if (level == 2)
			 {
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;			 	
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;			 
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;
				rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;			 
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			 }
			 else
			 {		   
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;			 	
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;			 
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;
			 }
			// get_result(NUM);
		} 
			 // цифра 5 на табло
		if (i ==5)
		{		 
				rect_lamp_Green[1].visible = true;
				circle_lamp_Green[1].visible = true;			 	
				rect_lamp_Green[4].visible = true;
				circle_lamp_Green[4].visible = true;			 
				rect_lamp_Green[5].visible = true;
				circle_lamp_Green[5].visible = true;
				rect_lamp_Green[7].visible = true;
				circle_lamp_Green[7].visible = true;			 
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;			 
			 
			if (level == 2)
			{
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;	
				rect_lamp_Green[4].visible = false;;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;	
				rect_lamp_Green[8].visible = false;;
				circle_lamp_Green[8].visible = false;
			 
			}
			else
			{			 
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;	
				rect_lamp_Green[4].visible = false;;
				circle_lamp_Green[4].visible = false;
			} 
			 //get_result(NUM);
		}
			 // цифра 6 на табло
		if (i ==6)
		{			 
				rect_lamp_Green[2].visible = true;
				circle_lamp_Green[2].visible = true;	
				rect_lamp_Green[4].visible = true;
				circle_lamp_Green[4].visible = true;
				rect_lamp_Green[7].visible = true;
				circle_lamp_Green[7].visible = true;	
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;				
			if (level == 2)
			{
				rect_lamp_Green[2].visible = false;
			    circle_lamp_Green[2].visible = false;
				rect_lamp_Green[0].visible = false;
			    circle_lamp_Green[0].visible = false;
				rect_lamp_Green[1].visible = false;
			    circle_lamp_Green[1].visible = false;
				rect_lamp_Green[8].visible = false;
			    circle_lamp_Green[8].visible = false;
			}
			else
			{ 
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;		 
			} 
			// get_result(NUM);
		}
			 // цифра 7 на табло
		if (i ==7)
		{			 
			 	
			    rect_lamp_Green[2].visible = true;
			    circle_lamp_Green[2].visible = true;
				rect_lamp_Green[0].visible = true;
			    circle_lamp_Green[0].visible = true;
				rect_lamp_Green[1].visible = true;
			    circle_lamp_Green[1].visible = true;
				rect_lamp_Green[8].visible = true;
			    circle_lamp_Green[8].visible = true;		 
			 	
			if (level == 2)
			{
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;				 		 
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;
				rect_lamp_Green[6].visible = false;
				circle_lamp_Green[6].visible = false;
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			}
			else
			{
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;				 		 
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;			 
			}
			 //get_result(NUM);			
		}
			 // цифра 8 на табло
		if (i ==8)
		{			
			    rect_lamp_Green[0].visible = true;
				circle_lamp_Green[0].visible = true;				 		 
				rect_lamp_Green[2].visible = true;
				circle_lamp_Green[2].visible = true;
				rect_lamp_Green[3].visible = true;
				circle_lamp_Green[3].visible = true;
				rect_lamp_Green[5].visible = true;
				circle_lamp_Green[5].visible = true;
				rect_lamp_Green[6].visible = true;
				circle_lamp_Green[6].visible = true;
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;
				rect_lamp_Green[4].visible = true;
				circle_lamp_Green[4].visible = true;
			
			if (level == 2)
			{
				rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			}
			 
			 //get_result(NUM);
		}
			 // цифра 9 на табло
		if (i==9)
		{	    
				rect_lamp_Green[7].visible = true;
				circle_lamp_Green[7].visible = true;
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;
				
			if (level == 2)
			{
				rect_lamp_Green[4].visible = false;
			    circle_lamp_Green[4].visible = false;
			    rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;
				rect_lamp_Green[5].visible = false;
			    circle_lamp_Green[5].visible = false;
				rect_lamp_Green[6].visible = false;
			    circle_lamp_Green[6].visible = false;
			}
			else
			{
			 rect_lamp_Green[4].visible = false;
			 circle_lamp_Green[4].visible = false;				 
			}
		}	
		controllaContattonot(e);
		controllaContattoor(e);
		controllaContatto(e);
		controlLamp(e);//вставлено чтобы для блока не евент сработал до  обработки результата, иначе результат не зачтётся
		get_result(i);
		Record();
	}		  	
}
		//===================================================
		public function test_step(e:Event):void
		{
			// блокировка кнопок
			
			// цифра 0 на табло
			
		if (NUM == 0)
		{
			        for (var i:int = 0; i < 9; i++)
				     {
				        rect_lamp_Green[i].visible = true;
				        circle_lamp_Green[i].visible = true;					
				     }	
					rect_lamp_Green[3].visible = false;
			        circle_lamp_Green[3].visible = false;
					rect_lamp_Green[7].visible = false;
			        circle_lamp_Green[7].visible = false;
					rect_lamp_Green[8].visible = false;
			        circle_lamp_Green[8].visible = false;
				
			 //get_result(NUM);
		}
		
			 // цифра 1 на табло
		if (NUM == 1)
		{
			    for (var i:int = 0; i < 9; i++)
				{
				   rect_lamp_Green[i].visible = true;
				   circle_lamp_Green[i].visible = true;					
				}	
			
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;	
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;	
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;			 
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			
			// get_result(NUM);
		}		
			 // цифра 2 на табло
		if (NUM == 2)
		{						
				for (var i:int = 0; i < 9; i++)
				{
				   rect_lamp_Green[i].visible = true;
				   circle_lamp_Green[i].visible = true;					
				}				
			 
			
			   rect_lamp_Green[0].visible = false;
			   circle_lamp_Green[0].visible = false;			 
			   rect_lamp_Green[6].visible = false;
			   circle_lamp_Green[6].visible = false;
			   rect_lamp_Green[3].visible = false;
			   circle_lamp_Green[3].visible = false;
			   rect_lamp_Green[4].visible = false;
			   circle_lamp_Green[4].visible = false;
			   rect_lamp_Green[7].visible = false;
			   circle_lamp_Green[7].visible = false;
			 
			// get_result(NUM);
		}
			 // цифра 3 на табло
	    if (NUM ==3)
		{		 
			   for (var i:int = 0; i < 9; i++)
				{
				   rect_lamp_Green[i].visible = true;
				   circle_lamp_Green[i].visible = true;					
				}		
			   
			 
			   rect_lamp_Green[0].visible = false;
			   circle_lamp_Green[0].visible = false;			 
			   rect_lamp_Green[2].visible = false;
			   circle_lamp_Green[2].visible = false;
			   rect_lamp_Green[4].visible = false;
			   circle_lamp_Green[4].visible = false;
			   rect_lamp_Green[5].visible = false;
			   circle_lamp_Green[5].visible = false;
			   rect_lamp_Green[6].visible = false;
			   circle_lamp_Green[6].visible = false; 				 
			 
			// get_result(NUM);
		} 
			 // цифра 4 на табло
		if (NUM ==4)
		{		 
			   for (var i:int = 0; i < 9; i++)
				{
				   rect_lamp_Green[i].visible = true;
				   circle_lamp_Green[i].visible = true;					
				}					
			 
			 
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;			 	
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;			 
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;
				rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;			 
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			 
			// get_result(NUM);
		} 
			 // цифра 5 на табло
		if (NUM ==5)
		{		 
				for (var i:int = 0; i < 9; i++)
				{
				   rect_lamp_Green[i].visible = true;
				   circle_lamp_Green[i].visible = true;					
				}				 
			 
			
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;	
				rect_lamp_Green[4].visible = false;;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;	
				rect_lamp_Green[8].visible = false;;
				circle_lamp_Green[8].visible = false;
			 
			
			 //get_result(NUM);
		}
			 // цифра 6 на табло
		if (NUM ==6)
		{			 
				for (var i:int = 0; i < 9; i++)
				{
				   rect_lamp_Green[i].visible = true;
				   circle_lamp_Green[i].visible = true;					
				}					
			
				rect_lamp_Green[2].visible = false;
			    circle_lamp_Green[2].visible = false;
				rect_lamp_Green[0].visible = false;
			    circle_lamp_Green[0].visible = false;
				rect_lamp_Green[1].visible = false;
			    circle_lamp_Green[1].visible = false;
				rect_lamp_Green[8].visible = false;
			    circle_lamp_Green[8].visible = false;
			
			// get_result(NUM);
		}
			 // цифра 7 на табло
		if (NUM ==7)
		{			 
			 	
			    for (var i:int = 0; i < 9; i++)
				{
				   rect_lamp_Green[i].visible = true;
				   circle_lamp_Green[i].visible = true;					
				}		 
			 	
			
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;				 		 
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;
				rect_lamp_Green[6].visible = false;
				circle_lamp_Green[6].visible = false;
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			
			 //get_result(NUM);			
		}
			 // цифра 8 на табло
		if (NUM ==8)
		{			
			    for (var i:int = 0; i < 9; i++)
				{
				   rect_lamp_Green[i].visible = true;
				   circle_lamp_Green[i].visible = true;					
				}	
			
			
				rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			
			 
			 //get_result(NUM);
		}
			 // цифра 9 на табло
		if (NUM ==9)
		{	    
				for (var i:int = 0; i < 9; i++)
				{
				   rect_lamp_Green[i].visible = true;
				   circle_lamp_Green[i].visible = true;					
				}	
				
			
				rect_lamp_Green[4].visible = false;
			    circle_lamp_Green[4].visible = false;
			    rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;
				rect_lamp_Green[5].visible = false;
			    circle_lamp_Green[5].visible = false;
				rect_lamp_Green[6].visible = false;
			    circle_lamp_Green[6].visible = false;
			
		}	
		
		controllaContattonot(e);
		controllaContattoor(e);
		controllaContatto(e);
		controlLamp(e);//вставлено чтобы для блока не евент сработал до  обработки результата, иначе результат не зачтётся
		get_result(NUM);
		Record();		
		}
		//===============================================================================================
		public function test(e:Event):void
		{			
			// блокировка кнопок
			
			
			timer.addEventListener(TimerEvent.TIMER, test_time);
			timer.start();
			
		}
		public function test_time(e:Event):void
		{		
				// цифра 0 на табло
		if (NUM_1 == 0)
		{
			     if ( level == 2)
				{
					rect_lamp_Green[3].visible = false;
			        circle_lamp_Green[3].visible = false;
					rect_lamp_Green[7].visible = false;
			        circle_lamp_Green[7].visible = false;
					rect_lamp_Green[8].visible = false;
			        circle_lamp_Green[8].visible = false;
				}
				else
				{
				   rect_lamp_Green[3].visible = false;
			       circle_lamp_Green[3].visible = false;
				}
			// get_result(NUM);
		}
			 // цифра 1 на табло
		if (NUM_1 == 1)
		{
				rect_lamp_Green[3].visible = true;
				circle_lamp_Green[3].visible = true;					
				rect_lamp_Green[7].visible = true;
				circle_lamp_Green[7].visible = true;
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;	
					
			if (level == 2)
			{
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;	
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;	
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;			 
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			}
			else
			{
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;	
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;	
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;	
			}
			// get_result(NUM);
		}		
			 // цифра 2 на табло
		if (NUM_1 == 2)
		{						
				rect_lamp_Green[0].visible = true;
				circle_lamp_Green[0].visible = true;	
				rect_lamp_Green[1].visible = true;
				circle_lamp_Green[1].visible = true;	
				rect_lamp_Green[3].visible = true;
				circle_lamp_Green[3].visible = true;
				rect_lamp_Green[4].visible = true;
				circle_lamp_Green[4].visible = true;
				rect_lamp_Green[5].visible = true;
				circle_lamp_Green[5].visible = true;			 
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;			
			 
			 if (level == 2)
			 {
			   rect_lamp_Green[0].visible = false;
			   circle_lamp_Green[0].visible = false;			 
			   rect_lamp_Green[6].visible = false;
			   circle_lamp_Green[6].visible = false;
			   rect_lamp_Green[3].visible = false;
			   circle_lamp_Green[3].visible = false;
			   rect_lamp_Green[4].visible = false;
			   circle_lamp_Green[4].visible = false;
			   rect_lamp_Green[7].visible = false;
			   circle_lamp_Green[7].visible = false;
			 }
			 else
			 {
			   rect_lamp_Green[0].visible = false;
			   circle_lamp_Green[0].visible = false;			 
			   rect_lamp_Green[6].visible = false;
			   circle_lamp_Green[6].visible = false;
			 }
			// get_result(NUM);
		}
			 // цифра 3 на табло
	    if (NUM_1 ==3)
		{		 
			   rect_lamp_Green[0].visible = true;
			   circle_lamp_Green[0].visible = true;			 
			   rect_lamp_Green[6].visible = true;
			   circle_lamp_Green[6].visible = true;
			   rect_lamp_Green[3].visible = true;
			   circle_lamp_Green[3].visible = true;
			   rect_lamp_Green[4].visible = true;
			   circle_lamp_Green[4].visible = true;
			   rect_lamp_Green[7].visible = true;
			   circle_lamp_Green[7].visible = true;	
			   
			 if (level == 2)
			 {
			   rect_lamp_Green[0].visible = false;
			   circle_lamp_Green[0].visible = false;			 
			   rect_lamp_Green[2].visible = false;
			   circle_lamp_Green[2].visible = false;
			   rect_lamp_Green[4].visible = false;
			   circle_lamp_Green[4].visible = false;
			   rect_lamp_Green[5].visible = false;
			   circle_lamp_Green[5].visible = false;
			   rect_lamp_Green[6].visible = false;
			   circle_lamp_Green[6].visible = false; 				 
			 }
			 else 
			 {			
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;				
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;
			 }
			// get_result(NUM);
		} 
			 // цифра 4 на табло
		if (NUM_1 ==4)
		{		 
			   rect_lamp_Green[0].visible = true;
			   circle_lamp_Green[0].visible = true;			 
			   rect_lamp_Green[2].visible = true;
			   circle_lamp_Green[2].visible = true;
			   rect_lamp_Green[4].visible = true;
			   circle_lamp_Green[4].visible = true;
			   rect_lamp_Green[5].visible = true;
			   circle_lamp_Green[5].visible = true;
			   rect_lamp_Green[6].visible = true;
			   circle_lamp_Green[6].visible = true; 				
			 
			 if (level == 2)
			 {
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;			 	
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;			 
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;
				rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;			 
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			 }
			 else
			 {		   
				rect_lamp_Green[1].visible = false;
				circle_lamp_Green[1].visible = false;			 	
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;			 
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;
			 }
			// get_result(NUM);
		} 
			 // цифра 5 на табло
		if (NUM_1 ==5)
		{		 
				rect_lamp_Green[1].visible = true;
				circle_lamp_Green[1].visible = true;			 	
				rect_lamp_Green[4].visible = true;
				circle_lamp_Green[4].visible = true;			 
				rect_lamp_Green[5].visible = true;
				circle_lamp_Green[5].visible = true;
				rect_lamp_Green[7].visible = true;
				circle_lamp_Green[7].visible = true;			 
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;			 
			 
			if (level == 2)
			{
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;	
				rect_lamp_Green[4].visible = false;;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;	
				rect_lamp_Green[8].visible = false;;
				circle_lamp_Green[8].visible = false;
			 
			}
			else
			{			 
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;	
				rect_lamp_Green[4].visible = false;;
				circle_lamp_Green[4].visible = false;
			} 
			 //get_result(NUM);
		}
			 // цифра 6 на табло
		if (NUM_1 ==6)
		{			 
				rect_lamp_Green[2].visible = true;
				circle_lamp_Green[2].visible = true;	
				rect_lamp_Green[4].visible = true;
				circle_lamp_Green[4].visible = true;
				rect_lamp_Green[7].visible = true;
				circle_lamp_Green[7].visible = true;	
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;				
			if (level == 2)
			{
				rect_lamp_Green[2].visible = false;
			    circle_lamp_Green[2].visible = false;
				rect_lamp_Green[0].visible = false;
			    circle_lamp_Green[0].visible = false;
				rect_lamp_Green[1].visible = false;
			    circle_lamp_Green[1].visible = false;
				rect_lamp_Green[8].visible = false;
			    circle_lamp_Green[8].visible = false;
			}
			else
			{ 
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;		 
			} 
			// get_result(NUM);
		}
			 // цифра 7 на табло
		if (NUM_1 ==7)
		{			 
			 	
			    rect_lamp_Green[2].visible = true;
			    circle_lamp_Green[2].visible = true;
				rect_lamp_Green[0].visible = true;
			    circle_lamp_Green[0].visible = true;
				rect_lamp_Green[1].visible = true;
			    circle_lamp_Green[1].visible = true;
				rect_lamp_Green[8].visible = true;
			    circle_lamp_Green[8].visible = true;		 
			 	
			if (level == 2)
			{
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;				 		 
				rect_lamp_Green[2].visible = false;
				circle_lamp_Green[2].visible = false;
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;
				rect_lamp_Green[6].visible = false;
				circle_lamp_Green[6].visible = false;
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			}
			else
			{
				rect_lamp_Green[0].visible = false;
				circle_lamp_Green[0].visible = false;				 		 
				rect_lamp_Green[3].visible = false;
				circle_lamp_Green[3].visible = false;
				rect_lamp_Green[4].visible = false;
				circle_lamp_Green[4].visible = false;
				rect_lamp_Green[5].visible = false;
				circle_lamp_Green[5].visible = false;			 
			}
			 //get_result(NUM);			
		}
			 // цифра 8 на табло
		if (NUM_1 ==8)
		{			
			    rect_lamp_Green[0].visible = true;
				circle_lamp_Green[0].visible = true;				 		 
				rect_lamp_Green[2].visible = true;
				circle_lamp_Green[2].visible = true;
				rect_lamp_Green[3].visible = true;
				circle_lamp_Green[3].visible = true;
				rect_lamp_Green[5].visible = true;
				circle_lamp_Green[5].visible = true;
				rect_lamp_Green[6].visible = true;
				circle_lamp_Green[6].visible = true;
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;
				rect_lamp_Green[4].visible = true;
				circle_lamp_Green[4].visible = true;
			
			if (level == 2)
			{
				rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;
				rect_lamp_Green[8].visible = false;
				circle_lamp_Green[8].visible = false;
			}
			 
			 //get_result(NUM);
		}
			 // цифра 9 на табло
		if (NUM_1 ==9)
		{	    
				rect_lamp_Green[7].visible = true;
				circle_lamp_Green[7].visible = true;
				rect_lamp_Green[8].visible = true;
				circle_lamp_Green[8].visible = true;
				
			if (level == 2)
			{
				rect_lamp_Green[4].visible = false;
			    circle_lamp_Green[4].visible = false;
			    rect_lamp_Green[7].visible = false;
				circle_lamp_Green[7].visible = false;
				rect_lamp_Green[5].visible = false;
			    circle_lamp_Green[5].visible = false;
				rect_lamp_Green[6].visible = false;
			    circle_lamp_Green[6].visible = false;
			}
			else
			{
			 rect_lamp_Green[4].visible = false;
			 circle_lamp_Green[4].visible = false;				 
			}
		}	
			controllaContattonot(e);
			controllaContattoor(e);
			controllaContatto(e);
			controlLamp(e);//вставлено чтобы для блока не евент сработал до  обработки результата, иначе результат не зачтётся
			get_result(NUM_1);
			Record();
			 NUM_1++;			
		}		
		//===================================================
		public function But_1(e:Event):void
		{
			NUM = 1;
			test_step(e);
		}
		public function But_2(e:Event):void
		{
			NUM = 2;
			test_step(e);
		}
		public function But_3(e:Event):void
		{
			NUM = 3;
			test_step(e);
		}
		public function But_4(e:Event):void
		{
			NUM = 4;
			test_step(e);
		}
		public function But_5(e:Event):void
		{
			NUM = 5;
			test_step(e);
		}
		public function But_6(e:Event):void
		{
			NUM = 6;
			test_step(e);
		}
		public function But_7(e:Event):void
		{
			NUM = 7;
			test_step(e);
		}
		public function But_8(e:Event):void
		{
			NUM = 8;
			test_step(e);
		}
		public function But_9(e:Event):void
		{
			NUM = 9;
			test_step(e);
		}
		public function But_0(e:Event):void
		{
			NUM = 0;
			test_step(e);
		}
		//===================================================
		public function Buttons():void	//функция создающая кнопки
		{				
										
    				
			//---------------------------------------------------
			//кнопка и		
			var tf_and:TextField = new TextField();
			tf_and.text = "И";			
			tf_and.selectable = false;
			tf_and.autoSize = TextFieldAutoSize.CENTER;
			tf_and.x = 58;
            tf_and.y = 320;
			addChild(tf_and);
    		var And:Sprite = new Sprite();
			var bmp_and:* = new And_01;
			And.addChild(bmp_and);//добавляем картинку на спрайт
			And.x = 60;
			And.y = 340;
			addChild(And);
			And.addEventListener(MouseEvent.CLICK, CreateAnd);
					
			//кнопка или		
			var tf_or:TextField = new TextField();
			tf_or.text = "ИЛИ";			
			tf_or.selectable = false;
			tf_or.autoSize = TextFieldAutoSize.CENTER;
			tf_or.x = 118;
            tf_or.y = 320;
			addChild(tf_or);
    		var Or:Sprite = new Sprite();
			var bmp_or:* = new Or_01;
			 Or.addChild(bmp_or);//добавляем картинку на спрайт
			 Or.x = 120;
			 Or.y = 340;
			addChild( Or);
			 Or.addEventListener(MouseEvent.CLICK, Createor);
						
			//кнопка не
			var tf_not:TextField = new TextField();
			tf_not.text = "НЕ";			
			tf_not.selectable = false;
			tf_not.autoSize = TextFieldAutoSize.CENTER;
			tf_not.x = 80;
            tf_not.y = 365;
			addChild(tf_not);
    		var Not:Sprite = new Sprite();
			var bmp_not:* = new Not_01;
			 Not.addChild(bmp_not);//добавляем картинку на спрайт
			 Not.x = 80;
			 Not.y = 380;
			addChild( Not);
			Not.addEventListener(MouseEvent.CLICK, Createnot);
			
			//---------------------------------------------------------------------
			var tf_1:TextField = new TextField();
			tf_1.text = "Разделить";			
			tf_1.selectable = false;
			tf_1.autoSize = TextFieldAutoSize.CENTER;
			tf_1.x = 58;
            tf_1.y = 425;
			var But_create_non:SimpleButton = createButtons("'Разделить'");
			But_create_non.x = 20;
			But_create_non.y = 420;
			addChild(But_create_non);
			addChild(tf_1);
			But_create_non.addEventListener(MouseEvent.CLICK, Createnon);
			
			var tf_2:TextField = new TextField();
			tf_2.text = "Отсоединить";		
			tf_2.selectable = false;
			tf_2.autoSize = TextFieldAutoSize.CENTER;
			tf_2.x = 52;
			tf_2.y = 465;			
			var But_create_Disconnect:SimpleButton = createButtons("Отсоединить");
			But_create_Disconnect.x = 20;
			But_create_Disconnect.y = 460;
			addChild(But_create_Disconnect);
			addChild(tf_2);
			But_create_Disconnect.addEventListener(MouseEvent.CLICK, disconnect);
			
			//---------------------------------------------------------------------------
			//кнопки проверки
			//1
			var tf_but_1:TextField = new TextField();
			tf_but_1.text = "1";		
			tf_but_1.selectable = false;
			tf_but_1.autoSize = TextFieldAutoSize.CENTER;
			tf_but_1.x = 20;
			tf_but_1.y = 10;			
			var But_01:SimpleButton = createButtons_2("");
			But_01.x = 10;
			But_01.y = 5;
			addChild(But_01);
			addChild(tf_but_1);
			But_01.addEventListener(MouseEvent.CLICK, But_1);
			
			//2
			var tf_but_2:TextField = new TextField();
			tf_but_2.text = "2";		
			tf_but_2.selectable = false;
			tf_but_2.autoSize = TextFieldAutoSize.CENTER;
			tf_but_2.x = 60;
			tf_but_2.y = 10;			
			var But_02:SimpleButton = createButtons_2("");
			But_02.x = 50;
			But_02.y = 5;
			addChild(But_02);
			addChild(tf_but_2);
			But_02.addEventListener(MouseEvent.CLICK, But_2);
			
			//3
			var tf_but_3:TextField = new TextField();
			tf_but_3.text = "3";		
			tf_but_3.selectable = false;
			tf_but_3.autoSize = TextFieldAutoSize.CENTER;
			tf_but_3.x = 100;
			tf_but_3.y = 10;			
			var But_03:SimpleButton = createButtons_2("");
			But_03.x = 90;
			But_03.y = 5;
			addChild(But_03);
			addChild(tf_but_3);
			But_03.addEventListener(MouseEvent.CLICK, But_3);
			
			//4
			var tf_but_4:TextField = new TextField();
			tf_but_4.text = "4";		
			tf_but_4.selectable = false;
			tf_but_4.autoSize = TextFieldAutoSize.CENTER;
			tf_but_4.x = 20;
			tf_but_4.y = 45;			
			var But_04:SimpleButton = createButtons_2("");
			But_04.x = 10;
			But_04.y = 40;
			addChild(But_04);
			addChild(tf_but_4);
			But_04.addEventListener(MouseEvent.CLICK, But_4);
			
			//5
			var tf_but_5:TextField = new TextField();
			tf_but_5.text = "5";		
			tf_but_5.selectable = false;
			tf_but_5.autoSize = TextFieldAutoSize.CENTER;
			tf_but_5.x = 60;
			tf_but_5.y = 45;			
			var But_05:SimpleButton = createButtons_2("");
			But_05.x = 50;
			But_05.y = 40;
			addChild(But_05);
			addChild(tf_but_5);
			But_05.addEventListener(MouseEvent.CLICK, But_5);
			
			//6
			var tf_but_6:TextField = new TextField();
			tf_but_6.text = "6";		
			tf_but_6.selectable = false;
			tf_but_6.autoSize = TextFieldAutoSize.CENTER;
			tf_but_6.x = 100;
			tf_but_6.y = 45;			
			var But_06:SimpleButton = createButtons_2("");
			But_06.x = 90;
			But_06.y = 40;
			addChild(But_06);
			addChild(tf_but_6);
			But_06.addEventListener(MouseEvent.CLICK, But_6);
			
			//0
			var tf_but_0:TextField = new TextField();
			tf_but_0.text = "0";		
			tf_but_0.selectable = false;
			tf_but_0.autoSize = TextFieldAutoSize.CENTER;
			tf_but_0.x = 140;
			tf_but_0.y = 45;			
			var But_00:SimpleButton = createButtons_2("");
			But_00.x = 130;
			But_00.y = 40;
			addChild(But_00);
			addChild(tf_but_0);
			But_00.addEventListener(MouseEvent.CLICK, But_0);
			
			//7
			var tf_but_7:TextField = new TextField();
			tf_but_7.text = "7";		
			tf_but_7.selectable = false;
			tf_but_7.autoSize = TextFieldAutoSize.CENTER;
			tf_but_7.x = 20;
			tf_but_7.y = 80;			
			var But_07:SimpleButton = createButtons_2("");
			But_07.x = 10;
			But_07.y = 75;
			addChild(But_07);
			addChild(tf_but_7);
			But_07.addEventListener(MouseEvent.CLICK, But_7);
			
			//8
			var tf_but_8:TextField = new TextField();
			tf_but_8.text = "8";		
			tf_but_8.selectable = false;
			tf_but_8.autoSize = TextFieldAutoSize.CENTER;
			tf_but_8.x = 60;
			tf_but_8.y = 80;			
			var But_08:SimpleButton = createButtons_2("");
			But_08.x = 50;
			But_08.y = 75;
			addChild(But_08);
			addChild(tf_but_8);
			But_08.addEventListener(MouseEvent.CLICK, But_8);
			
			//9
			var tf_but_9:TextField = new TextField();
			tf_but_9.text = "9";		
			tf_but_9.selectable = false;
			tf_but_9.autoSize = TextFieldAutoSize.CENTER;
			tf_but_9.x = 100;
			tf_but_9.y = 80;			
			var But_09:SimpleButton = createButtons_2("");
			But_09.x = 90;
			But_09.y = 75;
			addChild(But_09);
			addChild(tf_but_9);
			But_09.addEventListener(MouseEvent.CLICK, But_9);
			
			//-------------------------------------------------------------------------------
			// кнопка сброса решения
			/*var tf_3:TextField = new TextField();
			tf_3.text = "Сбросить";		
			tf_3.selectable = false;
			tf_3.autoSize = TextFieldAutoSize.CENTER;
			tf_3.x = 680;
			tf_3.y = 370;	
			var Del_result:SimpleButton = createButtons("Сбросить");
			Del_result.x = 640;
			Del_result.y = 365;
			addChild(Del_result);
			addChild(tf_3);
			Del_result.addEventListener(MouseEvent.CLICK, del_result);*/
						
		}
		//===================================================================================================
		public function createButtons(a:String):SimpleButton  // функция создания кнопок
		{
			var button:SimpleButton = new  SimpleButton;
			var bb1:Sprite = new Sprite();
			var bmp_but_1:* = new Big_Button_01;
			bb1.addChild(bmp_but_1); 
			var bb2:Sprite = new Sprite();
			var bmp_but_2:* = new Big_Button_02;
			bb2.addChild(bmp_but_2); 
			var bb3:Sprite = new Sprite();
			var bmp_but_3:* = new Big_Button_03;
			bb3.addChild(bmp_but_3);			
			button.upState = 	bmp_but_1;
			button.overState = bmp_but_2;
			button.downState = bmp_but_3;
			button.hitTestState = button.overState;
			
			return button;
		}	
		public function createButtons_2(a:String):SimpleButton  // функция создания кнопок
		{
			var button:SimpleButton = new  SimpleButton;
			var bb1:Sprite = new Sprite();
			var bmp_but_1:* = new Small_Button_01;
			bb1.addChild(bmp_but_1); 
			var bb2:Sprite = new Sprite();
			var bmp_but_2:* = new Small_Button_02;
			bb2.addChild(bmp_but_2); 
			var bb3:Sprite = new Sprite();
			var bmp_but_3:* = new Small_Button_03;
			bb3.addChild(bmp_but_3);			
			button.upState = 	bmp_but_1;
			button.overState = bmp_but_2;
			button.downState = bmp_but_3;
			button.hitTestState = button.overState;
			
			return button;
		}
		
		//===================================================================================================
		[Embed(source="Enter.png")]
		public static const Enter:Class;
		public function createCont_Prov():void // функция создающая лампочки конечной проверки
		{	
			var i:int;
			var a:int = 27;
			var b:int = 27;
			var bmp:*= new Enter; var bmp2:*= new Enter; var bmp3:*= new Enter; var bmp4:*= new Enter;
			var bmp5:*= new Enter; var bmp6:*= new Enter; var bmp7:*= new Enter; var bmp8:*= new Enter;
			var bmp9:*= new Enter; var bmp10:*= new Enter;
			
			var img:*= new Conect; var img2:*= new Conect; var img3:*= new Conect; var img4:*= new Conect; 
			var img5:*= new Conect; var img6:*= new Conect; var img7:*= new Conect; var img8:*= new Conect; 
			var img9:*= new Conect; var img10:*= new Conect; 
			
			/*var circle:Sprite = new Sprite();
			circle.addChild(img);
			circle.x = 722;
			circle.y = 20;
			
			var circle2:Sprite = new Sprite();
			circle2.addChild(img2);
			circle2.x = 722;
			circle2.y = 60;
			
			var circle3:Sprite = new Sprite();
			circle3.addChild(img3);
			circle3.x = 722;
			circle3.y = 100;
			
			var circle4:Sprite = new Sprite();
			circle4.addChild(img4);
			circle4.x = 722;
			circle4.y = 140;
			
			var circle5:Sprite = new Sprite();
			circle5.addChild(img5);
			circle5.x = 722;
			circle5.y = 180;
			
			var circle6:Sprite = new Sprite();
			circle6.addChild(img6);
			circle6.x = 722;
			circle6.y = 220;
			
			var circle7:Sprite = new Sprite();
			circle7.addChild(img7);
			circle7.x = 722;
			circle7.y = 260;
			
			var circle8:Sprite = new Sprite();
			circle8.addChild(img8);
			circle8.x = 722;
			circle8.y = 300;
			
			var circle9:Sprite = new Sprite();
			circle9.addChild(img9);
			circle9.x = 722;
			circle9.y = 340;
			
			var circle10:Sprite = new Sprite();
			circle10.addChild(img10);
			circle10.x = 722;
			circle10.y = 380;*/
			
			
			var rect:Sprite = new Sprite();
			rect.addChild(bmp);
			rect.x = 750;
			rect.y = 20;
			
			var rect2:Sprite = new Sprite();
			rect2.addChild(bmp2);
			rect2.x = 750;
			rect2.y = 60;
			
			var rect3:Sprite = new Sprite();
			rect3.addChild(bmp3);
			rect3.x = 750;
			rect3.y = 100;
			
			var rect4:Sprite = new Sprite();
			rect4.addChild(bmp4);
			rect4.x = 750;
			rect4.y = 140;
			
			var rect5:Sprite = new Sprite();
			rect5.addChild(bmp5);
			rect5.x = 750;
			rect5.y = 180;
			
			var rect6:Sprite = new Sprite();
			rect6.addChild(bmp6);
			rect6.x = 750;
			rect6.y = 220;
			
			var rect7:Sprite = new Sprite();
			rect7.addChild(bmp7);
			rect7.x = 750;
			rect7.y = 260;
			
			var rect8:Sprite = new Sprite();
			rect8.addChild(bmp8);
			rect8.x = 750;
			rect8.y = 300;
			
			var rect9:Sprite = new Sprite();
			rect9.addChild(bmp9);
			rect9.x = 750;
			rect9.y = 340;
			
			var rect10:Sprite = new Sprite();
			rect10.addChild(bmp10);
			rect10.x = 750;
			rect10.y = 380;
			
			//---------------------------------------------------------------------------------------------------------
			//---------------------------------------------------------------------------------------------------------
			// красные лампочки
			/*for (i = 0; i < 10; i++) 
			{
				
				var c_lamp_Red_prov:Sprite = createCircle( 0xff0000, 5,1);
				circle_lamp_Red_prov[i] = c_lamp_Red_prov;
				
				circle_lamp_Red_prov[i].x = 730;
				circle_lamp_Red_prov[i].y = a;
				addChild(circle_lamp_Red_prov[i]);
				createSimpleLine(750, b, 730, a,  0, 0);
				a = a + 40;
				
				b = b + 40;
				
			}
			//---------------------------------------------------------------------------------
			// зеленые лампочки
			a = 27;
			for (i = 0; i < 10; i++) 
			{
				var c_lamp_Green_prov:Sprite = createCircle( 0x00ff00, 5,1);
				circle_lamp_Green_prov[i] = c_lamp_Green_prov;
				
				circle_lamp_Green_prov[i].x = 730;
				circle_lamp_Green_prov[i].y = a;
				addChild(circle_lamp_Green_prov[i]);
                a = a + 40;
			}*/
			
			addChild(rect); addChild(rect2); addChild(rect3); addChild(rect4); addChild(rect5);
			addChild(rect6); addChild(rect7); addChild(rect8); addChild(rect9); addChild(rect10);
			
			//circle_lamp_Green_prov[0].visible = false;
			var text_f_7:TextField = new TextField();
			text_f_7.autoSize = TextFieldAutoSize.LEFT;
			text_f_7.text = "0";
			text_f_7.x = 753;
			text_f_7.y = 18;			
			addChild(text_f_7);
			
			
			//circle_lamp_Green_prov[1].visible = false;
			var text_f_8:TextField = new TextField();
			text_f_8.autoSize = TextFieldAutoSize.LEFT;
			text_f_8.text = "1";
			text_f_8.x = 753;
			text_f_8.y = 58;			
			addChild(text_f_8);
			
			
			//circle_lamp_Green_prov[2].visible = false;
			var text_f_9:TextField = new TextField();
			text_f_9.autoSize = TextFieldAutoSize.LEFT;
			text_f_9.text = "2";
			text_f_9.x = 753;
			text_f_9.y = 98;			
			addChild(text_f_9);
			
			
			//circle_lamp_Green_prov[3].visible = false;
			var text_f_10:TextField = new TextField();
			text_f_10.autoSize = TextFieldAutoSize.LEFT;
			text_f_10.text = "3";
			text_f_10.x = 753;
			text_f_10.y = 138;			
			addChild(text_f_10);
			
			
			//circle_lamp_Green_prov[4].visible = false;
			var text_f_11:TextField = new TextField();
			text_f_11.autoSize = TextFieldAutoSize.LEFT;
			text_f_11.text = "4";
			text_f_11.x = 753;
			text_f_11.y = 178;			
			addChild(text_f_11);
			
			
			//circle_lamp_Green_prov[5].visible = false;
			var text_f_12:TextField = new TextField();
			text_f_12.autoSize = TextFieldAutoSize.LEFT;
			text_f_12.text = "5";
			text_f_12.x = 753;
			text_f_12.y = 218;			
			addChild(text_f_12);
			
			
			//circle_lamp_Green_prov[6].visible = false;
			var text_f_13:TextField = new TextField();
			text_f_13.autoSize = TextFieldAutoSize.LEFT;
			text_f_13.text = "6";
			text_f_13.x = 753;
			text_f_13.y = 258;			
			addChild(text_f_13);
			
			
			//circle_lamp_Green_prov[7].visible = false;
			var text_f_14:TextField = new TextField();
			text_f_14.autoSize = TextFieldAutoSize.LEFT;
			text_f_14.text = "7";
			text_f_14.x = 753;
			text_f_14.y = 298;			
			addChild(text_f_14);
			
			
			//circle_lamp_Green_prov[8].visible = false;
			var text_f_15:TextField = new TextField();
			text_f_15.autoSize = TextFieldAutoSize.LEFT;
			text_f_15.text = "8";
			text_f_15.x = 753;
			text_f_15.y = 338;			
			addChild(text_f_15);
			
		
			//circle_lamp_Green_prov[9].visible = false;
			var text_f_16:TextField = new TextField();
			text_f_16.autoSize = TextFieldAutoSize.LEFT;
			text_f_16.text = "9";
			text_f_16.x = 753;
			text_f_16.y = 378;			
			addChild(text_f_16);
			
			//addChild(circle); addChild(circle2); addChild(circle3); addChild(circle4); addChild(circle5); 
			//addChild(circle6); addChild(circle7); addChild(circle8); addChild(circle9); addChild(circle10); 

		}
		//===================================================================================================
		
		[Embed(source="Exit.png")]
		public static const Exit:Class;
		public function createCont():void //функция создающая контакты
		{
			var bmp:*= new Exit;
			var bmp2:*= new Exit; 
			var bmp3:*= new Exit;
			var bmp4:*= new Exit;
			var bmp5:*= new Exit;
			var bmp6:*= new Exit;
			var bmp7:*= new Exit;
			var bmp8:*= new Exit;
			var bmp9:*= new Exit;
			var exits1:Sprite = new Sprite();
			var exits2:Sprite = new Sprite();
			var exits3:Sprite = new Sprite();
			var exits4:Sprite = new Sprite();
			var exits5:Sprite = new Sprite();
			var exits6:Sprite = new Sprite();
			var exits7:Sprite = new Sprite();
			var exits8:Sprite = new Sprite();
			var exits9:Sprite = new Sprite();
			exits1.addChild(bmp);
			exits1.x = 190;
			exits1.y = 65;
			
			exits2.addChild(bmp2);
			exits2.x = 190;
			exits2.y = 105;
			
			exits3.addChild(bmp3);
			exits3.x = 190;
			exits3.y = 145;
			
			exits4.addChild(bmp4);
			exits4.x = 190;
			exits4.y = 185;
			
			exits5.addChild(bmp5);
			exits5.x = 190;
			exits5.y = 225;
			
			exits6.addChild(bmp6);
			exits6.x = 190;
			exits6.y = 265;
			
			exits7.addChild(bmp7);
			exits7.x = 190;
			exits7.y = 305;
			
			exits8.addChild(bmp8);
			exits8.x = 190;
			exits8.y = 345;
			
			exits9.addChild(bmp9);
			exits9.x = 190;
			exits9.y = 25;
			
			var i:int = 0;
			var a:int = 35;
			// красные лампочки			
			for (i = 0; i < 9; i++) 
			{
				var c_lamp_Red:Sprite = createCircle( 0xff0000, 7,1);
				circle_lamp_Red[i] = c_lamp_Red;
				
				
			}	
		circle_lamp_Red[0].x = 200;
	    circle_lamp_Red[0].y = 75;			    
		circle_lamp_Red[1].x = 200;
	    circle_lamp_Red[1].y = 35;
		circle_lamp_Red[2].x = 200;
	    circle_lamp_Red[2].y = 155;
		circle_lamp_Red[3].x = 200;
	    circle_lamp_Red[3].y = 195;
		circle_lamp_Red[4].x = 200;
	    circle_lamp_Red[4].y = 235;
		circle_lamp_Red[5].x = 200;
	    circle_lamp_Red[5].y = 355;
		circle_lamp_Red[6].x = 200;
	    circle_lamp_Red[6].y = 315;
		circle_lamp_Red[7].x = 200;
	    circle_lamp_Red[7].y = 115;
		circle_lamp_Red[8].x = 200;
	    circle_lamp_Red[8].y = 275;
	
		//-------------------------------------------------------------------------------------------
		// зеленые лампочки
		
		for (i = 0; i < 9; i++) 
			{
				var c_lamp_Green:Sprite = createCircle( 0x00ff00, 7,1);
				circle_lamp_Green[i] = c_lamp_Green;				
							
			}
		circle_lamp_Green[0].x = 200;
		circle_lamp_Green[0].y = 75;			    
		circle_lamp_Green[1].x = 200;
		circle_lamp_Green[1].y = 35;
		circle_lamp_Green[2].x = 200;
		circle_lamp_Green[2].y = 155;
		circle_lamp_Green[3].x = 200;
		circle_lamp_Green[3].y = 195;
		circle_lamp_Green[4].x = 200;
		circle_lamp_Green[4].y = 235;
		circle_lamp_Green[5].x = 200;
		circle_lamp_Green[5].y = 355;
		circle_lamp_Green[6].x = 200;
		circle_lamp_Green[6].y = 315;
		circle_lamp_Green[7].x = 200;
		circle_lamp_Green[7].y = 115;
		circle_lamp_Green[8].x = 200;
		circle_lamp_Green[8].y = 275;
			
		// вывод на сцены ламп
		  	for (i = 0; i < 9; i++)	
			  {
				addChild(circle_lamp_Red[i]);
				addChild(circle_lamp_Green[i]);
			   }
		 addChild(exits1);	
		 addChild(exits2);
		 addChild(exits3);
		 addChild(exits4);
		 addChild(exits5);
		 addChild(exits6);
		 addChild(exits7);
		 addChild(exits8);
		 addChild(exits9);
		}	
		//===================================================================================================
		public function createNum():void //функция создающая табло
		{
		    var i:int;	
			
			for (i = 0; i < 9; i++) 
			{
				var lamp_Green:Sprite = new Sprite;
				var bmp_lamp:* = new Lamp_H_01;
				lamp_Green.addChild(bmp_lamp);
				rect_lamp_Green[i] = lamp_Green;
			}	
			for (i = 0; i < 9; i++) 
			{
				var lamp_Green_Down:Sprite = new Sprite;
				var bmp_lamp_down:* = new Lamp_H_03;
				lamp_Green_Down.addChild(bmp_lamp_down);
				rect_lamp_Green_Down[i] = lamp_Green_Down;
			}
			//местоположение не горящих ламп
			//верхний 1я линия
			rect_lamp_Green_Down[1].x = 65; 
			rect_lamp_Green_Down[1].y = 130;			
			addChild(rect_lamp_Green_Down[1]);
			//средний 5я линия
			rect_lamp_Green_Down[3].x = 65; 
			rect_lamp_Green_Down[3].y = 200;
			addChild(rect_lamp_Green_Down[3]);
			//нижний 9я линия
			rect_lamp_Green_Down[5].x = 65; 
			rect_lamp_Green_Down[5].y = 270;
			addChild(rect_lamp_Green_Down[5]);
			
			// местоположение зеленых вертикальных ламп
			//левый верхний 2я линия
			rect_lamp_Green_Down[0].x = 62; 
			rect_lamp_Green_Down[0].y = 145;
			rect_lamp_Green_Down[0].rotation = 90;
		    addChild(rect_lamp_Green_Down[0]);
			//левый нижний 6я линия
			rect_lamp_Green_Down[4].x = 62; 
			rect_lamp_Green_Down[4].y = 215;
			rect_lamp_Green_Down[4].rotation = 90;
			addChild(rect_lamp_Green_Down[4]);
			//правый верхний 4я линия
			rect_lamp_Green_Down[2].x = 145; 
			rect_lamp_Green_Down[2].y = 145;
			rect_lamp_Green_Down[2].rotation = 90;
			addChild(rect_lamp_Green_Down[2]);
			//правый нижний 8я линия
			rect_lamp_Green_Down[6].x = 145; 
			rect_lamp_Green_Down[6].y = 215;
			rect_lamp_Green_Down[6].rotation = 90;
			addChild(rect_lamp_Green_Down[6]);			
		    //диагональный верхний 3я линия
			rect_lamp_Green_Down[7].x = 68; 
			rect_lamp_Green_Down[7].y = 188;
			rect_lamp_Green_Down[7].rotation = -45;
			addChild(rect_lamp_Green_Down[7]);
			//диагональный нижний 7я линия
			rect_lamp_Green_Down[8].x = 68; 
			rect_lamp_Green_Down[8].y = 258;
			rect_lamp_Green_Down[8].rotation =-45;
			addChild(rect_lamp_Green_Down[8]);
			
			
			// местоположение зеленых горизонтальных ламп
			//верхний 1я линия
			rect_lamp_Green[1].x = 65; 
			rect_lamp_Green[1].y = 130;			
			addChild(rect_lamp_Green[1]);
			//средний 5я линия
			rect_lamp_Green[3].x = 65; 
			rect_lamp_Green[3].y = 200;
			addChild(rect_lamp_Green[3]);
			//нижний 9я линия
			rect_lamp_Green[5].x = 65; 
			rect_lamp_Green[5].y = 270;
			addChild(rect_lamp_Green[5]);
			
			// местоположение зеленых вертикальных ламп
			//левый верхний 2я линия
			rect_lamp_Green[0].x = 62; 
			rect_lamp_Green[0].y = 145;
			rect_lamp_Green[0].rotation = 90;
		    addChild(rect_lamp_Green[0]);
			//левый нижний 6я линия
			rect_lamp_Green[4].x = 62; 
			rect_lamp_Green[4].y = 215;
			rect_lamp_Green[4].rotation = 90;
			addChild(rect_lamp_Green[4]);
			//правый верхний 4я линия
			rect_lamp_Green[2].x = 145; 
			rect_lamp_Green[2].y = 145;
			rect_lamp_Green[2].rotation = 90;
			addChild(rect_lamp_Green[2]);
			//правый нижний 8я линия
			rect_lamp_Green[6].x = 145; 
			rect_lamp_Green[6].y = 215;
			rect_lamp_Green[6].rotation = 90;
			addChild(rect_lamp_Green[6]);			
		    //диагональный верхний 3я линия
			rect_lamp_Green[7].x = 68; 
			rect_lamp_Green[7].y = 188;
			rect_lamp_Green[7].rotation = -45;
			addChild(rect_lamp_Green[7]);
			//диагональный нижний 7я линия
			rect_lamp_Green[8].x = 68; 
			rect_lamp_Green[8].y = 258;
			rect_lamp_Green[8].rotation =-45;
			addChild(rect_lamp_Green[8]);
			
			var Wires:Sprite = new Sprite();
			var bmp_Wires:* = new Wires_02;
			Wires.addChild(bmp_Wires); //добавляем картинку на спрайт
			addChild(Wires);
			Wires.x = 46;
			Wires.y = 25;
			
			
			
			
			}
		
		//==========================================================================
		//==========================================================================
		public function createRect( color: int , length: int,width: int): Sprite
		{
			var shape:Sprite = new Sprite();			
			shape.graphics.beginFill(color);
			shape.graphics.lineStyle(1);
			shape.graphics.drawRect(0, 0, length,width);
			shape.graphics.endFill();			
			return shape;
		}
		//===================================================
		public function createCircle( color: int , radius:int,alp:int): Sprite
		{
			var shape:Sprite = new Sprite();
			shape.graphics.beginFill(color,alp);
			shape.graphics.drawCircle(0, 0, radius);
			shape.graphics.endFill();	
			return shape;
		}
		
		public function del_result (e:Event) :void // функция сброса результатат
		{
			
			
			/* rect_lamp_Green[0].visible = true;
			 circle_lamp_Green[0].visible = true;	
			 rect_lamp_Green[1].visible = true;
			 circle_lamp_Green[1].visible = true;	
			 rect_lamp_Green[2].visible = true;
			 circle_lamp_Green[2].visible = true;
			 rect_lamp_Green[3].visible = true;
			 circle_lamp_Green[3].visible = true;			 
			 rect_lamp_Green[4].visible = true;
			 circle_lamp_Green[4].visible = true;
			 rect_lamp_Green[5].visible = true;
			 circle_lamp_Green[5].visible = true;
			 rect_lamp_Green[6].visible = true;
			 circle_lamp_Green[6].visible = true;
			 rect_lamp_Green[7].visible = true;
			 circle_lamp_Green[7].visible = true;
			 rect_lamp_Green[8].visible = true;
			 circle_lamp_Green[8].visible = true;*/
			 
			/*var i:int = 0;
			for ( i = 0 ; i < 10 ; i++)
			{
			   circle_lamp_Green_prov[i].visible = false;
			       		   
			}		*/	 
			Result = 0;
			t_result.text =  '  ' + Result;
			t_nB.text =  '  ' + NumberBlokcs;
			if (NUM_first_Break_lamp != 11)
			{
			   addChild(rect_lamp_Green[NUM_first_Break_lamp]);			   
			   addChild(circle_lamp_Red[NUM_first_Break_lamp]);
			   addChild(circle_lamp_Green[NUM_first_Break_lamp]);
			}
			if (NUM_second_Break_lamp != 11)
			{
			   addChild(rect_lamp_Green[NUM_first_Break_lamp]);			   
			   addChild(circle_lamp_Red[NUM_first_Break_lamp]);
			   addChild(circle_lamp_Green[NUM_first_Break_lamp]);
			   
			   addChild(rect_lamp_Green[NUM_second_Break_lamp]);			   
			   addChild(circle_lamp_Red[NUM_second_Break_lamp]);
			   addChild(circle_lamp_Green[NUM_second_Break_lamp]);
			}
			NUM = 0;
			NUM_1 = 0;
			timer.stop();
		}		
	    //===================================================
		public function get_result (n:int) :void //функция получения результата
		{
			var i:int = 0;
			var flag:int = 1;
			var a:int = 0;
			if (n == 0)
				for (i = 0; i < 10; i++)
					controlAnswer[i] = -1;		
			for ( i = 0 ; i < 10 ; i++)
			{
				if (i != n  && answerConAim[i] == true)
				{
					flag = 0;
					controlAnswer[i] = 0;
				}
				if (answerConAim[i] == true && i == n  && flag != 0)
				{
					a = 1;
					if(controlAnswer[i]!=0)
						controlAnswer[i] = 1;
				}
			}
			if (n == 9)
			{
				for (i = 0; i < 10; i++)
				{
					if(controlAnswer[i] == 1)
						Result++;
				}
				t_result.text =  '  ' + Result;
				t_nB.text =  '  ' + NumberBlokcs;
			}
			
		}		
		//====================================================
		public function Record ():void
		{
			if (Result > Record_Result)
			{
			          Record_Result = Result;
					  Record_NumberBlokcs = NumberBlokcs;
			}
			else
			  if (Result == Record_Result)
			  {
				  if (NumberBlokcs > Record_NumberBlokcs)
				  {
					Record_Result = Result;
					 Record_NumberBlokcs = NumberBlokcs;  
				  }				  
			  }	
			  t_record_result.text =  '  ' + Record_Result;
			  t_record_numberBlokcs.text =  '  ' + Record_NumberBlokcs
		}
		//====================================================
		public function one_Break_lamp ( e:Event):void // функция удаления одной лампы
		{
			del_result(e);
			var i:int = 0;
			
			i = Math.floor(Math.random()*7);
			removeChild(rect_lamp_Green[i]);
			removeChild(circle_lamp_Green[i]);
			removeChild(circle_lamp_Red[i]);
			NUM_first_Break_lamp = i;
			
		}		
		//===================================================
		public function two_Breaks_lamp ( e:Event):void // функция удаления двух ламп
		{
			var j:int = 0;
			var i:int = 0;
		
			i = Math.floor(Math.random() * 9);
			j = Math.floor(Math.random() * 9);
			if (i == j)
			{
				i = Math.floor(Math.random() * 9);
				j = Math.floor(Math.random() * 9);
			}		
			
			removeChild(rect_lamp_Green[j]);
			removeChild(circle_lamp_Green[j]);
			removeChild(circle_lamp_Red[j]);
			
			removeChild(rect_lamp_Green[i]);
			removeChild(circle_lamp_Green[i]);
			removeChild(circle_lamp_Red[i]);
			NUM_first_Break_lamp = i;	
			NUM_second_Break_lamp = j;
		}		
		//=================================================
		/**
		* ...
		* @author this part is Vlad
		* 
		* 
		*/
		//=====================================================
		public function disconnect(e:Event):void
		{
			var flag:int = 1;
			var flag2:int = 1;
			var flag3:int = 1;
			for (var i:int=0; i < andTull.length && flag; i++)
			{
				if (lineLAddAnd[i]&&leftAndHit[i])
				{
					andLeft[i].x = andTull[i].x - 20; 
					andLeft[i].y = andTull[i].y -5;
					flag = 0;
				}
				if (lineRAddAnd[i] && rightAndHit[i])
				{
					andRight[i].x = andTull[i].x - 20; 
					andRight[i].y = andTull[i].y + 10;
					flag = 0;
				}
			}
			for (i=0; i < orTull.length && flag2; i++)
			{
				if (lineLAddOr[i]&&leftOrHit[i])
				{
					orLeft[i].x = orTull[i].x - 20; 
					orLeft[i].y = orTull[i].y -5;
					flag2 = 0;
				}
				if (lineRAddOr[i] && rightOrHit[i])
				{
					orRight[i].x = orTull[i].x - 20; 
					orRight[i].y = orTull[i].y + 10;
					flag2 = 0;
				}
			}
			for (i=0; i < notTull.length && flag3; i++)
			{
				if (lineRAddNot[i] && rightNotHit[i])
				{
					notRight[i].x = notTull[i].x - 20; 
					notRight[i].y = notTull[i].y + 5;
					flag3 = 0;
				}
			}			
			
		}
		//====================================================
		
		[Embed(source="And_01.png")]
		public static const And:Class;
		public function CreateAnd(e:Event):void 
		{
			del_result(e);
			timer.stop();
			var bmp:*= new And();
			var bmp2:*= new Conect();
			var bmp3:*= new Conect();
            var tull:Sprite = new Sprite(); //тело
		    var leftc:Sprite = new Sprite();// левый контакт
		    var rightc:Sprite = new Sprite();// правый контакт
		    var aimc:Sprite = createCircle(0x200321, 3,0);	//		итоговый контакт
			tull.addChild(bmp);
			rightc.addChild(bmp2);
			leftc.addChild(bmp3);
			
			tull.x = 350;
			tull.y = 10;
			leftc.x = 330;
			leftc.y = 5;
			rightc.x = 330;
			rightc.y = 20;
			aimc.x = 380;
			aimc.y = 20;
			
			andTull.push(tull);
			andLeft.push(leftc);
			andRight.push(rightc);
			andAim.push(aimc);
			
			addChild(leftc);
			addChild(tull);	
			addChild(rightc);
			addChild(aimc);
			
			createLine(tull.x, tull.y, rightc.x, rightc.y, andLineR,30,15,numAnd);
			createLine(tull.x, tull.y, leftc.x, leftc.y, andLineL,30,15,numAnd);
			
			addEventListener(MouseEvent.MOUSE_DOWN, down);
			addEventListener(MouseEvent.MOUSE_UP,  up);
			
			
			addEventListener(Event.ENTER_FRAME, controllaContatto);
			addEventListener(Event.ENTER_FRAME, controlWire);
			NumberBlokcs++;
			numAnd++;
		}
		//========================================================= 
		public function controlLamp(e:Event):void
		{
			var i:int;
			var k:int;
			var flag:int = 1;
			var flag2:int = 1;
			var flag3:int = 1;
			for (i = 0; i < 10; i++)
			{
				for (k = 0; k < andTull.length&&flag; k++)
				{
					if (answerCon[i].hitTestObject(andAim[k]))
					{
						answerConAim[i] = andAimResult[k];
						flag = 0;
					}
				}
				for (k = 0; k < orTull.length&&flag2; k++)
				{
					if (answerCon[i].hitTestObject(orAim[k]))
					{
						answerConAim[i] = orAimResult[k];
						flag2 = 0;
					}
				}
				for (k = 0; k < notTull.length&&flag3; k++)
				{
					if (answerCon[i].hitTestObject(notAim[k]))
					{
						answerConAim[i] = notAimResult[k];
						flag3 = 0;
					}
				}
				if (flag&&flag2&&flag3)
				{
					answerConAim[i] = false;
				}
				flag = 1;
				flag2 = 1;
				flag3 = 1;
			}
		}
		//=========================================================
		public function createLine(x1:int, y1:int, x2:int, y2:int,arr:Array, stepX:int, stepY:int,n:int):void
		{
			var line:Sprite = new Sprite();
			line.graphics.lineStyle(3);
			line.graphics.moveTo(x1+stepX, y1+stepY);
			line.graphics.lineTo(x2,y2);
			addChild(line);
			arr[n]=line;
		}
		//===================================================
		public function createSimpleLine(x1:int, y1:int, x2:int, y2:int, stepX:int, stepY:int):void
		{
			var line:Sprite = new Sprite();
			line.graphics.lineStyle(3);
			line.graphics.moveTo(x1+stepX, y1+stepY);
			line.graphics.lineTo(x2,y2);
			addChild(line);
		}
		//==================================================
		public function createBezie(x1:int, y1:int, x2:int, y2:int, arr:Array, stepX:int, stepY:int,stepYAnchor:int,n:int):void
		{
			var line:Sprite = new Sprite();
			line.graphics.lineStyle(2,0x0000CC);
			line.graphics.moveTo(x1+stepX, y1+stepY);
			line.graphics.curveTo(x1+20+(x2-x1)/2,y2-stepYAnchor,x2,y2);
			addChild(line);
			arr[n]=line;
		}
		//===================================================
		public function wireL(e:Event,n:int):void
		{   
			removeChild(andLineL[n]);
			var additLine:Sprite = new Sprite();
			var line:Sprite = new Sprite();
			if (andLeftResult[n] == true)
				{
					line.graphics.lineStyle(3, 0xF7C709);
				}
			else
				{
					line.graphics.lineStyle(3, 0x000001);
				}
				
			if (lineLAddAnd[n])
				{
					removeChild(additLineLAnd[n]);
					if (andLeftResult[n] == true)
					{
						additLine.graphics.lineStyle(6, 0xF7C709,0.3);
					}
					else
					{
						additLine.graphics.lineStyle(6, 0x000001,0.3);
					}
					additLine.graphics.moveTo(andTull[n].x, andTull[n].y+3);
					additLine.graphics.lineTo(andLeft[n].x + 10,andLeft[n].y + 6);
					additLineLAnd[n] = additLine;
					addChild(additLineLAnd[n]);
				}
				
			line.graphics.moveTo(andTull[n].x, andTull[n].y+3);
			line.graphics.lineTo(andLeft[n].x +10,andLeft[n].y + 6);
			addChild(line);
			andLineL[n] = line;
		}
		//=====================================================
		public function wireR(e:Event,n:int):void
		{   
			removeChild(andLineR[n]);
			var line:Sprite = new Sprite();
			var additLine:Sprite = new Sprite();
			if (andRightResult[n] == true)
				{
					line.graphics.lineStyle(3, 0xF7C709);
				}
			else
				{
					line.graphics.lineStyle(3, 0x000001);
				}
			if (lineRAddAnd[n])
				{
					removeChild(additLineRAnd[n]);
					if (andRightResult[n] == true)
					{
						additLine.graphics.lineStyle(6, 0xF7C709,0.3);
					}
					else
					{
						additLine.graphics.lineStyle(6, 0x000001,0.3);
					}
					additLine.graphics.moveTo(andTull[n].x, andTull[n].y+15);
					additLine.graphics.lineTo(andRight[n].x + 10,andRight[n].y + 6);
					additLineRAnd[n] = additLine;
					addChild(additLineRAnd[n]);
				}
			line.graphics.moveTo(andTull[n].x, andTull[n].y+17);
			line.graphics.lineTo(andRight[n].x + 10, andRight[n].y + 6)
			addChild(line);
			andLineR[n] = line;
		}
		//====================================================
		
		public function down(e:Event):void
		{
			var vs:Sprite = new Sprite();
			var flag : int = 0 ;
			var k: int = 0;
			
			var additLine:Sprite = new Sprite();
			for (k = 0;k < 30 && flag==0; k++)
			{
				if(andTull[k]==e.target)
				{
					setChildIndex(andTull[k], numChildren - 1);
					flag = 1;
					myVar = k;// глобальный подсчёт блоков И
					andTull[k].startDrag();
					addEventListener(MouseEvent.MOUSE_MOVE, dragConnect);
					if(leftAndHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragContactsAnd);
					if (rightAndHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragContactsAnd);
					if(!leftAndHit[k]&&!rightAndHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragCircle);
				}
				if (andRight[k]==e.target )
				{
					flag = 1;
					myVar = k;
					andRight[k].startDrag();
					setChildIndex(andRight[k], numChildren - 1);
				}
				if ( andLeft[k]==e.target )
				{
					flag = 1;
					myVar = k;
					andLeft[k].startDrag();
					setChildIndex(andLeft[k], numChildren - 1);
				}	
				if (e.target == andLineL[k])
				{
					flag = 1;
					myVar = k;
					for (var i:int = 0; i < andTull.length;i++)
					{
						if (lineLAddAnd[i])
							{
								lineLAddAnd[i] = false;
								removeChild(additLineLAnd[i]);
								if (i == myVar)
								{
									complite = 1;
								}
								else
								{
									complite = 0;
								}
							}
						if (lineRAddAnd[i])
							{
								lineRAddAnd[i] = false;
								removeChild(additLineRAnd[i]);
								complite = 0;
							}
					}
					for (i = 0; i < notTull.length; i++)
					{
						if (lineRAddNot[i])
							{
								lineRAddNot[i] = false;
								removeChild(additLineRNot[i]);
								complite3 = 0;
							}
					}
					for (i = 0; i < orTull.length; i++)
					{
						if (lineLAddOr[i])
							{
								lineLAddOr[i] = false;
								removeChild(additLineLOr[i]);
								complite2 = 0;
							}
						if (lineRAddOr[i])
							{
								lineRAddOr[i] = false;
								removeChild(additLineROr[i]);
								complite2 = 0;
							}
					}
					for (i = 0; i < nonTull.length;i++)
					{
						if (lineRAddNon[i])
						{
							lineRAddNon[i] = false;
							removeChild(additLineRNon[i]);
							complite4 = 0;
						}
					}
					
					if(!complite)
					{
						flag = 1;
						myVar = k;
						lineLAddAnd[k] = true;
						setChildIndex(andLeft[k], numChildren - 1);
						additLine.graphics.lineStyle(6, 0x000001,0.3);
						additLine.graphics.moveTo(andTull[k].x, andTull[k].y+3);
						additLine.graphics.lineTo(andLeft[k].x + 10,andLeft[k].y +5);
						additLineLAnd[k] = additLine;
						addChild(additLineLAnd[k]);
						complite = 1;
					}
					else
						complite = 0;
				}
				if (e.target == andLineR[k])
				{
					flag = 1;
					myVar = k;
					for (i = 0; i < andTull.length;i++)
					{
						if (lineRAddAnd[i])
							{
							lineRAddAnd[i] = false;
							removeChild(additLineRAnd[i]);
							if (i == myVar)
							{
								complite = 1;
							}
							else
							{
								complite = 0;
							}
						}
						if (lineLAddAnd[i])
							{
								lineLAddAnd[i] = false;
								removeChild(additLineLAnd[i]);
								complite = 0;
							}
					}
					for (i = 0; i < notTull.length; i++)
					{
						if (lineRAddNot[i])
							{
								lineRAddNot[i] = false;
								removeChild(additLineRNot[i]);
								complite3 = 0;
							}
					}
					for (i = 0; i < orTull.length; i++)
					{
						if (lineLAddOr[i])
							{
								lineLAddOr[i] = false;
								removeChild(additLineLOr[i]);
								complite2 = 0;
							}
						if (lineRAddOr[i])
							{
								lineRAddOr[i] = false;
								removeChild(additLineROr[i]);
								complite2 = 0;
							}
					}
					for (i = 0; i < nonTull.length;i++)
					{
						if (lineRAddNon[i])
						{
							lineRAddNon[i] = false;
							removeChild(additLineRNon[i]);
							complite4 = 0;
						}
					}
					if(!complite)
					{
						flag = 1;
						myVar = k;
						lineRAddAnd[k] = true;
						setChildIndex(andRight[k], numChildren - 1);
						additLine.graphics.lineStyle(6, 0x000001,0.3);
						additLine.graphics.moveTo(andTull[k].x, andTull[k].y+15);
						additLine.graphics.lineTo(andRight[k].x + 10,andRight[k].y + 6);
						additLineRAnd[k] = additLine;
						addChild(additLineRAnd[k]);
						complite = 1;
					}
					else
						complite = 0;
				}
			}			
			
		}
		//===================================================
		public function controlWire(e:Event):void
		{
			for (var i:int = 0; i < numAnd; i++)
			{
				wireL(e,i);
				wireR(e,i);
			}
		}
		//===================================================
		public function dragCircle(event:MouseEvent):void 
		{ 
			var x1:int = andLeft[myVar].x;
			var y1:int=andLeft[myVar].y;
			var x2:int=andRight[myVar].x;
			var y2:int = andRight[myVar].y;
			if (myVar >= 0)
			{
				andAim[myVar].x = andTull[myVar].x + 30; 
				andAim[myVar].y = andTull[myVar].y + 11;
				andLeft[myVar].x = andTull[myVar].x - 20; 
				andLeft[myVar].y = andTull[myVar].y-3 ;
				andRight[myVar].x = andTull[myVar].x - 20; 
				andRight[myVar].y = andTull[myVar].y + 12;
				wireL(event,myVar);
				wireR(event,myVar);
				event.updateAfterEvent(); 
			}

		} 	
		//====================================================
		public function dragContactsAnd(event:MouseEvent):void 
		{
			if (myVar >= 0)
			{
			andAim[myVar].x = andTull[myVar].x + 30; 
			andAim[myVar].y = andTull[myVar].y + 11;
			if (!leftAndHit[myVar])
			{
				andLeft[myVar].x = andTull[myVar].x - 20; 
				andLeft[myVar].y = andTull[myVar].y - 5;
			}
			
			if (!rightAndHit[myVar])
			{
				andRight[myVar].x = andTull[myVar].x - 20; 
				andRight[myVar].y = andTull[myVar].y + 10;
			}
			//if (leftAndHit[myVar] && rightAndHit[myVar])
			
			wireL(event,myVar);
			wireR(event,myVar);
			event.updateAfterEvent(); 
			}
		}
		//===================================================
		public function dragConnect(event:MouseEvent):void
		{
			if (myVar >= 0)
				moveconnect(event, myVar, andAim);
		}
		//=====================================================
		public function dragConnectOr(event:MouseEvent):void
		{
			if (myVar2 >= 0)
				moveconnect(event, myVar2, orAim);
		}
		//======================================================
		public function dragConnectNot(event:MouseEvent):void
		{
			if (myVar3 >= 0)
				moveconnect(event, myVar3, notAim);
		}
		//=======================================================
		public function dragConnectNon(event:MouseEvent):void
		{
			if (myVar4 >= 0)
				moveconnect(event, myVar4, nonAim);
		}
		//===================================================
		public function moveconnect(e:MouseEvent,n:int, aim:Array):void
		{
			var flag:int = 1;
			for (var i:int = 0; i < andTull.length&&flag; i++)
			{
				if (andLeft[i].hitTestObject(aim[n]))
				{
					andLeft[i].x = aim[n].x-4;
					andLeft[i].y = aim[n].y-5;
					flag = 0;
				}
				if (andRight[i].hitTestObject(aim[n]))
				{
					andRight[i].x = aim[n].x-4;
					andRight[i].y = aim[n].y-5;
					flag = 0;
				}
			}
			for (i = 0; i < orTull.length&&flag; i++)
			{
				if (orLeft[i].hitTestObject(aim[n]))
				{
					orLeft[i].x = aim[n].x-4;
					orLeft[i].y = aim[n].y-5;
					flag = 0;
				}
				if (orRight[i].hitTestObject(aim[n]))
				{
					orRight[i].x = aim[n].x-4;
					orRight[i].y = aim[n].y-5;
					flag = 0;
				}
			}
			for (i = 0; i < notTull.length&&flag; i++)
			{
				if (notRight[i].hitTestObject(aim[n]))
				{
					notRight[i].x = aim[n].x-4;
					notRight[i].y = aim[n].y-5;
					flag = 0;
				}
			}
			for (i = 0; i < nonTull.length&&flag; i++)
			{
				if (nonRight[i].hitTestObject(aim[n]))
				{
					nonRight[i].x = aim[n].x-4;
					nonRight[i].y = aim[n].y-5;
					flag = 0;
				}
			}
			for (i = 0; i < 10&&flag; i++)
			{
				if (answerCon[i].hitTestObject(aim[n]))
				{
					answerCon[i].x = aim[n].x-4;
					answerCon[i].y = aim[n].y-5;
					flag = 0;
				}
			}
			e.updateAfterEvent(); 
		}
		//===================================================
		public function up(e:Event):void
		{
			var flag:int = 0;
			var k:int = 0;
			var vs:Sprite = new Sprite();//вспомогательная переменная
			var vs2:Boolean;
			if (e.target == andLeft[myVar])
				{
					andLeft[myVar].stopDrag();
					for (k = 0; k < 9; k++)
					{
						if (andLeft[myVar].hitTestObject(circle_lamp_Green[k]))
							{
								andLeft[myVar].x = circle_lamp_Green[k].x+3;
								andLeft[myVar].y = circle_lamp_Green[k].y-5;
							}
					}
					for (k = 0; k < andTull.length; k++)
					{
						if (andLeft[myVar].hitTestObject(andAim[k]))
						{
							andLeft[myVar].x = andAim[k].x-4;
							andLeft[myVar].y = andAim[k].y-5;
						}
					}
					for (k = 0; k < orTull.length; k++)
					{
						if (andLeft[myVar].hitTestObject(orAim[k]))
						{
							andLeft[myVar].x = orAim[k].x-4;
							andLeft[myVar].y = orAim[k].y-5;
						}
					}
					for (k = 0; k < notTull.length; k++)
					{
						if (andLeft[myVar].hitTestObject(notAim[k]))
						{
							andLeft[myVar].x = notAim[k].x-4;
							andLeft[myVar].y = notAim[k].y-5;
						}
					}
					
				}
				if (e.target == andRight[myVar])
				{
					andRight[myVar].stopDrag();
					for (k = 0; k < 9; k++)
					{
						if (andRight[myVar].hitTestObject(circle_lamp_Green[k]))
							{
								andRight[myVar].x = circle_lamp_Green[k].x+3;
								andRight[myVar].y = circle_lamp_Green[k].y-5;
							}
					}
					for (k = 0; k < andTull.length; k++)
					{
						if (andRight[myVar].hitTestObject(andAim[k]))
						{
							andRight[myVar].x = andAim[k].x-4;
							andRight[myVar].y = andAim[k].y-5;
						}
					}
					for (k = 0; k < orTull.length; k++)
					{
						if (andRight[myVar].hitTestObject(orAim[k]))
						{
							andRight[myVar].x = orAim[k].x-4;
							andRight[myVar].y = orAim[k].y-5;
						}
					}
					for (k = 0; k < notTull.length; k++)
					{
						if (andRight[myVar].hitTestObject(notAim[k]))
						{
							andRight[myVar].x = notAim[k].x-4;
							andRight[myVar].y = notAim[k].y-5;
						}
					}
					for (k = 0; k < nonTull.length; k++)
					{
						if (andRight[myVar].hitTestObject(nonAim[k]))
						{
							andRight[myVar].x = nonAim[k].x-4;
							andRight[myVar].y = nonAim[k].y-5;
						}
					}
				}
				if(e.target==andTull[myVar])
				{
					andTull[myVar].stopDrag();
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragCircle);
					removeEventListener(MouseEvent.MOUSE_MOVE, dragConnect);
					if(leftAndHit[myVar])
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragContactsAnd);
					if (rightAndHit[myVar])
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragContactsAnd);
					if(!leftAndHit[myVar]&&!rightAndHit[myVar])
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragCircle);
				}
			
			if (myVar >= 0)// дополнительная проверка, так как при добавлении кнопки срабатывает функция up,
						   //а переменная ещё не изменилась
			{
				if(andTull[myVar].hitTestObject(bin))//Удаление
					{
						removeChild(andLeft[myVar]);
						removeChild(andRight[myVar]);
						removeChild(andAim[myVar]);
						removeChild(andTull[myVar]);
						removeChild(andLineL[myVar]);
						removeChild(andLineR[myVar]);
						if (lineLAddAnd[myVar])
							removeChild(additLineLAnd[myVar]);
						if (lineRAddAnd[myVar])
							removeChild(additLineRAnd[myVar]);
						flag = 1;
					}
				if (flag)
				{
					flag = 0;
					vs = andTull[myVar];
					andTull[myVar] = andTull[andTull.length - 1];
					andTull[andTull.length - 1] = vs;
				
					vs = andAim[myVar];
					andAim[myVar] = andAim[andAim.length - 1];
					andAim[andAim.length - 1] = vs;
					
					vs = andLeft[myVar];
					andLeft[myVar] = andLeft[andLeft.length - 1];
					andLeft[andLeft.length - 1] = vs;
				
					vs = andRight[myVar];
					andRight[myVar] = andRight[andRight.length - 1];
					andRight[andRight.length - 1] = vs;
					
					vs = andLineL[myVar];
					andLineL[myVar] = andLineL[andLineL.length - 1];
					andLineL[andLineL.length - 1] = vs;
					
					vs = andLineR[myVar];
					andLineR[myVar] = andLineR[andLineR.length - 1];
					andLineR[andLineR.length - 1] = vs;
					
					vs2 = andLeftResult[myVar];
					andLeftResult[myVar] = andLeftResult[andLeftResult.length - 1];
					andLeftResult[andLeftResult.length - 1] = vs2;
					
					vs2 = andRightResult[myVar];
					andRightResult[myVar] = andRightResult[andRightResult.length - 1];
					andRightResult[andRightResult.length - 1] = vs2;
					
					vs2 = leftAndHit[myVar];
					leftAndHit[myVar] = leftAndHit[leftAndHit.length - 1];
					leftAndHit[leftAndHit.length - 1] = vs2;
					
					vs2 = rightAndHit[myVar];
					rightAndHit[myVar] = rightAndHit[rightAndHit.length - 1];
					rightAndHit[rightAndHit.length - 1] = vs2;
					
					//if ( lineLAddAnd[myVar])
					//{
						vs = additLineLAnd[myVar];
						additLineLAnd[myVar] = additLineLAnd[additLineLAnd.length - 1];
						additLineLAnd[additLineLAnd.length - 1] = vs;
						additLineLAnd.pop();
					//	trace(1);
					//}
					//if ( lineLAddAnd[myVar])
					//{
						vs2 = lineLAddAnd[myVar];
						lineLAddAnd[myVar] = lineLAddAnd[lineLAddAnd.length - 1];
						lineLAddAnd[lineLAddAnd.length - 1] = vs2;
						lineLAddAnd.pop();
					//	trace(2);
					//}
					
					//if ( lineRAddAnd[myVar])
					//{
						vs = additLineRAnd[myVar];
						additLineRAnd[myVar] = additLineRAnd[additLineRAnd.length - 1];
						additLineRAnd[additLineRAnd.length - 1] = vs;
						additLineRAnd.pop();
					//}
					//if ( lineRAddAnd[myVar])
					//{
						vs2 = lineRAddAnd[myVar];
						lineRAddAnd[myVar] = lineRAddAnd[lineRAddAnd.length - 1];
						lineRAddAnd[lineRAddAnd.length - 1] = vs2;
						lineRAddAnd.pop();
					//}
					
					
					andTull.pop();
					andAim.pop();
					andLeft.pop();
					andRight.pop();
					andLineL.pop();
					andLineR.pop();
					andLeftResult.pop();
					andRightResult.pop();
					rightAndHit.pop();
					leftAndHit.pop();
					
					myVar--;
					NumberBlokcs--;
					numAnd--;
				}
			}
		}
		//===================================================
		public function controllaContatto(e:Event):void
		{
			var flag:int = 1;
			var unit1:int = 1; var unit1b:int = 1;
			var unit2:int = 1; var unit2b:int = 1;
			var unit3:int = 1; var unit3b:int = 1;
			var unit4:int = 1; var unit4b:int = 1;
			var unit5:int = 1; var unit5b:int = 1;
			for (var i:int = 0; i < andRight.length; i++)
			{
				for (var k:int = 0; k < 9;k++)
					{
						if(andRight[i].hitTestObject(circle_lamp_Green[k]))
							{
								unit1 = 0;
								rightAndHit[i] = true;
								andRightResult[i] = circle_lamp_Green[k].visible;
							}
						if(andLeft[i].hitTestObject(circle_lamp_Green[k]))
							{
								unit1b = 0;
								leftAndHit[i] = true;
								andLeftResult[i] = circle_lamp_Green[k].visible;
							}
					}
				for (k = 0; k < andTull.length; k++)
					{
						if (andRight[i].hitTestObject(andAim[k]))
							{
								unit2 = 0;
								rightAndHit[i] = true;
								andRightResult[i] = andAimResult[k];
							}
						if (andLeft[i].hitTestObject(andAim[k]))
							{
								unit2b = 0;
								leftAndHit[i] = true;
								andLeftResult[i] = andAimResult[k];
							}
					}
				for (k = 0; k < orTull.length;k++)
					{
						if (andRight[i].hitTestObject(orAim[k]))
							{
								unit3 = 0;
								rightAndHit[i] = true;
								andRightResult[i] = orAimResult[k];
							}
						if (andLeft[i].hitTestObject(orAim[k]))
							{
								unit3b = 0;
								leftAndHit[i] = true;
								andLeftResult[i] = orAimResult[k];
							}
					}
				for (k = 0; k < notTull.length; k++)
				{
					if (andRight[i].hitTestObject(notAim[k]))
							{
								unit4 = 0;
								rightAndHit[myVar] = true;
								andRightResult[i] = notAimResult[k];
							}
					if (andLeft[i].hitTestObject(notAim[k]))
							{
								unit4b = 0;
								leftAndHit[myVar] = true;
								andLeftResult[i] = notAimResult[k];
							}
				}
				for (k = 0; k < nonTull.length; k++)
				{
					if (andRight[i].hitTestObject(nonAim[k]))
							{
								unit5 = 0;
								rightAndHit[myVar] = true;
								andRightResult[i] = nonAimResult[k];
							}
					if (andLeft[i].hitTestObject(nonAim[k]))
							{
								unit5b = 0;
								leftAndHit[myVar] = true;
								andLeftResult[i] = nonAimResult[k];
							}
				}			
				andAimResult[i] = andLeftResult[i] && andRightResult[i];
				if (unit1 && unit2 && unit3 && unit4&& unit5)
					{
						rightAndHit[i] = false;
					}
				if (unit1b && unit2b && unit3b && unit4b&&unit5b)
					{
						leftAndHit[i] = false;
					}
				unit1 = unit2 = unit3 = unit4 = unit5 = 1;
				unit1b = unit2b = unit3b = unit4b = unit5b = 1;
			}
			/*for (i = 0; i < 10; i++)
			{
				for (k = 0; k < andTull.length&&flag; k++)
				{
					if (circle_lamp_Green_prov[i].hitTestObject(andAim[k]))
					{
						circle_lamp_Green_prov[i].visible = andAimResult[k];
						flag = 0;
					}
					else
					{
						circle_lamp_Green_prov[i].visible = false;
					}
				}
				flag = 1;
			}*/
		}
		//===================================================
		[Embed(source="Or_01.png")]
		public static const Or:Class;
		
		public function Createor(e:Event):void 
		{
			del_result(e);
			timer.stop();
			var img1:*= new Or;
			var img2:*= new Conect;
			var img3:*= new Conect;
            var tull:Sprite = new Sprite(); //тело
		    var leftc:Sprite = new Sprite();// левый контакт
		    var rightc:Sprite = new Sprite();// правый контакт
		    var aimc:Sprite = createCircle(0x200321, 3, 0);	//		итоговый контакт
			tull.addChild(img1);
			leftc.addChild(img2);
			rightc.addChild(img3);
			
			
			tull.x = 350;
			tull.y = 10;
			leftc.x = 330;
			leftc.y = 5;
			rightc.x = 330;
			rightc.y = 20;
			aimc.x = 380;
			aimc.y = 20;
			
			orTull.push(tull);
			orLeft.push(leftc);
			orRight.push(rightc);
			orAim.push(aimc);
			
			addChild(leftc);
			addChild(tull);	
			addChild(rightc);
			addChild(aimc);
			
			createLine(tull.x, tull.y, rightc.x, rightc.y, orLineR,30,15,numOr);
			createLine(tull.x, tull.y, leftc.x, leftc.y, orLineL,30,15,numOr);
			
			addEventListener(MouseEvent.MOUSE_DOWN, downor);
			addEventListener(MouseEvent.MOUSE_UP,  upor);
			addEventListener(Event.ENTER_FRAME, controllaContattoor);
			addEventListener(Event.ENTER_FRAME, controlWireOr);
			
			NumberBlokcs++;
			numOr++;
		}
		//===================================================
		public function wireRor(e:Event,n:int):void
		{   
			removeChild(orLineR[n]);
			var line:Sprite = new Sprite();
			var additLine:Sprite = new Sprite();
			if (orRightResult[n] == true)
				{
					line.graphics.lineStyle(3, 0xF7C709);
				}
			else
				{
					line.graphics.lineStyle(3, 0x000001);
				}
			if (lineRAddOr[n])
				{
					removeChild(additLineROr[n]);
					if (orRightResult[n] == true)
					{
						additLine.graphics.lineStyle(6, 0xF7C709,0.3);
					}
					else
					{
						additLine.graphics.lineStyle(6, 0x000001,0.3);
					}
					additLine.graphics.moveTo(orTull[n].x, orTull[n].y+15);
					additLine.graphics.lineTo(orRight[n].x + 10,orRight[n].y + 6);
					additLineROr[n] = additLine;
					addChild(additLineROr[n]);
				}
			line.graphics.moveTo(orTull[n].x, orTull[n].y+15);
			line.graphics.lineTo(orRight[n].x + 10,orRight[n].y + 6);
			addChild(line);
			orLineR[n] = line;
		}
		//=======================================================
		public function wireLor(e:Event,n:int):void
		{   
			removeChild(orLineL[n]);
			var line:Sprite = new Sprite();
			var additLine:Sprite = new Sprite();
			if (orLeftResult[n] == true)
				{
					line.graphics.lineStyle(3, 0xF7C709);
				}
			else
				{
					line.graphics.lineStyle(3, 0x000001);
				}
			if (lineLAddOr[n])
				{
					removeChild(additLineLOr[n]);
					if (orLeftResult[n] == true)
					{
						additLine.graphics.lineStyle(6, 0xF7C709,0.3);
					}
					else
					{
						additLine.graphics.lineStyle(6, 0x000001,0.3);
					}
					additLine.graphics.moveTo(orTull[n].x, orTull[n].y+3);
					additLine.graphics.lineTo(orLeft[n].x + 10,orLeft[n].y + 6);
					additLineLOr[n] = additLine;
					addChild(additLineLOr[n]);
				}
			line.graphics.moveTo(orTull[n].x, orTull[n].y+3);
			line.graphics.lineTo(orLeft[n].x + 10,orLeft[n].y + 6);
			addChild(line);
			orLineL[n] = line;
		}
		//===================================================
		public function controlWireOr(e:Event):void
		{
			for (var i:int = 0; i < numOr; i++)
			{
				wireLor(e,i);
				wireRor(e,i);
			}
		}
		//======================================================
		public function downor(e:Event):void
		{
			var flag : int = 0 ;
			var k: int = 0;
			var additLine:Sprite = new Sprite();
			for (k = 0;k < 30 && flag==0; k++)
			{
				if(orTull[k]==e.target)
				{
					myVar2 = k;
					flag = 1;
					setChildIndex(orTull[k], numChildren - 1);
					orTull[k].startDrag();
					addEventListener(MouseEvent.MOUSE_MOVE, dragConnectOr);
					if(leftOrHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragContactsOr);
					if (rightOrHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragContactsOr);
					if(!leftOrHit[k]&&!rightOrHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragCircleor);
				}
				if (orRight[k]==e.target )
				{
					flag = 1;
					myVar2 = k;
					setChildIndex(orRight[k], numChildren - 1);
					orRight[k].startDrag();
				}
				if ( orLeft[k]==e.target )
				{
					flag = 1;
					myVar2 = k;
					setChildIndex(orLeft[k], numChildren - 1);
					orLeft[k].startDrag();
				}	
				if (e.target == orLineL[k])
				{
					flag = 1;
					myVar2 = k;
					for (var i:int = 0; i < orTull.length;i++)
					{
						if (lineLAddOr[i])
							{
								lineLAddOr[i] = false;
								removeChild(additLineLOr[i]);
								if (i == myVar2)
								{
									complite2 = 1;
								}
								else
								{
									complite2 = 0;
								}
							}
						if (lineRAddOr[i])
							{
								lineRAddOr[i] = false;
								removeChild(additLineROr[i]);
								complite2 = 0;
							}
					}
					for (i = 0; i < notTull.length; i++)
					{
						if (lineRAddNot[i])
							{
								lineRAddNot[i] = false;
								removeChild(additLineRNot[i]);
								complite3 = 0;
							}
					}
					for (i = 0; i < andTull.length; i++)
					{
						if (lineLAddAnd[i])
							{
								lineLAddAnd[i] = false;
								removeChild(additLineLAnd[i]);
								complite = 0;
							}
						if (lineRAddAnd[i])
							{
								lineRAddAnd[i] = false;
								removeChild(additLineRAnd[i]);
								complite = 0;
							}
					}
					for (i = 0; i < nonTull.length;i++)
					{
						if (lineRAddNon[i])
						{
							lineRAddNon[i] = false;
							removeChild(additLineRNon[i]);
							complite4 = 0;
						}
					}
					if(!complite2)
					{
						flag = 1;
						myVar2 = k;
						lineLAddOr[k] = true;
						setChildIndex(orLeft[k], numChildren - 1);
						additLine.graphics.lineStyle(6, 0x000001FF);
						additLine.graphics.moveTo(orTull[k].x, orTull[k].y+3);
						additLine.graphics.lineTo(orLeft[k].x + 10,orLeft[k].y + 6);
						additLineLOr[k] = additLine;
						addChild(additLineLOr[k]);
						complite2 = 1;
					}
					else
						complite2 = 0;
				}
				if (e.target == orLineR[k])
				{
					flag = 1;
					myVar2 = k;
					for (i = 0; i < orTull.length;i++)
					{
						if (lineRAddOr[i])
							{
								lineRAddOr[i] = false;
								removeChild(additLineROr[i]);
								if (i == myVar2)
								{
									complite2 = 1;
								}
								else
								{
									complite2 = 0;
								}
							}
						if (lineLAddOr[i])
							{
								lineLAddOr[i] = false;
								removeChild(additLineLOr[i]);
								complite2 = 0;
							}
					}
					for (i = 0; i < notTull.length; i++)
					{
						if (lineRAddNot[i])
							{
								lineRAddNot[i] = false;
								removeChild(additLineRNot[i]);
								complite3 = 0;
							}
					}
					for (i = 0; i < andTull.length; i++)
					{
						if (lineLAddAnd[i])
							{
								lineLAddAnd[i] = false;
								removeChild(additLineLAnd[i]);
								complite = 0;
							}
						if (lineRAddAnd[i])
							{
								lineRAddAnd[i] = false;
								removeChild(additLineRAnd[i]);
								complite = 0;
							}
					}
					for (i = 0; i < nonTull.length;i++)
					{
						if (lineRAddNon[i])
						{
							lineRAddNon[i] = false;
							removeChild(additLineRNon[i]);
							complite4 = 0;
						}
					}
					if(!complite2)
					{
						flag = 1;
						myVar2 = k;
						lineRAddOr[k] = true;
						setChildIndex(orRight[k], numChildren - 1);
						additLine.graphics.lineStyle(6, 0x00CCFF);
						additLine.graphics.moveTo(orTull[k].x, orTull[k].y+15);
						additLine.graphics.lineTo(orRight[k].x + 10,orRight[k].y + 6);
						additLineROr[k] = additLine;
						addChild(additLineROr[k]);
						complite2 = 1;
					}
					else
						complite2 = 0;
				}

			}			
			
		}
		//===================================================
		public function dragCircleor(event:MouseEvent):void 
		{ 
			if (myVar2 >= 0)
			{
				orLeft[myVar2].x = orTull[myVar2].x -20; 
				orLeft[myVar2].y = orTull[myVar2].y -5;
				orRight[myVar2].x = orTull[myVar2].x - 20; 
				orRight[myVar2].y = orTull[myVar2].y +12;
				orAim[myVar2].x = orTull[myVar2].x + 30; 
				orAim[myVar2].y = orTull[myVar2].y +11;
				wireLor(event,myVar2);
				wireRor(event,myVar2);
				event.updateAfterEvent(); 
			}
		} 
		//====================================================
		public function dragContactsOr(event:MouseEvent):void 
		{ 
			if (myVar2 >= 0)
			{
				if (!leftOrHit[myVar2])
				{
					orLeft[myVar2].x = orTull[myVar2].x -20; 
					orLeft[myVar2].y = orTull[myVar2].y -3;
				}
				if (!rightOrHit[myVar2])
				{
					orRight[myVar2].x = orTull[myVar2].x - 20; 
					orRight[myVar2].y = orTull[myVar2].y +12;
				}
				orAim[myVar2].x = orTull[myVar2].x + 30; 
				orAim[myVar2].y = orTull[myVar2].y +11;
				wireLor(event,myVar2);
				wireRor(event,myVar2);
				event.updateAfterEvent(); 
			}
		} 
		//===================================================
		public function upor(e:Event):void
		{
			var flag:int = 0;
			var k:int = 0;
			var vs2:Sprite = new Sprite();
			var vs:Boolean;
			if (e.target == orLeft[myVar2])
				{
					orLeft[myVar2].stopDrag();
					for (k = 0; k < 9; k++)
					{
						if (orLeft[myVar2].hitTestObject(circle_lamp_Green[k]))
							{
								orLeft[myVar2].x = circle_lamp_Green[k].x+3;
								orLeft[myVar2].y = circle_lamp_Green[k].y-5;
							}
					}
					for (k = 0; k < andTull.length; k++)
					{
						if (orLeft[myVar2].hitTestObject(andAim[k]))
						{
							orLeft[myVar2].x = andAim[k].x - 4;
							orLeft[myVar2].y = andAim[k].y - 5;
						}
					}
					for (k = 0; k < orTull.length; k++)
					{
						if (orLeft[myVar2].hitTestObject(orAim[k]))
						{
							orLeft[myVar2].x = orAim[k].x - 4;
							orLeft[myVar2].y = orAim[k].y - 5;
						}
					}
					for (k = 0; k < notTull.length; k++)
					{
						if (orLeft[myVar2].hitTestObject(notAim[k]))
						{
							orLeft[myVar2].x = notAim[k].x - 4;
							orLeft[myVar2].y = notAim[k].y - 5;
						}
					}
				}
				if (e.target == orRight[myVar2])
				{
					orRight[myVar2].stopDrag();
					for (k = 0; k < 9; k++)
					{
						if (orRight[myVar2].hitTestObject(circle_lamp_Green[k]))
							{
								orRight[myVar2].x = circle_lamp_Green[k].x + 3;
								orRight[myVar2].y = circle_lamp_Green[k].y - 5;
							}
					}
					for (k = 0; k < andTull.length; k++)
					{
						if (orRight[myVar2].hitTestObject(andAim[k]))
						{
							orRight[myVar2].x = andAim[k].x - 4;
							orRight[myVar2].y = andAim[k].y - 5;
						}
					}
					for (k = 0; k < orTull.length; k++)
					{
						if (orRight[myVar2].hitTestObject(orAim[k]))
						{
							orRight[myVar2].x = orAim[k].x - 4;
							orRight[myVar2].y = orAim[k].y - 5;
						}
					}
					for (k = 0; k < notTull.length; k++)
					{
						if (orRight[myVar2].hitTestObject(notAim[k]))
						{
							orRight[myVar2].x = notAim[k].x - 4;
							orRight[myVar2].y = notAim[k].y - 5;
						}
					}
				}
				if(e.target==orTull[myVar2])
				{
					orTull[myVar2].stopDrag();
					removeEventListener(MouseEvent.MOUSE_MOVE, dragConnectOr);
					if(leftOrHit[myVar2])
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragContactsOr);
					if (rightOrHit[myVar2])
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragContactsOr);
					if(!leftOrHit[myVar2]&&!rightOrHit[myVar2])
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragCircleor);
					
				}
			//stage.removeEventListener(MouseEvent.MOUSE_MOVE, distanceOr); 
			if (myVar2 >= 0)
			{
				if(orTull[myVar2].hitTestObject(bin))//Удаление
					{
						
						removeChild(orLeft[myVar2]);
						removeChild(orRight[myVar2]);
						removeChild(orAim[myVar2]);
						removeChild(orTull[myVar2]);
						removeChild(orLineR[myVar2]);
						removeChild(orLineL[myVar2]);
						if (lineLAddOr[myVar2])
							removeChild(additLineLOr[myVar2]);
						if (lineRAddOr[myVar2])
							removeChild(additLineROr[myVar2]);
						flag = 1;
						
					}
				if (flag)
				{
					flag = 0;
					vs2 = orTull[myVar2];
					orTull[myVar2] = orTull[orTull.length - 1];
					orTull[orTull.length - 1] = vs2;
				
					vs2 = orAim[myVar2];
					orAim[myVar2] = orAim[orAim.length - 1];
					orAim[orAim.length - 1] = vs2;
				
					vs2 = orLeft[myVar2];
					orLeft[myVar2] = orLeft[orLeft.length - 1];
					orLeft[orLeft.length - 1] = vs2;
				
					vs2 = orRight[myVar2];
					orRight[myVar2] = orRight[orRight.length - 1];
					orRight[orRight.length - 1] = vs2;
					
					vs2 = orLineR[myVar2];
					orLineR[myVar2] = orLineR[orLineR.length - 1];
					orLineR[orLineR.length - 1] = vs2;
					
					vs2 = orLineL[myVar2];
					orLineL[myVar2] = orLineL[orLineL.length - 1];
					orLineL[orLineL.length - 1] = vs2;
					
					vs = orLeftResult[myVar2];
					orLeftResult[myVar2] = orLeftResult[orLeftResult.length - 1];
					orLeftResult[orLeftResult.length - 1] = vs;
					
					vs = orRightResult[myVar2];
					orRightResult[myVar2] = orRightResult[orRightResult.length - 1];
					orRightResult[orRightResult.length - 1] = vs;
					
					vs2 = additLineROr[myVar2];
					additLineROr[myVar2] = additLineROr[additLineROr.length - 1];
					additLineROr[additLineROr.length - 1] = vs2;
					additLineROr.pop();
					
					vs = lineRAddOr[myVar2];
					lineRAddOr[myVar2] = lineRAddOr[lineRAddOr.length - 1];
					lineRAddOr[lineRAddOr.length - 1] = vs;
					lineRAddOr.pop();
					
					vs2 = additLineLOr[myVar2];
					additLineLOr[myVar2] = additLineLOr[additLineLOr.length - 1];
					additLineLOr[additLineLOr.length - 1] = vs2;
					additLineLOr.pop();
					
					vs = lineLAddOr[myVar2];
					lineLAddOr[myVar2] = lineLAddOr[lineLAddOr.length - 1];
					lineLAddOr[lineLAddOr.length - 1] = vs;
					lineLAddOr.pop();
					
					
					orTull.pop();
					orAim.pop();
					orLeft.pop();
					orRight.pop();
					orLineAim.pop()
					orLineL.pop();
					orLineR.pop();
					orLeftResult.pop();
					orRightResult.pop();
					myVar2--;
					NumberBlokcs--;
					numOr--;
				}
			}
		}
		//===================================================
		public function controllaContattoor(e:Event):void
		{
			var flag:int = 1;
			var unit1:int = 1; var unit1b:int = 1;
			var unit2:int = 1; var unit2b:int = 1;
			var unit3:int = 1; var unit3b:int = 1;
			var unit4:int = 1; var unit4b:int = 1;
			var unit5:int = 1; var unit5b:int = 1;
			for (var i:int = 0; i < orRight.length; i++)
			{
				for (var k:int = 0; k < 9;k++)
					{
						if (orRight[i].hitTestObject(circle_lamp_Green[k]))
						{
							orRightResult[i] = circle_lamp_Green[k].visible;
							unit1 = 0;
							rightOrHit[i] = true;
						}
						if(orLeft[i].hitTestObject(circle_lamp_Green[k]))
							{
								unit1b = 0;
								leftOrHit[i] = true;
								orLeftResult[i] = circle_lamp_Green[k].visible;
							}
					}
				for (k = 0; k < orTull.length; k++)
					{
						if (orRight[i].hitTestObject(orAim[k]))
							{
								unit2 = 0;
								rightOrHit[i] = true;
								orRightResult[i] = orAimResult[k];
							}
						if (orLeft[i].hitTestObject(orAim[k]))
							{
								unit2b = 0;
								leftOrHit[i] = true;
								orLeftResult[i] = orAimResult[k];
							}
					}
				for (k = 0; k < andTull.length;k++)
					{
						if (orRight[i].hitTestObject(andAim[k]))
							{
								unit3 = 0;
								rightOrHit[i] = true;
								orRightResult[i] = andAimResult[k];
							}
						if (orLeft[i].hitTestObject(andAim[k]))
							{
								unit3b = 0;
								leftOrHit[i] = true;
								orLeftResult[i] = andAimResult[k];
							}
					}
				for (k = 0; k < notTull.length; k++)
					{
						if (orRight[i].hitTestObject(notAim[k]))
							{
								unit4 = 0;
								rightOrHit[i] = true;
								orRightResult[i] = notAimResult[k];
							}
						if (orLeft[i].hitTestObject(notAim[k]))
							{
								unit4b = 0;
								leftOrHit[i] = true;
								orLeftResult[i] = notAimResult[k];
							}
					}
					for (k = 0; k < nonTull.length; k++)
					{
						if (orRight[i].hitTestObject(nonAim[k]))
							{
								unit5 = 0;
								rightOrHit[i] = true;
								orRightResult[i] = nonAimResult[k];
							}
						if (orLeft[i].hitTestObject(nonAim[k]))
							{
								unit5b = 0;
								leftOrHit[i] = true;
								orLeftResult[i] = nonAimResult[k];
							}
					}
				
				orAimResult[i] = orLeftResult[i] || orRightResult[i];
				if (unit1 && unit2 && unit3 && unit4&&unit5)
					{
						rightOrHit[i] = false;
					}
				if (unit1b && unit2b && unit3b && unit4b&&unit5b)
					{
						leftOrHit[i] = false;
					}
				unit1 = unit2 = unit3 = unit4 = unit5 = 1;
				unit1b = unit2b = unit3b = unit4b = unit5b = 1;
			}
			/*for (i = 0; i < 10; i++)
				{
					for (k = 0; k < orTull.length&&flag; k++)
					{
						if (circle_lamp_Green_prov[i].hitTestObject(orAim[k]))
						{
							circle_lamp_Green_prov[i].visible = orAimResult[k];
							flag = 0;
						}
						else
						{
							circle_lamp_Green_prov[i].visible = false;
						}
					}
					flag = 1;
				}*/
		}
		//===================================================
		[Embed(source="Not_01.png")]
		public static const Not:Class;
		
		public function Createnot(e:Event):void 
		{
			del_result(e);
			timer.stop();
			var img1:*= new Not;
			var img2:*= new Conect;
			
            var tull:Sprite = new Sprite(); //тело
		    var rightc:Sprite = new Sprite();//  контакт
		    var aimc:Sprite = createCircle(0x200321, 3,0);	//		итоговый контакт
			tull.addChild(img1);
			rightc.addChild(img2);
			
			tull.x = 350;
			tull.y = 10;
			rightc.x = 330;
			rightc.y = 15;
			aimc.x = 380;
			aimc.y = 21;
			
			notTull.push(tull);
			notRight.push(rightc);
			notAim.push(aimc);
			
			addChild(tull);	
			addChild(rightc);
			addChild(aimc);
			
			createLine(tull.x, tull.y, rightc.x, rightc.y, notLineR,30,15,numNot);
		
			
			addEventListener(MouseEvent.MOUSE_DOWN, downnot);
			addEventListener(MouseEvent.MOUSE_UP,  upnot);
			addEventListener(Event.ENTER_FRAME, controllaContattonot);
			addEventListener(Event.ENTER_FRAME, controlWireNot);
						
			NumberBlokcs++;
			numNot++;
		}
		//===================================================
		public function wireNot(e:Event,n:int):void
		{
			removeChild(notLineR[n]);
			var line:Sprite = new Sprite();
			var additLine:Sprite = new Sprite();
			if (notRightResult[n] == true)
				{
					line.graphics.lineStyle(3, 0xF7C709);
				}
			else
				{
					line.graphics.lineStyle(3, 0x000001);
				}
			if (lineRAddNot[n])
				{
					removeChild(additLineRNot[n]);
					if (notRightResult[n] == true)
					{
						additLine.graphics.lineStyle(6, 0xF7C709,0.3);
					}
					else
					{
						additLine.graphics.lineStyle(6, 0x000001,0.3);
					}

					additLine.graphics.moveTo(notTull[n].x, notTull[n].y+15);
					additLine.graphics.lineTo(notRight[n].x + 12,notRight[n].y + 6);
					additLineRNot[n] = additLine;
					addChild(additLineRNot[n]);
				}
			line.graphics.moveTo(notTull[n].x, notTull[n].y+12);
			line.graphics.lineTo(notRight[n].x + 12,notRight[n].y + 6);
			addChild(line);
			notLineR[n] = line;
		}
		//=====================================================
		public function downnot(e:Event):void
		{
			var flag : int = 0 ;
			var k: int = 0;
			var additLine:Sprite = new Sprite();
			for (k = 0;k < 30 && flag==0; k++)
			{
				if(notTull[k]==e.target)
				{
					myVar3 = k;
					flag = 1;
					setChildIndex(notTull[k], numChildren - 1);
					notTull[k].startDrag();
					addEventListener(MouseEvent.MOUSE_MOVE, dragConnectNot);
					if (rightNotHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragContactsNot);
					if(!rightNotHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragCirclenot);	
				}
				if (notRight[k]==e.target )
				{
					flag = 1;
					myVar3 = k;
					setChildIndex(notRight[k], numChildren - 1);
					notRight[k].startDrag();
				}	
				if (e.target == notLineR[k])
				{
					flag = 1;
					myVar3 = k;
					for (var i:int = 0; i < notTull.length;i++)
					{
						if (lineRAddNot[i])
						{
							lineRAddNot[i] = false;
							removeChild(additLineRNot[i]);
							if (i == myVar3)
							{
								complite3 = 1;
							}
							else
							{
								complite3 = 0;
							}
						}
					}
					for (i = 0; i < orTull.length; i++)
					{
						if (lineLAddOr[i])
							{
								lineLAddOr[i] = false;
								removeChild(additLineLOr[i]);
								complite2 = 0;
							}
						if (lineRAddOr[i])
							{
								lineRAddOr[i] = false;
								removeChild(additLineROr[i]);
								complite2 = 0;
							}
					}
					for (i = 0; i < andTull.length; i++)
					{
						if (lineLAddAnd[i])
							{
								lineLAddAnd[i] = false;
								removeChild(additLineLAnd[i]);
								complite = 0;
							}
						if (lineRAddAnd[i])
							{
								lineRAddAnd[i] = false;
								removeChild(additLineRAnd[i]);
								complite = 0;
							}
					}
					for (i = 0; i < nonTull.length;i++)
					{
						if (lineRAddNon[i])
						{
							lineRAddNon[i] = false;
							removeChild(additLineRNon[i]);
							complite4 = 0;
						}
					}
					if(!complite3)
					{
						flag = 1;
						myVar3 = k;
						lineRAddNot[k] = true;
						setChildIndex(notRight[k], numChildren - 1);
						additLine.graphics.lineStyle(6, 0x00CCFF);
						additLine.graphics.moveTo(notTull[k].x, notTull[k].y+12);
						additLine.graphics.lineTo(notRight[k].x + 12,notRight[k].y + 6);
						additLineRNot[k] = additLine;
						addChild(additLineRNot[k]);
						complite3 = 1;
					}
					else
						complite3 = 0;
				}
			}
		}
		//===================================================
		public function dragCirclenot(event:MouseEvent):void 
		{ 
			if (myVar3 >= 0)
			{
				notAim[myVar3].x = notTull[myVar3].x +30; 
				notAim[myVar3].y = notTull[myVar3].y + 10;
				notRight[myVar3].x = notTull[myVar3].x - 20; 
				notRight[myVar3].y = notTull[myVar3].y + 5;
				wireNot(event,myVar3);
				event.updateAfterEvent(); 
			}
		} 
		//===================================================
		public function controlWireNot(e:Event):void
		{
			for (var i:int = 0; i < numNot; i++)
			{
				wireNot(e,i);
			}
		}
		//=====================================================
		public function dragContactsNot(event:MouseEvent):void 
		{ 
			if (!rightNotHit[myVar3])
			{
				notRight[myVar3].x = notTull[myVar3].x - 20; 
				notRight[myVar3].y = notTull[myVar3].y + 5;
			}
			notAim[myVar3].x = notTull[myVar3].x +30; 
			notAim[myVar3].y = notTull[myVar3].y + 10;
			wireNot(event,myVar3);
			event.updateAfterEvent();
		} 
		//===================================================
		public function upnot(e:Event):void
		{
			var flag:int = 0;
			var k:int = 0;
			var vs2:Sprite = new Sprite();
			var vs:Boolean;
			if (e.target == notRight[myVar3])
			{
				notRight[myVar3].stopDrag();
				for (k = 0; k < 9; k++)
					{
						if (notRight[myVar3].hitTestObject(circle_lamp_Green[k]))
							{
								notRight[myVar3].x = circle_lamp_Green[k].x+3;
								notRight[myVar3].y = circle_lamp_Green[k].y-5;
								//wireNot(e);
							}
					}
					for (k = 0; k < andTull.length; k++)
					{
						if (notRight[myVar3].hitTestObject(andAim[k]))
						{
							notRight[myVar3].x = andAim[k].x-4;
							notRight[myVar3].y = andAim[k].y-5;
							//wireNot(e);
						}
					}
					for (k = 0; k < orTull.length; k++)
					{
						if (notRight[myVar3].hitTestObject(orAim[k]))
						{
							notRight[myVar3].x = orAim[k].x-4;
							notRight[myVar3].y = orAim[k].y-5;
							//wireNot(e);
						}
					}
					for (k = 0; k < notTull.length; k++)
					{
						if (notRight[myVar3].hitTestObject(notAim[k]))
						{
							notRight[myVar3].x = notAim[k].x-4;
							notRight[myVar3].y = notAim[k].y-5;
							//wireNot(e);
						}
					}
			}
			if(e.target==notTull[myVar3])
			{
				notTull[myVar3].stopDrag();
				removeEventListener(MouseEvent.MOUSE_MOVE, dragConnectNot);
				if (rightNotHit[myVar3])
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragContactsNot);
					if(!rightNotHit[myVar3])
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragCirclenot);	
			}
			//stage.removeEventListener(MouseEvent.MOUSE_MOVE, distanceNot); 
			if (myVar3 >= 0)
			{
				if(notTull[myVar3].hitTestObject(bin))//Удаление
					{
						
						removeChild(notRight[myVar3]);
						removeChild(notAim[myVar3]);
						removeChild(notTull[myVar3]);
						removeChild(notLineR[myVar3]);
						if (lineRAddNot[myVar3])
							removeChild(additLineRNot[myVar3]);
						flag = 1;
						
					}
				if (flag)
				{
					flag = 0;
					vs2 = notTull[myVar3];
					notTull[myVar3] = notTull[notTull.length - 1];
					notTull[notTull.length - 1] = vs2;
				
					vs2 = notAim[myVar3];
					notAim[myVar3] = notAim[notAim.length - 1];
					notAim[notAim.length - 1] = vs2;
				
					vs2 = notRight[myVar3];
					notRight[myVar3] = notRight[notRight.length - 1];
					notRight[notRight.length - 1] = vs2;
					
					vs2 = notLineR[myVar3];
					notLineR[myVar3] = notLineR[notLineR.length - 1];
					notLineR[notLineR.length - 1] = vs2;
					
					vs = notRightResult[myVar3];
					notRightResult[myVar3] = notRightResult[notRightResult.length - 1];
					notRightResult[notRightResult.length - 1] = vs;
					
					vs2 = additLineRNot[myVar3];
					additLineRNot[myVar3] = additLineRNot[additLineRNot.length - 1];
					additLineRNot[additLineRNot.length - 1] = vs2;
					additLineRNot.pop();
					
					vs = lineRAddNot[myVar3];
					lineRAddNot[myVar3] = lineRAddNot[lineRAddNot.length - 1];
					lineRAddNot[lineRAddNot.length - 1] = vs;
					lineRAddNot.pop();
					
					
					notTull.pop();
					notAim.pop();
					notRight.pop();
					notLineR.pop();
					notLineAim.pop();
					notRightResult.pop();
					myVar3--;
					NumberBlokcs--;
					numNot--;
				}
			}
		}
		//===================================================
		public function controllaContattonot(e:Event):void
		{
			var flag:int = 1;
			var unit1:int = 1;
			var unit2:int = 1;
			var unit3:int = 1;
			var unit4:int = 1;
			var unit5 :int = 1;
			
			for (var i:int = 0; i < notRight.length; i++)
			{
				for (var k:int = 0; k < 9;k++)
					{
						if(notRight[i].hitTestObject(circle_lamp_Green[k]))
							{
								unit1 = 0;
								rightNotHit[i] = true;
								notRightResult[i] = circle_lamp_Green[k].visible;
							}
					}
				for (k = 0; k < andTull.length; k++)
					{
						if (notRight[i].hitTestObject(andAim[k]))
							{
								unit2 = 0;
								rightNotHit[i] = true;
								notRightResult[i] = andAimResult[k];
							}
					}
				for (k = 0; k < orTull.length;k++)
					{
						if (notRight[i].hitTestObject(orAim[k]))
							{
								unit3 = 0;
								rightNotHit[i] = true;
								notRightResult[i] = orAimResult[k];
							}
					}
				for (k = 0; k < notTull.length; k++)
				{
					if (notRight[i].hitTestObject(notAim[k]))
							{
								unit4 = 0;
								rightNotHit[i] = true;
								notRightResult[i] = notAimResult[k];
							}
				}
				for (k = 0; k < nonTull.length; k++)
				{
					if (notRight[i].hitTestObject(nonAim[k]))
							{
								unit5 = 0;
								rightNotHit[i] = true;
								notRightResult[i] = nonAimResult[k];
							}
				}
				notAimResult[i] = !notRightResult[i];
				if (unit1 && unit2 && unit3 && unit4&&unit5)
					rightNotHit[i] = false;
				unit1 = unit2 = unit3 = unit4 = unit5 = 1;		
			}
		}
		//========================================================
		[Embed(source="Empty_01.png")]
		public static const Non:Class;
		[Embed(source="Connector_01.png")]
		public static const Conect:Class;
		public function Createnon(e:Event):void 
		{
			del_result(e);
			timer.stop();
			
            var flag:int = 1;
			var tull:Sprite = new Sprite(); //тело
			var bmp:*= new Non;
			var con:*= new Conect;
			tull.addChild(bmp);
		    var rightc:Sprite = new Sprite();//  контакт
			rightc.addChild(con);
		    var aimc:Sprite = createCircle(0x00ff99, 3,0);	//		итоговый контакт
			for (var i:int = 0; i < andTull.length&&flag;i++)
			{
				if (lineLAddAnd[i])
				{
					tull.x = (andTull[i].x-(andTull[i].x-andLeft[i].x)/2);
					tull.y = andTull[i].y-(andTull[i].y-andLeft[i].y)/2;
					rightc.x = andLeft[i].x;
					rightc.y = andLeft[i].y;
					aimc.x = tull.x+13;
					aimc.y = tull.y + 5;
					andLeft[i].x = aimc.x-4;
					andLeft[i].y = aimc.y-5;
					flag = 0;
					nonTull.push(tull);
					nonRight.push(rightc);
					nonAim.push(aimc);
			
					addChild(tull);	
					addChild(rightc);
					addChild(aimc);
					createLine(tull.x, tull.y, rightc.x + 12, rightc.y + 6, nonLineR, 0, 5, numNon);
					addEventListener(MouseEvent.MOUSE_DOWN, downnon);
					addEventListener(MouseEvent.MOUSE_UP,  upnon);
					addEventListener(Event.ENTER_FRAME, controllaContattonon);
					addEventListener(Event.ENTER_FRAME, controlWireNon);
					numNon++;
				}
				if (lineRAddAnd[i])
				{
					tull.x = (andTull[i].x-(andTull[i].x-andRight[i].x)/2);
					tull.y = andTull[i].y-(andTull[i].y-andRight[i].y)/2;
					rightc.x = andRight[i].x;
					rightc.y = andRight[i].y;
					aimc.x = tull.x+13;
					aimc.y = tull.y + 5;
					andRight[i].x = aimc.x-4;
					andRight[i].y = aimc.y-5;
					flag = 0;
					nonTull.push(tull);
					nonRight.push(rightc);
					nonAim.push(aimc);
			
					addChild(tull);	
					addChild(rightc);
					addChild(aimc);
					createLine(tull.x, tull.y, rightc.x + 12, rightc.y + 6, nonLineR, 0, 5, numNon);
					addEventListener(MouseEvent.MOUSE_DOWN, downnon);
					addEventListener(MouseEvent.MOUSE_UP,  upnon);
					addEventListener(Event.ENTER_FRAME, controllaContattonon);
					addEventListener(Event.ENTER_FRAME, controlWireNon);
					numNon++;
				}
			}
			for (i = 0; i < notTull.length && flag; i++)
			{
				if (lineRAddNot[i])
				{
					tull.x = (notTull[i].x-(notTull[i].x-notRight[i].x)/2);
					tull.y = notTull[i].y-(notTull[i].y-notRight[i].y)/2;
					rightc.x = notRight[i].x;
					rightc.y = notRight[i].y;
					aimc.x = tull.x+13;
					aimc.y = tull.y + 5;
					notRight[i].x = aimc.x-4;
					notRight[i].y = aimc.y-5;
					flag = 0;
					nonTull.push(tull);
					nonRight.push(rightc);
					nonAim.push(aimc);
			
					addChild(tull);	
					addChild(rightc);
					addChild(aimc);
					createLine(tull.x, tull.y, rightc.x + 12, rightc.y + 6, nonLineR, 0, 5, numNon);
					addEventListener(MouseEvent.MOUSE_DOWN, downnon);
					addEventListener(MouseEvent.MOUSE_UP,  upnon);
					addEventListener(Event.ENTER_FRAME, controllaContattonon);
					addEventListener(Event.ENTER_FRAME, controlWireNon);
					numNon++;
				}
			}
			for (i = 0; i < orTull.length&&flag; i++)
			{
				if (lineRAddOr[i])
				{
					tull.x = (orTull[i].x-(orTull[i].x-orRight[i].x)/2);
					tull.y = orTull[i].y-(orTull[i].y-orRight[i].y)/2;
					rightc.x = orRight[i].x;
					rightc.y = orRight[i].y;
					aimc.x = tull.x+13;
					aimc.y = tull.y + 5;
					orRight[i].x = aimc.x-4;
					orRight[i].y = aimc.y-5;
					flag = 0;
					nonTull.push(tull);
					nonRight.push(rightc);
					nonAim.push(aimc);
			
					addChild(tull);	
					addChild(rightc);
					addChild(aimc);
					createLine(tull.x, tull.y, rightc.x + 12, rightc.y + 6, nonLineR, 0, 5, numNon);
					addEventListener(MouseEvent.MOUSE_DOWN, downnon);
					addEventListener(MouseEvent.MOUSE_UP,  upnon);
					addEventListener(Event.ENTER_FRAME, controllaContattonon);
					addEventListener(Event.ENTER_FRAME, controlWireNon);
					numNon++;
				}
				if (lineLAddOr[i])
				{
					tull.x = (orTull[i].x-(orTull[i].x-orLeft[i].x)/2);
					tull.y = orTull[i].y-(orTull[i].y-orLeft[i].y)/2;
					rightc.x = orLeft[i].x;
					rightc.y = orLeft[i].y;
					aimc.x = tull.x+13;
					aimc.y = tull.y + 5;
					orLeft[i].x = aimc.x-4;
					orLeft[i].y = aimc.y-5;
					flag = 0;
					nonTull.push(tull);
					nonRight.push(rightc);
					nonAim.push(aimc);
			
					addChild(tull);	
					addChild(rightc);
					addChild(aimc);
					createLine(tull.x, tull.y, rightc.x + 12, rightc.y + 6, nonLineR, 0, 5, numNon);
					addEventListener(MouseEvent.MOUSE_DOWN, downnon);
					addEventListener(MouseEvent.MOUSE_UP,  upnon);
					addEventListener(Event.ENTER_FRAME, controllaContattonon);
					addEventListener(Event.ENTER_FRAME, controlWireNon);
					numNon++;
				}
			}
			for (i = 0; i < nonTull.length && flag; i++)
			{
				if (lineRAddNon[i])
				{
					tull.x = (nonTull[i].x-(nonTull[i].x-nonRight[i].x)/2);
					tull.y = nonTull[i].y-(nonTull[i].y-nonRight[i].y)/2;
					rightc.x = nonRight[i].x;
					rightc.y = nonRight[i].y;
					aimc.x = tull.x+13;
					aimc.y = tull.y + 5;
					nonRight[i].x = aimc.x-4;
					nonRight[i].y = aimc.y-5;
					flag = 0;
					nonTull.push(tull);
					nonRight.push(rightc);
					nonAim.push(aimc);
			
					addChild(tull);	
					addChild(rightc);
					addChild(aimc);
					createLine(tull.x, tull.y, rightc.x + 12, rightc.y + 6, nonLineR, 0, 5, numNon);
					addEventListener(MouseEvent.MOUSE_DOWN, downnon);
					addEventListener(MouseEvent.MOUSE_UP,  upnon);
					addEventListener(Event.ENTER_FRAME, controllaContattonon);
					addEventListener(Event.ENTER_FRAME, controlWireNon);
					numNon++;
				}
			}
			
		}
		//=========================================================
		public function controlWireNon(e:Event):void
		{
			for (var i:int = 0; i < numNon; i++)
			{
				wireNon(e,i);
			}
		}
		//========================================================
		public function controllaContattonon(e:Event):void
		{
			var flag:int = 1;
			var unit1:int = 1;
			var unit2:int = 1;
			var unit3:int = 1;
			var unit4:int = 1;
			var unit5:int = 1;

			for (var i:int = 0; i < nonRight.length; i++)
			{
				
				for (var k:int = 0; k < 9;k++)
					{
						if(nonRight[i].hitTestObject(circle_lamp_Green[k]))
							{
								unit1 = 0;
								rightNonHit[i] = true;
								nonRightResult[i] = circle_lamp_Green[k].visible;
							}
					}
				for (k = 0; k < andTull.length; k++)
					{
						if (nonRight[i].hitTestObject(andAim[k]))
							{
								unit2 = 0;
								rightNonHit[i] = true;
								nonRightResult[i] = andAimResult[k];
							}
					}
				for (k = 0; k < orTull.length;k++)
					{
						if (nonRight[i].hitTestObject(orAim[k]))
							{
								unit3 = 0;
								rightNonHit[i] = true;
								nonRightResult[i] = orAimResult[k];
							}
					}
				for (k = 0; k < notTull.length; k++)
				{
					if (nonRight[i].hitTestObject(notAim[k]))
							{
								unit4 = 0;
								rightNonHit[i] = true;
								nonRightResult[i] = notAimResult[k];
							}
				}
				for (k = 0; k < nonTull.length; k++)
				{
					if (nonRight[i].hitTestObject(nonAim[k]))
							{
								unit5 = 0;
								rightNonHit[i] = true;
								nonRightResult[i] = nonAimResult[k];
							}
				}
				
				nonAimResult[i] = nonRightResult[i];
				if (unit1 && unit2 && unit3 && unit4&&unit5)
					rightNonHit[i] = false;
				unit1 = 1; unit2 = 1; unit3 = 1; unit4 = 1; unit5 = 1;
			}
		}
		//========================================================
		public function wireNon(e:Event,n:int):void
		{
			removeChild(nonLineR[n]);
			var line:Sprite = new Sprite();
			var additLine:Sprite = new Sprite();
			if (nonRightResult[n] == true)
				{
					line.graphics.lineStyle(2, 0xF7C709);
				}
			else
				{
					line.graphics.lineStyle(2, 0x000001);
				}
			if (lineRAddNon[n])
				{
					removeChild(additLineRNon[n]);
					if (nonRightResult[n] == true)
						additLine.graphics.lineStyle(6, 0xF7C709, 0.3);
					else
						additLine.graphics.lineStyle(6, 0x000001, 0.3);
					additLine.graphics.moveTo(nonTull[n].x, nonTull[n].y+5);
					additLine.graphics.lineTo(nonRight[n].x+12,nonRight[n].y+6);
					additLineRNon[n] = additLine;
					addChild(additLineRNon[n]);
				}
			line.graphics.moveTo(nonTull[n].x, nonTull[n].y+5);
			line.graphics.lineTo(nonRight[n].x+12,nonRight[n].y+6);
			addChild(line);
			nonLineR[n] = line;
		}
		//=========================================================
		public function downnon(e:Event):void
		{
			var flag : int = 0 ;
			var k: int = 0;
			var additLine:Sprite = new Sprite();
			for (k = 0;k < 30 && flag==0; k++)
			{
				if(nonTull[k]==e.target)
				{
					myVar4 = k;
					flag = 1;
					setChildIndex(nonTull[k], numChildren - 1);
					nonTull[k].startDrag();
					addEventListener(MouseEvent.MOUSE_MOVE, dragConnectNon);
					if (rightNonHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragContactsNon);
					if(!rightNonHit[k])
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragCirclenon);	
				}
				if (nonRight[k]==e.target )
				{
					flag = 1;
					myVar4 = k;
					setChildIndex(nonRight[k], numChildren - 1);
					nonRight[k].startDrag();
				}	
				if (e.target == nonLineR[k])
				{
					flag = 1;
					myVar4 = k;
					for (var i:int = 0; i < nonTull.length;i++)
					{
						if (lineRAddNon[i])
						{
							lineRAddNon[i] = false;
							removeChild(additLineRNon[i]);
							if (i == myVar4)
							{
								complite4 = 1;
							}
							else
							{
								complite4 = 0;
							}
						}
					}
					for (i = 0; i < notTull.length;i++)
					{
						if (lineRAddNot[i])
						{
							lineRAddNot[i] = false;
							removeChild(additLineRNot[i]);
							complite3 = 0;
						}
					}
					for (i = 0; i < orTull.length; i++)
					{
						if (lineLAddOr[i])
							{
								lineLAddOr[i] = false;
								removeChild(additLineLOr[i]);
								complite2 = 0;
							}
						if (lineRAddOr[i])
							{
								lineRAddOr[i] = false;
								removeChild(additLineROr[i]);
								complite2 = 0;
							}
					}
					for (i = 0; i < andTull.length; i++)
					{
						if (lineLAddAnd[i])
							{
								lineLAddAnd[i] = false;
								removeChild(additLineLAnd[i]);
								complite = 0;
							}
						if (lineRAddAnd[i])
							{
								lineRAddAnd[i] = false;
								removeChild(additLineRAnd[i]);
								complite = 0;
							}
					}
					if(!complite4)
					{
						flag = 1;
						myVar4 = k;
						lineRAddNon[k] = true;
						setChildIndex(nonRight[k], numChildren - 1);
						additLine.graphics.lineStyle(5, 0x00CCFF);
						additLine.graphics.moveTo(nonTull[k].x, nonTull[k].y+15);
						
						additLineRNon[k] = additLine;
						addChild(additLineRNon[k]);
						complite4 = 1;
					}
					else
						complite4 = 0;
				}
			}
		}
		//========================================================
		//===================================================
		public function dragCirclenon(event:MouseEvent):void 
		{ 
			if (myVar4 >= 0)
			{
				nonAim[myVar4].x = nonTull[myVar4].x +13; 
				nonAim[myVar4].y = nonTull[myVar4].y + 5;
				nonRight[myVar4].x = nonTull[myVar4].x - 30; 
				nonRight[myVar4].y = nonTull[myVar4].y - 2;
				wireNon(event,myVar4);
				event.updateAfterEvent(); 
			}
		} 
		//===================================================
		public function dragContactsNon(event:MouseEvent):void 
		{ 
			if (!rightNonHit[myVar4])
			{
				nonRight[myVar4].x = nonTull[myVar4].x - 30; 
				nonRight[myVar4].y = nonTull[myVar4].y - 2;
			}
			nonAim[myVar4].x = nonTull[myVar4].x +13; 
			nonAim[myVar4].y = nonTull[myVar4].y + 5;
			wireNon(event,myVar4);
			event.updateAfterEvent();
		} 
		//========================================
		public function upnon(e:Event):void
		{
			var flag:int = 0;
			var k:int = 0;
			var vs2:Sprite = new Sprite();
			var vs:Boolean;
			if (e.target == nonRight[myVar4])
			{
				nonRight[myVar4].stopDrag();
				for (k = 0; k < 9; k++)
					{
						if (nonRight[myVar4].hitTestObject(circle_lamp_Green[k]))
							{
								nonRight[myVar4].x = circle_lamp_Green[k].x;
								nonRight[myVar4].y = circle_lamp_Green[k].y;
								//wireNot(e);
							}
					}
					for (k = 0; k < andTull.length; k++)
					{
						if (nonRight[myVar4].hitTestObject(andAim[k]))
						{
							nonRight[myVar4].x = andAim[k].x;
							nonRight[myVar4].y = andAim[k].y;
							//wireNot(e);
						}
					}
					for (k = 0; k < orTull.length; k++)
					{
						if (nonRight[myVar4].hitTestObject(orAim[k]))
						{
							nonRight[myVar4].x = orAim[k].x;
							nonRight[myVar4].y = orAim[k].y;
							//wireNot(e);
						}
					}
					for (k = 0; k < notTull.length; k++)
					{
						if (nonRight[myVar4].hitTestObject(notAim[k]))
						{
							nonRight[myVar4].x = notAim[k].x;
							nonRight[myVar4].y = notAim[k].y;
							//wireNot(e);
						}
					}
					for (k = 0; k < nonTull.length; k++)
					{
						if (nonRight[myVar4].hitTestObject(nonAim[k]))
						{
							nonRight[myVar4].x = nonAim[k].x;
							nonRight[myVar4].y = nonAim[k].y;
							//wireNot(e);
						}
					}
			}
			if(e.target==nonTull[myVar4])
			{
				nonTull[myVar4].stopDrag();
				//trace(k);
				removeEventListener(MouseEvent.MOUSE_MOVE, dragConnectNon);
				if (rightNonHit[myVar4])
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragContactsNon);
				if(!rightNonHit[myVar4])
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragCirclenon);	
			}
			//stage.removeEventListener(MouseEvent.MOUSE_MOVE, distanceNot); 
			if (myVar4 >= 0)
			{
				if(nonTull[myVar4].hitTestObject(bin))//Удаление
					{
						
						removeChild(nonRight[myVar4]);
						removeChild(nonAim[myVar4]);
						removeChild(nonTull[myVar4]);
						removeChild(nonLineR[myVar4]);
						if (lineRAddNon[myVar4])
							removeChild(additLineRNon[myVar4]);
						flag = 1;
						
					}
				if (flag)
				{
					flag = 0;
					vs2 = nonTull[myVar4];
					nonTull[myVar4] = nonTull[nonTull.length - 1];
					nonTull[nonTull.length - 1] = vs2;
				
					vs2 = nonAim[myVar4];
					nonAim[myVar4] = nonAim[nonAim.length - 1];
					nonAim[nonAim.length - 1] = vs2;
				
					vs2 = nonRight[myVar4];
					nonRight[myVar4] = nonRight[nonRight.length - 1];
					nonRight[nonRight.length - 1] = vs2;
					
					vs2 = nonLineR[myVar4];
					nonLineR[myVar4] = nonLineR[nonLineR.length - 1];
					nonLineR[nonLineR.length - 1] = vs2;
					
					vs = nonRightResult[myVar4];
					nonRightResult[myVar4] = nonRightResult[nonRightResult.length - 1];
					nonRightResult[nonRightResult.length - 1] = vs;
					
					vs2 = additLineRNon[myVar4];
					additLineRNon[myVar4] = additLineRNon[additLineRNon.length - 1];
					additLineRNon[additLineRNon.length - 1] = vs2;
					additLineRNon.pop();
					
					vs = lineRAddNon[myVar4];
					lineRAddNon[myVar4] = lineRAddNon[lineRAddNon.length - 1];
					lineRAddNon[lineRAddNon.length - 1] = vs;
					lineRAddNon.pop();
					
					
					nonTull.pop();
					nonAim.pop();
					nonRight.pop();
					nonLineR.pop();
					nonRightResult.pop();
					myVar4--;
					numNon--;
				}
			}
		}
		//==========================================
		public function createAnswer(n:int): void
		{
			var img:*= new Conect;
			var circle:Sprite = new Sprite();
			circle.addChild(img);
			answerCon[n] = circle;
			answerCon[n].x = 722;
			answerCon[n].y = 20 +40 * n;
			addChild(answerCon[n]);
			createLine(750, 27 + 40 * n, answerCon[n].x, answerCon[n].y-6, answerConLine, 0, 0, n);
			
			addEventListener(MouseEvent.MOUSE_DOWN, downAnswer);
			addEventListener(MouseEvent.MOUSE_UP, upAnswer);
			addEventListener(Event.ENTER_FRAME, controlwireAnswer);
		}
		public function downAnswer(e:Event): void
		{
			var flag : int = 1 ;
			for (var i: int = 0; i < 10 && flag; i++)
			{
				if (e.target == answerCon[i])
				{
					flag = 0;
					myVar5 = i;
					answerCon[i].startDrag();
					//createLine(750, 27 + 40 * i, answerCon[i].x, answerCon[i].y, answerConLine, 0, 0, i);
				}
			}
		}
		public function upAnswer(e:Event): void
		{
			if (e.target == answerCon[myVar5])
			{
				answerCon[myVar5].stopDrag();
				for (var k:int = 0; k < andTull.length; k++)
					{
						if (answerCon[myVar5].hitTestObject(andAim[k]))
						{
							answerCon[myVar5].x = andAim[k].x-3;
							answerCon[myVar5].y = andAim[k].y-7;
							//wireNot(e);
						}
					}
					for (k = 0; k < orTull.length; k++)
					{
						if (answerCon[myVar5].hitTestObject(orAim[k]))
						{
							answerCon[myVar5].x = orAim[k].x-3;
							answerCon[myVar5].y = orAim[k].y-7;
							//wireNot(e);
						}
					}
					for (k = 0; k < notTull.length; k++)
					{
						if (answerCon[myVar5].hitTestObject(notAim[k]))
						{
							answerCon[myVar5].x = notAim[k].x-3;
							answerCon[myVar5].y = notAim[k].y-7;
							//wireNot(e);
						}
					}
					for (k = 0; k < nonTull.length; k++)
					{
						if (answerCon[myVar5].hitTestObject(nonAim[k]))
						{
							answerCon[myVar5].x = nonAim[k].x-3;
							answerCon[myVar5].y = nonAim[k].y-7;
							//wireNot(e);
						}
					}
			}
		}
		public function controlwireAnswer(e:Event): void
		{
			var b:int = 27;
			for ( var i:int = 0; i < 10; i++)
				{
					wireRAnswer(e, i, b);
					b = b + 40;
				}
				
		}
		public function wireRAnswer(e:Event, n:int,y:int): void
		{
			var line:Sprite = new Sprite();
			
			if (answerConAim[n] == true)
				{
					line.graphics.lineStyle(2, 0xF7C709);
				}
			else
				{
					line.graphics.lineStyle(2, 0x000001);
				}
			removeChild(answerConLine[n]);
			line.graphics.moveTo(750, y);
			line.graphics.lineTo(answerCon[n].x+10,answerCon[n].y+6);
			addChild(line);
			answerConLine[n] = line;
		}
		//===========================================
	}
}