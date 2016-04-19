package Component
{	
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import Util.CustomizeEvent;

	public class RadioButtonManager extends EventDispatcher
	{	
		private var _radioButtons:Dictionary;
		private var _mode:String;
		
		private var _emptyButtonTexture:Texture;
		private var _checkButtonTexture:Texture;
		
		public function RadioButtonManager(emptyButtonTexture:Texture, checkButtonTexture:Texture)
		{
			_radioButtons = new Dictionary();
			
			_emptyButtonTexture = emptyButtonTexture;
			_checkButtonTexture = checkButtonTexture;
		}
		
		public function get mode():String
		{
			return _mode;
		}

		public function set mode(value:String):void
		{
			_mode = value;
		}

		/**
		 *라디오 매니저가 관리하게되는 라디오버튼들을 생성합니다. 
		 * @param key
		 * @return = RadioButton을 리턴해줍니다.
		 * RadioButton은 ButtonObject에서 상속을 받아서 만든 클래스입니다.
		 */		
		public function createButton(key:String):RadioButton
		{
			var button:RadioButton = new RadioButton(_emptyButtonTexture, key);
			button.addEventListener(Event.TRIGGERED, onClickButton);
			_radioButtons[key] = button;
			return button;
		}
		
		/**
		 *라디오 매니저가 관리하는 버튼이 클릭이되면 호출되는 함수입니다.
		 * 현재 모드를 해당버튼의 key값으로 변경해주며 원래있었던 모드의 버튼은 눌리지않은 상태로 바꿔줍니다.  
		 * @param event
		 * 
		 */		
		public function onClickButton(event:Event):void
		{
			if(!RadioButton(event.currentTarget).radioState)
			{
				_radioButtons[_mode].radioState = false;
				_radioButtons[_mode].buttonTexture = _emptyButtonTexture;
				_radioButtons[_mode].setStateTexture(_emptyButtonTexture);
				
				_mode = RadioButton(event.currentTarget).key;
				RadioButton(event.currentTarget).buttonTexture = _checkButtonTexture;
				RadioButton(event.currentTarget).setStateTexture(_checkButtonTexture);
				RadioButton(event.currentTarget).radioState = true;
				dispatchEvent(new Event(CustomizeEvent.ModeChange));
			}
		}
	}
}