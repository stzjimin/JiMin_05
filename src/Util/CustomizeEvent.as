package Util
{
	public class CustomizeEvent
	{
		private static const _PngLoadFail:String = "PngLoadFail";
		private static const _XmlLoadFail:String = "XmlLoadFail";
		private static const _AnimationStart:String = "StartAnimation";
		private static const _AnimationStop:String = "StopAnimation";
		private static const _SpriteDelete:String = "SpriteDelete";
		private static const _ImageChange:String = "ImageChange";
		private static const _SaveComplete:String = "CompleteSave";
		private static const _ImageAdd:String = "ImageAdd";
		private static const _PackingComplete:String = "CompletePack";
		private static const _ListChange:String = "ListChange";
		private static const _ModeChange:String = "ModeChange";
		private static const _SpeedChange:String = "SpeedChange";
		
		public function CustomizeEvent()
		{
		}

		public static function get SpeedChange():String
		{
			return _SpeedChange;
		}

		public static function get ModeChange():String
		{
			return _ModeChange;
		}

		public static function get ListChange():String
		{
			return _ListChange;
		}

		public static function get PackingComplete():String
		{
			return _PackingComplete;
		}

		public static function get ImageAdd():String
		{
			return _ImageAdd;
		}

		public static function get SaveComplete():String
		{
			return _SaveComplete;
		}

		public static function get ImageChange():String
		{
			return _ImageChange;
		}

		public static function get SpriteDelete():String
		{
			return _SpriteDelete;
		}

		public static function get AnimationStop():String
		{
			return _AnimationStop;
		}

		public static function get AnimationStart():String
		{
			return _AnimationStart;
		}

		public static function get XmlLoadFail():String
		{
			return _XmlLoadFail;
		}

		public static function get PngLoadFail():String
		{
			return _PngLoadFail;
		}

	}
}