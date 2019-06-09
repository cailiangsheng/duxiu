package sigma.lib.tools.flexsrc
{
	import flash.utils.ByteArray;
	
	import sigma.lib.tools.ConsoleExecutor;
	import sigma.lib.utils.FileUtil;
	import sigma.lib.utils.StringUtil;

	public class FlexSourceCompiler
	{
		public static const COMPILER_BUSY: String = "compilerBuzy";
		public static const COMPILER_BAD_SDK: String = "compilerBadSDK";
		public static const COMPILER_BAD_JRE: String = "compilerBadJRE";
		public static const COMPILER_BAD_SOURCE: String = "compilerBadSource";
		public static const COMPILER_NO_SOURCE: String = "compilerNoSource";
		public static const COMPILER_BAD_BATCH: String = "compilerBadBatch";
		public static const COMPILER_BAD_EXECUTE: String = "compilerBadExecute";
		public static const COMPILER_EXECUTING: String = "compilerOK";
		
		private static const CHARSET_CONSOLE: String = "gb2312";
		
		[Embed(source="../../../../../assets/compile.bat", mimeType="application/octet-stream")]
		private static var CompileBatch: Class;
		
		private var m_sdkHome: String;
		private var m_jreHome: String;
		private var m_executor: ConsoleExecutor;
		
		public function FlexSourceCompiler()
		{
			m_executor = new ConsoleExecutor();
		}
		
		public function init(sdkHome: String, jreHome: String): Boolean
		{
			if (checkSDK(sdkHome) && checkJRE(jreHome))
			{
				m_sdkHome = sdkHome;
				m_jreHome = jreHome;
			}
			return false;
		}
		
		public function get executor(): ConsoleExecutor
		{
			return m_executor;
		}
		
		public function get compiling(): Boolean
		{
			return m_executor && m_executor.executing;
		}
		
		public function compile(sourceHome: String, sources: Vector.<IFlexSource>): String
		{
			if (this.compiling)
			{
				return COMPILER_BUSY;
			}
			else if (!checkSDK(m_sdkHome))
			{
				return COMPILER_BAD_SDK;
			}
			else if (!checkJRE(m_jreHome))
			{
				return COMPILER_BAD_JRE;
			}
			else if (sources && sources.length > 0 && mainSource)
			{
				// export source files
				var mainSource: FlexSourceMain = new FlexSourceMain();
				var sourcePaths: Vector.<String> = new Vector.<String>();
				for each (var source: IFlexSource in sources)
				{
					mainSource.addSource(source);
					
					var path: String = source.exportFile(sourceHome);
					if (path)
					{
						return COMPILER_BAD_SOURCE;
					}
					else
					{
						sourcePaths.push(path);
					}
				}
				
				// export main source file
				var mainSourcePath: String = mainSource.exportFile(sourceHome);
				if (mainSourcePath == null)
				{
					return COMPILER_BAD_SOURCE;
				}
				
				// generate batch files
				var cmd: String = generateBatches(sourceHome, sourcePaths, mainSourcePath);
				if (cmd)
				{
					// execute batch files
					if (m_executor.start() && m_executor.executeAndExit(cmd))
					{
						return COMPILER_EXECUTING;
					}
					else
					{
						return COMPILER_BAD_EXECUTE;
					}
				}
				else
				{
					return COMPILER_BAD_BATCH;
				}
			}
			return COMPILER_NO_SOURCE;
		}
		
		private function generateBatches(sourceHome: String, sourcePaths: Vector.<String>, mainSourcePath: String): String
		{
			var compileBatchPath: String = sourceHome + "\\compile.bat";
			var compileBatch: ByteArray = new (CompileBatch)();
			FileUtil.writeBytes(compileBatchPath, compileBatch);
			
			var cleanBatchPath: String = sourceHome + "\\clean.bat";
			var cleanBatch: String = "";
			for each (var path: String in sourcePaths)
			{
				cleanBatch += "\ndel" + path;
			}
			FileUtil.writeText(cleanBatchPath, cleanBatch, CHARSET_CONSOLE);
			
			var executeBatchPath: String = sourceHome + "\\execute.bat";
			var executeBatch: String = StringUtil.bound(compileBatchPath) + " " + 
									   StringUtil.bound(m_sdkHome) + " " + 
									   StringUtil.bound(m_jreHome) + " " + 
									   StringUtil.bound(mainSourcePath);
			executeBatch += "\n" + StringUtil.bound(cleanBatchPath);
			FileUtil.writeText(executeBatchPath, executeBatch, CHARSET_CONSOLE);
			
			return executeBatchPath;
		}
	}
}

import flash.filesystem.File;

import sigma.lib.utils.FileUtil;
import sigma.lib.utils.SystemUtil;

function checkSDK(sdkHome: String): Boolean
{
	if (SystemUtil.isWindows)
	{
		return FileUtil.checkExist(sdkHome + "\\bin\\mxmlc.exe");
	}
	return false;
}

function checkJRE(jreHome: String): Boolean
{
	if (SystemUtil.isWindows)
	{
		return FileUtil.checkExist(jreHome + "\\bin\\java.exe");
	}
	return false;
}