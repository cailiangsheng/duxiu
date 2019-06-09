package sigma.lib.tools.flexsrc
{
	internal class FlexSourceMain extends FlexSource
	{
		private var m_sources: Vector.<IFlexSource>;
		
		public function FlexSourceMain(mainClassPackage: String = "", 
									   mainClassName: String = "main")
		{
			super(mainClassPackage, mainClassName);
			m_sources = new Vector.<IFlexSource>();
		}
		
		public function addSource(source: IFlexSource): void
		{
			if (m_sources.indexOf(source) < 0)
			{
				m_sources.push(source);
			}
		}
		
		public function removeSource(source: IFlexSource): void
		{
			var index: int = m_sources.indexOf(source);
			if (index >= 0)
			{
				m_sources.splice(index, 1);
			}
		}
		
		public override function get sourceCode():String
		{
			var imports: String = "";
			var defines: String = "";
			for each (var source: IFlexSource in m_sources)
			{
				var fullClassName: String = source.fullClassName;
				imports += "\r\n\timports " + fullClassName + ";";
				defines += "\r\n\t\tpublic var " + toVariableName(fullClassName) + ": Class = " + fullClassName + ";";
			}
			
			return "package " + super.packageName + 
				"\r\n{" +
				"\r\n\timport flash.display.Sprite;" + imports + 
				"\r\n\tpublic class " + super.className + " extends Sprite" + 
				"\r\n\t{" +
				"\r\n\t\t" + defines +
				"\r\n\t}" + 
				"\r\n}";
		}
		
		private static function toVariableName(fullClassName: String): String
		{
			return fullClassName.replace(".", "_").toUpperCase();
		}
	}
}