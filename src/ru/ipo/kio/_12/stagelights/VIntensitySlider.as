package ru.ipo.kio._12.stagelights 
{
	
	import fl.controls.Label;
	import fl.controls.Slider;
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFormat;
	import fl.events.SliderEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ovv
	 */
	public class VIntensitySlider extends Slider {
		
		private var _spotlightController: CIndensityHandler;
		private var _input: Label;
		private var _plus: MovieClip;
		private var _minus: MovieClip;
		
		public function VIntensitySlider(spotlightController: CIndensityHandler) {
			_spotlightController = spotlightController;
			_spotlightController.spotlight.addEventListener(Event.CHANGE, update);
			minimum = 0;
			maximum = 255;
			width = 142;
			height = 20;
			value = _spotlightController.spotlight.intensity;
			snapInterval = 1;
			addEventListener(SliderEvent.THUMB_DRAG, _spotlightController.handler);
			addEventListener(SliderEvent.CHANGE, _spotlightController.handler);
			
			_input = new Label();
			_input.x = -85;
			_input.y = -7;
			_input.width = 26;
			_input.height = 18;
			_input.textField.height = 18;
			_input.textField.embedFonts = true;
			
			_plus= new Plus();
			_plus.x = -40;
			_plus.y = 2;
			_plus.addEventListener(MouseEvent.CLICK, inc);
			addChild(_plus);
			_minus = new Minus();
			_minus.x = -21;
			_minus.y = 2;
			_minus.addEventListener(MouseEvent.CLICK, dec);
			addChild(_minus);
			
			
			var format: TextFormat = new TextFormat();
            format.color = 0x000000;
			format.font = "KioTahoma";
			format.bold = true;
            format.size = 10;
			
			_input.setStyle("textFormat", format);
			addChild(_input);
			_input.text = _value.toString();
			_input.textField.embedFonts = true;
		}
		
		private function update(e: Event = null): void {
			value = e.target.intensity;
			_input.text = " " + e.target.intensity.toString();
		}
		
		private function inc(e: Event =  null): void {
			if (_spotlightController.spotlight.intensity < 255) _spotlightController.spotlight.intensity++;
		}
		private function dec(e: Event =  null): void {
			if (_spotlightController.spotlight.intensity > 0) _spotlightController.spotlight.intensity--;
		}
		
		public function get plus(): MovieClip {
			return _plus;
		}
		public function get minus(): MovieClip {
			return _minus;
		}
		
	}

}