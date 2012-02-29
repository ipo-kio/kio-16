package ru.ipo.kio._12.stagelights 
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;	
	import flash.display.BlendMode;
	import flash.events.Event;

	
	import flash.geom.ColorTransform;
	
	
	/**
	 * ...
	 * @author ovv
	 */
	public class VBody extends Sprite {
		
		private var _body: IBody;
		private var _silhouette: MovieClip;
		
		public function VBody(body: IBody, silhouette: MovieClip, blend: Boolean = false) {
			_body = body;
			_body.addEventListener(Event.CHANGE, refresh);
			_silhouette = silhouette;
			if (blend) {
				_silhouette.blendMode = BlendMode.ADD;
			}
			var red: Number = _body.red / 246;
			var green: Number = _body.green/ 246;
			var blue: Number = _body.blue / 246;
			_silhouette.transform.colorTransform = new ColorTransform(red, green, blue);
			addChild(_silhouette);
		}
		
		public function refresh(e: Event = null): void {
			var red: Number = _body.red / 246;
			var green: Number = _body.green/ 246;
			var blue: Number = _body.blue / 246;
			_silhouette.transform.colorTransform = new ColorTransform(red, green, blue);
		}
		
		public function get body(): IBody {
			return _body;
		}
		
		public function get silhouette(): MovieClip {
			return _silhouette;
		}
	}

}