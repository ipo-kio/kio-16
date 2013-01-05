/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 09.12.12
 * Time: 0:22
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.controller {
import org.osmf.layout.PaddingLayoutMetadata;

import ru.ipo.kio._13.crane.model.Crane;
import ru.ipo.kio._13.crane.view.WorkspaceView;

public class LangModel {

    private var _pos:int = 0;
    private var _input:String;
    var _main: Programm;
    private var loopNum:String = "";
    public var loopProg: Programm;
    public var inLoop: Boolean = false;
    public function read():String {
        if (_pos >= _input.length) {
            return "$";
        } else {
            return _input.charAt(_pos);
        }
        /*
         var ch: String = _input[_pos];
         if (!ch)
         return "$";
         else
         return ch;*/
    }

    private var _error:Error = new Error("ошибка");

    public function errorFunc() {
        throw _error;
    }

    public function read_rule():void {
        switch (read()) {
            case 'L':
            case 'R':
            case 'U':
            case 'D':
            case 'T':
            case 'P':
                if (inLoop){
                    loopProg.push(new Action(read()));
                }  else {
                    _main.push(new Action(read()));
                }
                next();
                break;
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':

                read_loop_number();
                trace(read(), "много цифер");
                if (read() != '(') {
                    errorFunc();
                }
                trace(read());

                loopProg = new Programm();
                inLoop = true;

                next();
                trace(read());
                read_beginning();
                trace(read());
                if (read() != ')') {
                    errorFunc();
                } else {
                    _main.push(new Loop(int(loopNum), loopProg));
                    loopNum = "";
                    loopProg = null;
                    inLoop = false;
                    next();
                    trace(read());
                }
                break;
            default:
                errorFunc();

        }

    }

    public function read_other_rule():void {
        switch (read()) {
            case 'L':
            case 'R':
            case 'U':
            case 'D':
            case 'T':
            case 'P':
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                read_beginning();
                break;
            /*

             read_loop_number();

             break;*/
            case '$':
                break;
            case ')':
                break;
            default:
                errorFunc();
        }
    }

    public function read_loop_number():void {
        switch (read()) {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                read_numeric();
                read_other_num();
                break;
            default:
                errorFunc();
        }

    }

    public function read_numeric():void {
        switch (read()) {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                loopNum = loopNum + read();
                next();
                break;
            default:
                errorFunc();
        }

    }

    public function read_other_num():void {
        switch (read()) {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                read_loop_number();
                break;
            case '(':
                break;
            default:
                errorFunc();
        }

    }

    public function read_beginning():void {
        switch (read()) {
            case 'L':
            case 'R':
            case 'U':
            case 'D':
            case 'T':
            case 'P':
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                trace(read(), "read rule");
                read_rule();
                read_other_rule();
                break;
            default:
                errorFunc();
        }


    }

    public function next():void {
        _pos++;
    }


    public function LangModel(main:Programm):void {
        _main = main;


    }

    public function get pos():int {
        return _pos;
    }

    public function get input():String {
        return _input;
    }

    public function set input(value:String):void {
        _input = value;
    }

    public function get error():Error {
        return _error;
    }

    public function set error(value:Error):void {
        _error = value;
    }
}
}
