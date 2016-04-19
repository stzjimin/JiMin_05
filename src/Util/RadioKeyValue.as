package Util
{
	public class RadioKeyValue
	{
		private static const _ANIMATION:String = "Animation";
		private static const _IMAGE:String = "Image";
		
		/**
		 *라디오버튼이 가질수있는 키값들이 정의되어있는 클래스입니다. 
		 * 
		 */		
		public function RadioKeyValue()
		{
		}

		public static function get IMAGE():String
		{
			return _IMAGE;
		}

		public static function get ANIMATION():String
		{
			return _ANIMATION;
		}

	}
}