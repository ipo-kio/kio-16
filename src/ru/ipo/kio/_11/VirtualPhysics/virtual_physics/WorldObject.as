package  ru.ipo.kio._11.VirtualPhysics.virtual_physics
{
	//Класс представляющий собой объект-частицу
	public class WorldObject
	{
		//Координата частицы по оси Х
		public var X:Number=0;
		//Координата частицы по оси Y
	    public var Y:Number=0;
		//Состовляющая скорости по оси Х
		public var Vx:Number = 0;
		//Состовляющая скорости по оси Y
	    public var Vy:Number = 0;
		//Тип частицы
		public var Type:Number=0;
		//Задать позицию частицы
		public function setPosition(x:Number,y:Number):void {
			X = x;
			Y = y;
		}
	}
}