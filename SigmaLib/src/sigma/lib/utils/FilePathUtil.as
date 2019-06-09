package sigma.lib.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileReference;
	
	public class FilePathUtil
	{
		public static function getDirectory(filePath: String): String
		{
			return filePath.substring(0, filePath.lastIndexOf(File.separator));
		}
		
		public static function getFileName(filePath: String): String
		{
			return filePath.substr(filePath.lastIndexOf(File.separator) + 1);
		}
		
		public static function getFileMainName(filePath: String): String
		{
			return getMainName(getFileName(filePath));
		}
		
		public static function getFileExtension(filePath: String): String
		{
			return getExtension(getFileName(filePath));
		}
		
		public static function getMainName(fileName: String): String
		{
			return fileName.substring(0, fileName.lastIndexOf("."));
		}
		
		public static function getExtension(fileName: String): String
		{
			return fileName.substr(fileName.lastIndexOf(".") + 1);
		}
		
		public static function isValid(filePath: String): Boolean
		{
			try
			{
				new File(filePath);
				return true;
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public static function replaceExtension(filePath: String, extension: String): String
		{
			var prefix: String = filePath.substring(0, filePath.lastIndexOf("."));
			return prefix + "." + extension;
		}
		
		public static function doubleSeperator(filePath: String): String
		{
			return StringUtil.replaceAll(filePath, "\\", "\\\\");
		}
		
		public static function boundParenthesis(filePath: String): String
		{
			return "\"" + filePath + "\"";
		}
	}
}