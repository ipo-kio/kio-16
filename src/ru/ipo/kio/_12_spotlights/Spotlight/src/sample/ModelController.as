package sample 
{
	import flash.display.Sprite;
	import sample.colorModels.colorControllers.RGBController;
	/**
	 * ...
	 * @author ...
	 */
	public class ModelController 
	{
		
		private var _sprite: Sprite;
		private var _model: Model;
		private var _level: int;
		private var _arrayControllers: Array;
		private var _minEnergy: int;
		private var _maxEnergy: int;
		
		public function ModelController(sprite: Sprite, model: Model, level: int, minEnergy: int, maxEnergy: int) {
			_sprite = sprite;
			_model =  model;
			_level =  level;
			_minEnergy = minEnergy;
			_maxEnergy = maxEnergy;
			_arrayControllers = new Array(model.countSpotlights);
			if (level == 1) {
				_arrayControllers[0] = new RGBController(650, 100 + 0 * 50, [0], _model, _minEnergy, _maxEnergy);
				_arrayControllers[1] = new RGBController(650, 100 + 1 * 50, [1], _model, _minEnergy, _maxEnergy);
				_arrayControllers[2] = new RGBController(650, 100 + 2 * 50, [2], _model, _minEnergy, _maxEnergy);
			}
			if (level == 2) {
				_arrayControllers[0] = new RGBController(650, 100 + 0 * 50, [0, 1], _model, _minEnergy, _maxEnergy);
				_arrayControllers[1] = new RGBController(650, 100 + 1 * 50, [2], _model, _minEnergy, _maxEnergy);
			}
		}
		
		public function init(): void {
			if (_level == 1) {
				_arrayControllers[0].init(_sprite);
				_arrayControllers[1].init(_sprite);
				_arrayControllers[2].init(_sprite);
			}
			if (_level == 2) {
				_arrayControllers[0].init(_sprite);
				_arrayControllers[1].init(_sprite);
			}
		}
		
	}

}