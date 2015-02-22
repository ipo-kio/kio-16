/**
 * Created by Vasiliy on 17.02.2015.
 */
package ru.ipo.kio._15.markov {
public class Placeholder extends BasicView{
    public function Placeholder() {
    }

    public override function update():void {
        clear();

        var width:int = SettingsManager.instance.tileWidth;
        var height:int = SettingsManager.instance.tileHeight;


        graphics.lineStyle(1,0xCCCCCC);
        graphics.drawRect(0,0,width,height);
        graphics.endFill();

    }
}
}
