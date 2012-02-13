/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model {
import ru.ipo.kio._12.train.model.types.RailConnectorType;

public class RailConnector {
    
    private var type:RailConnectorType;

    private var firstEnd:RailEnd;

    private var secondEnd:RailEnd;
    
    public function RailConnector(type:RailConnectorType,  firstEnd:RailEnd, secondEnd:RailEnd) {
        this.type = type;
        this.firstEnd=firstEnd;
        this.secondEnd=secondEnd;
        firstEnd.addConnector(this);
        secondEnd.addConnector(this);
    }
    
    public function getAnotherRail(rail:Rail):Rail{
        if(firstEnd.rail == rail){
            return secondEnd.rail;
        }else if(secondEnd.rail == rail){
            return firstEnd.rail;
        }else{
            throw new Error("There is no such rail in connector");
        }
    }

    public function getAnotherEnd(end:RailEnd):RailEnd{
        if(firstEnd==end){
            return secondEnd;
        }else if(secondEnd==end){
            return firstEnd;
        }else{
            return null;
        }
    
    }
}
}
