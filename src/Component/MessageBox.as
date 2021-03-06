package Component
{
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;

	public class MessageBox extends DisplayObjectContainer
	{
		private var _messageText:TextField;
		private var _frameCounter:int;
		private var _frameLate:int;
		private var _x:int;
		private var _y:int;
		private var _content:Sprite;
		
		/**
		 *사용자에게 특정 메세지를 전달해주고싶을 때 사용하게될 메세지박스 클래스입니다.
		 * 해당 클래스로 만들어진 객체는 showMessageBox가 호출되면
		 * 목표가되는 오브젝트의 자식으로 추가되었다가 지정한 기간이 지나면 사라집니다. 
		 * 
		 */		
		public function MessageBox()
		{
			_content = new Sprite();
			_messageText = new TextField(200, 30, "");
			_content.addChild(_messageText);
			addChild(_content);
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
			_messageText.format.font = "Arial";
			_messageText.format.size = 20;
		}

		public function showMessageBox(text:String, frameCount:int, parent:DisplayObjectContainer, color:uint = Color.AQUA):void
		{
			_messageText.format.color = color;
			_messageText.text = text;
			this.x = parent.width / 2;
			this.y = parent.height/5 * 4;
			_frameLate = frameCount;
			_frameCounter = 0;
			_messageText.addEventListener(Event.ENTER_FRAME, onFrameEnter);
			parent.addChild(this);
		}
		
		private function onFrameEnter(event:Event):void
		{
			_frameCounter++;
			if(_frameCounter >= _frameLate)
			{
				_messageText.removeEventListener(Event.ENTER_FRAME, onFrameEnter);
				this.removeFromParent(true);
			}
		}
	}
}