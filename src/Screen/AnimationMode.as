package Screen
{
	import flash.display.Bitmap;
	
	import Component.ButtonObject;
	import Component.Dropdownbar;
	
	import Data.Resource;
	
	import Util.CustomizeEvent;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class AnimationMode extends Sprite
	{	
		private var _startButton:ButtonObject;
		private var _stopButton:ButtonObject;
		private var _deleteButton:ButtonObject;
		private var _animationSpeed:Dropdownbar;
		
		public function AnimationMode()
		{	
			_startButton = new ButtonObject(Texture.fromBitmap(Resource.resources["start.png"] as Bitmap));
			_startButton.width = 64;
			_startButton.height = 64;
			_startButton.x = 0;
			_startButton.y = 30;
			_startButton.addEventListener(Event.TRIGGERED, onClickStartButton);
			
			_stopButton = new ButtonObject(Texture.fromBitmap(Resource.resources["stop.png"] as Bitmap));
			_stopButton.width = 64;
			_stopButton.height = 64;
			_stopButton.x = 60;
			_stopButton.y = 30;
			_stopButton.addEventListener(Event.TRIGGERED, onClickStopButton);
			
			_deleteButton = new ButtonObject(Texture.fromBitmap(Resource.resources["delete.png"] as Bitmap));
			_deleteButton.width = 64;
			_deleteButton.height = 64;
			_deleteButton.x = 120;
			_deleteButton.y = 27;
			_deleteButton.addEventListener(Event.TRIGGERED, onClickDeleteButton);
			
			_animationSpeed = new Dropdownbar(150, Texture.fromBitmap(Resource.resources["dropdown.png"] as Bitmap), Texture.fromBitmap(Resource.resources["arrowUp.png"] as Bitmap), Texture.fromBitmap(Resource.resources["arrowDown.png"] as Bitmap));
			_animationSpeed.x = 10;
			_animationSpeed.y = 0;
			_animationSpeed.addEventListener(CustomizeEvent.ListChange, onChangeSpeed);
			_animationSpeed.createList("5frame / 1page");
			_animationSpeed.createList("10frame / 1page");
			_animationSpeed.createList("30frame / 1page");
			_animationSpeed.createList("50frame / 1page");
			
			addChild(_startButton);
			addChild(_stopButton);
			addChild(_deleteButton);
			addChild(_animationSpeed);
		}
		
		private function onChangeSpeed(event:Event):void
		{
			var speed:int = int(_animationSpeed.currentSelectList.text.replace("frame / 1page", ""));
			dispatchEvent(new Event(CustomizeEvent.SpeedChange, false, speed));
		}
		
		private function onClickStartButton(event:Event):void
		{
			dispatchEvent(new Event(CustomizeEvent.AnimationStart));
		}
		
		private function onClickStopButton(event:Event):void
		{
			dispatchEvent(new Event(CustomizeEvent.AnimationStop));
		}
		
		private function onClickDeleteButton(event:Event):void
		{
			dispatchEvent(new Event(CustomizeEvent.SpriteDelete));
		}
	}
}