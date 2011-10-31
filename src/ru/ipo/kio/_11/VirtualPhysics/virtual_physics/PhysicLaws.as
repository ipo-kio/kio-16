package  ru.ipo.kio._11.VirtualPhysics.virtual_physics
{
	//Класс реализующий законы физики
	public class PhysicLaws
	{
		
		public function PhysicLaws() 
		{
			
		}
		//Метод учёта абсолютно упругих столкновений с бортиками
		public static function boardCollusion(obj:WorldObject):void {
			if (obj.X <= (WorldConstants.LeftLine)+(WorldConstants.ObjectRadius)) {
				obj.X = 2*WorldConstants.ObjectRadius -(obj.X);
				if(obj.Vx<0)
				obj.Vx = obj.Vx * -1;
			}
			if (obj.X >= (WorldConstants.RightLine)-(WorldConstants.ObjectRadius)) {
				obj.X = 2*((WorldConstants.RightLine)-(WorldConstants.ObjectRadius)) -(obj.X);
				if(obj.Vx>0)
				obj.Vx = obj.Vx * -1;
			}
			if (obj.Y <= (WorldConstants.TopLine)+(WorldConstants.ObjectRadius)) {
				obj.Y = 2*(WorldConstants.ObjectRadius) -(obj.Y);
				if(obj.Vy<0)
				obj.Vy = obj.Vy * -1;
			}
			if (obj.Y >= (WorldConstants.BottomLine)-(WorldConstants.ObjectRadius)) {
			    obj.Y = 2*((WorldConstants.BottomLine)-(WorldConstants.ObjectRadius)) -(obj.Y);
				if(obj.Vy>0)
				obj.Vy = obj.Vy * -1;
			}
		}
		//Метод учёта абсолютно упругих столкновений между шариками
		public static function objectCollusion(obj1:WorldObject , obj2:WorldObject ):Boolean {
			var nx:Number = obj1.X - obj2.X, ny:Number = obj1.Y- obj2.Y;
			var dist:Number;
			dist = Math.sqrt(Math.pow(obj1.X - obj2.X, 2) + Math.pow(obj1.Y - obj2.Y, 2)); 
			    if ((dist < (2.3 * WorldConstants.ObjectRadius))) 
				if(		(obj2.Vx*nx+obj2.Vy*ny )>0 ||
						( -obj1.Vx * nx - obj1.Vy * ny ) > 0)
						{
					//столкновение
				   
					var n:Number = Math.sqrt( nx*nx + ny*ny );
					var cosU:Number = nx/n;
					
					var sinU:Number = ny/n;
		
					//Переносим систему координат
					var rx:Number = obj2.Vx*cosU - obj2.Vy*(-sinU);
					var ry:Number = obj2.Vx*(-sinU) + obj2.Vy*cosU;
	
					var rx2:Number = obj1.Vx*cosU - obj1.Vy*(-sinU);
					var ry2:Number = obj1.Vx*(-sinU) + obj1.Vy*cosU;

					var _rx:Number = rx2;
					var _rx2:Number = rx;

					rx = rx2;
					rx2 = _rx2;
		

					//поворачиваем обратно систему координат
				    obj2.Vx = rx*cosU - ry*sinU;
					obj2.Vy = rx*sinU + ry*cosU;

					obj1.Vx = rx2*cosU - ry2*sinU;
					obj1.Vy = rx2 * sinU + ry2 * cosU;
					return true;
	            }
				return false;
		}
		//Метод учёта сил действующих на шарики
		public static function applyForceToObject(obj:Array , h:Number =0.5 ):void {
	
			
			var dist:Number ;
			var angle:Number ;
			
				
	        var a:Number;
			
			
			
					

			//Конечные скорости шариков			
			var v1x:Array=new Array(obj.length);
			var v1y:Array = new Array(obj.length);
			//Начальные скорости шариков
			var v0x:Array=new Array(obj.length);
			var v0y:Array=new Array(obj.length);
			//Начальные координаты шариков
			var x0:Array=new Array(obj.length);
			var y0:Array = new Array(obj.length);
			//Конечные координаты шариков
			var y1:Array=new Array(obj.length);
			var x1:Array=new Array(obj.length);
			//Коэффициеты для метода Рунге-Кутта 4 порядка
			var kx1:Array=new Array(obj.length), 
				kx2:Array=new Array(obj.length), 
				kx3:Array=new Array(obj.length), 
				kx4:Array=new Array(obj.length);
				
			var ky1:Array=new Array(obj.length), 
				ky2:Array=new Array(obj.length), 
				ky3:Array=new Array(obj.length), 
				ky4:Array=new Array(obj.length);				
				
			var mx1:Array=new Array(obj.length), 
				mx2:Array=new Array(obj.length), 
				mx3:Array=new Array(obj.length), 
				mx4:Array=new Array(obj.length);
				
			var my1:Array=new Array(obj.length), 
				my2:Array=new Array(obj.length), 
				my3:Array=new Array(obj.length), 
				my4:Array=new Array(obj.length);
			
			
			//Инициализация начальных условий
			var i:Number;
			var j:Number;
			for (i = 0; i < obj.length; i++) {
				v0x[i] = obj[i].Vx;	
				v0y[i] = obj[i].Vy;
				x0[i]=  obj[i].X;
				y0[i] = obj[i].Y;
				x1[i] = x0[i];
				y1[i] = y0[i];
			}
			//Шаг 1 метода Рунге-Кутта
			for (i = 0; i < obj.length; i++) {

				kx1[i] = 0;      ky1[i] = 0;
				
				mx1[i] = v0x[i]; my1[i] = v0y[i];
				
				for (j = 0; j < obj.length; j++) {	
					if(j!=i){
					dist  = Math.sqrt(Math.pow(x1[i] -x1[j], 2) + Math.pow(y1[i] - y1[j], 2)); 
					angle = Math.atan2( -x1[i] + x1[j], -y1[i] + y1[j]);
					
					if (obj[i].Type != obj[j].Type) {	
						a= WorldConstants.ForceOneToTwo.calculateWithValue(dist);
						
					}
					if(obj[i].Type==0&&obj[j].Type==0){
						a = WorldConstants.ForceOneToOne.calculateWithValue(dist);
					}
					if(obj[i].Type==1&&obj[j].Type==1){
						a = WorldConstants.ForceTwoToTwo.calculateWithValue(dist);
					}
					//if ((dist < (2.1 * WorldConstants.ObjectRadius)))  a = 0.0;
						kx1[i] -= a * Math.sin(angle);
						ky1[i] -= a * Math.cos(angle);
					}
					
						   
					
				}
				 kx1[i] -=  stopperForce2(mx1[i],kx1[i]); 
				 kx1[i] -=  stopperForce1(mx1[i]); 
				 		
				 ky1[i] -=  stopperForce2(my1[i],ky1[i]); 
				 ky1[i] -=  stopperForce1(my1[i]); 
				
					
					
			}
			//Шаг 2 метода Рунге-Кутта
			for (i = 0; i < obj.length; i++) {
				x1[i] = x0[i] + (h / 2) * mx1[i]; y1[i] = y0[i] + (h / 2) * my1[i];
			}
			
			for (i = 0; i < obj.length; i++) {
				mx2[i]= v0x[i]+(h/2)*kx1[i];  my2[i] = v0y[i]+(h/2)*ky1[i];				
				kx2[i] = 0;
			    ky2[i] = 0;
				
				for (j = 0; j < obj.length; j++) {	
					if(j!=i){
					dist= Math.sqrt(Math.pow(x1[i] -x1[j], 2) + Math.pow(y1[i] - y1[j], 2)); 
					angle = Math.atan2( -x1[i] + x1[j], -y1[i] + y1[j]);
					
					if (obj[i].Type != obj[j].Type) {	
						a= WorldConstants.ForceOneToTwo.calculateWithValue(dist);
						
					}
					if(obj[i].Type==0&&obj[j].Type==0){
						a = WorldConstants.ForceOneToOne.calculateWithValue(dist);
					}
					if(obj[i].Type==1&&obj[j].Type==1){
						a = WorldConstants.ForceTwoToTwo.calculateWithValue(dist);
					}
					//if ((dist < (2.3* WorldConstants.ObjectRadius)))  a = 0.0;
					kx2[i] -= a * Math.sin(angle);
					ky2[i] -= a * Math.cos(angle);
			
					}
					
							
						
					
				}
				kx2[i] -=  stopperForce2(mx2[i],kx2[i]); 
				kx2[i] -=  stopperForce1(mx2[i]); 
						
				ky2[i] -=  stopperForce2(my2[i],ky2[i]); 
				ky2[i] -=  stopperForce1(my2[i]); 
			}
			
			
			//Шаг 3 метода Рунге-Кутта
			for (i = 0; i < obj.length; i++) {
				x1[i] = x0[i] + (h / 2) * mx2[i]; y1[i] = y0[i] + (h / 2) * my2[i];
			}
			
			for (i = 0; i < obj.length; i++) {
				mx3[i]= v0x[i]+(h/2)*kx2[i];  my3[i] = v0y[i]+(h/2)*ky2[i];				
				kx3[i] = 0;
				ky3[i] = 0;
				for (j = 0; j < obj.length; j++) {
					if(j!=i){
					dist= Math.sqrt(Math.pow(x1[i] -x1[j], 2) + Math.pow(y1[i] - y1[j], 2)); 
					angle = Math.atan2( -x1[i] + x1[j], -y1[i] + y1[j]);
					
					if (obj[i].Type != obj[j].Type) {	
						a= WorldConstants.ForceOneToTwo.calculateWithValue(dist);
						
					}
					if(obj[i].Type==0&&obj[j].Type==0){
						a = WorldConstants.ForceOneToOne.calculateWithValue(dist);
					}
					if(obj[i].Type==1&&obj[j].Type==1){
						a = WorldConstants.ForceTwoToTwo.calculateWithValue(dist);
					}
					//if ((dist < (2.3 * WorldConstants.ObjectRadius)))  a = 0.0;
						kx3[i] -= a * Math.sin(angle);
						ky3[i] -= a * Math.cos(angle);
					}
					
							
						
					

				}
				kx3[i] -=  stopperForce2(mx3[i],kx3[i]); 
				kx3[i] -=  stopperForce1(mx3[i]); 
						
				ky3[i] -=  stopperForce2(my3[i],ky3[i]); 
				ky3[i] -=  stopperForce1(my3[i]); 
			}
			
			
			//Шаг 4 метода Рунге-Кутта
			for (i = 0; i < obj.length; i++) {
				x1[i] = x0[i] + h*mx3[i]; y1[i] = y0[i] + h*my3[i];
			}
			
			for (i = 0; i < obj.length; i++) {
				mx4[i]= v0x[i] + h*kx3[i];  my4[i] = v0y[i] + h*ky3[i];				
				kx4[i] = 0;
				ky4[i] = 0;
				for (j = 0; j < obj.length; j++) {
					if(j!=i){
					dist= Math.sqrt(Math.pow(x1[i] -x1[j], 2) + Math.pow(y1[i] - y1[j], 2)); 
					angle = Math.atan2( -x1[i] + x1[j], -y1[i] + y1[j]);
					
					if (obj[i].Type != obj[j].Type) {	
						a= WorldConstants.ForceOneToTwo.calculateWithValue(dist);
						
					}
					
					if(obj[i].Type==0&&obj[j].Type==0){
						a = WorldConstants.ForceOneToOne.calculateWithValue(dist);
					}
					if(obj[i].Type==1&&obj[j].Type==1){
						a = WorldConstants.ForceTwoToTwo.calculateWithValue(dist);
					}
					//if ((dist < (2.3 * WorldConstants.ObjectRadius)))  a = 0.0;
						kx4[i] -= a * Math.sin(angle);
						ky4[i] -= a * Math.cos(angle);
			
					}
					
							
						
					
				}
				kx4[i] -=  stopperForce2(mx4[i],kx4[i]); 
				kx4[i] -=  stopperForce1(mx4[i]); 
						
				ky4[i] -=  stopperForce2(my4[i],ky4[i]); 
				ky4[i] -=  stopperForce1(my4[i]); 
			}
			
			
		
			//Рассчёт конечных координат и скоростей
			for (i = 0; i < obj.length; i++) {
				x1[i] = x0[i] + (h / 6)*(mx1[i] + 2 * mx2[i] + 2 * mx3[i] + mx4[i]);
			
				
				y1[i] = y0[i] + (h / 6)*(my1[i] + 2 * my2[i] + 2 * my3[i] + my4[i]);
				
							
				v1x[i] = v0x[i] + (h / 6) * (kx1[i] + 2 * kx2[i] + 2 * kx3[i] + kx4[i]);
				
				
				v1y[i] = v0y[i] + (h / 6) * (ky1[i] + 2 * ky2[i] + 2 * ky3[i]+ ky4[i]);
			}
		
			
				for (i = 0; i < obj.length; i++) {
					obj[i].Vx = v1x[i];
				
					obj[i].Vy = v1y[i];
					
					obj[i].X = x1[i];
					obj[i].Y = y1[i];
					
			}
			
			
		
			
			
			
			
			
			
			
		}
		//Сила вязкости 1
		public static function stopperForce1(speed:Number ):Number {
			//var F = 0.001*Math.abs( speed);
			//if(Math.abs(speed)>10)
			
		
			//if (Math.abs(speed) > 100)
			var F:Number = WorldConstants.KoeffOne * Math.abs(speed);
			if (speed < 0)
				F = -F;
			
		    
			return F; 
		}
		//Сила вязкости 2(уменьшает силу со временем, среда как бы густеет)
		public static function stopperForce2(speed:Number, a:Number):Number {
			var k:Number = 0.05 / Math.abs(a);
			if (Math.abs(a) > 10000) WorldConstants.KoeffTwo = 1;
		    var F:Number = (1-k)*WorldConstants.KoeffTwo* Math.abs(a);
			if (a < 0)
					F = -F;
			return F; 
		}
	}

}
