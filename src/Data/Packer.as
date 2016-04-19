package Data
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Packer
	{
		private const MaxWidth:int = 1024;
		private const MaxHeight:int = 1024;
		
		private var _dataQueue:Vector.<ImageInfo>;
		private var _sheetBitmapData:BitmapData;
		
		private var _currentPackedData:PackedData;
		
		private var _count:int;
		private var _spaceArray:Vector.<Rectangle>;
		
		/**
		 *Assignment_03에 있는 Packer클래스를 본따서 만든 클래스입니다.
		 * 기본적인 패킹방식은 같다고 보시면 됩니다. 
		 * 
		 */		
		public function Packer()
		{
			
		}
		
		public function get currentPackedData():PackedData
		{
			return _currentPackedData;
		}
		
		/**
		 *Packer클래스를 초기화시키는 함수입니다.
		 * 해당 함수가 호출되면 Packer는 패킹준비를 하게 됩니다.
		 * 이 때 인자로 입력받는 spriteSheet는 ImageMode에서 현재가지고있는 SpriteSheet입니다.
		 * @param spriteSheet
		 * 
		 */		
		public function initPacker(spriteSheet:SpriteSheet):void
		{
			_currentPackedData = new PackedData(MaxWidth, MaxHeight);
			_dataQueue = clone(spriteSheet.images);
			_sheetBitmapData = spriteSheet.spriteBitmap.bitmapData;
			
			_count = 0;
			_spaceArray = new Vector.<Rectangle>();
			var firstRect:Rectangle = new Rectangle(0, 0, MaxWidth, MaxHeight);
			
			_spaceArray.push(firstRect);
		}
		
		/**
		 *인자로 입력받은 bitmap과 addImageInfo를 이용하여 새롭게 추가되는 이미지가 있는채로 SpriteSheet를 패킹합니다.
		 * 이 때 기존의 이미지나 새롭게 추가되는 이미지가 들어갈 공간이 없다면 그 즉시 패킹은 종료되며 false를 반환합니다.
		 * @param addBitmap
		 * @param addImageInfo
		 * @return 
		 * 
		 */		
		public function addImage(addBitmap:Bitmap, addImageInfo:ImageInfo):Boolean
		{
			_dataQueue.push(addImageInfo);
			_dataQueue = _dataQueue.sort(orderPixels);
			var maxWidth:int = 0;
			var maxHeight:int = 0;
			while(_dataQueue.length != 0)
			{
				var image:ImageInfo = _dataQueue.shift();
				var nonFlag:Boolean = true;
				for(var i:int = 0; i < _spaceArray.length; i++)
				{
					if(_spaceArray[i].containsRect(new Rectangle(_spaceArray[i].x, _spaceArray[i].y, image.width, image.height)))
					{
						var point:Point = new Point(_spaceArray[i].x, _spaceArray[i].y);
						var imageRect:Rectangle = new Rectangle(image.x, image.y, image.width, image.height);
						if(addImageInfo.name != image.name)
							_currentPackedData.bitmapData.copyPixels(_sheetBitmapData, imageRect, point);
						else
							_currentPackedData.bitmapData.copyPixels(addBitmap.bitmapData, imageRect, point);
						image.x = imageRect.x = point.x;
						image.y = imageRect.y = point.y;
						_currentPackedData.packedImageQueue.push(image);
						searchIntersects(_spaceArray, imageRect);
						
						nonFlag = false;
						break;
					}
				}
				
				//추가하려는 이미지가  들어갈 수 있는 공간이 없을 경우
				if(nonFlag)
				{
					return false;
				}
				
				_spaceArray.sort(orderYvalue);	//여유공간을  y값으로 정렬하여 상대적으로 아래쪽에 있는 공간은 나중에 선택이 되도록 합니다
			}
			return true;
		}
		
		private function orderYvalue(space1:Rectangle, space2:Rectangle):int
		{
			if(space1.y < space2.y) 
			{ 
				return -1;
			} 
			else if(space1.y > space2.y)
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}
		
		private function searchIntersects(spaceArray:Vector.<Rectangle>, imageRect:Rectangle):void
		{
			for(var i:int = spaceArray.length-1; i >= 0; i--)
			{
				if(spaceArray[i].intersects(imageRect))
				{
					var inter:Rectangle = spaceArray[i].intersection(imageRect);
					var rect:Rectangle = spaceArray.removeAt(i);
					
					var leftRect:Rectangle = new Rectangle(rect.x, rect.y, (inter.x-rect.x), rect.height);
					if(leftRect.width > 0 && leftRect.height > 0)
						spaceArray.push(leftRect);
					var rightRect:Rectangle = new Rectangle((inter.x+inter.width), rect.y, (rect.x+rect.width-(inter.x+inter.width)), rect.height);
					if(rightRect.width > 0 && rightRect.height > 0)
						spaceArray.push(rightRect);
					var bottomRect:Rectangle = new Rectangle(rect.x, (inter.y+inter.height), rect.width, (rect.y+rect.height-(inter.y+inter.height)));
					if(bottomRect.width > 0 && bottomRect.height > 0)
						spaceArray.push(bottomRect);
					var topRect:Rectangle = new Rectangle(rect.x, rect.y, rect.width, (inter.y-rect.y));
					if(topRect.width > 0 && topRect.height > 0)
						spaceArray.push(topRect);
				}
			}
			removeContains(spaceArray);
		}
		
		private function removeContains(spaceArray:Vector.<Rectangle>):void
		{
			for(var i:int = spaceArray.length-1; i >= 0; i--)
			{
				for(var j:int = 0; j < spaceArray.length; j++)
				{
					if((spaceArray[j].containsRect(spaceArray[i])) && (i != j))
					{
						spaceArray.removeAt(i);
						break;
					}
				}
			}	
		}
		
		private function clone(source:Vector.<ImageInfo>):Vector.<ImageInfo>
		{
			var clone:Vector.<ImageInfo> = new Vector.<ImageInfo>;
			for(var i:int = 0; i < source.length; i++)
				clone[i] = source[i];
			return clone;
		}
		
		private function orderPixels(data1:ImageInfo, data2:ImageInfo):int
		{
			if(data1.width*data1.height > data2.width*data2.height) 
			{ 
				return -1;
			} 
			else if(data1.width*data1.height < data2.width*data2.height) 
			{ 
				return 1; 
			} 
			else 
			{ 
				return 0; 
			} 
		}
	}
}