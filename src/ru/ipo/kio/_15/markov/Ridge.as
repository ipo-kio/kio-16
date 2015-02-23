/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.display.Sprite;

public class Ridge extends BasicView{

    private var _tiles:Vector.<Tile> = new Vector.<Tile>();

    private var _select:Boolean=false;

    private var glass:Sprite;

    public function Ridge() {

    }

    public function get select():Boolean {
        return _select;
    }

    public function set select(value:Boolean):void {
        _select = value;
    }

    public function get tiles():Vector.<Tile> {
        return _tiles;
    }

    public function clearTiles():void {
        _tiles = new Vector.<Tile>();
    }

    public function addTile(code:String):void{
        tiles.push(new Tile(Symbol.getSymbol(code)));
    }

    public function clone():Ridge{
        var ridge = new Ridge();
        for each (var tile:Tile in _tiles) {
            ridge.addTile(tile.symbol.code);
        }
        return ridge;
    }

    public override function update():void{
        clear();
        glass=new Sprite();
        graphics.lineStyle(0,0xFFFFFF);
        glass.graphics.drawRect(0,0,SettingsManager.instance.ridgeWidth, SettingsManager.instance.ridgeHeight);
        var spaceY:int = (SettingsManager.instance.ridgeHeight - SettingsManager.instance.tileHeight)/2;
        var spaceX:int = SettingsManager.instance.ridgeWidth-SettingsManager.instance.tileAmount*(SettingsManager.instance.tileWidth+1);
        var shift:int = spaceX/2;
        var last:Tile = null;
        for each(var tile:Tile in _tiles){
            tile.update();
            addChildTo(tile, shift, spaceY);

            var mod:int = _tiles.indexOf(tile)%2;

            if(select && last!=null && last.symbol.code!=tile.symbol.code){
                glass.graphics.lineStyle(2,0x990033);
                if(mod==1) {
                    glass.graphics.drawRect(shift - SettingsManager.instance.tileWidth - 1, spaceY+5, (SettingsManager.instance.tileWidth + 2) * 2, SettingsManager.instance.tileHeight);
                }else{
                    glass.graphics.drawRect(shift - SettingsManager.instance.tileWidth - 1, spaceY-5, (SettingsManager.instance.tileWidth + 2) * 2, SettingsManager.instance.tileHeight);
                }
                    glass.graphics.lineStyle(0,0xFFFFFF);

            }

            shift+=SettingsManager.instance.tileWidth+1;
            last=tile;
        }
addChild(glass)


    }


    public function getString():String {
        var str:String="";
        for each(var tile:Tile in _tiles){
            str+=tile.symbol.code;
        }
        return str;
    }
}
}
