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

    private var pos:int;
    private var code:String;

    private var tokenType:int;
    private var token:String;

    private const EOS:int = 0;
    private const LEFT:int = 1;
    private const RIGHT:int = 2;
    private const PUT:int = 3;
    private const TAKE:int = 4;
    private const OPEN_BRACKET:int = 5;
    private const CLOSE_BRACKET:int = 6;
    private const DIGIT:int = 7;

    public function Parser(code:String) {
        pos = -1;
        this.code = code;

        next();

        _program = readSequence();

        if (tokenType != EOS)
            throw new ParseError(pos, loc.parse_errors.unexpected_symbol + " " + token);
    }

    public function get program():Program {
        return _program;
    }

    private function next():void {
        while (true) {
            pos ++;

            if (pos >= code.length) {
                tokenType = EOS;
                return;
            }

            token = code.charAt(pos);

            switch (token) {
                case 'L':
                    tokenType = LEFT;
                    return;
                case 'R':
                    tokenType = RIGHT;
                    return;
                case 'P':
                    tokenType = PUT;
                    return;
                case 'T':
                    tokenType = TAKE;
                    return;
                case '(':
                    tokenType = OPEN_BRACKET;
                    return;
                case ')':
                    tokenType = CLOSE_BRACKET;
                    return;
                case ' ':
                    continue;
            }

            break;
        }

        if (token >= '0' && token <= '9') {
            tokenType = DIGIT;
            return;
        }

        throw new ParseError(pos, loc.parse_errors.unexpected_symbol + " " + token);
    }

    private function readSequence():Program {
        var p:SequenceProgram = new SequenceProgram();

        while (tokenType != EOS && tokenType != CLOSE_BRACKET)
            p.add(readItem());

        return p;
    }

    private function readLoop():Program {
        var n:int = 0;
        while (tokenType == DIGIT) {
            n = n * 10 + token.charCodeAt() - '0'.charCodeAt();
            next();
        }

        return new LoopProgram(readItem(), n);
    }

    private function readItem():Program {
        switch (tokenType) {
            case LEFT:
                next();
                return new Command(Command.LEFT, pos);
            case RIGHT:
                next();
                return new Command(Command.RIGHT, pos);
            case PUT:
                next();
                return new Command(Command.PUT, pos);
            case TAKE:
                next();
                return new Command(Command.TAKE, pos);
            case OPEN_BRACKET: //just a brackets
                next();
                var seq:Program = readSequence();
                if (tokenType != CLOSE_BRACKET)
                    throw new ParseError(pos, loc.parse_errors.close_bracket_expected + " " + token);
                next();
                return seq;
            case DIGIT:
                return readLoop();
            default:
                throw new ParseError(pos, loc.parse_errors.unexpected_token + " " + token);
        }
    }
}
}
