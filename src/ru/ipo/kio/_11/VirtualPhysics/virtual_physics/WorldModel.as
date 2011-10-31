package ru.ipo.kio._11.VirtualPhysics.virtual_physics {



//Класс представляющий собой модель мира
	public class WorldModel {
		//Рисовальщик мира
		public var painter: WorldDrawer = null;
		//Массив частиц-объектов мира
		internal var obj:Array = new Array();				
		//Переменная счетчика
		internal var i:int = 0;
		//Метод установки начального положения
		public function reset():void {
			//Создаем нужное количество объектов
			for (i = 0; i < WorldConstants.ObjectNumber ; i++) {
				obj[i] = new WorldObject();		
				obj[i].Type = i % 2;
			}
			//Обнуляем скорости всех частиц
			for (i = 0; i < obj.length; i++) {
				obj[i].Vx = 0;
				obj[i].Vy = 0;
			}
			//Задаем положения частиц по умолчанию
			//Ряд 1
			obj[0].setPosition(120, 50);
			obj[1].setPosition(168, 50);
			obj[4].setPosition(216, 50);
			obj[5].setPosition(264, 50);
			obj[8].setPosition(312, 50);
			obj[9].setPosition(360, 50);
			//Ряд 2
			obj[2].setPosition(120,110);
			obj[3].setPosition(168,110);
			obj[6].setPosition(216,110);
			obj[7].setPosition(264,110);			
			obj[10].setPosition(312,110);
			obj[11].setPosition(360, 110);
			//Ряд 3
			obj[12].setPosition(120, 170);
			obj[15].setPosition(168, 170);
			obj[16].setPosition(216, 170);
			obj[17].setPosition(264, 170);
			obj[20].setPosition(312,170);
			obj[21].setPosition(360,170);
			//Ряд 4
			obj[14].setPosition(120,230);
			obj[13].setPosition(168,230);
			obj[18].setPosition(216, 230);
			obj[19].setPosition(264, 230);
			obj[22].setPosition(312, 230);
			obj[23].setPosition(360, 230);
			//Задаем коэффициенты вязкости
			WorldConstants.KoeffOne = 0.0001;
			WorldConstants.KoeffTwo = 0.0;
			//Рисуем мир
			redrawWorld();
		}
		//Метод перерисовки мира
		public function redrawWorld():void {
			//Рисуем сетку
			painter.drawGrid();
			//Рисуем частицы
			for (i = 0; i < obj.length;i++){
				painter.drawObject(obj[i].X, obj[i].Y, obj[i].Type);
			}
		}
		//Метод очищения массива graphics-шариков
		public function removeObj():void {
			obj = [] ;
		}
		//Метод перерисовки Sprite-шариков в graphics-шарики
		public function convertSprite():void {
			WorldConstants.KoeffOne = 0.0001;
			WorldConstants.KoeffTwo = 0.0;	
			painter.redraw(obj);
		}
		//Очищение массива graphics-шариков и обнуление начальных скоростей
		public function restart():void {
			for (i = 0; i < obj.length; i++) {
				obj[i].Vx = 0;
				obj[i].Vy = 0;
			}
		    removeObj();
			redrawWorld();
		}
		//Метод производящий шаг моделирования
		public function simulationStep():void {
			//Увеличение коэффициетов вязкости со временем
			if(WorldConstants.KoeffOne < 1)
				WorldConstants.KoeffOne += 0.0001;
			if(WorldConstants.KoeffTwo < 1)
				WorldConstants.KoeffTwo += 0.01;
			//Применяем силы к объектам
			PhysicLaws.applyForceToObject(obj);
			//Проверяем объекты на сталкновения с бортиками
			for (i = 0; i < obj.length; i++){
				PhysicLaws.boardCollusion(obj[i]);
			}
			//Проверяем объекты на сталкновения друг с другом
			 for (i = 0; i < obj.length; i++) {
				for (var j:int = i + 1; j < obj.length; j++) {	
					PhysicLaws.objectCollusion(obj[i], obj[j]);
				}
			}		
			//Подсчитываем кинетическую энергию
			var energy:Number = 0;
			for (i = 0; i < obj.length; i++) {
				energy += obj[i].Vx * obj[i].Vx + obj[i].Vy * obj[i].Vy;
			}
		    WorldConstants.a.text = energy.toString();
			//Принудительная остановка при  малой энергии
			if (energy < 0.5)
				WorldConstants.a.text = "zero";
			//Вычисление критериев оценки равномерности распределения
			var res1:Number = ResultAnalyzer.analyzeFinalStateСriterionTwoHalves(obj);
			WorldConstants.result1.text = res1.toString();
			var res2:Number = ResultAnalyzer.analyzeFinalStateСriterionOneInCell(obj);
			WorldConstants.result2.text = res2.toString();
		    var res3:Number = ResultAnalyzer.analyzeFinalStateСriterionOneInCellDistance(obj);
			WorldConstants.result3.text = res3.toFixed(2);
			//Рисуем новое состояние мира
			redrawWorld();
		}		
	}
}