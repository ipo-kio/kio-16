package  
ru.ipo.kio.api.controls{
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

/**
	 * ...
	 * @author Ilya
	 */
	public class TextSprite extends Sprite
	{
		
		public function TextSprite(text:String, width:int, height: int, borderColor:uint, fillColor:uint, textColor:uint, dx:int, dy:int) 
		{
			graphics.beginFill(fillColor);
			graphics.lineStyle(3, borderColor);
			graphics.drawRoundRect(0, 0, width, height, 4);
			graphics.endFill();
			var tf:TextField = new TextField();
			tf.text = text;
			tf.textColor = textColor;
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.x = (width - tf.width) / 2 + dx;
			tf.y = (height - tf.height) / 2 + dy;
			addChild(tf);			
		}
		
	}

}