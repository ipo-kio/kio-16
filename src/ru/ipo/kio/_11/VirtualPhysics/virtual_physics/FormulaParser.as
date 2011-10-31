package  ru.ipo.kio._11.VirtualPhysics.virtual_physics {
import ru.ipo.kio._11.VirtualPhysics.ndef_ru.parser.*;

//Класс вычисляющий формулы
  public class FormulaParser  {
  //Парсер формул
  internal var parser:Parser = new Parser(["r"]);
  //Выражение
  internal var parsedexpression:Array;
  
  public function FormulaParser(str:String="") {
	this.setExpressionString(str);
  }
  //Метод задания выражения
  public function setExpressionString(str:String):void {
	parsedexpression = parser.parse(str);
  }
  //Метод получения информации об ошибке
  public function getError():String {
	   return parser.errormsg;
  }
  //Метод проверки корректости выражения
  public function isExpressionCorrect():Boolean {
       this.calculateWithValue(0);	   
	   return parser.success;
  }
  public function calculateWithValue(r:Number):Number {
   return parser.eval(parsedexpression, [r]);
  }
 }
}