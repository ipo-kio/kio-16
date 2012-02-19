package ru.ipo.kio._12.stagelights 
{
	import flash.events.IEventDispatcher;
	/**
	 * ...
	 * @author ovv
	 */
	public interface IBody extends IEventDispatcher {
		
		function get red(): int;
		function set red(value: int): void;
		
		function get green(): int;
		function set green(value: int): void;
		
		function get blue(): int;
		function set blue(value: int): void;
		
	}

}