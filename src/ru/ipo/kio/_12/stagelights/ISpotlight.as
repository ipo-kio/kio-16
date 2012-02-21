package ru.ipo.kio._12.stagelights 
{
	
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author ovv
	 */
	public interface ISpotlight extends IEventDispatcher {
		
		function getColor(intensity: int = -1): uint;
		function setColor(value: uint): void;
		
		function get intensity(): int;
		function set intensity(value: int): void;
		
	}

}