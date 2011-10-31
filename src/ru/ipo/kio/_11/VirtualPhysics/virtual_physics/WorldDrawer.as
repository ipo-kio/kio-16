package ru.ipo.kio._11.VirtualPhysics.virtual_physics {
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import mx.core.BitmapAsset;
import mx.core.Container;

//	import org.flashdevelop.utils.FlashConnect ;

	//Класс рисующий мир
	public class WorldDrawer extends Container {
		//массив Sprite-шариков
		public var arr:Array = new Array();
		//переменная счетчика
		internal var i:int = 0;
		//цвет добавляемого Sprite-шарика
		internal var ballColor:int = 0;
		//constructor
		public function WorldDrawer() {
			super();
		}
		[Embed(source="../images/Sphere_01.png")]
		public var MyEmbed_01:Class;
        public var MyEmbed_01_BMP:BitmapData = new MyEmbed_01().bitmapData;
			private function getBitmapData_01():BitmapData {
				/*var bitmapAsset:mx.core.BitmapAsset = new MyEmbed_01();
				return bitmapAsset.bitmapData;*/
                return MyEmbed_01_BMP;
			}
		[Embed(source="../images/Sphere_02.png")]
        public var MyEmbed_02:Class;
        public var MyEmbed_02_BMP:BitmapData = new MyEmbed_02().bitmapData;
			private function getBitmapData_02():BitmapData {
				/*var bitmapAsset:mx.core.BitmapAsset = new MyEmbed_02();
				return bitmapAsset.bitmapData;*/
                return MyEmbed_02_BMP;
			}
		[Embed(source="../images/Background.jpg")]
		public var MyEmbed_background:Class;
			private function getBitmapData_background():BitmapData {
				var bitmapAsset:BitmapAsset = new MyEmbed_background();
				return bitmapAsset.bitmapData;
			}
		//Метод отрисовки объекта
		public function drawObject(x:Number, y:Number, type:Number):void {
			var g:Graphics = this.graphics;
            var m:Matrix = new Matrix;
            m.translate(x - Math.round(MyEmbed_01_BMP.width / 2), y - Math.round(MyEmbed_01_BMP.height / 2));
            g.lineStyle(0, 0, 0);
			switch(type) {
				case 0:
					g.beginBitmapFill( getBitmapData_01(), m);
				break;
				case 1:
					g.beginBitmapFill( getBitmapData_02(), m);
				break;
			}
			g.drawCircle(x, y, WorldConstants.ObjectRadius);
			g.endFill();
		}
		//Метод отрисовки сеточки
		public function drawGrid():void {
			var g:Graphics = this.graphics;
			g.clear();
			g.lineStyle(1, 0x000000);
			g.beginBitmapFill(getBitmapData_background());
			//рисуем горизонтальные линии
			var hstep:Number = width / WorldConstants.HorizontalSize;
			for (i = 0; i <= width ; i += hstep) {
				g.moveTo(i, 0);
				g.lineTo(i, height);
			}
			//рисуем  вертикальные линии
			var vstep:Number = height / WorldConstants.VerticalSize;
			for (i = 0; i <= height ; i += vstep) {
				g.moveTo(0, i);
				g.lineTo(width, i);
			}
			g.moveTo(width / 2, 0);
			g.lineStyle(3, 0x000000);
			g.lineTo(width / 2, height);
			g.drawRect(getRect(this).x, getRect(this).y, width, height); //прямоугольник, куда врисовывается картинка
			g.endFill();
		}
		//метод добавления шариков в ручном режиме
		public function dynamicFunc():void {
			var newSp:Sprite = new Sprite();
			//обработчики действий мыши
			newSp.addEventListener(MouseEvent.MOUSE_DOWN, down);
			newSp.addEventListener(MouseEvent.MOUSE_UP, up);
			//помещаем новый шарик в левый верхний угол области
			newSp.x = getRect(stage).x;
			newSp.y = getRect(stage).y;
			ballColor++;
			ballColor %= 2;
			var m:Matrix = new Matrix();
			m.translate(14, 14); //матрица "сдвига", на 10 и 20 пикселей
			switch(ballColor) {
				case 1:
					newSp.graphics.beginBitmapFill( getBitmapData_01(), m);
				break;
				case 0:
					newSp.graphics.beginBitmapFill( getBitmapData_02(), m);
				break;
			}
			newSp.graphics.drawCircle(0,0,WorldConstants.ObjectRadius);
			stage.addChild(newSp);
			arr.push(newSp);
			//нажатие на левую кнопку мыши
			function down(event:MouseEvent):void {
				event.target.startDrag(true , getRect(stage));
			}
			//отпускание левой кнопки мыши
			function up(event:MouseEvent):void {
				event.target.stopDrag();
				WorldConstants.dragPosX = event.target.x - getRect(stage).x;
				WorldConstants.dragPosY = event.target.y - getRect(stage).y;
			}
		}
		//преобразуем Sprite-шарики в graphics-шарики
		public	function redraw(obj:Array):void {
			for (i = 0; i < arr.length; i++) {
				var reSp:Graphics = this.graphics;
				var cvet :int ;
				obj[i] = new WorldObject() ;
			    obj[i].Type = i % 2;
				obj[i].Vx = 0;
				obj[i].Vy = 0;
				cvet = obj[i].Type ;
				obj[i].setPosition(arr[i].x - getRect(stage).x ,arr[i].y - getRect(stage).y);
					switch(cvet) {
					case 0:
						reSp.beginFill( 0xFF0000);
					break;
					case 1:
						reSp.beginFill( 0x00CC00);
					break;
					}
				reSp.drawCircle(obj[i].X,obj[i].Y,WorldConstants.ObjectRadius);
				reSp.endFill();
				obj.push(reSp);
				stage.removeChild(arr[i]);
			}
			arr = [];
			obj.length -= 1 ;
		}
		//удаляем Sprite-шарики
		public function removeSprites():void {
			for (i = 0; i < arr.length; i++)
				stage.removeChild(arr[i]);
			arr = [];
	    }
	}
}