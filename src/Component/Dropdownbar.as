package Component
{	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import Util.CustomizeEvent;

	public class Dropdownbar extends DisplayObjectContainer
	{
		private var _list:Vector.<TextField>;
		
		private var _width:int;
		private var _listHeight:int;
		private var _listY:int;
		
		private var _currentSelectList:TextField;
		private var _selectedIndex:int;
		
		private var _dropButton:ButtonObject;
		private var _currentView:int;
		
		private var _backGround:Quad;
		private var _upButton:ButtonObject;
		private var _downButton:ButtonObject;
		private var _content:Sprite;
		
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
			_selectedIndex = 0;
			_list = new Vector.<TextField>();
			
			_width = width;
			
			_listHeight = 20;
			_listY = _listHeight / 2;
			
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
			
			_upButton = new ButtonObject(upTexture);
			_upButton.width = 20;
			_upButton.height = 40;
			_upButton.x = _width-20;
			_upButton.addEventListener(Event.TRIGGERED, onClickUpButton);
			
			_downButton = new ButtonObject(downTexture);
			_downButton.width = 20;
			_downButton.height = 40;
			_downButton.x = _width-20;
			_downButton.y = 40;
			_downButton.addEventListener(Event.TRIGGERED, onClickDownButton);
			
			_content = new Sprite();
			_content.y = 20;
			_content.visible = false;
			_content.addChild(_backGround);
			_content.addChild(_upButton);
			_content.addChild(_downButton);
			
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
			for(var i:int = 0; i < _list.length; i++)
			{
				_list[i].removeEventListener(TouchEvent.TOUCH, onClickList);
				_list[i] = null;
			}
			_list = new Vector.<TextField>();
			_selectedIndex = 0;
		}
		
		/**
		 *새로운 리스트를 하나 생성하는 함수입니다.
		 * 인자로 받아온 문자열로 새로운 리스트를 생성합니다. 
		 * @param name
		 * 
		 */		
		public function createList(name:String):void
		{
			var list:TextField = new TextField(_width-20, _listHeight, name);
			list.name = name;
			list.border = true;
			list.pivotX = list.width / 2;
			list.pivotY = list.height / 2;
			list.x += list.width / 2;
			list.y = _listY;
			list.addEventListener(TouchEvent.TOUCH, onClickList);
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
			for(var i:int = 0; i < _list.length; i++)
			{
				if(_list[i].text == name)
				{
					_list[i].removeEventListener(TouchEvent.TOUCH, onClickList);
					_list[i].removeFromParent(true);
					_list.removeAt(i);
					break;
				}
			}
		}
		
		/**
		 *리스트를 현재의 상태에 맞게 새로고침을 해주는 함수입니다.
		 * 주로 리스트업버튼이나 다운버튼을 눌렀을 때 호출됩니다. 
		 * 
		 */		
		public function refreshList():void
		{
			for(var j:int = _content.numChildren-1; j > 2; j--)
			{
				_content.getChildAt(j).y = _listY;
				_content.removeChildAt(j);
			}
			
			if(_content.visible)
			{
				for(var i:int = 0; i < 4; i++)
				{
					if((_list.length-1) >= _currentView+i)
					{
						_content.addChild(_list[_currentView+i]);
						_list[_currentView+i].y += i*20;
					}
				}
			}
		}
		
		/**
		 *드롭버튼을 눌렀을 때 호출됩니다.
		 * 드롭버튼을 누를경우 리스트의 비지블이 토글됩니다. 
		 * @param event
		 * 
		 */		
		private function onClickDropdownbar(event:Event):void
		{
			togleVisible();
		}
		
		/**
		 *리스트의 비지블이 토글되는 함수입니다.
		 * _content는 리스트전체를 포함하는 Sprite이기에 해당 Sprite의 비지블을 전환해줍니다.
		 * 현재 보여져야할 리스트는 선택되어있는것에 맞춥니다.
		 * 그 후 리스트를 새로고침해줍니다. 
		 * 
		 */		
		private function togleVisible():void
		{
			_content.visible = !_content.visible;
			if(_content.visible)
			{
				_currentView = _selectedIndex;
				refreshList();
			}
		}
		
		/**
		 *리스트업버튼을 눌렀을 때 호출되는 함수입니다.
		 * 현재보여지는 리스트를 한칸씩 올리고 리스트를 새로고침해줍니다. 
		 * @param event
		 * 
		 */		
		private function onClickUpButton(event:Event):void
		{
			if(_currentView > 0)
				_currentView--;
			refreshList();
		}
		
		/**
		 *리스트다운버튼을 눌렸을 때 호출되는 함수입니다.
		 * 현재보여지는 리스트를 한칸씩 내리고 리스트를 새로고침해줍니다. 
		 * @param event
		 * 
		 */		
		private function onClickDownButton(event:Event):void
		{
			if((_list.length-1) > _currentView)
				_currentView++;
			refreshList();
		}
		
		/**
		 *리스트가 눌려졌을 때 호출되는 함수입니다.
		 * 해당 리스트의 텍스트를 _currentSelectList로 맞추고 _selectedIndex를 해당 리스트의 인덱스번호로 맞춥니다. 
		 * @param event
		 * 
		 */		
		private function onClickList(event:TouchEvent):void
		{
			if(event.getTouch(TextField(event.currentTarget), TouchPhase.BEGAN) != null)
			{
				TextField(event.currentTarget).scale = 0.9;
			}
			
			if(event.getTouch(TextField(event.currentTarget), TouchPhase.ENDED) != null)
			{
				TextField(event.currentTarget).scale = 1.0;
				_selectedIndex = _list.indexOf(TextField(event.currentTarget));
				togleVisible();
				_currentSelectList.text = TextField(event.currentTarget).text;
				dispatchEvent(new Event(CustomizeEvent.ListChange));
			}
		}
	}
}