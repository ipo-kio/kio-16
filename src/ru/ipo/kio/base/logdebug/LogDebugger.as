
package ru.ipo.kio.base.logdebug {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.utils.ByteArray;


import ru.ipo.kio.api.ILogDebuggerHandler;

public class LogDebugger extends EventDispatcher{

    private var _display:LogDebuggerView;

    private var handlers:Vector.<ILogDebuggerHandler> = new Vector.<ILogDebuggerHandler>();

    private var _commands:Vector.<LogDebugCommand> = new Vector.<LogDebugCommand>();

    private var _currentIndex:int=0;

    private var played:Boolean=false;

    private var _delay:int=50;

    private var delayCounter:int=0;

    public function LogDebugger() {
        _display = new LogDebuggerView(this);
    }

    public function tick():void{
        if(!played){
            return;
        }
        delayCounter++;
        if(delayCounter>_delay){
            executeNextCommand();
            _display.updateSelection();
            _currentIndex++;
            delayCounter=0;
        }
    }

    private function executeNextCommand():void {
        if (_currentIndex < _commands.length - 1) {
            for (var i:int = 0; i < handlers.length; i++) {
                handlers[i].execute(_commands[_currentIndex]);
            }
        } else {
            stop();
        }
    }

    internal function play():void{
        played=true;
    }

    internal function pause():void{
        played=false;
    }

    internal function stop():void{
        _currentIndex=0;
        played=false;
    }

    internal function load():void{
        stop();
        _commands = new Vector.<LogDebugCommand>();
        var fileRef:FileReference = new FileReference();
        fileRef.browse([
            new FileFilter("Все файлы", "*.*")
        ]);
        fileRef.addEventListener(Event.SELECT, function(e:Event):void {
            fileRef.addEventListener(Event.COMPLETE, function(e:Event):void {
                var data:ByteArray = fileRef.data;
                var dataUTF:String = data.readUTFBytes(data.length);
                try {
                    loadCommands(dataUTF);
                } catch (error:Error) {
                }
            });
            fileRef.load();
        });
    }

    private function loadCommands(solUTF:String):void {
        var items:Array = solUTF.split("\n");
        for each(var item:String in items) {
            var command:LogDebugCommand = new LogDebugCommand(item);
            inner:
            for(var i:int = 0; i<handlers.length; i++) {
                if (handlers[i].canExecute(command)) {
                    _commands.push(command);
                    break inner;
                }
            }
        }
        _display.updateCommands();
    }


    public function get display():Sprite {
        return _display;
    }

    public function addHandler(handler:ILogDebuggerHandler){
        handlers.push(handler);
    }


    internal function get commands():Vector.<LogDebugCommand> {
        return _commands;
    }


    internal function get currentIndex():int {
        return _currentIndex;
    }


    internal function get delay():int {
        return _delay;
    }

    internal function set delay(value:int):void {
        _delay = value;
    }
}
}
