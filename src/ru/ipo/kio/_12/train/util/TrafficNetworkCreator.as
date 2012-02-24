/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.util {
import flash.events.Event;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.text.TextField;

import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.RailConnector;

import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.Train;
import ru.ipo.kio._12.train.model.TrainStation;
import ru.ipo.kio._12.train.model.types.RailConnectorType;
import ru.ipo.kio._12.train.model.types.RailStationType;
import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.view.CrossConnectorView;

public class TrafficNetworkCreator {

    private static var _instance:TrafficNetworkCreator;

    private var _result:TextField;

    private var trafficNetwork:TrafficNetwork;

    public function TrafficNetworkCreator(privateClass:PrivateClass) {
    }

    public static function get instance():TrafficNetworkCreator {
        if(TrafficNetworkCreator._instance == null)
            TrafficNetworkCreator._instance=new TrafficNetworkCreator(new PrivateClass( ));
        return _instance;
    }

    public function createTrafficNetwork(level:int):TrafficNetwork{
        trafficNetwork = TrafficNetwork.instance;
        trafficNetwork.level=level;
        if(level == 1){
            generateFirstLevel();
        }
        trafficNetwork.timeOfStep=1000;
        trafficNetwork.view.update();
        return trafficNetwork;
    }


    private function generateFirstLevel():void {
        trafficNetwork.railLength = 33;
        trafficNetwork.railWidth = 42;
        trafficNetwork.railSpace = 21;
        trafficNetwork.passengerSize = 3;
        trafficNetwork.passengerSpace = 2;
        trafficNetwork.maxPassengers=4;
        var size:int = 5;
        var initX:int = 130+133;
        var initY:int = 115
        generateGrid(size, initX, initY);

        generateTopSemiRound(size, RailStationType.FIRST, 0);
        generateBottomSemiRound(size, RailStationType.THIRD, 1);
        generateLeftSemiRound(size, RailStationType.FOURTH, 1);
        generateRightSemiRound(size, RailStationType.SECOND, 0);

        var firstRowRailFirst:Rail = trafficNetwork.getRail(0);
        var firstRowRailLast:Rail = trafficNetwork.getRail(size-1);
        var lastRowRailFirst:Rail = trafficNetwork.getRail(size*size);
        var lastRowRailLast:Rail = trafficNetwork.getRail(size*(size+1)-1);
        var firstColumnRailFirst:Rail = trafficNetwork.getRail(size*(size+1));
        var firstColumnRailLast:Rail = trafficNetwork.getRail(size*(size+1)+size-1);
        var lastColumnRailFirst:Rail = trafficNetwork.getRail(2*size*(size+1)-size);
        var lastColumnRailLast:Rail = trafficNetwork.getRail(2*(size+1)*size-1);

        var initRail1:Rail = generateTopLeftRound(firstRowRailFirst, firstColumnRailFirst);
        var initRail2:Rail = generateTopRightRound(firstRowRailLast, lastColumnRailFirst);
        var initRail4:Rail = generateBottomLeftRound(lastRowRailFirst, firstColumnRailLast);
        var initRail3:Rail = generateBottomRightRound(lastRowRailLast, lastColumnRailLast);

        addConnectorViews(size);

        addTrain(0xb0d01b, initRail4, RailStationType.FOURTH);
        addTrain(0xdf86701, initRail3, RailStationType.THIRD);
        addTrain(0x88b7ff, initRail1, RailStationType.FIRST);
        addTrain(0xffc21b, initRail2, RailStationType.SECOND);
    }
    
    private function addTrain(color:int, initRail:Rail, type:RailStationType){
        var train1:Train = new Train(type);
        train1.rail = initRail;
        train1.color = color;
        train1.route.addRail(initRail);
        trafficNetwork.trains.push(train1);
        trafficNetwork.view.addChild(train1.view);
    }

    private function addConnectorViews(size:int):void {
        for (var i:int = 0; i < size + 1; i++) {
            for (var j:int = 0; j < size; j++) {
                var index:int = j+i*size;
                var rail:Rail = trafficNetwork.getRail(index);
                if(j == 0){
                    var view:CrossConnectorView = new CrossConnectorView();
                    view.x = rail.firstEnd.point.x - trafficNetwork.railSpace*2;
                    view.y = rail.firstEnd.point.y - trafficNetwork.railSpace;
                    trafficNetwork.view.addChild(view);
                    var connectors:Vector.<RailConnector> =  rail.firstEnd.getAllNearConnectors();
                    trafficNetwork.connectorViews.push(view);
                    for(var k:int = 0; k<connectors.length; k++){
                        connectors[k].view = view;
                        view.connectors.push(connectors[k]);
                    }
                }
                var view:CrossConnectorView = new CrossConnectorView();
                view.x = rail.secondEnd.point.x;
                view.y = rail.secondEnd.point.y - trafficNetwork.railSpace;
                trafficNetwork.view.addChild(view);
                var connectors:Vector.<RailConnector> =  rail.secondEnd.getAllNearConnectors();
                trafficNetwork.connectorViews.push(view);
                for(var k:int = 0; k<connectors.length; k++){
                    connectors[k].view = view;
                    view.connectors.push(connectors[k]);
                }
            }
        }
    }


    private function generateBottomRightRound(lastRowRailLast:Rail, lastColumnRailLast:Rail, stationType:RailStationType=null):Rail {
        var bottomRightRail:Rail = stationType!=null?
                new TrainStation(stationType, trafficNetwork, RailType.ROUND_BOTTOM_RIGHT,
                new Point(lastRowRailLast.secondEnd.point.x + 2 * trafficNetwork.railSpace, lastRowRailLast.secondEnd.point.y + trafficNetwork.railSpace),
                new Point(lastRowRailLast.secondEnd.point.x + trafficNetwork.railSpace, lastRowRailLast.secondEnd.point.y + trafficNetwork.railSpace))
                :new Rail(trafficNetwork, RailType.ROUND_BOTTOM_RIGHT,
                new Point(lastRowRailLast.secondEnd.point.x + 2 * trafficNetwork.railSpace, lastRowRailLast.secondEnd.point.y + trafficNetwork.railSpace),
                new Point(lastRowRailLast.secondEnd.point.x + trafficNetwork.railSpace, lastRowRailLast.secondEnd.point.y + trafficNetwork.railSpace));
        trafficNetwork.addRail(bottomRightRail);

        new RailConnector(RailConnectorType.TOP_RIGHT, lastRowRailLast.secondEnd, bottomRightRail.secondEnd);
        new RailConnector(RailConnectorType.BOTTOM_LEFT, lastColumnRailLast.secondEnd, bottomRightRail.firstEnd);

        new RailConnector(RailConnectorType.HORIZONTAL, lastRowRailLast.secondEnd, bottomRightRail.firstEnd);
        new RailConnector(RailConnectorType.VERTICAL, lastColumnRailLast.secondEnd, bottomRightRail.secondEnd);

        new RailConnector(RailConnectorType.TOP_LEFT, bottomRightRail.firstEnd, bottomRightRail.secondEnd);

        return bottomRightRail;
    }

    private function generateBottomLeftRound(lastRowRailFirst:Rail, firstColumnRailLast:Rail):Rail {
        var bottomLeftRail:Rail = new Rail(trafficNetwork, RailType.ROUND_BOTTOM_LEFT,
                new Point(lastRowRailFirst.firstEnd.point.x - trafficNetwork.railSpace, lastRowRailFirst.firstEnd.point.y + trafficNetwork.railSpace),
                new Point(lastRowRailFirst.firstEnd.point.x - 2 * trafficNetwork.railSpace, lastRowRailFirst.firstEnd.point.y));
        trafficNetwork.addRail(bottomLeftRail);

        new RailConnector(RailConnectorType.BOTTOM_RIGHT, firstColumnRailLast.secondEnd, bottomLeftRail.secondEnd);
        new RailConnector(RailConnectorType.TOP_LEFT, lastRowRailFirst.firstEnd, bottomLeftRail.firstEnd);

        new RailConnector(RailConnectorType.HORIZONTAL, lastRowRailFirst.firstEnd, bottomLeftRail.secondEnd);
        new RailConnector(RailConnectorType.VERTICAL, firstColumnRailLast.secondEnd, bottomLeftRail.firstEnd);

        new RailConnector(RailConnectorType.TOP_RIGHT, bottomLeftRail.firstEnd, bottomLeftRail.secondEnd);

        return bottomLeftRail;
    }

    private function generateTopRightRound(firstRowRailLast:Rail, lastColumnRailFirst:Rail):Rail {
        var topRightRail:Rail = new Rail(trafficNetwork, RailType.ROUND_TOP_RIGHT,
                new Point(firstRowRailLast.secondEnd.point.x + 1 * trafficNetwork.railSpace, firstRowRailLast.secondEnd.point.y - trafficNetwork.railSpace),
                new Point(firstRowRailLast.secondEnd.point.x + 2 * trafficNetwork.railSpace, firstRowRailLast.secondEnd.point.y));
        trafficNetwork.addRail(topRightRail);

        new RailConnector(RailConnectorType.BOTTOM_RIGHT, firstRowRailLast.secondEnd, topRightRail.firstEnd);
        new RailConnector(RailConnectorType.TOP_LEFT, lastColumnRailFirst.firstEnd, topRightRail.secondEnd);

        new RailConnector(RailConnectorType.HORIZONTAL, firstRowRailLast.secondEnd, topRightRail.secondEnd);
        new RailConnector(RailConnectorType.VERTICAL, lastColumnRailFirst.firstEnd, topRightRail.firstEnd);

        new RailConnector(RailConnectorType.BOTTOM_LEFT, topRightRail.firstEnd, topRightRail.secondEnd);

        return topRightRail;
    }

    private function generateTopLeftRound(firstRowRailFirst:Rail, firstColumnRailFirst:Rail, stationType:RailStationType=null):Rail {
        var topLeftRail:Rail = stationType!=null?
                new TrainStation(stationType, trafficNetwork, RailType.ROUND_TOP_LEFT,
                new Point(firstRowRailFirst.firstEnd.point.x - 2 * trafficNetwork.railSpace, firstRowRailFirst.firstEnd.point.y),
                new Point(firstRowRailFirst.firstEnd.point.x - trafficNetwork.railSpace, firstRowRailFirst.firstEnd.point.y - trafficNetwork.railSpace)):
                new Rail(trafficNetwork, RailType.ROUND_TOP_LEFT,
                new Point(firstRowRailFirst.firstEnd.point.x - 2 * trafficNetwork.railSpace, firstRowRailFirst.firstEnd.point.y),
                new Point(firstRowRailFirst.firstEnd.point.x - trafficNetwork.railSpace, firstRowRailFirst.firstEnd.point.y - trafficNetwork.railSpace));
        trafficNetwork.addRail(topLeftRail);

        new RailConnector(RailConnectorType.BOTTOM_LEFT, firstRowRailFirst.firstEnd, topLeftRail.secondEnd);
        new RailConnector(RailConnectorType.TOP_RIGHT, firstColumnRailFirst.firstEnd, topLeftRail.firstEnd);
        new RailConnector(RailConnectorType.HORIZONTAL, firstRowRailFirst.firstEnd, topLeftRail.firstEnd);
        new RailConnector(RailConnectorType.VERTICAL, firstColumnRailFirst.firstEnd, topLeftRail.secondEnd);
        new RailConnector(RailConnectorType.BOTTOM_RIGHT, topLeftRail.firstEnd, topLeftRail.secondEnd);
        return topLeftRail;
    }

    private function generateRightSemiRound(size:int, stationType:RailStationType=null, stationIndex:int=0):void {
       
        for (var i:int = size*(size+1)*2-size+1, c:int = 0; i < size*(size+1)*2; i += 2, c++) {
            var rail:Rail = trafficNetwork.getRail(i);
            var railRight:Rail = stationType!=null && stationIndex == c?
                    new TrainStation(stationType, trafficNetwork, RailType.SEMI_ROUND_RIGHT,
                    new Point(rail.firstEnd.point.x + trafficNetwork.railSpace, rail.firstEnd.point.y - trafficNetwork.railSpace),
                    new Point(rail.secondEnd.point.x + trafficNetwork.railSpace, rail.secondEnd.point.y + trafficNetwork.railSpace)):                    
                    addPassengers(new Rail(trafficNetwork, RailType.SEMI_ROUND_RIGHT,
                    new Point(rail.firstEnd.point.x + trafficNetwork.railSpace, rail.firstEnd.point.y - trafficNetwork.railSpace),
                    new Point(rail.secondEnd.point.x + trafficNetwork.railSpace, rail.secondEnd.point.y + trafficNetwork.railSpace)));
            trafficNetwork.addRail(railRight);
            new RailConnector(RailConnectorType.BOTTOM_LEFT, trafficNetwork.getRail(i - 1).secondEnd, railRight.firstEnd);
            new RailConnector(RailConnectorType.TOP_LEFT, railRight.secondEnd, trafficNetwork.getRail(i + 1).firstEnd);

            new RailConnector(RailConnectorType.TOP_LEFT, railRight.firstEnd, rail.firstEnd);
            new RailConnector(RailConnectorType.BOTTOM_LEFT, railRight.secondEnd, rail.secondEnd);

            new RailConnector(RailConnectorType.HORIZONTAL, railRight.firstEnd, trafficNetwork.getRail(size * (1 + i-(size*(size+1)*2-size))-1).secondEnd);
            new RailConnector(RailConnectorType.HORIZONTAL, railRight.secondEnd, trafficNetwork.getRail(size * (2 + i-(size*(size+1)*2-size))-1).secondEnd);

        }
    }


    private function generateLeftSemiRound(size:int, stationType:RailStationType=null, stationIndex:int=0):void {
        for (var i:int = size*(size+1)+1, c:int = 0; i < size*(size+2); i += 2, c++) {
            var rail:Rail = trafficNetwork.getRail(i);
            var railLeft:Rail = stationType!=null && stationIndex == c?
                    new TrainStation(stationType, trafficNetwork, RailType.SEMI_ROUND_LEFT,
                            new Point(rail.firstEnd.point.x - trafficNetwork.railSpace, rail.firstEnd.point.y - trafficNetwork.railSpace),
                            new Point(rail.secondEnd.point.x - trafficNetwork.railSpace, rail.secondEnd.point.y + trafficNetwork.railSpace)):
                            addPassengers(new Rail(trafficNetwork, RailType.SEMI_ROUND_LEFT,
                    new Point(rail.firstEnd.point.x - trafficNetwork.railSpace, rail.firstEnd.point.y - trafficNetwork.railSpace),
                    new Point(rail.secondEnd.point.x - trafficNetwork.railSpace, rail.secondEnd.point.y + trafficNetwork.railSpace)));
            trafficNetwork.addRail(railLeft);
            new RailConnector(RailConnectorType.BOTTOM_RIGHT, trafficNetwork.getRail(i - 1).secondEnd, railLeft.firstEnd);
            new RailConnector(RailConnectorType.TOP_RIGHT, railLeft.secondEnd, trafficNetwork.getRail(i + 1).firstEnd);
            new RailConnector(RailConnectorType.TOP_RIGHT, railLeft.firstEnd, rail.firstEnd);
            new RailConnector(RailConnectorType.BOTTOM_RIGHT, railLeft.secondEnd, rail.secondEnd);
            new RailConnector(RailConnectorType.HORIZONTAL, railLeft.firstEnd, trafficNetwork.getRail(size * (i-size*(size+1))).firstEnd);
            new RailConnector(RailConnectorType.HORIZONTAL, railLeft.secondEnd, trafficNetwork.getRail(size * (1 + i-size*(size+1))).firstEnd);
        }
    }


    private function generateBottomSemiRound(size:int, stationType:RailStationType=null, stationIndex:int=0):void {
        for(var i:int = size*size+1, c:int = 0; i<size*(size+1); i+=2, c++){
            var rail:Rail = trafficNetwork.getRail(i);
            var railDown:Rail = stationType!=null && stationIndex == c?
                    new TrainStation(stationType, trafficNetwork, RailType.SEMI_ROUND_BOTTOM,
                            new Point(rail.firstEnd.point.x-trafficNetwork.railSpace, rail.firstEnd.point.y+trafficNetwork.railSpace),
                            new Point(rail.secondEnd.point.x+trafficNetwork.railSpace, rail.secondEnd.point.y+trafficNetwork.railSpace)):
                    addPassengers(new Rail(trafficNetwork, RailType.SEMI_ROUND_BOTTOM,
                    new Point(rail.firstEnd.point.x-trafficNetwork.railSpace, rail.firstEnd.point.y+trafficNetwork.railSpace),
                    new Point(rail.secondEnd.point.x+trafficNetwork.railSpace, rail.secondEnd.point.y+trafficNetwork.railSpace)));
            trafficNetwork.addRail(railDown);
            new RailConnector(RailConnectorType.TOP_RIGHT, trafficNetwork.getRail(i-1).secondEnd, railDown.firstEnd);
            new RailConnector(RailConnectorType.TOP_LEFT, railDown.secondEnd, trafficNetwork.getRail(i+1).firstEnd);
            new RailConnector(RailConnectorType.TOP_LEFT, railDown.firstEnd, rail.firstEnd);
            new RailConnector(RailConnectorType.TOP_RIGHT, railDown.secondEnd, rail.secondEnd);
            new RailConnector(RailConnectorType.VERTICAL, railDown.firstEnd, trafficNetwork.getRail(size*(size+2+i-size*size)-1).secondEnd);
            new RailConnector(RailConnectorType.VERTICAL, railDown.secondEnd, trafficNetwork.getRail(size*(size+3+i-size*size)-1).secondEnd);
        }
    }

    private function generateTopSemiRound(size:int, stationType:RailStationType=null, stationIndex:int=0):void {
        for (var i:int = 1, c:int = 0; i < size; i += 2, c++) {
            var rail:Rail = trafficNetwork.getRail(i);
            var railUp:Rail = stationType!=null && stationIndex == c?
                    new TrainStation(stationType, trafficNetwork, RailType.SEMI_ROUND_TOP,
                    new Point(rail.firstEnd.point.x - trafficNetwork.railSpace, rail.firstEnd.point.y - trafficNetwork.railSpace),
                    new Point(rail.secondEnd.point.x + trafficNetwork.railSpace, rail.secondEnd.point.y - trafficNetwork.railSpace)):
                    addPassengers(new Rail(trafficNetwork, RailType.SEMI_ROUND_TOP,
                    new Point(rail.firstEnd.point.x - trafficNetwork.railSpace, rail.firstEnd.point.y - trafficNetwork.railSpace),
                    new Point(rail.secondEnd.point.x + trafficNetwork.railSpace, rail.secondEnd.point.y - trafficNetwork.railSpace)));
            trafficNetwork.addRail(railUp);
            new RailConnector(RailConnectorType.BOTTOM_RIGHT, trafficNetwork.getRail(i - 1).secondEnd, railUp.firstEnd);
            new RailConnector(RailConnectorType.BOTTOM_LEFT, railUp.secondEnd, trafficNetwork.getRail(i + 1).firstEnd);
            new RailConnector(RailConnectorType.BOTTOM_LEFT, railUp.firstEnd, rail.firstEnd);
            new RailConnector(RailConnectorType.BOTTOM_RIGHT, railUp.secondEnd, rail.secondEnd);
            new RailConnector(RailConnectorType.VERTICAL, railUp.firstEnd, trafficNetwork.getRail(size * (size + 1 + i)).firstEnd);
            new RailConnector(RailConnectorType.VERTICAL, railUp.secondEnd, trafficNetwork.getRail(size * (size + 2 + i)).firstEnd);
        }
    }

    private function generateGrid(size:int, initX:int, initY:int):void {
        var shift:int = trafficNetwork.railSpace * 2 + trafficNetwork.railLength;
        for (var i:int = 0; i < size + 1; i++) {
            var row:Vector.<Rail> = generateRow(size, new Point(initX, initY + shift * i));
            for (var j:int = 0; j < row.length; j++) {
                trafficNetwork.addRail(row[j]);
            }
        }
        for (var i:int = 0; i < size + 1; i++) {
            var column:Vector.<Rail> = generateColumn(size, new Point(initX + shift * i, initY));
            for (var j:int = 0; j < column.length; j++) {
                trafficNetwork.addRail(column[j]);
                if(i<size){
                    new RailConnector(RailConnectorType.TOP_LEFT, column[j].firstEnd, trafficNetwork.getRail(size*j+i).firstEnd);
                    new RailConnector(RailConnectorType.BOTTOM_LEFT, column[j].secondEnd, trafficNetwork.getRail(size*(j+1)+i).firstEnd);
                }
                if(i>0){
                    new RailConnector(RailConnectorType.TOP_RIGHT, column[j].firstEnd, trafficNetwork.getRail(size*j+i-1).secondEnd);
                    new RailConnector(RailConnectorType.BOTTOM_RIGHT, column[j].secondEnd, trafficNetwork.getRail(size*(j+1)+i-1).secondEnd);
                }
            }
        }
    }

    private function generateRow(size:int, point:Point):Vector.<Rail> {
        var row:Vector.<Rail> = new Vector.<Rail>();
        var shift:int = trafficNetwork.railSpace*2+trafficNetwork.railLength;
        for(var i:int = 0; i<size; i++){
           var rail:Rail = addPassengers(new Rail(trafficNetwork, RailType.HORIZONTAL,
                   new Point(point.x+trafficNetwork.railSpace+i*shift, point.y),
                   new Point(point.x+trafficNetwork.railSpace+i*shift+trafficNetwork.railLength, point.y)));
           row.push(rail);
           if(i>0){
               var previousRail:Rail = row[i-1];
               new RailConnector(RailConnectorType.HORIZONTAL, previousRail.secondEnd, rail.firstEnd);
           }
        }
        return row;
    }

    private function generateColumn(size:int, point:Point):Vector.<Rail> {
        var column:Vector.<Rail> = new Vector.<Rail>();
        var shift:int = trafficNetwork.railSpace*2+trafficNetwork.railLength;
        for(var i:int = 0; i<size; i++){
            var rail:Rail = addPassengers(new Rail(trafficNetwork, RailType.VERTICAL,
                    new Point(point.x, point.y+trafficNetwork.railSpace+i*shift),
                    new Point(point.x, point.y+trafficNetwork.railSpace+i*shift+trafficNetwork.railLength)));
            column.push(rail);
            if(i>0){
                var previousRail:Rail = column[i-1];
                new RailConnector(RailConnectorType.VERTICAL, previousRail.secondEnd, rail.firstEnd);
            }
        }
        return column;
    }


    private function addPassengers(rail:Rail):Rail{
      var max:int = trafficNetwork.maxPassengers;
      var realNumber = Math.round(Math.random()*max);
      realNumber=4;
      var secondDivisor = Math.round(Math.random()*realNumber);
      var firstDivisor = Math.round(Math.random()*secondDivisor);
      var thirdDivisor = secondDivisor+Math.round(Math.random()*realNumber-secondDivisor);

      for(var i:int =0; i<firstDivisor; i++){
          rail.addPassenger(new Passenger(RailStationType.FIRST));
      }

      for(var i:int =firstDivisor; i<secondDivisor; i++){
          rail.addPassenger(new Passenger(RailStationType.SECOND));
      }

      for(var i:int =secondDivisor; i<thirdDivisor; i++){
           rail.addPassenger(new Passenger(RailStationType.THIRD));
      }

       for(var i:int =thirdDivisor; i<realNumber; i++){
           rail.addPassenger(new Passenger(RailStationType.FOURTH));
       }


      return rail;
    }

    public function get result():TextField {
        return _result;
    }

    public function set result(value:TextField):void {
        _result = value;
    }
}
}
class PrivateClass{
    public function PrivateClass(){

    }
}
