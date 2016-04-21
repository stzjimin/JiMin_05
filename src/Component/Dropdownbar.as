package Component
{	
	import com.lpesign.ToastExtension;
	
	import flash.events.IEventDispatcher;
	
	import Util.CustomizeEvent;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
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
		private var _currentView:int;
		
		private var _backGround:Quad;
		private var _content:Sprite;
		private var _eventDispatcher:IEventDispatcher;
		private var dialogExtension:DialogExtension;
		private var toastExtension:ToastExtension;
		
		/**
		 *드롭다운바에 대한 클래스입니다.
		 * 드롭다운바는 3개의 버튼과 4개의 리스트로 이루어집니다.
		 * 3개의 버튼은 각각 드롭버튼, 리스트업버튼, 리스트다운버튼 입니다. 
		 * 각각의 리스트도 버튼처럼 클릭이 가능하며 버튼이 클릭이 되면 _currentViewList에 값이 할당됩니다.
		 * @param width
		 * @param dropTexture
		 * @param upTexture
		 * @param downTexture
		 * 
		 */		
		public function Dropdownbar(width:int, dropTexture:Texture, upTexture:Texture, downTexture:Texture)
		{
			dialogExtension = new DialogExtension(_eventDispatcher);
			toastExtension = new ToastExtension();
			
			_list = new Array();
			
			_width = width;
			
			_dropButton = new ButtonObject(dropTexture);
			_dropButton.width = 20;
			_dropButton.height = 20;
			_dropButton.x = _width - 20;
			_dropButton.addEventListener(Event.TRIGGERED, onClickDropdownbar);
			
			_currentSelectList = new TextField(_width-20, 20, "");
			_currentSelectList.border = true;
			
			_backGround = new Quad(width, 80);
			_backGround.alpha = 0.5;
			_backGround.color = Color.SILVER;
			
			_content = new Sprite();
			_content.y = 20;
			_content.visible = false;
			_content.addChild(_backGround);
			
			addChild(_currentSelectList);
			addChild(_dropButton);
			addChild(_content);
		}
		
		
		public function get currentSelectList():TextField
		{
			return _currentSelectList;
		}
		
		/**
		 *드롭다운바의 모든 리스트를 제거하는 함수입니다. 
		 * 리스트를 제거할 때는 모든 리스트의 이벤트리스너를 제거한 후 제거해줍니다.
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
		 * 이 때 제거되는 리스트의 이벤트리스너도 제거해줍니다. 
		 * @param name
		 * 
		 */		
		public function deleteList(name:String):void
		{
			_list.removeAt(_list.indexOf(name));
		}
		
		
		/**
		 *드롭버튼을 눌렀을 때 호출됩니다.
		 * 드롭버튼을 누를경우 리스트의 비지블이 토글됩니다. 
		 * @param event
		 * 
		 */		
		private function onClickDropdownbar(event:Event):void
		{
			var array:Array = _list;
			
			dialogExtension.showListDialog(array, onClickList);
			toastExtension.toast("찌발");
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