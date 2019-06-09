package sigma.lib.utils
{
	import flash.system.Capabilities;
	
	public class FlashPlayerUtil
	{
		private static var ms_version: Array;
		
		private static const Major: int = 0;
		private static const Minor: int = 1;
		private static const Build: int = 2;
		private static const InternalBuild: int = 3;
		
		private static function get version(): Array
		{
			if (ms_version == null)
			{
				var v: String = Capabilities.version;
				ms_version = v.substring(v.indexOf(" ") + 1).split(",");
			}
			return ms_version;
		}
		
		public static function get mainVersion(): Number
		{
			return majorVersion + minorVersion / 10;
		}
		
		public static function get majorVersion(): uint
		{
			return parseInt(version[Major]);
		}
		
		public static function get minorVersion(): uint
		{
			return parseInt(version[Minor]);
		}
		
		public static function get buildVersion(): uint
		{
			return parseInt(version[Build]);
		}
		
		public static function get internalBuildVersion(): uint
		{
			return parseInt(version[InternalBuild]);
		}
		
		public static function get isFP11(): Boolean
		{
			return majorVersion == 11;
		}
		
		public static function get isFP10(): Boolean
		{
			return majorVersion == 10;
		}
		
		public static function get isFP9(): Boolean
		{
			return majorVersion == 9;
		}
		
		public static function get debug(): Boolean
		{
			return Capabilities.isDebugger;
		}
	}
}