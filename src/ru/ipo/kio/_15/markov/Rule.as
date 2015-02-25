/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

public class Rule extends BasicView{

    /**
     * Номер правила
     */
    private var _number:int=0;

    /**
     * Входные элементы
     */
    private var _input:Vector.<MovingTile> = new Vector.<MovingTile>();

    /**
     * Выходные элементы
     */
    private var _output:Vector.<MovingTile> = new Vector.<MovingTile>();

    /**
     * Кнопка удаления правила
     */
    private var _deleteButton:SimpleButton;

   private var _select:Boolean=false;
    private var oldTemp:MovingTile;


    public function get select():Boolean {
        return _select;
    }

    public function set select(value:Boolean):void {
        _select = value;
    }

    public function Rule(number:int) {
        this._number = number;
    }


    public function get number():int {
        return _number;
    }

    public function get input():Vector.<MovingTile> {
        return _input;
    }

    public function get output():Vector.<MovingTile> {
        return _output;
    }


    private function removeFictive(list:Vector.<MovingTile>):void {
        for each(var tile: MovingTile  in list){
            if(tile.fictive){
                list.splice(list.indexOf(tile), 1);
            }
        }
    }

    public override function update():void{

        rebuildTiles();
        draw();
    }

    public function draw():void {
        clear();

        var shiftX:int = 20;

        for each(var tile:MovingTile  in input) {
            tile.update();
            addChildTo(tile, shiftX, 0);
            shiftX += SettingsManager.instance.tileWidth + 1;
        }

        shiftX += 20;
        addChildTo(createField("заменить на", 16), shiftX, (SettingsManager.instance.tileHeight - 16) / 2);
        shiftX += 105;

        for each(var tile:MovingTile  in output) {
            tile.update();
            addChildTo(tile, shiftX, 0);
            shiftX += SettingsManager.instance.tileWidth + 1;
        }


        addChildTo(createField(number + "", 20), 0, (SettingsManager.instance.tileHeight - 20) / 2);

        _deleteButton = ImageHolder.createButton(this, "X", Math.max(SettingsManager.instance.ruleWidth - 40, shiftX), 5, function () {
            RuleManager.instance.rules.splice(RuleManager.instance.rules.indexOf(this), 1);
            RuleManager.instance.update();
        }, RuleManager.instance.level == 2 ? RuleManager.instance.api.localization.button.delete_rule : RuleManager.instance.api.localization.button.delete_direction);


        NormalButton(_deleteButton).enable( RuleManager.instance.edit);



        if (select) {
            graphics.beginFill(0x0083C4, 0.35);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
        }
        if (!valid) {
            graphics.beginFill(0xFF3C53, 0.3);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
        }
    }

    public function rebuildTiles():void {
        clearTemp();

        if (hasEmpty(input) && hasEmpty(output)) {
            removeFictive(input);
            removeFictive(output);
        }


        if (input.length == 0 && output.length == 0) {
            input.push(new MovingTile(null, null, true));
            output.push(new MovingTile(null, null, true));
        }

        if(input.length>output.length && hasEmpty(input)){
            removeFictive(input);
        }

        if(output.length>input.length && hasEmpty(output)){
            removeFictive(output);
        }

        if(RuleManager.instance.level==0) {
            if(hasEmpty(input)){
                removeFictive(input);
            }

            if(hasEmpty(output)){
                removeFictive(output);
            }
        }


        if(RuleManager.instance.level==0) {
            for (var i = 0; i < input.length - output.length; i++) {
                output.push(new MovingTile(null, null, true));
            }

            for (var i = 0; i < output.length - input.length; i++) {
                input.push(new MovingTile(null, null, true));
            }
        }

        if (input.length == 0 && output.length == 0) {
            input.push(new MovingTile(null, null, true));
            output.push(new MovingTile(null, null, true));
        }



    }

    private function notFictive(list:Vector.<MovingTile>):int {
        var sum:int=0;
        for each(var tile:MovingTile  in list) {
            if (!tile.fictive) {
                sum++;
            }
        }
        return sum;
    }



    public function set number(number:int):void {
        _number = number;
    }

    public function consumeMove(ntile:MovingTile, x:Number, y:Number):Boolean {
        return consumeList(input, ntile, x,y, true) || consumeList(output, ntile, x,y, true);
    }

    public function consume(ntile:MovingTile, x:int, y:int):Boolean {
        return consumeList(input, ntile, x,y) || consumeList(output, ntile, x,y);
    }

