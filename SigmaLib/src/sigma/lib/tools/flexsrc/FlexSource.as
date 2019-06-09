package sigma.lib.tools.flexsrc
{
	import flash.filesystem.File;
	
	import sigma.lib.utils.FileUtil;
	import sigma.lib.utils.StringUtil;

	internal class FlexSource implements IFlexSource
	{
		private static const CHARSET_SOURCE: String = "utf-8";
		
		public var packageName: String;
		public var className: String;
		
		public function FlexSource(packageName: String, className: String)
		{
			this.packageName = packageName;
			this.className = className;
		}
		
		public function get sourceCode(): String
		{
			throw new Error("to be overrided!");
			return null;
		}
		
		public function get fullClassName(): String
		{
			if (packageName)
			{
				return packageName + "." + className;
			}
			return className;
		}
		
		public function exportFile(sourceHome: String): String
		{
			var filePath: String = sourceHome + File.separator + 
								   StringUtil.replaceAll(fullClassName, ".", File.separator) + ".as";
			if (FileUtil.writeText(filePath, this.sourceCode, CHARSET_SOURCE))
			{
				return filePath;
			}
			return null;
		}
	}
}