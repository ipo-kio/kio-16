/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 19:56
 */
package ru.ipo.kio._13.blocks.parser {

import ru.ipo.kio._13.blocks.BlocksProblem;
import ru.ipo.kio.api.KioApi;

public class Parser {

    public static const MAX_NUMBER:int = 1000;

    private var _program:Program;

    private var loc:Object = KioApi.getLocalization(BlocksProblem.ID);

    private var _simple:Boolean;
    private var code:String;
    private var tokenType:int;
    private var token:String;

    private var tokenPos:int; //this is the position of the first symbol of the next token to read
    private var pos:int; //this is the position of the first symbol of the last read token  //TODO report Ctrl+Shift+Up moves a lot here

    private static const EOS:String = null;

    public static const TOKEN_COMMAND:int = 0;
    public static const TOKEN_NUMBER:int = 1;
    public static const TOKEN_PUNCTUATION:int = 2;
    private var _tokensCallback:Function;

    public function Parser(simple:Boolean, tokensCallback:Function = null) {
        _simple = simple;
        _tokensCallback = tokensCallback;
    }

    public function parse(code:String):void {
        pos = -1;
        tokenPos = 0;
        this.code = code;

        next();

        _program = readSequence();

        if (token != EOS)
            throw new ParseError(pos, token.length, loc.parse_errors.unexpected_symbol + " " + token);
    }

    public function get program():Program {
        return _program;
    }

    private function next():void {
        shiftHead();

        if (_simple && token != EOS && tokenType != TOKEN_COMMAND)
            new ParseError(pos, token.length, loc.parse_errors.unexpected_symbol + " " + token);

        if (_tokensCallback != null)
            _tokensCallback(token, tokenType, pos, token == null ? 0 : token.length);
    }

    private function shiftHead():void {
        pos = tokenPos;

        while (true) {
            if (tokenPos >= code.length) {
                token = EOS;
                tokenType = TOKEN_PUNCTUATION;
                return;
            }

            token = code.charAt(tokenPos);

            tokenPos ++;

            switch (token) {
                case 'L':
                case 'R':
                case 'P':
                case 'T':
                    tokenType = TOKEN_COMMAND;
                    return;
                case '(':
                case ')':
                    tokenType = TOKEN_PUNCTUATION;
                    return;
                case ' ':
                case '\n':
                case '\r':
                case '\t':
                    pos ++;
                    continue;
            }

            break;
        }

        if (token >= '1' && token <= '9') { //a number can not be 0 or start with 0
            tokenType = TOKEN_NUMBER;

            //read all other digits
            while (tokenPos < code.length) {
                var digit:String = code.charAt(tokenPos);
                if (digit >= '0' && digit <= '9') {
                    token += digit;

                    var number:Number = parseFloat(token);
                    if (number > MAX_NUMBER)
                        throw new ParseError(pos, token.length, loc.parse_errors.number_too_big);

                    tokenPos ++;
                } else
                    break;
            }

            return;
        }

        throw new ParseError(pos, token.length, loc.parse_errors.unexpected_symbol + " " + token);
    }

    private function readSequence():Program {
        var p:SequenceProgram = new SequenceProgram();

        while (token != EOS && token != ')')
            p.add(readItem());

        return p;
    }

    private function readLoop():Program {
        if (tokenType != TOKEN_NUMBER)
            throw new ParseError(pos, token.length, unexpectedTokenMessage());
        var n:int = parseInt(token);

        next();

        return new LoopProgram(readItem(), n);
    }

    private function unexpectedTokenMessage():String {
        if (token == EOS)
            return loc.parse_errors.unexpected_end;
        else
            return loc.parse_errors.unexpected_token + " " + token;
    }

    private function readItem():Program {
        switch (token) {
            case 'L':
                var cmd:Command = new Command(Command.LEFT, pos);
                next();
                return cmd;
            case 'R':
                cmd = new Command(Command.RIGHT, pos);
                next();
                return cmd;
            case 'P':
                cmd = new Command(Command.PUT, pos);
                next();
                return cmd;
            case 'T':
                cmd = new Command(Command.TAKE, pos);
                next();
                return cmd;
            case '(': //just a brackets
                next();
                var seq:Program = readSequence();
                if (token != ')')
                    throw new ParseError(pos, token == null ? 0 : token.length, loc.parse_errors.close_bracket_expected);
                next();
                return seq;
        }

        if (tokenType == TOKEN_NUMBER)
            return readLoop();

        throw new ParseError(pos, token == null ? 0 : token.length, unexpectedTokenMessage());
    }
}
}
