package Data
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class SpriteLoader
	{
		private var _spritePath:String;
		
		private var _spriteSheet:Bitmap;
		private var _xml:XML;
		private var _name:String;
		
		private var _completeFunc:Function;
		private var _failFunc:Function;
		
		private var _eventDispatcher:IEventDispatcher;
		private var _dialogExtension:DialogExtension;
		
		public function SpriteLoader(completeFunc:Function, failFunc:Function)
		{
			_dialogExtension = new DialogExtension(_eventDispatcher);
			_completeFunc = completeFunc;
			_failFunc = failFunc;
			_dialogExtension.showGallery(onImagePicked);
		}
		
		private function onImagePicked(data:String):void
		{
			var file:File = new File(data);
			onInputPNG(file.url, file.name);
		}

		/**
		 *사용자가 선택한 png파일을 로드하는 함수입니다. 
		 * @param filePath
		 * @param fileName
		 * 
		 */		
		private function onInputPNG(filePath:String, fileName:String):void
		{
			_name = fileName;
			_spritePath = filePath;
			var urlRequest:URLRequest = new URLRequest(_spritePath);
			var pngLoader:Loader = new Loader();
			pngLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompletePngLoad);
			pngLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, uncaughtPngError);
			pngLoader.load(urlRequest);
		}
		
		/**
		 *PNG로더의 IO애러시 호출될 함수 
		 * @param event
		 * 
		 */		
		private function uncaughtPngError(event:IOErrorEvent):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onCompletePngLoad);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtPngError);
			event.currentTarget.loader.unload();
			_failFunc("PNG File unLoaded");
		}
		
		/**
		 *png파일이 로드가 끝나면  Bitmap을 저장한 뒤 xml파일을 로드합니다.
		 * 이 때 xml파일은 png파일과 같은이름을 가져야 하며 그러지 않을경우 로드가 되지 않습니다.
		 * @param event
		 * 
		 */		
		private function onCompletePngLoad(event:Event):void
		{
			_spriteSheet = event.currentTarget.loader.content as Bitmap;
			event.currentTarget.removeEventListener(Event.COMPLETE, onCompletePngLoad);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtPngError);
			event.currentTarget.loader.unload();
			
			var urlRequest:URLRequest = new URLRequest(_spritePath.replace("png","xml"));
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener("complete", onCompleteXmlLoad);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, uncaughtXmlError);
			xmlLoader.load(urlRequest);
		}
		
		/**
		 *XML로더의 IO애러시 호출될 함수 
		 * @param event
		 * 
		 */		
		private function uncaughtXmlError(event:IOErrorEvent):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onCompleteXmlLoad);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtXmlError);
			event.currentTarget.close();
			_failFunc("XML File unLoaded");
		}
		
		/**
		 *xml파일이 로드가됬을 때 호추되는 함수입니다.
		 * xml파일까지 로드가 끝나면 파일의 이름, 비트맵, xml파일을 반환해줍니다. 
		 * @param event
		 * 
		 */		
		private function onCompleteXmlLoad(event:Event):void
		{
			_xml = new XML(event.currentTarget.data);
			event.currentTarget.removeEventListener("complete", onCompleteXmlLoad);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtXmlError);
			event.currentTarget.close();
			_completeFunc(_name, _spriteSheet, _xml);
		}
	}
}