package ru.ipo.kio._12.stagelights 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import mx.core.BitmapAsset;
	
	/**
	 * ...
	 * @author ovv
	 */
	public class Main extends Sprite 
	{
		
		private var _parts: Array = [];
		private var crnt: int = 0;
		private var bNext: Button;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_parts[0] = new Stagelights(1);
			addChild(_parts[0]);
			_parts[1] = new Stagelights(0);
			addChild(_parts[1]);

			_parts[0].visible = true;
			_parts[1].visible = false;
			
			bNext = new Button();
			bNext.width = 160;
			bNext.height = 26;
			bNext.label = "Перейти ко второй части";
			bNext.x = 680 - bNext.width / 2;
			bNext.y = 20; 
			bNext.addEventListener(MouseEvent.CLICK, change);
			addChild(bNext);
			
			var bRefresh: Button = new Button();
			bRefresh.width = 160;
			bRefresh.height = 26;
			bRefresh.label = "Новое условие задачи";
			bRefresh.x = 100 - bRefresh.width / 2;
			bRefresh.y = 20; 
			bRefresh.addEventListener(MouseEvent.CLICK, refresh);
			addChild(bRefresh);
			
		}
		
		private function refresh(e: Event = null): void {
			_parts[crnt].refresh();
		}
		
		private function change(e: Event = null): void {
			trace(0);
			_parts[0].visible = !_parts[0].visible;
			_parts[1].visible = !_parts[1].visible;
			if (crnt == 0) {
				bNext.label = "Перейти ко второй части";
				crnt = 1;
			} else {
				bNext.label = "Перейти к первой части";
				crnt = 0;
			}
		}
		
		
		
	}
	
}