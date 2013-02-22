/**
 * Утилита - создатель реализации для уровня
 *
 * @author: Vasiliy
 * @date: 21.02.13
 */
package ru.ipo.kio._13.clock.model.level {
public class LevelCreator {

    public function LevelCreator(pvt:PrivateClass) {
    }

    public static function createLevelImpl(levelNumber:int):ITaskLevel{
        if(levelNumber==0){
            return new ZeroLevel();
        }else if (levelNumber==1){
            return new FirstLevel();
        }else if (levelNumber==2){
            return new SecondLevel();
        }else{
            throw Error("Unknown level number: "+levelNumber);
        }
}
}
}

internal class PrivateClass{
    public function PrivateClass(){
    }
}
