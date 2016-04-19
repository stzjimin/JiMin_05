package Data
{
	import flash.display.BitmapData;

	public class PackedData
	{
		private var _bitmapData:BitmapData;
		private var _packedImageQueue:Vector.<ImageInfo>;
		private var _width:int;
		private var _height:int;
		
		public function PackedData(width:int, height:int)
		{
			_packedImageQueue = new Vector.<ImageInfo>();
			_bitmapData = new BitmapData(width, height);
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}

		public function get packedImageQueue():Vector.<ImageInfo>
		{
			return _packedImageQueue;
		}

		public function set packedImageQueue(value:Vector.<ImageInfo>):void
		{
			_packedImageQueue = value;
		}
	}
}