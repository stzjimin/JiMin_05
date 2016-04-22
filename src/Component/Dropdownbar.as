package Component
{		
	import flash.events.IEventDispatcher;
	
	import Util.CustomizeEvent;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class Dropdownbar extends DisplayObjectContainer
	{
		private var _list:Array;
		
		private var _width:int;
		
		private var _currentSelectList:TextField;
		
		private var _dropButton:ButtonObject;
		
		private var _backGround:Quad;
		private var _eventDispatcher:IEventDispatcher;
		private var _dialogExtension:DialogExtension;
		
		/**
		 *드롭다운바에 대한 클래스입니다.
		 * 안드로이드 환경에서는 드롭다운바의 드롭버튼을 누를경우 리스트다이얼로그에서 선택이되게 합니다.
		 * @param width
		 * @param dropTexture
		 * @param upTexture
		 * @param downTexture
		 * 
		 */		
		public function Dropdownbar(width:int, dropTexture:Texture)
		{
			_dialogExtension = new DialogExtension(_eventDispatcher);
			
			_list = new Array();
			
			_width = width;
			
			_dropButton = new ButtonObject(dropTexture);
			_dropButton.width = 30;
			_dropButton.height = 25;
			_dropButton.x = _width - 30;
			_dropButton.addEventListener(Event.TRIGGERED, onClickDropdownbar);
			
			_currentSelectList = new TextField(_width-30, 25, "");
			_currentSelectList.border = true;
			
			_backGround = new Quad(width, 25);
			_backGround.alpha = 0.5;
			_backGround.color = Color.SILVER;
			
			addChild(_backGround);
			addChild(_currentSelectList);
			addChild(_dropButton);
		}
		
		
		public function get currentSelectList():TextField
		{
			return _currentSelectList;
		}
		
		/**
		 *드롭다운바의 모든 리스트를 제거하는 함수입니다. 
		 */		
		public function initList():void
		{
			_list = new Array();
		}
		
		/**
		 *새로운 리스트를 하나 생성하는 함수입니다.
		 * 인자로 받아온 문자열로 새로운 리스트를 생성합니다. 
		 * @param name
		 * 
		 */		
		public function createList(name:String):void
		{
			var list:String = name;

			_list.push(list);
		}
		
		/**
		 *인자로 받은 문자열에 해당하는 리스트를 제거합니다.
		 * @param name
		 * 
		 */		
		public function deleteList(name:String):void
		{
			_list.removeAt(_list.indexOf(name));
		}
		
		
		/**
		 *드롭버튼을 눌렀을 때 호출됩니다.
		 * 드롭버튼을 누를경우 리스트다이얼로그를 띄워줍니다.
		 * @param event
		 * 
		 */		
		private function onClickDropdownbar(event:Event):void
		{
			var array:Array = _list;
			
			_dialogExtension.showListDialog(array, onClickList);
		}
		

		/**
		 *리스트가 눌려졌을 때 호출되는 함수입니다.
		 * 해당 리스트의 텍스트를 _currentSelectList로 맞추고 _selectedIndex를 해당 리스트의 인덱스번호로 맞춥니다. 
		 * @param event
		 * 
		 */		
		private function onClickList(name:String):void
		{
			_currentSelectList.text = name;
			dispatchEvent(new Event(CustomizeEvent.ListChange));
		}
	}
}