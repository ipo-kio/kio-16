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
		
		public function VBody(body: IBody, silhouette: MovieClip) {
			_body = body;
			_body.addEventListener(Event.CHANGE, refresh);
			_silhouette = silhouette;
			_silhouette.transform.colorTransform = new ColorTransform(_body.red / 255, _body.green / 255, _body.blue / 255);
			addChild(_silhouette);
		}
		
		public function refresh(e: Event = null): void {
			_silhouette.transform.colorTransform = new ColorTransform(_body.red / 255, _body.green / 255, _body.blue / 255);
		}
		
		public function get body(): IBody {
			return _body;
		}
		
	}

}