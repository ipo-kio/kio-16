package ColorModels 
{
	/**
	 * ...
	 * @author ovv
	 */
	public interface ColorsBuilder 
	{
		function randomColor(): void;
		function setFromHex(color: uint): void;
		function calcHex(conversionOptions: Array): uint;
		function mixColor(colorsArray: Array): uint;
		
	}

}