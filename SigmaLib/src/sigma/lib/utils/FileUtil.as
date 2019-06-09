package sigma.lib.utils
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;

	public class FileUtil
	{
		public static function checkExist(filePath: String): Boolean
		{
			try
			{
				var file: File = new File(filePath);
				return file.exists;
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public static function checkEmptyDir(dirPath: String): Boolean
		{
			var dirFile: File = new File(dirPath);
			if (dirFile.isDirectory && dirFile.exists)
			{
				var subFiles: Array = dirFile.getDirectoryListing();
				return subFiles == null || subFiles && subFiles.length == 0;
			}
			return false;
		}
		
		public static function checkOverwritable(filePath: String): Boolean
		{
			try
			{
				var file: File = new File(filePath);
				if (file.exists)
				{
					var newFileName: String = file.name + ".bak";
					if (renameFile(file, newFileName, false))
					{
						var newFilePath: String = file.parent.nativePath + File.separator + newFileName;
						return renameFile(new File(newFilePath), file.name, false);
					}
				}
				else
				{
					return true;
				}
			}
			catch (e: Error)
			{}
			return false;
		}
		
		//-----------------------------------------------------------------------------------
		public static function readText(filePath: String, charset: String = "utf-8"): String
		{
			try
			{
				var file: File = new File(filePath);
				var fs: FileStream = new FileStream();
				fs.open(file, FileMode.READ);
				var text: String = fs.readMultiByte(fs.bytesAvailable, charset);
				fs.close();
				return text;
			}
			catch (e: Error)
			{}
			return null;
		}
		
		public static function writeText(filePath: String, text: String, charset: String): Boolean
		{
			try
			{
				var file: File = new File(filePath);
				
				var fs: FileStream = new FileStream();
				fs.open(file, FileMode.WRITE);
				fs.writeMultiByte(text, charset);
				fs.close();
				
				return true;
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public static function readBytes(filePath: String): ByteArray
		{
			try
			{
				var file: File = new File(filePath);
				var fs: FileStream = new FileStream();
				fs.open(file, FileMode.READ);
				var bytes: ByteArray = new ByteArray();
				fs.readBytes(bytes, 0, fs.bytesAvailable);
				fs.close();
				return bytes;
			}
			catch (e: Error)
			{}
			return null;
		}
		
		public static function writeBytes(filePath: String, bytes: ByteArray): Boolean
		{
			try
			{
				if (bytes)
				{
					var file: File = new File(filePath);
					var fs: FileStream = new FileStream();
					fs.open(file, FileMode.WRITE);
					fs.writeBytes(bytes);
					fs.close();
					return true;
				}
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public static function browseDir(dirPath: String): void
		{
			var request:URLRequest = new URLRequest(dirPath); 
			navigateToURL(request);
		}
		
		public static function exploreFile(filePath: String): Boolean
		{
			try
			{
				var file: File = new File(filePath);
				if (file.exists)
				{
					file.openWithDefaultApplication();
					return true;
				}
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public static function exploreDir(dirPath: String): Boolean
		{
			return exploreFile(dirPath);
		}
		
		public static function getDirPath(filePath: String): String
		{
			var index: int = filePath.lastIndexOf(File.separator);
			return filePath.substring(0, index);
		}
		
		//-----------------------------------------------------------------------------------
		public static function renameFile(file: File, newFileName: String, keepExtension: Boolean = true): Boolean
		{
			try
			{
				if (file && file.exists)
				{
					var dirPath: String = getDirPath(file.nativePath);
					var dirFile: File = new File(dirPath);
					var newFile: File = dirFile.resolvePath(newFileName + (keepExtension ? file.extension : ""));
					file.moveTo(newFile);
					return true;
				}
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public static function copyFile(srcPath: String, destPath: String, overwrite: Boolean): Boolean
		{
			try
			{
				if (srcPath.toLowerCase() != destPath.toLowerCase())
				{
					var srcFile: File = new File(srcPath);
					var destFile: File = new File(destPath);
					srcFile.copyTo(destFile, overwrite);
					return true;
				}
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public static function deleteFile(path: String): Boolean
		{
			try
			{
				var file: File = new File(path);
				file.deleteFile();
				return true;
			}
			catch (e: Error)
			{}
			return false;
		}
		
		//-----------------------------------------------------------------------------------
		private static function selectFilePrepare(filePath: String, onSelectFile: Function):  File
		{
			var file: File;
			try
			{
				file = new File(filePath);
			}
			catch (err: Error)
			{
				file = new File();
			}
			
			var onSelect: Function = function(e: Event): void
			{
				file.removeEventListener(Event.SELECT, onSelect);
				onSelectFile(file);
			};
			
			file.addEventListener(Event.SELECT, onSelect);
			return file;
		}
		
		private static function selectFilesPrepare(filePath: String, onSelectFiles: Function):  File
		{
			var file: File;
			try
			{
				file = new File(filePath);
			}
			catch (err: Error)
			{
				file = new File();
			}
			
			var onSelect: Function = function(e: FileListEvent): void
			{
				file.removeEventListener(FileListEvent.SELECT_MULTIPLE, onSelect);
				onSelectFiles(e.files);
			};
			
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, onSelect);
			return file;
		}
		
		public static function selectFile(filePath: String, title: String, onSelectFile: Function, filter: Array = null): void
		{
			var file: File = selectFilePrepare(filePath, onSelectFile);
			file.browseForOpen(title, filter);
		}
		
		public static function selectFiles(filePath: String, title: String, onSelectFiles: Function, filter: Array = null): void
		{
			var file: File = selectFilesPrepare(filePath, onSelectFiles);
			file.browseForOpenMultiple(title, filter);
		}
		
		public static function selectDirectroy(filePath: String, title: String, onSelectDirFile: Function): void
		{
			var file: File = selectFilePrepare(filePath, onSelectDirFile);
			file.browseForDirectory(title);
		}
		
		public static function saveFile(filePath: String, title: String, onSelectFile: Function): void
		{
			var file: File = selectFilePrepare(filePath, onSelectFile);
			file.browseForSave(title);
		}
	}
}