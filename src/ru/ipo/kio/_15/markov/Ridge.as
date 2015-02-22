/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.display.Sprite;

public class Ridge extends BasicView{

    private var _tiles:Vector.<Tile> = new Vector.<Tile>();

    public function Ridge() {

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
        graphics.lineStyle(0,0xFFFFFF);
        graphics.drawRect(0,0,SettingsManager.instance.ridgeWidth, SettingsManager.instance.ridgeHeight);
        var spaceY:int = (SettingsManager.instance.ridgeHeight - SettingsManager.instance.tileHeight)/2;
        var spaceX:int = SettingsManager.instance.ridgeWidth-SettingsManager.instance.tileAmount*(SettingsManager.instance.tileWidth+1);
        var shift:int = spaceX/2;
        for each(var tile:Tile in _tiles){
            tile.update();
            addChildTo(tile, shift, spaceY);
            shift+=SettingsManager.instance.tileWidth+1;
        }
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
