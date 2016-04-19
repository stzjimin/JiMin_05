package Data
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class ImageLoader
	{
		private const fileReg:RegExp = new RegExp("(.png|.jpg|.jpeg)$", "m");
		
		private var _completeFunc:Function;
		private var _failFunc:Function;
		private var _name:String;
		
		/**
		 *이미지파일을 로드하기위해 사용되는 클래스입니다. 
		 * @param completeFunc
		 * 
		 */		
		public function ImageLoader(completeFunc:Function, failFunc:Function)
		{
			_completeFunc = completeFunc;
			_failFunc = failFunc;
		}
		
		/**
		 *이미지로드를 할때에는 해당 이미지의 경로와 이름을 인자로 가져옵니다. 
		 * @param filePath
		 * @param fileName
		 * 
		 */		
		public function startImageLoad(filePath:String, fileName:String):void
		{
			_name = fileName;
			var urlRequest:URLRequest = new URLRequest(filePath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteImageLoad);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			loader.load(urlRequest);
		}
		
		/**
		 *로더의 IO애러시 호출될 함수 
		 * @param event
		 * 
		 */		
		private function uncaughtError(event:IOErrorEvent):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, onCompleteImageLoad);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			_failFunc("Image unLoaded");
		}
		
		/**
		 *이미지 로드가 완료되면 해당 이미지의 bitmap과 정보들을 가지고 ImageInfo객체를 생성합니다. 
		 * @param event
		 * 
		 */		
		private function onCompleteImageLoad(event:Event):void
		{
			var bitmap:Bitmap = event.currentTarget.loader.content as Bitmap;
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, uncaughtError);
			event.currentTarget.removeEventListener(Event.COMPLETE, onCompleteImageLoad);
			var imageInfo:ImageInfo = new ImageInfo();
			imageInfo.name = _name.replace(fileReg,"");
			imageInfo.x = bitmap.x;
			imageInfo.y = bitmap.y;
			imageInfo.width = bitmap.width;
			imageInfo.height = bitmap.height;
			_completeFunc(bitmap, imageInfo);
		}
	}
}