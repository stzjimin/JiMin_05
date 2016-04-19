package Component
{
	import starling.textures.Texture;

	public class RadioButton extends ButtonObject
	{	
		private var _key:String;
		private var _radioState:Boolean;
		
		/**
		 *라디오버튼에 대한 클래스입니다.
		 * 기본적으로 RadioButton은 ButtonObject를 상속해서 버튼의 속성을 띄게됩니다.
		 * 기존의 버튼과 차이점은 각 라디오버튼별로 key값을 가지고 radioState를 가지게됩니다.
		 * radioState가 true일 때는 해당 버튼이 눌려져있는 상태이고
		 * radioState가 false일 때는 해당버튼이 눌려져있지 않은 상태입니다.
		 * @param upState
		 * @param key
		 * 
		 */		
		public function RadioButton(upState:Texture, key:String)
		{
			_key = key;
			_radioState = false;
			super(upState);
		}

		public function get radioState():Boolean
		{
			return _radioState;
		}

		public function set radioState(value:Boolean):void
		{
			_radioState = value;
		}

		public function get key():String
		{
			return _key;
		}
	}
}