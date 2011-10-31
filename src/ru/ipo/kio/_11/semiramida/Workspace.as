package ru.ipo.kio._11.semiramida {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.controls.GraphicsButton;

public class Workspace extends Sprite {

    private var _house:House;

    private var currentResults:ResultsPanel;
    private var recordResults:ResultsPanel;

    [Embed(source='resources/BOSANO_7.TTF', embedAsCFF = "false", fontName="KioBosano", mimeType="application/x-font-truetype", unicodeRange = "U+0000-U+FFFF")]
    private static const GARDEN_FONT:Class;

    [Embed(source='resources/buttons/top1.png')]
    private static const BT_TOP_1:Class;
    [Embed(source='resources/buttons/top2.png')]
    private static const BT_TOP_2:Class;
    [Embed(source='resources/buttons/top3.png')]
    private static const BT_TOP_3:Class;

    [Embed(source='resources/buttons/bottom1.png')]
    private static const BT_BOTTOM_1:Class;
    [Embed(source='resources/buttons/bottom2.png')]
    private static const BT_BOTTOM_2:Class;
    [Embed(source='resources/buttons/bottom3.png')]
    private static const BT_BOTTOM_3:Class;

    [Embed(source='resources/buttons/up1.png')]
    private static const BT_UP_1:Class;
    [Embed(source='resources/buttons/up2.png')]
    private static const BT_UP_2:Class;
    [Embed(source='resources/buttons/up3.png')]
    private static const BT_UP_3:Class;

    [Embed(source='resources/buttons/down1.png')]
    private static const BT_DOWN_1:Class;
    [Embed(source='resources/buttons/down2.png')]
    private static const BT_DOWN_2:Class;
    [Embed(source='resources/buttons/down3.png')]
    private static const BT_DOWN_3:Class;

    [Embed(source='resources/buttons/left1.png')]
    private static const BT_LEFT_1:Class;
    [Embed(source='resources/buttons/left2.png')]
    private static const BT_LEFT_2:Class;
    [Embed(source='resources/buttons/left3.png')]
    private static const BT_LEFT_3:Class;

    [Embed(source='resources/buttons/right1.png')]
    private static const BT_RIGHT_1:Class;
    [Embed(source='resources/buttons/right2.png')]
    private static const BT_RIGHT_2:Class;
    [Embed(source='resources/buttons/right3.png')]
    private static const BT_RIGHT_3:Class;

    public function Workspace() {
        var api:KioApi = KioApi.instance(SemiramidaProblem.ID);

        //add background
        /*var m:Matrix = Resources.Bg.transform.matrix;
         m.scale(
         GlobalMetrics.WORKSPACE_WIDTH / Resources.Bg.bitmapData.width,
         GlobalMetrics.WORKSPACE_HEIGHT / Resources.Bg.bitmapData.height
         );
         Resources.Bg.transform.matrix = m;*/
        addChild(Resources.Bg);

        //scale flowers
        /*m = Resources.Flowers.transform.matrix;
         m.scale(
         700 / Resources.Flowers.bitmapData.width,
         450 / Resources.Flowers.bitmapData.height
         );
         Resources.Flowers.transform.matrix = m;*/

        //add _house
        _house = new House(677, 437);
        _house.x = 53;
        _house.y = 10 + 1;
        addChild(_house);

        //add buttons
        var createPipeButton:GraphicsButton = new GraphicsButton(
                api.localization.buttons.create_pipe,
                new BT_TOP_1().bitmapData,
                new BT_TOP_3().bitmapData,
                new BT_TOP_2().bitmapData,
                "KioBosano",
                16, 16
                );
        createPipeButton.x = 77;
        createPipeButton.y = 481;
        createPipeButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
            _house.createPipe();
            _house.refreshRooms();
        });
        addChild(createPipeButton);

        var removePipeButton:GraphicsButton = new GraphicsButton(
                api.localization.buttons.remove_pipe,
                new BT_TOP_1().bitmapData,
                new BT_TOP_3().bitmapData,
                new BT_TOP_2().bitmapData,
                "KioBosano",
                16, 16
                );
        removePipeButton.x = 77;
        removePipeButton.y = 523;
        removePipeButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
            _house.removePipe();
            _house.refreshRooms();
        });
        addChild(removePipeButton);

        var movePipeLeftButton:GraphicsButton = new GraphicsButton(
                '',
                new BT_LEFT_1().bitmapData,
                new BT_LEFT_3().bitmapData,
                new BT_LEFT_2().bitmapData,
                "KioBosano",
                16, 16
                );
        movePipeLeftButton.x = 230;
        movePipeLeftButton.y = 497;
        movePipeLeftButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
            _house.movePipe(-1);
        });
        addChild(movePipeLeftButton);

        var movePipeRightButton:GraphicsButton = new GraphicsButton(
                '',
                new BT_RIGHT_1().bitmapData,
                new BT_RIGHT_3().bitmapData,
                new BT_RIGHT_2().bitmapData,
                "KioBosano",
                16, 16
                );
        movePipeRightButton.x = 330;
        movePipeRightButton.y = 497;
        movePipeRightButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
            _house.movePipe(1);
        });
        addChild(movePipeRightButton);

        var movePipeUpButton:GraphicsButton = new GraphicsButton(
                '',
                new BT_UP_1().bitmapData,
                new BT_UP_3().bitmapData,
                new BT_UP_2().bitmapData,
                "KioBosano",
                16, 16
                );
        movePipeUpButton.x = 280;
        movePipeUpButton.y = 470;
        movePipeUpButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
            _house.changePipeLength(1);
        });
        addChild(movePipeUpButton);

        var movePipeDownButton:GraphicsButton = new GraphicsButton(
                '',
                new BT_DOWN_1().bitmapData,
                new BT_DOWN_3().bitmapData,
                new BT_DOWN_2().bitmapData,
                "KioBosano",
                16, 16
                );
        movePipeDownButton.x = 280;
        movePipeDownButton.y = 520;
        movePipeDownButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
            _house.changePipeLength(-1);
        });
        addChild(movePipeDownButton);

        currentResults = new ResultsPanel(api.localization.results.current, 200);
        recordResults = new ResultsPanel(api.localization.results.record, 200);

        currentResults.x = 380;
        currentResults.y = 472;
        addChild(currentResults);

        recordResults.x = 560;
        recordResults.y = 472;
        addChild(recordResults);

        //extra
//        var switchTimer:TextButton = new TextButton("Анимация");
//        switchTimer.x = 530;
//        switchTimer.y = 560;
//        switchTimer.addEventListener(MouseEvent.CLICK, function(event:Event):void {
        _house.switchWaterTimer();
//        });
//        addChild(switchTimer);

//        addEventListener(Event.ADDED_TO_STAGE, addedToStage);
//        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
    }

    /*private function addedToStage(event:Event):void {
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpOnWorkspace);
    }

    private function removedFromStage(event:Event):void {
        stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpOnWorkspace);
    }

    private function mouseUpOnWorkspace(event:Event):void {
        var api:KioApi = KioApi.instance(SemiramidaProblem.ID);
        SemiramidaProblem(api.problem).submitSolution(house.roomsCount, house.pipesLength);

        api.autoSaveSolution();
    }*/

    public function get house():House {
        return _house;
    }

    public function updateResults(isRecord:Boolean, rooms:int, pipesLength:int):void {
        var rp:ResultsPanel = isRecord ? recordResults : currentResults;

        rp.rooms = rooms;
        rp.pipesLength = pipesLength;
    }

}
}