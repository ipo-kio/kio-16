/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 04.02.14
 */
package ru.ipo.kio._14.tarski.model {
import mx.core.ByteArrayAsset;
import mx.utils.StringUtil;

import ru.ipo.kio._14.tarski.TarskiProblemFirst;

public class ConfigurationHolder {

    private static var _instance:ConfigurationHolder = new ConfigurationHolder();

    public static function get instance():ConfigurationHolder {
        return _instance;
    }

    [Embed(source="../_resources/examples/configuration1.txt", mimeType="application/octet-stream")]
    private static const CONFIG1:Class;

    [Embed(source="../_resources/examples/configuration2.txt", mimeType="application/octet-stream")]
    private static const CONFIG2:Class;


    private var _rightExamples:Vector.<Configuration> = new Vector.<Configuration>();

    private var _wrongExamples:Vector.<Configuration> = new Vector.<Configuration>();


    public function get rightExamples():Vector.<Configuration> {
        return _rightExamples;
    }

    public function get wrongExamples():Vector.<Configuration> {
        return _wrongExamples;
    }

    public function init() {
        if(TarskiProblemFirst.instance.level==1){
            var byteArrayAsset:ByteArrayAsset = new CONFIG1;
            var text:String = byteArrayAsset.toString();
            load(text);
        }else if(TarskiProblemFirst.instance.level==2){
            var byteArrayAsset:ByteArrayAsset = new CONFIG2;
            var text:String = byteArrayAsset.toString();
            load(text);
        }

    }

    public function load(data:String):void{
        _rightExamples = new Vector.<Configuration>();
        _wrongExamples = new Vector.<Configuration>();

        var amountOfRight:int=6;
        var lines:Array = data.split("\n");
        var configuration:Configuration = null;
        var right: Boolean = true;
        var rowCounter:int = 0;
        for(var i:int=0; i<lines.length; i++){
            lines[i] = StringUtil.trim(lines[i]);
            if(lines[i].indexOf("#")==0){
                continue;
            }else if(lines[i]==""){
                if(configuration!=null){
                    if(right){
                        _rightExamples.push(configuration);
                    }else{
                        _wrongExamples.push(configuration);
                    }
                    configuration=null;
                    if(_rightExamples.length==amountOfRight){
                        right = false;
                    }
                }
            }else{
                var figures:Array = lines[i].split(" ");
                if(configuration==null){
                    configuration=new Configuration(figures.length, figures.length);
                    rowCounter=0;
                }
                for(var j:int=0; j<figures.length; j++){
                    if(figures[j]!='__'){
                        configuration.addFigure(Figure.createFigureByCode(j, configuration.depth-rowCounter-1, figures[j]));
                    }
                }
                rowCounter++;
            }
        }
        TarskiProblemFirst.instance.update();
    }

    public function getRightSelectionAmount():int{
        var result:int = 0;
        for(var i:int = 0; i<rightExamples.length; i++){
            var rightConfiguration:Configuration = rightExamples[i];
            if(rightConfiguration.correct){
              result++;
            }
        }

        for(var i:int = 0; i<wrongExamples.length; i++){
            var wrongConfiguration:Configuration = wrongExamples[i];
            if(!wrongConfiguration.correct){
                result++;
            }
        }
        return result;
    }

}
}
