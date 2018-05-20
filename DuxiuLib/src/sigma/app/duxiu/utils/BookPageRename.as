package sigma.app.duxiu.utils
{
	import flash.filesystem.File;
	
	import sigma.app.duxiu.data.BookPageType;
	import sigma.lib.utils.FileUtil;
	import sigma.lib.utils.StringUtil;

	public class BookPageRename
	{
		private static function doRename(dirPath: String, renameHanlder: Function): Boolean
		{
			try
			{
				var file: File = new File(dirPath);
				if (file.exists && file.isDirectory && Boolean(renameHanlder))
				{
					var subFiles: Array = file.getDirectoryListing();
					for each (var subFile: File in subFiles)
					{
						renameHanlder(subFile);
					}
				}
				return true;
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public static function originRenamePages(dirPath: String): Boolean
		{
			return doRename(dirPath, originRenamePage);
		}
		
		private static function originRenamePage(pageFile: File): void
		{
			var pageType: BookPageType = BookPageDefine.getPageTypeEx(pageFile.name);
			if (pageType && StringUtil.checkPrefix(pageFile.name, pageType.orderSymbol))
			{
				var newFileName: String = pageFile.name.replace(pageType.orderSymbol, pageType.originSymbol);
				FileUtil.renameFile(pageFile, newFileName, false);
			}
		}
		
		public static function orderRenamePages(dirPath: String): Boolean
		{
			return doRename(dirPath, orderRenamePage);
		}
		
		private static function orderRenamePage(pageFile: File): void
		{
			var pageType: BookPageType = BookPageDefine.getPageTypeEx(pageFile.name);
			if (pageType && StringUtil.checkPrefix(pageFile.name, pageType.originSymbol))
			{
				var newFileName: String = pageFile.name.replace(pageType.originSymbol, pageType.orderSymbol);
				FileUtil.renameFile(pageFile, newFileName, false);
			}
		}
	}
}