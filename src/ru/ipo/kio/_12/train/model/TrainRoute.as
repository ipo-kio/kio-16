/**
 *
 * @author: Vasily Akimushkin
 * @since: 12.02.12
 */
package ru.ipo.kio._12.train.model {
import ru.ipo.kio._12.train.model.types.StationType;

public class TrainRoute {
    
    private var _rails:Vector.<Rail> = new Vector.<Rail>();

    private var _finished:Boolean = false;

    public function TrainRoute() {
    }
    
    public function addRail(rail:Rail):void{
        _rails.push(rail);
    }

    public function removeLast():void{
        if(_rails.length>0){
            _rails.pop();
            _finished=false;
        }
    }

    public function get rails():Vector.<Rail> {
        return _rails;
    }

    public function getAmountOfInput(rail:Rail):int {
       var count:int = 0;
       for(var i:int = 0; i<_rails.length; i++){
           if(_rails[i]==rail){
               count++;
           }
       }
       return count;
    }

    public function getAmountOfDirectInput(rail:Rail):int {
        var cnt:int = 0;
        var temp:Rail = _rails[0];
        if(temp == rail)
            cnt++;
        if(_rails.length==1){
             return cnt;
        }

        var next:Rail = _rails[1];
        var end:RailEnd = next.getAnotherEnd(next.getEnd(temp));
        if(next == rail && !end.isFirst()){
            cnt++;
        }

        for(var i:int = 2; i<_rails.length; i++){
            var next:Rail = _rails[i];
            end = next.getEndBy(end);
            end = next.getAnotherEnd(end);
            if(next == rail && !end.isFirst()){
                cnt++;
            }
        }
        return cnt;
    }

    public function getAmountOfReverseInput(rail:Rail):int {
        var cnt:int = 0;
        var temp:Rail = _rails[0];
        if(_rails.length==1){
            return cnt;
        }

        var next:Rail = _rails[1];
        var end:RailEnd = next.getAnotherEnd(next.getEnd(temp));
        if(next == rail && end.isFirst()){
            cnt++;
        }

        for(var i:int = 2; i<_rails.length; i++){
            var next:Rail = _rails[i];
            end = next.getEndBy(end);
            end = next.getAnotherEnd(end);
            if(next == rail && end.isFirst()){
                cnt++;
            }
        }
        return cnt;
    }

    public function getLastEnd():RailEnd {
        var temp:Rail = _rails[0];
        var next:Rail = _rails[1];
        var end:RailEnd = next.getAnotherEnd(next.getEnd(temp));
        for(var i:int = 2; i<_rails.length; i++){
            var next:Rail = _rails[i];
            end = next.getEndBy(end);
            end = next.getAnotherEnd(end);
        }
        return end;
    }

    public function getLastEndFor(cnt:int):RailEnd {
        var temp:Rail = _rails[0];
        if(cnt ==0)
            return temp.secondEnd;

        var next:Rail = _rails[1];
        var end:RailEnd = next.getAnotherEnd(next.getEnd(temp));
        for(var i:int = 2; i<cnt; i++){
            var next:Rail = _rails[i];
            end = next.getEndBy(end);
            end = next.getAnotherEnd(end);
        }
        return end;
    }

    public function finish():void {
       _finished = true;
    }

    public function get finished():Boolean {
        return _finished;
    }



    public function get time():int {
        var t:int = 0;
        for(var i:int = 0; i<_rails.length; i++){
            t+=_rails[i].type.length;
        }
        return t;
    }

    public function clear():void {
       _rails = new Vector.<Rail>();
    }
}
}
