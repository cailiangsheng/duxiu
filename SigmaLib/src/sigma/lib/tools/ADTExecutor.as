package sigma.lib.tools
{
	public class ADTExecutor
	{
		[Embed(source="../../../../assets/airi2air.bat", mimeType="application/octet-stream")]
		private static var AIRI2AIR: Class;
		
		[Embed(source="../../../../assets/air2exe.bat", mimeType="application/octet-stream")]
		private static var AIR2EXE: Class;
		
		private var m_executor: ConsoleExecutor;
		
		public function ADTExecutor()
		{
			m_executor = new ConsoleExecutor();
		}
		
		public function init(adtFilePath: String): Boolean
		{
			return false;
		}
		
		public function get executor(): ConsoleExecutor
		{
			return m_executor;
		}
		
		public function get running(): Boolean
		{
			return m_executor && m_executor.executing;
		}
		
		public function air2exe(): Boolean
		{
			return false;
		}
		
		public function airi2air(): Boolean
		{
			return false;
		}
		
		public function airi2exe(): Boolean
		{
			airi2air();
			air2exe();
			return false;
		}
	}
}