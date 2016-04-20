package Data
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import starling.utils.AssetManager;

	public class ResourceLoader
	{
		private const appReg:RegExp = new RegExp(/app:\//);
		
		private var _resources:Dictionary;
		private var _resourcePath:String;
		private var _assetsLoader:AssetManager;
		private var _libName:String;
		
		private var _assetLength:int = 1;
		private var _assetCounter:int = 0;
		
		private var _completeFunc:Function;
		
		private var _resourceURL:Vector.<String>;
		
		/**
		 *프로그램이 시작될 때 프로그램에서 필요한 리소스들을 로드해주는 클래스입니다.
		 * 리소스가 담겨져있는 폴더의 모든 이미지들을 가져온 후 _reasources에 저장해줍니다.
		 * @param libName
		 * @param completeFunc
		 * 
		 */		
		public function ResourceLoader(libName:String, completeFunc:Function)
		{
			_completeFunc = completeFunc;
			_libName = libName;
			_resourceURL = new Vector.<String>();
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/arrowDown.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/arrowUp.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/checkRadio.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/delete.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/dropdown.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/emptyRadio.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/imageAdd.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/load.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/packing.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/saveImage.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/start.png");
			_resourceURL.push("https://raw.githubusercontent.com/stzjimin/JiMin_04/master/bin-debug/GUI_resources/stop.png");
			_assetLength = _resourceURL.length;
		}
		public function loadResource(resources:Dictionary):void
		{
			_resources = resources;
			pushDict();
		}

		private function pushDict():void
		{
			for each(var rawAsset:String in _resourceURL)
			{
				var urlRequest:URLRequest = new URLRequest(rawAsset);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
				loader.load(urlRequest);
			}
		}
		
		/*
		public function ResourceLoader(libName:String, completeFunc:Function)
		{
			_completeFunc = completeFunc;
			_libName = libName;
		}
		
		public function loadResource(resources:Dictionary):void
		{
			_resources = resources;
			pushDict(File.applicationDirectory.resolvePath(_libName));
		}
		
		private function pushDict(...rawAssets):void
		{
			if(!rawAssets["isDirectory"])
				_assetLength = _assetLength + rawAssets.length - 1;
			for each(var rawAsset:Object in rawAssets)
			{
				if(rawAsset["isDirectory"])
					pushDict.apply(this, rawAsset["getDirectoryListing"]());
				else if(getQualifiedClassName(rawAsset) == "flash.filesystem::File")
				{
					var urlRequest:URLRequest = new URLRequest(decodeURI(rawAsset["url"]));
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
					loader.load(urlRequest);
				}
			}
		}
		*/
		
		/**
		 *이미지파일의 URL주소로 해당 이미지파일의 이름을 구하는 함수 
		 * @param rawAssetURL
		 * @return 
		 * 
		 */		
		private function getName(rawAssetURL:String):String
		{
			var fileName:String;
			
			fileName = rawAssetURL.replace(appReg,"").replace(_libName + "/","");
			
			return fileName;
		}
		
		/**
		 *로더의 IO애러시 호출될 함수 
		 * @param event
		 * 
		 */		
		private function uncaughtError(event:IOErrorEvent):void
		{
			trace("Please Check File!!");
			event.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoad);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			_assetCounter++;
		}
		
		/**
		 *로더가 개별 이미지의 로드를 했을 경우 호출될 함수 
		 * @param event
		 * 호출된 로더를 추적한 뒤 해당 로더가 가지고 있는 url과 content를 이용하여 BitmapImage객체 생성
		 */		
		private function onCompleteLoad(event:Event):void
		{
			trace(Bitmap(event.currentTarget.loader.content).name);
			_resources[getName(event.currentTarget.url)] = event.currentTarget.loader.content as Bitmap;
			event.currentTarget.removeEventListener(Event.COMPLETE, onCompleteLoad);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			_assetCounter++;
			
			trace(_assetCounter + " / " + _assetLength);
			if(_assetCounter == _assetLength)
				_completeFunc();
		}
	}
}