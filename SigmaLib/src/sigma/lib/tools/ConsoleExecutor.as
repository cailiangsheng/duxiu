package sigma.lib.tools
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.EventDispatcher;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import sigma.lib.events.DataEvent;
	import sigma.lib.events.ExecuteEvent;
	import sigma.lib.utils.StringUtil;
	import sigma.lib.utils.SystemUtil;

	[Event(type="sigma.lib.events.DataEvent", name="output")]
	[Event(type="sigma.lib.events.ExecuteEvent", name="executed")]
	public class ConsoleExecutor extends EventDispatcher
	{
		private var m_exePath: String;
		private var m_exeArgs: Vector.<String>;
		
		private var m_output: String;
		private var m_process: NativeProcess;
		
		public function ConsoleExecutor(exePath: String = null, exeArgs: Vector.<String> = null)
		{
			m_exePath = exePath;
			m_exeArgs = exeArgs;
		}
		
		public function get exePath(): String
		{
			if (m_exePath)
			{
				return m_exePath;
			}
			else if (SystemUtil.isWindows)
			{
				return "C:\\Windows\\System32\\cmd.exe";
			}
			else if (SystemUtil.isLinux)
			{
				return null;
			}
			return null;
		}
		
		public function get executing(): Boolean
		{
			return m_process && m_process.running;
		}
		
		public function start(): Boolean
		{
			try
			{
				if (m_process == null || !m_process.running)
				{
					m_output = "";
					
					m_process = new NativeProcess();
					m_process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
					m_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onProcessOutput);
					
					var info: NativeProcessStartupInfo = new NativeProcessStartupInfo();
					info.executable = new File(this.exePath);
					info.arguments = m_exeArgs;
					m_process.start(info);
				}
				return true;
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public function execute(command: String): Boolean
		{
			if (m_process && m_process.running && command)
			{
				var line: String = command + (command.charAt(0) == '^' ? "" : "\n");
				var cin: IDataOutput = m_process.standardInput;
				return StringUtil.writeString(cin, line);
			}
			return false;
		}
		
		public function exit(): Boolean
		{
			return execute("exit");
		}
		
		public function stop(): void
		{
			m_process.exit(true);
		}
		
		public function executeAndExit(command: String): Boolean
		{
			return execute(command) && exit();
		}
		
		public function get output(): String
		{
			return m_output;
		}
		
		//---------------------------------------------------------
		private function dispose(): void
		{
			if (m_process && !m_process.running)
			{
				m_process.removeEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
				m_process.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onProcessOutput);
				m_process = null;
			}
		}
		
		private function onProcessExit(e: NativeProcessExitEvent): void
		{
			dispose();
			
			this.dispatchEvent(new ExecuteEvent(ExecuteEvent.EXECUTED));
		}
		
		private function onProcessOutput(e: ProgressEvent): void
		{
			var cout: IDataInput = m_process.standardOutput;
			var str: String = StringUtil.readString(cout);
			
			m_output += str;
			
			var event: DataEvent = new DataEvent(DataEvent.OUTPUT);
			event.data = str;
			this.dispatchEvent(event);
		}
	}
}