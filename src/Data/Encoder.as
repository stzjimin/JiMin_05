package Data
{
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class Encoder
	{
		private const binaryReg:RegExp = new RegExp("^10*$", "m");
		
		private var _filePath:String;
		
		public function Encoder()
		{
		}
		
		/**
		 *인코드되어 만들어지는 파일이 저장되는 경로를 설정하는 함수입니다. 
		 * @param filePath
		 * 
		 */		
		public function setFilePath(filePath:String):void
		{
			_filePath = filePath;
		}
		
		/**
		 *인자로 받은 PackedData로 한쌍의 png파일과 xml파일을 생성하는 함수입니다. 
		 * @param packedData
		 * 
		 */		
		public function encode(packedData:PackedData):void
		{
			getXmlEncode(packedData);
			getPngEncode(packedData);
		}
		
		/**
		 *PackedData를 가지고 xml파일 하나를 만드는 함수입니다. 
		 * @param packedData
		 * 
		 */		
		private function getXmlEncode(packedData:PackedData):void
		{
			var localXmlFile:File = File.desktopDirectory.resolvePath(_filePath + ".xml");
			var fileAccess:FileStream = new FileStream();
			
			var maxWidth:int = 0;
			var maxHeight:int = 0;
			
			fileAccess.open(localXmlFile, FileMode.WRITE);
			fileAccess.writeUTFBytes("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
			fileAccess.writeUTFBytes("<TextureAtlas ImagePath=\"" + localXmlFile.name.replace(".xml",".png") + "\">\n");
			for(var i:int = 0; i < packedData.packedImageQueue.length; i ++)
			{
				var image:ImageInfo = packedData.packedImageQueue[i];
				fileAccess.writeUTFBytes("<SubTexture name=\"" + image.name + "\" x=\"" + image.x + "\" y=\"" + image.y + "\" width=\"" + image.width + "\" height=\"" + image.height + "\"/>\n");
				if(image.x+image.width > maxWidth)
					maxWidth = image.x+image.width;
				if(image.y+image.height > maxHeight)
					maxHeight = image.y+image.height;
			}
			packedData.width = maxWidth;
			packedData.height = maxHeight;
			fileAccess.writeUTFBytes("</TextureAtlas>");
			fileAccess.close();
		}
		
		/**
		 *PackedData를 가지고 png파일 하나를 만드는 함수입니다. 
		 * @param packedData
		 * 
		 */		
		private function getPngEncode(packedData:PackedData):void
		{
			var bitmapData:BitmapData = packedData.bitmapData;
			var byteArray:ByteArray = new ByteArray();
			
			var binary:String = packedData.width.toString(2);
			if(!binary.match(binaryReg))
				packedData.width = Math.pow(2,binary.length);
			
			binary = packedData.height.toString(2);
			if(!binary.match(binaryReg))
				packedData.height = Math.pow(2,binary.length);
			
			bitmapData.encode(new Rectangle(0, 0, packedData.width, packedData.height), new PNGEncoderOptions(), byteArray);
			
			var localPngFile:File = File.desktopDirectory.resolvePath(_filePath + ".png");
			var fileAccess:FileStream = new FileStream();
			fileAccess.open(localPngFile, FileMode.WRITE);
			fileAccess.writeBytes(byteArray, 0, byteArray.length);
			fileAccess.close();
		}
	}
}