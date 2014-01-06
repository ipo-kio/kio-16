package ru.ipo.kio._3x_pl_1 
{
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

/**
	 * ...
	 * @author Darya
	 */
	public class MyRecordEffect extends Sprite 
	{
		private var recordLabel:TextField;
        private var recLab:TextField;
		[Embed(source='resources/fontscore.com_s-segoe-print-bold.ttf', embedAsCFF="false", fontName="Segoe Print", mimeType='application/x-font-truetype')]
		private static var MyFont:Class;

		private var k:int = 0;
		private var textLabel:String;
        private var tf:TextFormat;
		
		public function MyRecordEffect(text:String, record:TextField)
		{
            alpha = 0;
            recLab = record;
			recordLabel = new TextField();
			tf = new TextFormat("Segoe Print", 20, null, true);
            recordLabel.embedFonts = true;
            recordLabel.defaultTextFormat = tf;
			recordLabel.width = 250;
			recordLabel.selectable = false;
			textLabel = text;
			
			addChild(recordLabel);
		}
		
		public function go():void
		{
            recLab.alpha = 0;
			addEventListener(Event.ENTER_FRAME, animation);
		}
		
		public function drop():void
		{
            recLab.alpha = 1;
			removeEventListener(Event.ENTER_FRAME, animation);
		}
		
		private function animation(e:Event):void
		{
			recordLabel.text = textLabel;
			//TODO remove 'my record effect' 1) removeEventListener, removeChild()
			if (k > 30 * 3) {
				drop();
				if (this.parent.contains(this))
					this.parent.removeChild(this);
			}
				
			if (k > 0 && k < 20)
			{
				alpha = (k * 2) / 20;
			}
            else if ((k > 20 && k < 28) || (k > 36 && k < 44) || (k > 52 && k < 60))
            {
                recordLabel.textColor = 0xff8800;
            }
			else if (k > 60 && k < 90)
            {
                alpha = 1 - (((k - 60) * 3)/90);
            }
            else
            {
                recordLabel.textColor = 0xe32636;
            }
			k++;
		}
		
	}

}