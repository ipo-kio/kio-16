package sample.colorModels 
{
	/**
	 * ...
	 * @author Osipov Vladimir
	 */
	public interface IColor
	{ 
		
		function newColor(): void;
		function calcHex(conversion: int): uint;
		function mixColor(colorsArray: Array): uint;
		
	}
}