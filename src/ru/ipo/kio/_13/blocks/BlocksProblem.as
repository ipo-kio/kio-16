package ru.ipo.kio._13.blocks {

import flash.display.DisplayObject;

import ru.ipo.kio._13.blocks.model.BlocksField;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class BlocksProblem implements KioProblem {

    [Embed(source="loc/blocks.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;
    [Embed(source="loc/blocks.es.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_ES:Class;
    [Embed(source="loc/blocks.en.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_EN:Class;
    [Embed(source="loc/blocks.bg.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_BG:Class;
    [Embed(source="loc/blocks.th.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_TH:Class;

    public static const ID:String = "blocks";

    private var _workspace:BlocksWorkspace;

    private var _level:int;

    public function BlocksProblem(level:int) {
        _level = level;
        KioApi.initialize(this);
        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_ES, new Settings(LOCALIZATION_ES).data);
        KioApi.registerLocalization(ID, KioApi.L_EN, new Settings(LOCALIZATION_EN).data);
        KioApi.registerLocalization(ID, KioApi.L_BG, new Settings(LOCALIZATION_BG).data);
        KioApi.registerLocalization(ID, KioApi.L_TH, new Settings(LOCALIZATION_TH).data);
        _workspace = new BlocksWorkspace();
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2013;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return _workspace;
    }

    public function get solution():Object {
        var res:Object = {prg: _workspace.editor.editorField.text};
        if (level == 2) {
            var field:BlocksField = _workspace.blocksDebugger.initialField;
            res.field = field.save();
        }

        return res;
        //return {prg: BlocksWorkspace.instance.editor.editorField.text}; //TODO report can not introduce variable
    }

    public function loadSolution(solution:Object):Boolean {
        //для загрузки решения нужно взять поле txt и записать его в текстовое поле
        if ('prg' in solution) {
            _workspace.editor.editorField.text = solution.prg;

            if (level == 2) {
                var initialField:BlocksField = _workspace.blocksDebugger.initialField;
                initialField.load(solution.field);
                _workspace.blocksDebugger.initialField = initialField;
                _workspace.blocksSelector.field = initialField.clone();
            }

            if (_workspace.blocksDebugger.program != null) {
                _workspace.blocksDebugger.toEnd();
                _workspace.blocksDebugger.moveToStep(0);
            }

            //не забыть сохранить решение, как обычно после того как оно изменилось
            KioApi.instance(ID).autoSaveSolution();
            //Если текущий результат еще и показывается где-то на экране, его тоже надо пересчитать
            //TODO это все должно происходить автоматически

            return true;
        } else
            return false;
    }

    public function check(solution:Object):Object {
        loadSolution(solution);
        return {}; //TODO implement
    }

    public function compare(solution1:Object, solution2:Object):int {
        if (level == 0) {
            var res:int = solution1.in_place - solution2.in_place;
            if (res == 0)
                res = solution2.penalty - solution1.penalty;
            if (res == 0)
                res = solution2.steps - solution1.steps;
            return res;
        } else {
            res = solution1.in_place - solution2.in_place;
            if (res == 0)
                res = solution2.prg_len - solution1.prg_len;
            if (res == 0)
                res = solution2.steps - solution1.steps;
            return res;
        }
    }

    [Embed(source="resources/icon.png")]
    public static const ICON_CLS:Class;

    public function get icon():Class {
        return ICON_CLS;
    }

    [Embed(source="resources/help/Level_0-Help-2.jpg")]
    public static const HELP_0_CLS:Class;
    [Embed(source="resources/help/Level_1-Help-2.jpg")]
    public static const HELP_1_CLS:Class;
    [Embed(source="resources/help/Level_2-Help-2.jpg")]
    public static const HELP_2_CLS:Class;
    [Embed(source="resources/help/Level_0-Statement-2.jpg")]
    public static const STATEMENT_0_CLS:Class;
    [Embed(source="resources/help/Level_1-Statement-2.jpg")]
    public static const STATEMENT_1_CLS:Class;
    [Embed(source="resources/help/Level_2-Statement-2.jpg")]
    public static const STATEMENT_2_CLS:Class;

    public function get icon_help():Class {
        switch (level) {
            case 0:
                return HELP_0_CLS;
            case 1:
                return HELP_1_CLS;
            case 2:
                return HELP_2_CLS;
        }
        return null;
    }

    public function get icon_statement():Class {
        switch (level) {
            case 0:
                return STATEMENT_0_CLS;
            case 1:
                return STATEMENT_1_CLS;
            case 2:
                return STATEMENT_2_CLS;
        }
        return null;
    }

    public function get best():Object {
        return null;
    }
}
}