    private function consumeList(list:Vector.<MovingTile>, ntile:MovingTile, x:int, y:int, move:Boolean=false):Boolean{
        if(RuleManager.instance.level==0 && list.length>=3 && !hasFictive(list)){
            return false;
        }else {
            if(ntile.symbol.code=="X" || ntile.symbol.code=="x"){
                if(list!=output || list.length!=1 || !list[0].fictive || isStart()){
                    return false;
                }
            }

            if(ntile.symbol.code=="S" || ntile.symbol.code=="s"){
                if(list!=input || list.length!=1 || !list[0].fictive || isFinish()){
                    return false;
                }
            }

            if(list==input && isStart()){
                return false;
            }

            if(list==output && isFinish()){
                return false;
            }

            for each(var tile:MovingTile  in list) {
                if (tile.fictive && ntile.rule==null) {
                    if (x > tile.x && x < tile.x + tile.width &&
                            y > tile.y && y < tile.y + tile.height) {
                        if(!move) {
                            var t:MovingTile = new MovingTile(ntile.symbol, this);
                            list.splice(list.indexOf(tile), 1, t);
                        }else{
                            if(tile.temp){{
                                return true;
                            }}
                            removeOldTemp();
                        }
                        return true;
                    }
                    continue;
                }

                if (x > (list.indexOf(tile)==0?tile.x-30:tile.x) && x < tile.x + tile.width / 2 &&
                        y >= tile.y && y < tile.y + tile.height) {
                    if(!move) {
                        if(ntile.rule!=null && list.indexOf(ntile)<0){
                            return false;
                        }
                        var t:MovingTile = new MovingTile(ntile.symbol, this);
                        list.splice(list.indexOf(tile), 0, t);
                        if(ntile.rule!=null){
                            list.splice(list.indexOf(ntile), 1);
                        }
                    }else{
                        var temp:MovingTile = new MovingTile(ntile.symbol, this, true, true);
                        var ind:int = list.indexOf(tile);
                        if(!tile.fictive && (ind-1<0 || !list[ind-1].fictive)) {
                            list.splice(list.indexOf(tile), 0, temp);
                            removeOldTemp();
                            oldTemp = temp;

                        }
                    }
                    return true;
                }
                if (x > tile.x + tile.width / 2 && x < tile.x + tile.width+(list.indexOf(tile)==list.length-1?30:0) &&
                        y >= tile.y && y < tile.y + tile.height) {
                    if(!move) {
                        if(ntile.rule!=null && list.indexOf(ntile)<0){
                            return false;
                        }
                        var t:MovingTile = new MovingTile(ntile.symbol, this);
                        list.splice(list.indexOf(tile) + 1, 0, t);
                        if(ntile.rule!=null){
                            list.splice(list.indexOf(ntile), 1);
                        }
                    }else{
                        var temp:MovingTile = new MovingTile(ntile.symbol, this, true, true);
                        var ind:int = list.indexOf(tile);
                        if(!tile.fictive && (ind+1>=list.length || !list[ind+1].fictive)) {
                            list.splice(list.indexOf(tile) + 1, 0, temp);
                            removeOldTemp();
                            oldTemp = temp;
                        }
                    }
                    return true;
                }
            }
        }
return false;
    }

    private function removeOldTemp():void {
        if (oldTemp != null && input.indexOf(oldTemp) >= 0) {
            input.splice(input.indexOf(oldTemp), 1);
        }
        if (oldTemp != null && output.indexOf(oldTemp) >= 0) {
            output.splice(output.indexOf(oldTemp), 1);
        }
    }

    public function putOpposite(t:MovingTile, ntile:MovingTile):void {
        if (input.indexOf(t) >= 0) {
            if (hasEmpty(output)) {
                for each(var ttt:MovingTile  in output) {
                    if (ttt.fictive) {
                        output.splice(output.indexOf(ttt), 1, new MovingTile(ntile.symbol, this));
                        break;
                    }
                }
            } else {
                output.push(new MovingTile(ntile.symbol, this))
            }
        } else {
            if (hasEmpty(input)) {
                for each(var ttt:MovingTile  in input) {
                    if (ttt.fictive) {
                        input.splice(input.indexOf(ttt), 1, new MovingTile(ntile.symbol, this));
                        break;
                    }
                }
            } else {
                input.push(new MovingTile(ntile.symbol, this))
            }
        }
    }

    private function checkSet(fulled:Vector.<MovingTile>, empty:Vector.<MovingTile>, ntile:MovingTile):Boolean {
        var fYell:int = 0;
        var fBlack:int = 0;
        var sYell:int = 0;
        var sBlack:int = 0;
        var fEmpty:int=0;
        var sEmpty:int=0;
        for each(var tile in fulled){
            if(!tile.fictive){
                if(tile.symbol.code=="o"){
                    fYell++;
                }
                else if(tile.symbol.code=="a"){
                    fBlack++;
                }
            }else{
                fEmpty++;
            }
        }

        for each(var tile in empty){
            if(!tile.fictive){
                if(tile.symbol.code=="o"){
                    sYell++;
                }
                else if(tile.symbol.code=="a"){
                    sBlack++;
                }
            }else{
                sEmpty++;
            }
        }

        if(ntile.symbol.code=="o"){
            sYell++;
        }
        else if(ntile.symbol.code=="a"){
            sBlack++;
        }

        return (fEmpty==1 && sEmpty==1) ||(fYell>=sYell && fBlack>=sBlack);

    }

