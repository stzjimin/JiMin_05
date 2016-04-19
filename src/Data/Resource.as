package Data
{
	import flash.utils.Dictionary;

	public class Resource
	{
		private static var _resources:Dictionary = new Dictionary();
		
		/**
		 *리소스를 가지고있는 클래스입니다.
		 * 접근의 편리성을 위해 따로 클래스를 분리한 후 static변수의 리소스만을 가지고있게 했습니다. 
		 * 
		 */		
		public function Resource()
		{
		}

		public static function get resources():Dictionary
		{
			return _resources;
		}

		public static function set resources(value:Dictionary):void
		{
			_resources = value;
		}

	}
}