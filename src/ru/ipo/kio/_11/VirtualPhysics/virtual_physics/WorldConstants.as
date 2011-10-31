package   ru.ipo.kio._11.VirtualPhysics.virtual_physics
{
import mx.controls.Label;

//Констаны определяющие мир
	public class WorldConstants
	{
		//Координаты последнего передвинутого шарика
		static public var dragPosX:Number;
		static public var dragPosY:Number;
		//Левая граница мира
		static public var LeftLine:Number; 
		//Правая граница мира
		static public var RightLine:Number;
		//Верхняя граница мира
		static public var TopLine:Number;
		//Нижняя граница мира
		static public var BottomLine:Number;
		//Размер сетки по горизонтали
		static public  var HorizontalSize:Number = 6;
		//Размер сетки по вертикале
		static public  var VerticalSize:Number = 4;
		//Количество объектов
		static  public var ObjectNumber:Number = 24;
		//Радиус объекта
		static public var ObjectRadius:Number;
		//Переменная для отладки
		static public var a:Label;
		//Результат по критерию половинности
		static public var result1:Label;
		//Результат по критерию в клетки одие объект
		static public var result2:Label;
		//Результат по критерию расстояние до центра клетки
		static public var result3:Label;
		//Сила действующая между шарами типа 1
		static public var ForceOneToOne:FormulaParser = new FormulaParser();
		//Сила действующая между шарами разного типа
		static public var ForceTwoToTwo:FormulaParser = new FormulaParser();
		//Сила действующая между шарами типа 2
		static public var ForceOneToTwo:FormulaParser = new FormulaParser();
		//Коэффициенты вязкости среды
		static public var KoeffOne:Number;
		static public var KoeffTwo:Number;
		
		public function WorldConstants() {
			
		}	
	}
}