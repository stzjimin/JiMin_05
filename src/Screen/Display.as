package Screen
{
	import Data.SpriteSheet;
	
	import Util.RadioKeyValue;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class Display extends Sprite
	{
		private var _animationFrame:int = 10;
		
		private var _content:Sprite;
		private var _backGround:Quad;
		
		private var _mode:String = RadioKeyValue.ANIMATION;
		private var _spriteSheet:SpriteSheet;
		private var _spriteTexture:Texture;
		
		private var _width:int;
		private var _height:int;
		
		private var _currentImage:Image;
		private var _currentAnimation:Image;
		private var _currentAnimationName:TextField;
		
		private var _animationCounter:int;
		private var _frameCounter:int;
		
		/**
		 *화면에서 유저에게 보여지는 Display화면을 담당하는 클래스입니다. 
		 * @param width
		 * @param height
		 * 
		 */		
		public function Display(width:int, height:int)
		{
			_content = new Sprite();
			
			_width = width;
			_height = height;
			
			_backGround = new Quad(width, height);
			_backGround.color = Color.SILVER;
			
			_currentImage = new Image(null);
			_currentImage.pivotX = _currentImage.width / 2;
		 	_currentImage.pivotY = _currentImage.height / 2;
			_currentImage.x = _width / 2;
			_currentImage.y = _height / 2;
			_currentImage.width = 1;
			_currentImage.height = 1;
			_currentImage.visible = false;
			_currentImage.addEventListener(TouchEvent.TOUCH, onClickImage);
			
			_currentAnimation = new Image(null);
			_currentAnimation.pivotX = _currentAnimation.width / 2;
			_currentAnimation.pivotY = _currentAnimation.height / 2;
			_currentAnimation.x = _width / 2;
			_currentAnimation.y = _height / 2;
			_currentAnimation.width = 1;
			_currentAnimation.height = 1;
			_currentAnimation.visible = true;
			
			_currentAnimationName = new TextField(120, 20, "");
			_currentAnimationName.pivotX = _currentAnimationName.width / 2;
			_currentAnimationName.pivotY = _currentAnimationName.height / 2;
			_currentAnimationName.x = _width/6 * 5;
			_currentAnimationName.y = _height/6 * 5;
			_currentAnimationName.visible = true;
			
			addChild(_backGround);
			addChild(_content);
			_content.addChild(_currentImage);
			_content.addChild(_currentAnimation);
			_content.addChild(_currentAnimationName);
		}

		/**
		 *_spriteSheet가 변경될때 필요한 작업들은 setter로 넣었습니다. 
		 * @param value
		 * 
		 */		
		public function set spriteSheet(value:SpriteSheet):void
		{
			_spriteSheet = value;
			_animationCounter = 0;
			
			_currentImage.texture = null;
			_currentImage.width = 1;
			_currentImage.height = 1;
			
			_currentAnimation.texture = null;
			_currentAnimation.width = 1;
			_currentAnimation.height = 1;
			
			_currentAnimationName.text = "";
		}

		public function get mode():String
		{
			return _mode;
		}

		/**
		 *디스플레이모드의 디폴트는 "Animation"입니다. 
		 * @param value
		 * 
		 */		
		public function set mode(value:String):void
		{
			_mode = value
			if(value == RadioKeyValue.ANIMATION)
			{
				_currentImage.visible = false;
				_currentAnimation.visible = true;
				_currentAnimationName.visible = true;
			}
			else if(value == RadioKeyValue.IMAGE)
			{
				_currentAnimation.visible = false;
				_currentAnimationName.visible = false;
				_currentImage.visible = true;
			}
			else
			{
				_mode = RadioKeyValue.ANIMATION;
				_currentImage.visible = false;
				_currentAnimation.visible = true;
				_currentAnimationName.visible = true;
			}
		}
		
		/**
		 *이미지 모드상태에서 해당 이미지를 변경하는 함수입니다. 
		 * @param textureName
		 * 
		 */		
		public function viewImage(textureName:String):void
		{
			_currentImage.width = getLocalWidth(_spriteSheet.subTextures[textureName].width);
			_currentImage.height = getLocalHeight(_spriteSheet.subTextures[textureName].height);
			_currentImage.texture = _spriteSheet.subTextures[textureName];
		}
		
		public function changeSpeed(speed:int):void
		{
			_animationFrame = speed;
		}
		
		/**
		 *에니메이션을 정지시키면 _currentAnimation의 EnterFrame에 대한 이벤트리스너를 제거합니다. 
		 * 
		 */		
		public function stopAnimation():void
		{
			_currentAnimation.removeEventListener(Event.ENTER_FRAME, goAnimation);
		}
		
		/**
		 *에니메이션이 시작하게되면 _framCounter는 초기화시켜주고  _currentAnimation에 EnterFrame에 대한 이벤트리스너를 추가시켜줍니다.
		 * 
		 */		
		public function startAnimation():void
		{
			if(_spriteSheet != null)
			{
				_frameCounter = 0;
				_currentAnimation.addEventListener(Event.ENTER_FRAME, goAnimation);
			}
		}
		
		/**
		 *_currentAnimation이 EnterFrame에 대한 이벤트리스너가 있을 때 EnterFrame이 될 때 마다 실행되는 함수입니다.
		 * 한번실행될때 마다 _frameCounter를 증가시켜주고 AnimaitonFrame에 도달하면 changeAnimation을 실행시키고 _frameCounter를 초기화시켜줍니다.
		 * @param event
		 * 
		 */		
		private function goAnimation(event:Event):void
		{
			_frameCounter++;
			if(_frameCounter >= _animationFrame)
			{
				changeAnimation();
				_frameCounter = 0;
			}
		}
		
		/**
		 *_currentAnimation의 텍스쳐를 다음 텍스쳐로 전환해줍니다.
		 * _animationCounter가 _spriteSheet에 있는 이미지의 개수만큼 증가했다면 애니메이션을 종료시켜줍니다.
		 * 
		 */		
		private function changeAnimation():void
		{
			_currentAnimation.texture = _spriteSheet.subTextures[_spriteSheet.images[_animationCounter].name];
			_currentAnimation.width = getLocalWidth(_spriteSheet.subTextures[_spriteSheet.images[_animationCounter].name].width);
			_currentAnimation.height = getLocalHeight(_spriteSheet.subTextures[_spriteSheet.images[_animationCounter].name].height);
			_currentAnimationName.text = _spriteSheet.images[_animationCounter].name;
			_animationCounter++;
			if(_animationCounter >= _spriteSheet.images.length)
			{
				_animationCounter = 0;
				_currentAnimation.removeEventListener(Event.ENTER_FRAME, goAnimation);
			}
		}
		
		/**
		 *Display가 이미지모드일 때 이미지가 클릭되면 호출되는 함수입니다.
		 * 이미지가 클릭되있는 동안 이미지는 고정크기로 전환됩니다. 
		 * @param event
		 * 
		 */		
		private function onClickImage(event:TouchEvent):void
		{
			if(event.getTouch(_currentImage, TouchPhase.BEGAN) != null)
			{
				_currentImage.width = 300;
				_currentImage.height = 400;
			}
			
			if(event.getTouch(_currentImage, TouchPhase.ENDED) != null)
			{
				_currentImage.width = getLocalWidth(_currentImage.texture.width);
				_currentImage.height = getLocalHeight(_currentImage.texture.height);
			}
		}
		
		/**
		 * Display창에 비례하여 이미지의 알맞은 길이를 계산하는 함수입니다.
		 * @param width
		 * @return 
		 * 
		 */		
		private function getLocalWidth(width:Number):Number
		{
			return width*_width / 1024;
		}
		/**
		 * Display창에 비례하여 이미지의 알맞은 높이를 계산하는 함수입니다.
		 * @param height
		 * @return 
		 * 
		 */		
		private function getLocalHeight(height:Number):Number
		{
			return height*_height / 1024;
		}
	}
}