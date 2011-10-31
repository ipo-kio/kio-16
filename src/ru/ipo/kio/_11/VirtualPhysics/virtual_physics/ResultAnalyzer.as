package   ru.ipo.kio._11.VirtualPhysics.virtual_physics
{
	//Класс проверки результата
	public class ResultAnalyzer extends WorldDrawer
	{
		
		public function ResultAnalyzer(){
			
		}
		//Метод проверки нахождения объекта в клетки
		private static function isObjectInRect(obj:WorldObject, left:Number,  right:Number,top:Number, bottom:Number):Boolean{
			    //FIXME маловероятно, но обьект может попасть на границу...
				if (obj.X > left &&
					obj.X < right &&
					obj.Y < bottom &&
					obj.Y > top)
					return true;
			    else
					return false;
					
		}
		//Метод подсчёта суммарного расстояния клеток с одним шаром
		public  static function analyzeFinalStateСriterionOneInCellDistance(obj:Array):Number {
			var hstep:Number = WorldConstants.RightLine / WorldConstants.HorizontalSize;
			var vstep:Number = WorldConstants.BottomLine / WorldConstants.VerticalSize;
			var i:Number,o:Number,j:Number;
			var result:Number = 0;
			var ResInCell:Number = 0;
			var BallInCell:Number;
			var Distance:Number=10000;
			for ( i = WorldConstants.LeftLine; i <= WorldConstants.RightLine-hstep ; i = i + hstep) {	
				for ( j = WorldConstants.TopLine; j <= WorldConstants.BottomLine-vstep ; j = j + vstep){
					BallInCell = 0;
					Distance = 100000;
					for (o = 0; o < (obj.length)&&(BallInCell<=1); o++) {
					if (isObjectInRect(obj[o],i,i+hstep,j,j+vstep)) {
							BallInCell++;
							var CenterX:Number = (i + hstep / 2);
							var CenterY:Number = (j + vstep / 2);		
							Distance = Math.sqrt(Math.pow(obj[o].X -CenterX, 2) + Math.pow(obj[o].Y - CenterY, 2));
					}
				}
				if(BallInCell==1){
						result += Distance;
						ResInCell++;
					}
				}
			}	
			return result/ResInCell;
		}
		//Метод посчета клеток с одним шаром
		public  static function analyzeFinalStateСriterionOneInCell(obj:Array):Number {
			var hstep:Number = WorldConstants.RightLine / WorldConstants.HorizontalSize;
			var vstep:Number = WorldConstants.BottomLine / WorldConstants.VerticalSize;
			var i:Number,o:Number,j:Number;
			var result:Number = 0;
			var BallInCell:Number;
			for ( i = WorldConstants.LeftLine; i <= WorldConstants.RightLine-hstep ; i = i + hstep) {	
				for ( j = WorldConstants.TopLine; j <= WorldConstants.BottomLine-vstep ; j = j + vstep){
					BallInCell = 0;
					for (o = 0; o < (obj.length)&&(BallInCell<=1); o++) {
					if (isObjectInRect(obj[o],i,i+hstep,j,j+vstep)) {
							BallInCell++;
					}
				}
				if(BallInCell==1)
						result++;
				}
			}	
			return result;
		}
		
		//Метод подсчёта пустых клеток
		public  static function analyzeFinalStateСriterionFreeCell(obj:Array):Number {
			var hstep:Number = WorldConstants.RightLine / WorldConstants.HorizontalSize;
			var vstep:Number = WorldConstants.BottomLine / WorldConstants.VerticalSize;
			var i:Number,o:Number,j:Number;
			var result:Number = 0;
			var isCellEmpty:Boolean;
			for ( i = WorldConstants.LeftLine; i <= WorldConstants.RightLine-hstep ; i = i + hstep) {	
				for ( j = WorldConstants.TopLine; j <= WorldConstants.BottomLine-vstep ; j = j + vstep){
					isCellEmpty = true;
					for (o = 0; o < (obj.length)&&isCellEmpty; o++) {
					if (isObjectInRect(obj[o],i,i+hstep,j,j+vstep)) {
							isCellEmpty = false;
					}
				}
				if(isCellEmpty)
						result++;
				}
			}
			
			
			return result;
		}
		//Метод подсчёта шариков не в своих половинках
		public  static function analyzeFinalStateСriterionTwoHalves(obj:Array):Number {
			var num_of_object_in_place1_Type1:Number=0;
			var num_of_object_in_place1_Type2:Number=0;
			var i:Number;
			//FIXME для оптимизации выбросить это отсюда в конструктор
			var place1_left:Number= WorldConstants.LeftLine;
			var place1_right:Number = WorldConstants.RightLine/2;
			var place1_top:Number = WorldConstants.TopLine;
			var place1_bottom:Number = WorldConstants.BottomLine;
			
			var place2_left:Number =  WorldConstants.RightLine/2;
			var place2_right:Number = WorldConstants.RightLine;
			var place2_top:Number = WorldConstants.TopLine;
			var place2_bottom:Number = WorldConstants.BottomLine;
			//FIXME игрек координаты можно не проверять
			for (i = 0; i < obj.length; i++) {
				if (isObjectInRect(obj[i], place1_left, place1_right, place1_top, place1_bottom)) {
					if (obj[i].Type == 0)
						num_of_object_in_place1_Type1++;
					if (obj[i].Type == 1)
						num_of_object_in_place1_Type2++;
					
				}
			var result:Number=0;
			var CorrectNumber:Number=obj.length/2;
			if (num_of_object_in_place1_Type1 > num_of_object_in_place1_Type2){
				//левая половина для шаров типа 1
				result = CorrectNumber - num_of_object_in_place1_Type1;
				result += num_of_object_in_place1_Type2;
			}else {
				//левая половина для шаров типа 2
				result = CorrectNumber - num_of_object_in_place1_Type2;
				result += num_of_object_in_place1_Type1;
			}
			}
			return result;
			    
			
		}	
	}

}