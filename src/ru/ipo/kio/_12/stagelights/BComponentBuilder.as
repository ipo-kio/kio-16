package ru.ipo.kio._12.stagelights 
{
	/**
	 * ...
	 * @author ...
	 */
	public class BComponentBuilder {
		
		public function BComponentBuilder() {
			
		}
		
		
		public static function body(): VBody {
			
		}
		
		public static function spotlight(spotlight: ISpotlight, source: MovieClip, workspace: IWorkspace, light: int, sourceX: int, sourceY: int, lightX: int, lightY: int): VSpotlight {
			var item: VSpotlight = new VSpotlight(spotlight, source, workspace, light);
			item.source.x = sourceX;
			item.source.y = sourceY;
			item.light.x = lightX;
			item.light.y = lightY;
		}
		
		public static function intensitySlider(): VIntensitySlider {
			
		}
		
	}

}