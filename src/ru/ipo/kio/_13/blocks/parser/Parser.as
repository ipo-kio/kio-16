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

    private var _program:Program;

    private var loc:Object = KioApi.getLocalization(BlocksProblem.ID);

    private var _simple:Boolean;

    private var pos:int;
    private var code:String;
    private var tokenType:int;
    private var token:String;

    private static const EOS:String = null;

    public static const TOKEN_COMMAND:int = 0;
    public static const TOKEN_DIGIT:int = 1;
    public static const TOKEN_PUNCTUATION:int = 2;
    private var _tokensCallback:Function;

    public function Parser(simple:Boolean, tokensCallback:Function = null) {
        _simple = simple;
        _tokensCallback = tokensCallback;
    }

    public function parse(code:String):void {
        pos = -1;
        this.code = code;

        next();

        _program = readSequence();

        if (token != EOS)
            throw new ParseError(pos, loc.parse_errors.unexpected_symbol + " " + token);
    }

    public function get program():Program {
        return _program;
    }

    private function next():void {
        shiftHead();

        if (_simple && token != EOS && tokenType != TOKEN_COMMAND)
            new ParseError(pos, loc.parse_errors.unexpected_symbol + " " + token);

        if (_tokensCallback != null)
            _tokensCallback(token, tokenType, pos, 1); //all tokens are of length 1 by now
    }

    private function shiftHead():void {
        while (true) {
            pos ++;

            if (pos >= code.length) {
                token = EOS;
                tokenType = TOKEN_PUNCTUATION;
                return;
            }

            token = code.charAt(pos);

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
                case "\n":
                case "\r":
                case "\t":
                    continue;
            }

            break;
        }

        if (token >= '0' && token <= '9') {
            tokenType = TOKEN_DIGIT;
            return;
        }

        throw new ParseError(pos, loc.parse_errors.unexpected_symbol + " " + token);
    }

    private function readSequence():Program {
        var p:SequenceProgram = new SequenceProgram();

        while (token != EOS && token != ')')
            p.add(readItem());

        return p;
    }

    private function readLoop():Program {
        var n:int = 0;
        while (tokenType == TOKEN_DIGIT) {
            n = n * 10 + token.charCodeAt() - '0'.charCodeAt();
            next();
        }

        return new LoopProgram(readItem(), n);
    }

    private function readItem():Program {
        switch (token) {
            case 'L':
                next();
                return new Command(Command.LEFT, pos);
            case 'R':
                next();
                return new Command(Command.RIGHT, pos);
            case 'P':
                next();
                return new Command(Command.PUT, pos);
            case 'T':
                next();
                return new Command(Command.TAKE, pos);
            case '(': //just a brackets
                next();
                var seq:Program = readSequence();
                if (token != ')')
                    throw new ParseError(pos, loc.parse_errors.close_bracket_expected + " " + token);
                next();
                return seq;
        }

        if (tokenType == TOKEN_DIGIT)
            return readLoop();

        throw new ParseError(pos, loc.parse_errors.unexpected_token + " " + token);
    }
}
}
