package ru.ipo.kio._12.stagelights 
{
	/**
	 * ...
	 * @author ovv
	 */
	public interface IWorkspace {
		
		function get x(): Number;
		function set x(value: Number): void;
		
		function get y(): Number;
		function set y(value: Number): void;
		
		function inSpace(x: Number, y: Number, radius: Number): Boolean;
		
		function dx(x: Number, y: Number, radius: Number): Number;
		function dy(x: Number, y: Number, radius: Number): Number;
		
	}

}