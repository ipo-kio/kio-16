package ru.ipo.kio._12.stagelights 
{
	
	import fl.controls.Label;
	import fl.controls.Slider;
	import fl.controls.TextInput;
	import flash.events.Event;
	import flash.text.TextFormat;
	import fl.events.SliderEvent;
	
	/**
	 * ...
	 * @author ovv
	 */
	public class VIntensitySlider extends Slider {
		
		private var _spotlightController: CIndensityHandler;
		private var _input: TextInput;
		
		public function VIntensitySlider(spotlightController: CIndensityHandler) {
			_spotlightController = spotlightController;
			_spotlightController.spotlight.addEventListener(Event.CHANGE, update);
			minimum = 0;
			maximum = 255;
			width = 150;
			height = 20;
			value = _spotlightController.spotlight.intensity;
			snapInterval = 1;
			addEventListener(SliderEvent.THUMB_DRAG, _spotlightController.handler);
			
			_input = new TextInput();
			_input.x = -40;
			_input.y = -8;
			_input.width = 28;
			_input.height = 18;
			
			var format: TextFormat = new TextFormat();
            format.color = 0x000000;
			format.font = "Tahoma";
            format.size = 11;
			
			_input.setStyle("textFormat", format);
			addChild(_input);
			_input.text = " " + _value.toString();
			_input.addEventListener(Event.CHANGE, _spotlightController.handler);
			
		}
		
		private function update(e: Event = null): void {
			value = e.target.intensity;
			_input.text = " " + e.target.intensity.toString();
		}
		
	}

}