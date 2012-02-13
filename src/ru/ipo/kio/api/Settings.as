/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 17.02.11
 * Time: 21:57
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api {
import com.adobe.serialization.json.JSONParseError;
import com.adobe.serialization.json.JSON_k;

import mx.core.ByteArrayAsset;

public class Settings {

    private var _data:Object;

    /**
     *
     * @param txtClass class marked as
     * [Embed(source="myTextFile.txt",mimeType="application/octet-stream")]
     */
    public function Settings(txtClass:Class) {
        var byteArrayAsset:ByteArrayAsset = new txtClass;
        var text:String = byteArrayAsset.toString();

        //remove comments
        var commentsRegExp:RegExp = new RegExp("/\\*.*?\\*/", "sg"); //s: . matches \n, g: all occurrences
//        text = text.replace(commentsRegExp , "");
        text = text.replace(commentsRegExp , "");

        //find all quotes <<<>>> and replace new lines there with spaces
        var multilineQuotesRegExp:RegExp = new RegExp("<<<(.*?)>>>", "sg");
        text = text.replace(multilineQuotesRegExp, function(match:String, gr:String, ind:int, str:String):String {
            return '"' + gr.replace(/(\r\n|\n\r)/g, " ").replace(/(\r|\n|\t)/g, " ") + '"';
        });

        try {
            _data = JSON_k.decode(text);
        } catch (e:JSONParseError) {
            var ind:int = e.location - 10;
            if (ind < 0)
                ind = 0;
            trace(e.text.slice(ind));
            throw e;
        }
    }

    public function get data():Object {
        return _data;
    }
}
}
