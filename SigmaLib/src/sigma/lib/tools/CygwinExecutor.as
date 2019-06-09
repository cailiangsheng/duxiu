package sigma.lib.tools
{
	import sigma.lib.utils.FilePathUtil;
	import sigma.lib.utils.FileUtil;

	public class CygwinExecutor extends ConsoleExecutor
	{
		public function CygwinExecutor(cygwinHome: String)
		{
			var exePath: String = cygwinHome + "\\bin\\bash.exe";
			var exeArgs: Vector.<String> = Vector.<String>(["--login", "-i"]);
			super(exePath, exeArgs);
			
			if (!FileUtil.checkExist(exePath))
			{
				throw new Error("File does not exist: " + exePath);
			}
		}
		
		public function shell(shellPath: String): Boolean
		{
			if (super.start())
			{
				var dirPath: String = FilePathUtil.doubleSeperator(FilePathUtil.getDirectory(shellPath));
				var cmdChangeDir: String = "cd " + FilePathUtil.boundParenthesis(dirPath);
				super.execute(cmdChangeDir);
				
				var shellName: String = FilePathUtil.getFileName(shellPath);
				var cmdSource: String = "source " + FilePathUtil.boundParenthesis(shellName);
				return super.executeAndExit(cmdSource);
			}
			return false;
		}
	}
}