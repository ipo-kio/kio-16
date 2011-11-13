package ModelComponents.Spotlight.SpotlightControllers 
{
	import fl.controls.Label;
	import fl.controls.Slider;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.Event;
	import fl.events.SliderEvent;
	/**
	 * ...
	 * @author ovv
	 */
	public class SpotlightRGBController
	{
		
		private var _x: int; // Координата левого верхнего угла по оси Х
		private var _y: int; // Координата левого верхнего угла по оси Y
		private var _energyLabel: Label // 
		private var _energyInput: TextInput; // Поле ввода мощности
		private var _energySlider: Slider; // Регулятор мощности
		private var _minEnergy: int; // Минимальная мощность
		private var _maxEnerdy: int; // Максимальная мощность
		
		public function SpotlightRGBController(x: int, y: int, minEnergy: int, maxEnergy: int) {
			_x = x;
			_y = y;
			_minEnergy = minEnergy;
			_maxEnerdy = maxEnergy;
		}
		
		public function get energyLabel(): Label {
			return _energyLabel;
		}
		public function get energyInput(): TextInput {
			return _energyInput;
		}
		public function get energySlider(): Slider {
			return _energySlider;
		}
		
		public function getConversionOptions(): Array {
			return [_energySlider.value];
		}
		public function init(sprite: Sprite): void {	
			_energyLabel = new Label();
			_energyLabel.x = _x;
			_energyLabel.y = _y;
			_energyLabel.width = 120;
			_energyLabel.height = 20;
			_energyLabel.text = "Мощность : ";
			
			_energyInput = new TextInput();
			_energyInput.x = _x + _energyLabel.width + 10;
			_energyInput.y = _y;
			_energyInput.width = 26;
			_energyInput.height = 20;
			_energyInput.text = _minEnergy.toString();
			
			_energySlider = new Slider();
			_energySlider.x = _x + 2;
			_energySlider.y = _y + 30;
			_energySlider.width = 153;
			_energySlider.minimum = _minEnergy;
			_energySlider.maximum =  _maxEnerdy;
			_energySlider.value = _minEnergy;
			_energySlider.snapInterval = 1;
			_energySlider.tickInterval = 5;
			
			_energySlider.addEventListener(SliderEvent.CHANGE, synchronizationS);
			_energyInput.addEventListener(Event.CHANGE, synchronizationI);
			
			function synchronizationS(e: Event):void 
			{
				_energyInput.text = _energySlider.value.toString();
			}
			function synchronizationI(e: Event):void 
			{
				_energySlider.value = parseInt(_energyInput.text);
			}
			
			sprite.addChild(_energyLabel);
			sprite.addChild(_energyInput);
			sprite.addChild(_energySlider);
		}
		
	}

}