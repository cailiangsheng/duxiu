package sigma.lib.utils
{
	import flash.system.Capabilities;
	
	public class SystemUtil
	{
		private static const Windows: String = "WIN";
		private static const Linux: String = "LNX";
		private static const Macintosh: String = "MAC";
		private static const Android: String = "AND";
		private static const iOS: String = "IOS";
		
		private static function get os(): String
		{
			return Capabilities.version.substr(0, 3);
		}
		
		public static function get isWindows(): Boolean
		{
			return os == Windows;
		}

		public static function get isLinux(): Boolean
		{
			return os == Linux;
		}
		
		public static function get isMacintosh(): Boolean
		{
			return os == Macintosh;
		}
		
		public static function get isAndroid(): Boolean
		{
			return os == Android;
		}
		
		public static function get isIOS(): Boolean
		{
			return os == iOS;
		}
		
		public static function get isApple(): Boolean
		{
			return isIOS || isMacintosh;
		}
		
		public static function get isMobile(): Boolean
		{
			return isAndroid || isIOS;
		}
	}
}