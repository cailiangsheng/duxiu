package sigma.lib.utils
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	
	public class AIRUtil
	{
		private static var ms_version: Array;
		
		private static const Major: int = 0;
		private static const Minor: int = 1;
		private static const Build: int = 2;
		
		private static function version(): Array
		{
			if (ms_version == null)
			{
				var v: String = NativeApplication.nativeApplication.runtimeVersion;
				ms_version = v.split(".");
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
		
		public static function get patchLevel(): uint
		{
			return NativeApplication.nativeApplication.runtimePatchLevel;
		}
		
		public static function get supporteNativeProcess(): Boolean
		{
			return NativeProcess.isSupported;
		}
	}
}