package Screen
{
	import com.lpesign.ToastExtension;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Screen;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import Component.ButtonObject;
	import Component.Dropdownbar;
	import Component.MessageBox;
	import Component.RadioButton;
	import Component.RadioButtonManager;
	
	import Data.Resource;
	import Data.ResourceLoader;
	import Data.SpriteLoader;
	import Data.SpriteSheet;
	
	import Util.CustomizeEvent;
	import Util.RadioKeyValue;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class Main extends DisplayObjectContainer
	{
		private var _content:Sprite;
		
		private var _resourceLoader:ResourceLoader;
		
		private var _spriteSheets:Dictionary = new Dictionary();
		
		private var _loadeButton:ButtonObject;
		private var _display:Display;
		private var _displayBound:Quad;
		private var _radioManager:RadioButtonManager;
		private var _animationButton:RadioButton;
		private var _imageButton:RadioButton;
		private var _animaionText:TextField;
		private var _imageText:TextField;
		private var _animationMode:AnimationMode;
		private var _imageMode:ImageMode;
		private var _SpriteSheetDrop:Dropdownbar;
		
		private var toastExtension:ToastExtension;
		private var dialogExtension:DialogExtension;
		
		private var _eventDispatcher:IEventDispatcher;
		
		/**
		 *Main클래스는 시작할 때 리소스를 로드합니다. 
		 * 
		 */		
		public function Main()
		{	
			_content = new Sprite();
			_resourceLoader = new ResourceLoader("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources", completeResourceLoad);
		//	_resourceLoader = new ResourceLoader("GUI_resources", completeResourceLoad);
			_resourceLoader.loadResource(Resource.resources);
			var messageBox:MessageBox = new MessageBox();
			messageBox.showMessageBox("Resource Loading", 60, _content);
			messageBox.x = 350;
			messageBox.y = 270;
			
		//	_content.alignPivot();
			
			toastExtension = new ToastExtension();
			dialogExtension = new DialogExtension(_eventDispatcher);
		//	_eventDispatcher.addEventListener("customEvent", onSelectDialog);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onClciBackButton);
		}
		
		/**
		 *리소스 로드가 끝나고나면 화면을 구성합니다. 
		 * 
		 */		
		private function completeResourceLoad():void
		{	
			this.width = 600;
			this.height = 700;
			
			_radioManager = new RadioButtonManager(Texture.fromBitmap(Resource.resources["emptyRadio.png"] as Bitmap), Texture.fromBitmap(Resource.resources["checkRadio.png"] as Bitmap));
			_radioManager.mode = RadioKeyValue.ANIMATION;
			_radioManager.addEventListener(CustomizeEvent.ModeChange,onChangeMode);
			
			_animaionText = new TextField(100, 20, "Animation");
			_animaionText.border = true;
			_animaionText.x = 200;
			_animaionText.y = 550;
			
			_imageText = new TextField(100, 20, "Image");
			_imageText.border = true;
			_imageText.x = 200;
			_imageText.y = 580;
			
			_animationButton = _radioManager.createButton(RadioKeyValue.ANIMATION);
			_animationButton.width = 20;
			_animationButton.height = 20;
			_animationButton.x = 180;
			_animationButton.y = 550;
			
			_imageButton = _radioManager.createButton(RadioKeyValue.IMAGE);
			_imageButton.width = 20;
			_imageButton.height = 20;
			_imageButton.x = 180;
			_imageButton.y = 580;
			
			_loadeButton = new ButtonObject(Texture.fromBitmap(Resource.resources["load.png"] as Bitmap));
			_loadeButton.width = 50;
			_loadeButton.height = 40;
			_loadeButton.x = 30;
			_loadeButton.y = 540;
			_loadeButton.addEventListener(Event.TRIGGERED, onClickLoadButton);
			
			_animationMode = new AnimationMode();
			_animationMode.x = 370;
			_animationMode.y = 550;
			_animationMode.visible = false;
			_animationMode.addEventListener(CustomizeEvent.AnimationStart, onStartAnimation);
			_animationMode.addEventListener(CustomizeEvent.AnimationStop, onStopAnimation);
			_animationMode.addEventListener(CustomizeEvent.SpriteDelete, onDeleteSheet);
			_animationMode.addEventListener(CustomizeEvent.SpeedChange, onChangeSpeed);
			
			_imageMode = new ImageMode();
			_imageMode.x = 370;
			_imageMode.y = 550;
			_imageMode.visible = false;
			_imageMode.addEventListener(CustomizeEvent.ImageChange, onChangeImage);
			_imageMode.addEventListener(CustomizeEvent.SaveComplete, onCompleteSave);
			_imageMode.addEventListener(CustomizeEvent.ImageAdd, onCompleteAdd);
			_imageMode.addEventListener(CustomizeEvent.PackingComplete, onCompletePack);
			
			_display = new Display(650, 500);
			_display.x = 25;
			_display.y = 25;
			_display.addEventListener(TouchEvent.TOUCH, onClickDispaly);
			
			_SpriteSheetDrop = new Dropdownbar(150, Texture.fromBitmap(Resource.resources["dropdown.png"] as Bitmap), Texture.fromBitmap(Resource.resources["arrowUp.png"] as Bitmap), Texture.fromBitmap(Resource.resources["arrowDown.png"] as Bitmap));
			_SpriteSheetDrop.x = 10;
			_SpriteSheetDrop.y = 590;
			_SpriteSheetDrop.addEventListener(CustomizeEvent.ListChange, onChangeSprite);
			
			trace(stage.width);
			addChild(_content);
			_content.addChild(_display);
			_content.addChild(_loadeButton);
			_content.addChild(_animationButton);
			_content.addChild(_imageButton);
			_content.addChild(_animaionText);
			_content.addChild(_imageText);
			_content.addChild(_animationMode);
			_content.addChild(_imageMode);
			_content.addChild(_SpriteSheetDrop);
			
			Resource.resources = null;		//리소스를 사용이 끝나고나면 메모리를 풀어줌
			System.gc();
			trace(this.x);
			trace(this.y);
			trace(flash.display.Screen.mainScreen.bounds);
			trace(stage.bounds);
			
		//	_animationButton.dispatchEvent(new Event(Event.TRIGGERED));
			this.alignPivot();
			
			this.x = flash.display.Screen.mainScreen.bounds.width / 2;
			this.y = flash.display.Screen.mainScreen.bounds.height / 2;
			
			this.width = flash.display.Screen.mainScreen.bounds.width /11 * 10 //- (flash.display.Screen.mainScreen.bounds.width / 14);
			this.height = flash.display.Screen.mainScreen.bounds.height /11 * 10 //- (flash.display.Screen.mainScreen.bounds.height / 14);
		}
		
		private function onSelectDialog(event:Event):void
		{
			trace("bbbbbb");
		}
		
		private function onClciBackButton(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				dialogExtension.showAlertDialog("종료?");
				trace("aa");
			}
		}
		
		/**
		 *현재 보고있는 SpriteSheet를 목록에서 삭제합니다. 
		 * @param event
		 * 
		 */		
		private function onDeleteSheet(event:Event):void
		{
			var messageBox:MessageBox = new MessageBox();
			if(_SpriteSheetDrop.currentSelectList.text == "")
				messageBox.showMessageBox("Delete Fail", 120, _display, Color.RED);
			else
				messageBox.showMessageBox("Delete Sheet", 120, _display, Color.RED);
			_spriteSheets[_SpriteSheetDrop.currentSelectList.text] = null;
			_SpriteSheetDrop.deleteList(_SpriteSheetDrop.currentSelectList.text);
			_SpriteSheetDrop.currentSelectList.text = "";
			_imageMode.spriteSheet = null;
			_display.stopAnimation();
			_display.spriteSheet = null;
		//	toastExtension.toast("삭제");
			dialogExtension.showGallery("기똥차게 넘어감");
		}
		
		private function onClickDispaly(event:TouchEvent):void
		{
			if(_display.mode == RadioKeyValue.IMAGE)
			{
				if(event.getTouch(_display, TouchPhase.BEGAN) != null)
				{
					_display.expansionImage();
				}
				
				if(event.getTouch(_display, TouchPhase.ENDED) != null)
				{
					_display.reduceImage();
				}
			}
		}
		
		/**
		 *현재 보고있는 에니메이션화면을 정지합니다. 
		 * @param event
		 * 
		 */		
		private function onStopAnimation(event:Event):void
		{
			_display.stopAnimation();
		}
		
		/**
		 *현재 선택되어있는 SpriteSheet의 에니메이션을 시작합니다. 
		 * @param event
		 * 
		 */		
		private function onStartAnimation(event:Event):void
		{
			_display.startAnimation();
		}
		
		private function onChangeSpeed(event:Event):void
		{
			_display.changeSpeed(event.data as int);
		}
		
		/**
		 *ImageMode에서 이미지추가에대한 결과보고를 받게되는 함수입니다.
		 * @param event
		 * 
		 */		
		private function onCompleteAdd(event:Event):void
		{
			var messageBox:MessageBox = new MessageBox();
			if(event.data == "Full")
				messageBox.showMessageBox("Not Enough Space", 120, _display, Color.RED);
			else if(event.data == "Used")
				messageBox.showMessageBox("Image Already Added", 120, _display, Color.RED);
			else if(event.data == "Success")
				messageBox.showMessageBox("Image Add", 120, _display);
			else
				messageBox.showMessageBox(event.data as String, 120, _display);
		}
		
		/**
		 *ImageMode에서 패킹에대한 결과보고를 받게되는 함수입니다.
		 * @param event
		 * 
		 */		
		private function onCompletePack(event:Event):void
		{
			var messageBox:MessageBox = new MessageBox();
			messageBox.showMessageBox("Complete Packing", 120, _display);
		}
		
		/**
		 *ImageMode에서 이미지가 변경됬을 때 호출되는 함수입니다. evnet와 함께 날아오는 data는 변경된 이미지의 이름입니다.
		 * @param event
		 * 
		 */		
		private function onChangeImage(event:Event):void
		{
			_display.viewImage(event.data as String);
		}
		
		/**
		 *ImageMode에서 현재보고있는 이미지에 대한 저장이 성공했을 때 호출되는 함수입니다. 
		 * @param event
		 * 
		 */		
		private function onCompleteSave(event:Event):void
		{
			var messageBox:MessageBox = new MessageBox();
			messageBox.showMessageBox("Save Complete", 120, _display);
		}
		
		/**
		 *_SpriteSheetDrop에서 SpriteSheet가 선택되었을 때 호출되는 함수입니다.
		 * _display와 _imageMode에 해당 스프라이트시트를 연결해줍니다. 
		 * @param event
		 * 
		 */		
		private function onChangeSprite(event:Event):void
		{
			_display.spriteSheet = _spriteSheets[Dropdownbar(event.currentTarget).currentSelectList.text];
			_imageMode.spriteSheet = _spriteSheets[Dropdownbar(event.currentTarget).currentSelectList.text];
		}
		
		/**
		 *_radioManager에 속해있는 버튼들 중 하나의 버튼이 클릭되면 호출되는 함수입니다.
		 * @param event
		 * 
		 */		
		private function onChangeMode(event:Event):void
		{
			_display.mode = _radioManager.mode;
			if(_display.mode == RadioKeyValue.ANIMATION)
			{
				_imageMode.visible = false;
				_animationMode.visible = true;
			}
			else if(_display.mode == RadioKeyValue.IMAGE)
			{
				_animationMode.visible = false;
				_imageMode.visible = true;
				_display.stopAnimation();
			}
		}
		
		/**
		 *SpriteLoad버튼이 눌렀을 때 호출되는 함수입니다. 
		 * @param event
		 * 
		 */		
		private function onClickLoadButton(event:Event):void
		{
			var spriteLoader:SpriteLoader = new SpriteLoader(completeLoad, uncompleteLoad);
		}
		
		/**
		 *spriteLoader가 로딩을 완료하게되면 호출되는 함수입니다.
		 * 로드된 png파일의 이름과 비트맵, xml파일로 새로운 SpriteSheet객체를 생성합니다.
		 * @param name
		 * @param loadSprite
		 * @param loadXml
		 * 
		 */		
		private function completeLoad(name:String, loadSprite:Bitmap, loadXml:XML):void
		{
			var messageBox:MessageBox = new MessageBox();
			if(_spriteSheets[name] == null)
			{
				var spriteSheet:SpriteSheet = new SpriteSheet(name, loadSprite, loadXml);
				_spriteSheets[name] = spriteSheet;
				_SpriteSheetDrop.createList(name);
				messageBox.showMessageBox("Load Success", 120, _display);
			}
			else
			{
				messageBox.showMessageBox("Already Added", 120, _display, Color.RED);
			}
		}
		
		private function uncompleteLoad(errorMessage:String):void
		{
			var messageBox:MessageBox = new MessageBox();
			messageBox.showMessageBox(errorMessage, 120, _display, Color.RED);
		}
	}
}