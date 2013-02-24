/**
 *
 * @author: Vasiliy
 * @date: 22.02.13
 */
package ru.ipo.kio._13.clock.model.level {
import flash.display.Sprite;


public class SilhouettesProductDrawer extends BasicProductDrawer{

    //картинки силуэтов
    [Embed(source='../../_resources/level0/people/0.png')]
    private static const PEOPLE0:Class;
    [Embed(source='../../_resources/level0/people/2.png')]
    private static const PEOPLE2:Class;
    [Embed(source='../../_resources/level0/people/3.png')]
    private static const PEOPLE3:Class;
    [Embed(source='../../_resources/level0/people/4.png')]
    private static const PEOPLE4:Class;
    [Embed(source='../../_resources/level0/people/5.png')]
    private static const PEOPLE5:Class;
    [Embed(source='../../_resources/level0/people/6.png')]
    private static const PEOPLE6:Class;
    [Embed(source='../../_resources/level0/people/7.png')]
    private static const PEOPLE7:Class;
    [Embed(source='../../_resources/level0/people/8.png')]
    private static const PEOPLE8:Class;
    [Embed(source='../../_resources/level0/people/9.png')]
    private static const PEOPLE9:Class;
    [Embed(source='../../_resources/level0/people/10.png')]
    private static const PEOPLE10:Class;
    [Embed(source='../../_resources/level0/people/11.png')]
    private static const PEOPLE11:Class;
    [Embed(source='../../_resources/level0/people/12.png')]
    private static const PEOPLE12:Class;
    [Embed(source='../../_resources/level0/people/13.png')]
    private static const PEOPLE13:Class;
    [Embed(source='../../_resources/level0/people/14.png')]
    private static const PEOPLE14:Class;
    [Embed(source='../../_resources/level0/people/15.png')]
    private static const PEOPLE15:Class;
    [Embed(source='../../_resources/level0/people/16.png')]
    private static const PEOPLE16:Class;
    [Embed(source='../../_resources/level0/people/17.png')]
    private static const PEOPLE17:Class;
    [Embed(source='../../_resources/level0/people/18.png')]
    private static const PEOPLE18:Class;
    [Embed(source='../../_resources/level0/people/19.png')]
    private static const PEOPLE19:Class;
    [Embed(source='../../_resources/level0/people/20.png')]
    private static const PEOPLE20:Class;
    [Embed(source='../../_resources/level0/people/21.png')]
    private static const PEOPLE21:Class;

    private var _people0:Sprite = new Sprite();
    private var _people2:Sprite = new Sprite();
    private var _people3:Sprite = new Sprite();
    private var _people4:Sprite = new Sprite();
    private var _people5:Sprite = new Sprite();
    private var _people6:Sprite = new Sprite();
    private var _people7:Sprite = new Sprite();
    private var _people8:Sprite = new Sprite();
    private var _people9:Sprite = new Sprite();
    private var _people10:Sprite = new Sprite();
    private var _people11:Sprite = new Sprite();
    private var _people12:Sprite = new Sprite();
    private var _people13:Sprite = new Sprite();
    private var _people14:Sprite = new Sprite();
    private var _people15:Sprite = new Sprite();
    private var _people16:Sprite = new Sprite();
    private var _people17:Sprite = new Sprite();
    private var _people18:Sprite = new Sprite();
    private var _people19:Sprite = new Sprite();
    private var _people20:Sprite = new Sprite();
    private var _people21:Sprite = new Sprite();


    protected var people:Array = [_people0,
        _people2,
        _people3,
        _people4,
        _people5,
        _people6,
        _people7,
        _people8,
        _people9,
        _people10,
        _people11,
        _people12,
        _people13,
        _people14,
        _people15,
        _people16,
        _people17,
        _people18,
        _people19,
        _people20,
        _people21 ];

    protected var lastPeople:Array = [];

    protected var lastAmountOfSilhouettes:int=0;

    public function SilhouettesProductDrawer() {
        _people0.addChild(new PEOPLE0);
        _people2.addChild(new PEOPLE2);
        _people3.addChild(new PEOPLE3);
        _people4.addChild(new PEOPLE4);
        _people5.addChild(new PEOPLE5);
        _people6.addChild(new PEOPLE6);
        _people7.addChild(new PEOPLE7);
        _people8.addChild(new PEOPLE8);
        _people9.addChild(new PEOPLE9);
        _people10.addChild(new PEOPLE10);
        _people11.addChild(new PEOPLE11);
        _people12.addChild(new PEOPLE12);
        _people13.addChild(new PEOPLE13);
        _people14.addChild(new PEOPLE14);
        _people15.addChild(new PEOPLE15);
        _people16.addChild(new PEOPLE16);
        _people17.addChild(new PEOPLE17);
        _people18.addChild(new PEOPLE18);
        _people19.addChild(new PEOPLE19);
        _people20.addChild(new PEOPLE20);
        _people21.addChild(new PEOPLE21);
        locateSilhouettes();
    }

    protected function addSilhouettes(amountOfSilhouettes:int):void {

        if(amountOfSilhouettes==lastAmountOfSilhouettes){
            for (var k:int = 0; k < lastPeople.length; k++) {
                productSprite.addChild(lastPeople[k]);
            }
        }else{
            lastAmountOfSilhouettes=amountOfSilhouettes;
            var temp:Array = [];
            for (var i:int = 0; i < people.length; i++) {
                temp.push(people[i]);
            }

            lastPeople = [];

            for (var j:int = amountOfSilhouettes; j > 0; j--) {
                var index:int = Math.random() * temp.length;
                var item:Sprite = temp.splice(index, 1)[0];
                if(item!=null){
                    productSprite.addChild(item);
                    lastPeople.push(item);
                }
            }
        }
    }


    private function locateSilhouettes():void {
        _people0.x = 635;
        _people0.y = 54;

        _people2.x = 15;
        _people2.y = 157;

        _people3.x = 10;
        _people3.y = 230;

        _people13.x = 142;
        _people13.y = 349;
        _people21.x = 563;
        _people21.y = 274;
        _people17.x = 138;
        _people17.y = 288;
        _people16.x = 174;
        _people16.y = 288;
        _people4.x = 10;
        _people4.y = 303;
        _people20.x = 477;
        _people20.y = 280;
        _people19.x = 477;
        _people19.y = 337;
        _people15.x = 166;
        _people15.y = 247;
        _people18.x = 209;
        _people18.y = 288;
        _people14.x = 174;
        _people14.y = 198;
        _people5.x = 80;
        _people5.y = 173;
        _people9.x = 90;
        _people9.y = 258;
        _people11.x = 100;
        _people11.y = 335;
        _people11.x = 100;
        _people11.y = 337;
        _people12.x = 100;
        _people12.y = 361;
        _people8.x = 90;
        _people8.y = 288;
        _people7.x = 102;
        _people7.y = 213;
        _people10.x = 95;
        _people10.y = 318;
        _people6.x = 78;
        _people6.y = 190;
    }

}
}
