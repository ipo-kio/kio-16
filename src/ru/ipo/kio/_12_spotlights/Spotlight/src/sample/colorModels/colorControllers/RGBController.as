package sample.colorModels.colorControllers 
{
	import fl.controls.Label;
	import fl.controls.Slider;
	import fl.controls.TextInput;
	import sample.Model;
	
	import fl.events.SliderEvent;
	
	import flash.events.Event;
	import flash.display.Sprite;
	
	import sample.Spotlight;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RGBController {
		
		private var _x: int; // Координата левого верхнего угла по оси Х
		private var _y: int; // Координата левого верхнего угла по оси Y
		private var _arrayIndexSpotlight: Array; //
		private var _model: Model; // Модель
		private var _energyInput: TextInput; // Поле ввода мощности
		private var _energySlider: Slider; // Регулятор мощности
		private var _minEnergy: int; // Минимальная мощность
		private var _maxEnerdy: int; // Максимальная мощность
		
		public function RGBController(x: int, y: int, arrayIndexSpotlight: Array, model: Model, minEnergy: int, maxEnergy: int) {
			_x = x;
			_y = y;
			_arrayIndexSpotlight = arrayIndexSpotlight;
			_model =  model;
			_minEnergy = minEnergy;
			_maxEnerdy = maxEnergy;
		}
		// 
		public function init(sprite: Sprite): void {	
			var _energyLabel: Label = new Label();
			_energyLabel.x = _x;
			_energyLabel.y = _y;
			_energyLabel.width = 174;
			if ( _arrayIndexSpotlight.length == 1 ) {
				_energyLabel.text = "Мощность прожектора № " + (_arrayIndexSpotlight[0] + 1);
			} else {
				_energyLabel.text = "Мощность прожекторов № " + (_arrayIndexSpotlight[0] + 1) + "-" + (_arrayIndexSpotlight[_arrayIndexSpotlight.length - 1] + 1);
			}
			
			var _energyInput: TextInput = new TextInput();
			_energyInput.x = _x + _energyLabel.width + 10;
			_energyInput.y = _y;
			_energyInput.width = 36;
			_energyInput.height = 22;
			_energyInput.text = _minEnergy.toString();
			
			var _energySlider: Slider = new Slider();
			_energySlider.x = _x + 3;
			_energySlider.y = _y + 35;
			_energySlider.width = 217;
			_energySlider.minimum = _minEnergy;
			_energySlider.maximum =  _maxEnerdy;
			_energySlider.value = _minEnergy;
			_energySlider.snapInterval = 1;
			_energySlider.tickInterval = 5;
			
			_energySlider.addEventListener(SliderEvent.CHANGE, changeSEnergy);
			_energyInput.addEventListener(Event.CHANGE, changeIEnergy);
			
			function changeSEnergy(e: Event):void 
			{
				_energyInput.text = _energySlider.value.toString();
				_model.refresh(_arrayIndexSpotlight, _energySlider.value);
			}
			function changeIEnergy(e: Event):void 
			{
				_energySlider.value = parseInt(_energyInput.text);
				_model.refresh(_arrayIndexSpotlight, _energySlider.value);
			}
			
			sprite.addChild(_energyLabel);
			sprite.addChild(_energyInput);
			sprite.addChild(_energySlider);
		}
	}
}
