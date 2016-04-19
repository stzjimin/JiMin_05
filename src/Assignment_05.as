package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import Screen.Main;
	
	import starling.core.Starling;
	
	[SWF(width="1980", height="1024", frameRate="60", backgroundColor="#FFFFF0")]
	public class Assignment_05 extends Sprite
	{
		private var _starling:Starling;
		
		public function Assignment_05()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_starling = new Starling(Main, stage);
			_starling.start();
			_starling.showStats = true;
		}
	}
}