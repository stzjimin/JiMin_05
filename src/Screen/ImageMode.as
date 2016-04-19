package Screen
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import Component.ButtonObject;
	import Component.Dropdownbar;
	import Data.Encoder;
	import Data.FileIOManager;
	import Data.ImageInfo;
	import Data.ImageLoader;
	import Data.PackedData;
	import Data.Packer;
	import Data.Resource;
	import Data.SpriteSheet;
	import Util.CustomizeEvent;

	public class ImageMode extends Sprite
	{	
		private var _imageSelectBar:Dropdownbar;
		private var _imageAddButton:ButtonObject;
		private var _imageSaveButton:ButtonObject;
		private var _currentSaveButton:ButtonObject;
		
		private var _spriteSheet:SpriteSheet;
		
		/**
		 *이미지모드와 관련된 일들을 담당하는 클래스입니다.
		 * 이미지모드는 1개의 드롭다운바와 3개의 버튼으로 구성됩니다.
		 * 각각 이미지리스트, 이미지추가, 이미지저장, 현재상태패킹을 담당합니다. 
		 * 
		 */		
		public function ImageMode()
		{
			_imageSelectBar = new Dropdownbar(150, Texture.fromBitmap(Resource.resources["dropdown.png"] as Bitmap), Texture.fromBitmap(Resource.resources["arrowUp.png"] as Bitmap), Texture.fromBitmap(Resource.resources["arrowDown.png"] as Bitmap));
			_imageSelectBar.y = 10;
			_imageSelectBar.addEventListener(CustomizeEvent.ListChange, onChangeImage);
			
			_imageAddButton = new ButtonObject(Texture.fromBitmap(Resource.resources["imageAdd.png"] as Bitmap));
			_imageAddButton.width = 40;
			_imageAddButton.height = 40;
			_imageAddButton.x = 170;
			_imageAddButton.addEventListener(Event.TRIGGERED, onClickedAddButton);
			
			_imageSaveButton = new ButtonObject(Texture.fromBitmap(Resource.resources["saveImage.png"] as Bitmap));
			_imageSaveButton.width = 40;
			_imageSaveButton.height = 40;
			_imageSaveButton.x = 220;
			_imageSaveButton.addEventListener(Event.TRIGGERED, onClickedSaveButton);
			
			_currentSaveButton = new ButtonObject(Texture.fromBitmap(Resource.resources["packing.png"] as Bitmap));
			_currentSaveButton.width = 40;
			_currentSaveButton.height = 40;
			_currentSaveButton.x = 270;
			_currentSaveButton.addEventListener(Event.TRIGGERED, onClickedPackButton);
			
			addChild(_imageSelectBar);
			addChild(_imageAddButton);
			addChild(_imageSaveButton);
			addChild(_currentSaveButton);
		}
		
		/**
		 *_spriteSheet가 변경될때 필요한 작업들을 setter에서 같이 해줍니다. 
		 * @param value
		 * 
		 */		
		public function set spriteSheet(value:SpriteSheet):void
		{
			_spriteSheet = value;
			_imageSelectBar.currentSelectList.text = "";
			setImages();
		}
		
		/**
		 *_spriteSheet의 images를 이용하여 스프라이트시트안에 있는 SubTexture의 이름들을 _imageSelectBar의 리스트로 추가시켜줍니다. 
		 * 
		 */		
		private function setImages():void
		{
			_imageSelectBar.initList();
			if(_spriteSheet != null)
			{
				for(var i:int = 0; i < _spriteSheet.images.length; i++)
					_imageSelectBar.createList(_spriteSheet.images[i].name);
			}
			_imageSelectBar.refreshList();
		}
		
		/**
		 *_imageSelectBar의 리스트에서 이미지가 선택되었을때 호출되는 함수입니다.
		 * 이객체에서 "ImageChange"라는 이벤트를 발생시켜주며  data로 교체된 리스트의 이름을 보내줍니다. 
		 * @param event
		 * 
		 */		
		private function onChangeImage(event:Event):void
		{
			dispatchEvent(new Event(CustomizeEvent.ImageChange, false, _imageSelectBar.currentSelectList.text));
		}
		
		/**
		 *이미지추가 버튼이 눌려졌을 때 호출되는 함수입니다.
		 * FileIOManager클래스를 통해서 파일선택창을 띄워주며 파일 선택이 완료되면 onLoadedImage함수를 호출합니다.
		 * @param event
		 * 
		 */		
		private function onClickedAddButton(event:Event):void
		{
			if(_spriteSheet != null)
			{
				var fileManager:FileIOManager = new FileIOManager();
				var imageFileFilter:FileFilter = new FileFilter("Images","*.jpg;*.png");
				fileManager.selectFile("이미지를 선택하세요", imageFileFilter, onLoadedImage);
			}
		}
		
		/**
		 *이미지파일선택이 완료되면 호출되는 함수입니다.
		 * ImageLoader를 이용하여 해당파일을 로드해줍니다.
		 * 로드가 완료되면 onCompleteLoad함수를 호출해줍니다.
		 * @param filePath
		 * @param fileName
		 * 
		 */		
		private function onLoadedImage(filePath:String, fileName:String):void
		{
			var imageLoader:ImageLoader = new ImageLoader(completeLoad, uncompleteLoad);
			imageLoader.startImageLoad(filePath, fileName);
		}
		
		/**
		 *imageLoader로 부터 파일이 로드가 완료되면 호출되는 함수입니다.
		 * 인자로받은 bitmap과 ImageInfo를 이용하여 _spriteSheet에 해당 이미지를 추가하며 여유공간이 충분한지 여부를 판단합니다.
		 * 여유공간이 충분하다면 packer에 있는 currentPackedData를 가져오고, 충분하지 않다면 ImageAdd이벤트에 Full이라는 data를 반환해줍니다.
		 * 이미지 여유공간을 검사하기전 해당 이미지가 이미 _spriteSheet에 추가되어있는 이미지라면 곧바로 ImageAdd이벤트에 Used를 data로 반환하며 함수를 종료시켜줍니다.
		 * @param bitmap
		 * @param imageInfo
		 * 
		 */		
		private function completeLoad(bitmap:Bitmap, imageInfo:ImageInfo):void
		{
			if(_spriteSheet.subTextures[imageInfo.name] != null)
			{
				dispatchEvent(new Event(CustomizeEvent.ImageAdd, false, "Used"));
				return;
			}
			var packer:Packer = new Packer();
			packer.initPacker(_spriteSheet);
			trace(imageInfo.x + ", " + imageInfo.y);
			if(packer.addImage(bitmap, imageInfo))
			{
				_spriteSheet.images.push(imageInfo);
				_spriteSheet.subTextures[imageInfo.name] = Texture.fromBitmap(bitmap);
				_spriteSheet.spriteBitmap.bitmapData = packer.currentPackedData.bitmapData;
				_imageSelectBar.createList(imageInfo.name);
				dispatchEvent(new Event(CustomizeEvent.ImageAdd, false, "Success"));
			}
			else
			{
				dispatchEvent(new Event(CustomizeEvent.ImageAdd, false, "Full"));
			}
		}
		
		private function uncompleteLoad(errorMessage:String):void
		{
			dispatchEvent(new Event(CustomizeEvent.ImageAdd, false, errorMessage));
		}
		
		/**
		 *패킹버튼을 눌렀을 때 호출되는 함수입니다.
		 * FileIOManager를 통하여 저장위치 및 이름선택장을 띄워줍니다.
		 * 선택이되면 onCompleteSaveSheet함수를 호출해줍니다. 
		 * @param event
		 * 
		 */		
		private function onClickedPackButton(event:Event):void
		{
			if(_spriteSheet != null)
			{
				var fileManager:FileIOManager = new FileIOManager();
				fileManager.saveFile("스프라이트 시트 저장", onCompleteSaveSheet);
			}
		}
		
		/**
		 *저장위치가 선택이되면 현재의 _spriteSheet상태를 인코드하여 한쌍의 png파일과 xml파일로 생성합니다.
		 * 생성이끝나면 "CompletePack"이벤트를 발생시켜줍니다. 
		 * @param filePath
		 * 
		 */		
		private function onCompleteSaveSheet(filePath:String):void
		{
			var packedData:PackedData = new PackedData(1024, 1024);
			packedData.bitmapData = _spriteSheet.spriteBitmap.bitmapData;
			packedData.packedImageQueue = _spriteSheet.images;
			var encoder:Encoder = new Encoder();
			encoder.setFilePath(filePath);
			encoder.encode(packedData);
			dispatchEvent(new Event(CustomizeEvent.PackingComplete));
		}
		
		/**
		 *이미지저장버튼을 눌렀을 때 호출되는 함수입니다.
		 * _imageSelectBar에 현재선택되어있는 리스트가 있다면 FileIOManager를 사용하여 저장위치 선택장을 띄워줍니다.
		 * 저장위치가 선택이되면 onCompleteSave함수를 호출합니다. 
		 * @param event
		 * 
		 */		
		private function onClickedSaveButton(event:Event):void
		{
			if(_imageSelectBar.currentSelectList.text != "")
			{
				var fileManager:FileIOManager = new FileIOManager();
				fileManager.saveFile("이미지 저장", onCompleteSave);
			}
		}
		
		/**
		 *이미지의 저장위치가 선택이되면 호출되는 함수입니다.
		 * 현재 _imageSelectBar에 선택되어있는 이미지에 대한 정보를 이용하여 새로운 png파일을 생성해줍니다.
		 * @param filePath
		 * 
		 */		
		private function onCompleteSave(filePath:String):void
		{
			var rect:Rectangle = searchImageRect(_imageSelectBar.currentSelectList.text);
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height);
			var byteArray:ByteArray = new ByteArray();
			bitmapData.copyPixels(_spriteSheet.spriteBitmap.bitmapData, rect, new Point(0, 0));
			bitmapData.encode(new Rectangle(0, 0, rect.width, rect.height), new PNGEncoderOptions(), byteArray);
			
			var localPngFile:File = File.desktopDirectory.resolvePath(filePath + ".png");
			var fileAccess:FileStream = new FileStream();
			fileAccess.open(localPngFile, FileMode.WRITE);
			fileAccess.writeBytes(byteArray, 0, byteArray.length);
			fileAccess.close();
			dispatchEvent(new Event(CustomizeEvent.SaveComplete));
		}
		
		/**
		 *인자로 받은 SubTexture의 이름을 이용하여 해당 텍스쳐가 아틀라스에서 어디에 위치해있는지 찾아내는 함수입니다. 
		 * @param subTextureName
		 * @return 
		 * 
		 */		
		private function searchImageRect(subTextureName:String):Rectangle
		{
			var rect:Rectangle = new Rectangle();
			for(var i:int = 0; i < _spriteSheet.images.length; i++)
			{
				if(_spriteSheet.images[i].name == subTextureName)
				{
					rect.x = _spriteSheet.images[i].x;
					rect.y = _spriteSheet.images[i].y;
					rect.width = _spriteSheet.images[i].width;
					rect.height = _spriteSheet.images[i].height;
				}
			}
			return rect;
		}
	}
}