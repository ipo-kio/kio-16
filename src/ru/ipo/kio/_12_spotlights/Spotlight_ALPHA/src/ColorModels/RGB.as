package ColorModels 
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class RGB implements ColorsBuilder
	{
		public static const MIN_VALUE: uint = 0x00; // Минимальное значение компоненты
		public static const MAX_VALUE: uint = 0xFF; // Максимальное значение компоненты
		
		private var _red: uint; // Компонента Red
		private var _green: uint; // Компонента Green
		private var _blue: uint; // Компонента Blue
		
		public function RGB(red: uint = 0xFF, green: uint = 0xFF, blue: uint = 0xFF ) {
			_red = red;
			_green = green;
			_blue = blue;
		}
		
		public function get red(): uint {
			return _red;
		}
		public function get green(): uint {
			return _green;
		}
		public function get blue(): uint {
			return _blue;
		}
		public function set red(red: uint): void {
			_red = red;
		}
		public function set green(green: uint): void {
			_green = green;
		}
		public function set blue(blue: uint): void {
			_blue = blue;
		}
		
		// Генерация нового цвета
		public function randomColor(): void {
			_red = Math.random() * 255;
			_green = Math.random() * 255;
			_blue =  Math.random() * 255;
		}
		
		// Получение новых значений компонент из Hex
		public function setFromHex(color: uint): void {
			_red = color << 16;
			_blue = color << 8 & 0xFF;
			_green = color & 0xFF;
		}
		
		// Представление цвета в виде Hex с учетом параметров
		public function calcHex(conversionOptions: Array): uint {
			return ((_red * conversionOptions[0]/100) << 16 & 0xFF0000) | ((_green * conversionOptions[0]/100) << 8 & 0xFF00) | ((_blue * conversionOptions[0]/100) & 0xFF);
		}
		
		// Смешение массива цветов
		public function mixColor(colorsArray: Array): uint {
			var red: uint = 0;
			var green: uint = 0;
			var blue: uint = 0;
			for (var i: int = 0; i < colorsArray.length; i++) {
				red += colorsArray[i].red;
				green += colorsArray[i].green;
				blue += colorsArray[i].blue;
			}
			var result: RGB = new RGB(red, green, blue);
			return (red  << 16 & 0xFF0000) | (green << 8 & 0xFF00) | (blue & 0xFF);
		}
		
	}

}