    public function remove(tile:MovingTile):void {
        if(_input.indexOf(tile)>=0){
            if(RuleManager.instance.level==0) {
                _input.splice(_input.indexOf(tile), 1, new MovingTile(null, null, true));
            }else{
                _input.splice(_input.indexOf(tile), 1);
                if(_input.length==0){
                    input.push(new MovingTile(null, null, true));
                }
            }

        }

        if(_output.indexOf(tile)>=0){
            if(RuleManager.instance.level==0) {
                _output.splice(_output.indexOf(tile), 1, new MovingTile(null, null, true));
            }else{
                _output.splice(_output.indexOf(tile), 1);
                if(_output.length==0){
                    output.push(new MovingTile(null, null, true));
                }
            }
        }
    }

    public function preremove(tile:MovingTile):void {
        if(_input.indexOf(tile)>=0){
            _input.splice(_input.indexOf(tile),1, new MovingTile(null, null, true));
        }

        if(_output.indexOf(tile)>=0){
            _output.splice(_output.indexOf(tile),1, new MovingTile(null, null, true));
        }
    }

    private function removeOpposite(list:Vector.<MovingTile>, symbol:Symbol):void {
        for each(var tile:MovingTile in list){
            if(tile.symbol==symbol){
                list.splice(list.indexOf(tile),1);
                return;
            }
        }
    }

    public function isStart():Boolean{
        return input.length==1 && !input[0].fictive && (input[0].symbol.code=="S" || input[0].symbol.code=="s");
    }

    public function isFinish():Boolean{
        return output.length==1  && !output[0].fictive  && (output[0].symbol.code=="X" || output[0].symbol.code=="x");
    }

    public function getStringInput():String {
        var str:String="";
        for each(var tile:Tile in _input){
            str+=tile.symbol.code;
        }
        return str;
    }

    public function getStringOutput():String {
        var str:String="";
        for each(var tile:Tile in _output){
            str+=tile.symbol.code;
        }
        return str;
    }

    public function load(code:String):void{
       var index:int = code.indexOf(":");
       var first:String = code.substr(0,index);
       var second:String = code.substr(index+1);
        for(var i:int=0; i<first.length; i++){
            if(first.charAt(i)!="_"){
                input.push(new MovingTile(Symbol.getSymbol(first.charAt(i)), this));
            }else{
                input.push(new MovingTile(null, null, true));
            }
        }
        for(var i:int=0; i<second.length; i++){
            if(second.charAt(i)!="_"){
                output.push(new MovingTile(Symbol.getSymbol(second.charAt(i)), this));
            }else{
                output.push(new MovingTile(null, null, true));
            }
        }

    }


    public function toCode():String {
        var result:String = "";
        for each(var tile: MovingTile  in _input){
            if(tile.fictive){
                result+="_";
            }else{
                result+=tile.symbol.code;
            }
        }
        result+=":";
        for each(var tile: MovingTile  in _output){
            if(tile.fictive){
                result+="_";
            }else{
                result+=tile.symbol.code;
            }
        }
        return result;
    }

    public function get deleteButton(): SimpleButton{
        return _deleteButton;
    }

    /**
     * Правило корректно
     * Либо пустое, либо все заполнено
     */
    public function get valid():Boolean {
        return empty ||  (!hasEmpty(_input) && !hasEmpty(_output));
    }

    /**
     * Правило пусто
     */
    public function get empty():Boolean {
        return emptyList(_input) && emptyList(_output);
    }

    private function hasFictive(list:Vector.<MovingTile>):Boolean{
        for each(var tile: MovingTile  in list){
            if(tile.fictive){
                return true;
            }
        }
        return false;
    }

    /**
     * В списке есть местодержатели
     * @param list
     * @return
     */
    private function hasEmpty(list:Vector.<MovingTile>):Boolean{
        for each(var tile: MovingTile  in list){
            if(tile.fictive && !tile.temp){
                return true;
            }
        }
        return false;
    }

    /**
     * В списке все пустые - "местодержатели"
     * @param list
     * @return
     */
    private function emptyList(list:Vector.<MovingTile>):Boolean {
        for each(var tile: MovingTile  in list){
            if(!tile.fictive){
                return false;
            }
        }
        return true;
    }

    public function removeAllTemp():void{
        removeTemp(input);
        removeTemp(output);
    }

    private function removeTemp(list:Vector.<MovingTile>):Boolean {
        for each(var tile: MovingTile  in list){
            if(tile.fictive && tile.temp){
                var index:int =  list.indexOf(tile);
                list.splice(index,1);
            }
        }
        return true;
    }


    public function clearTemp():void {
        removeTemp(_input);
        removeTemp(_output);
    }


    public function getLength():int {
        return notFictive(input)+notFictive(output);
    }
}
}
