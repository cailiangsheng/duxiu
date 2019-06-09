package sigma.lib.tools.flexsrc
{
	public interface IFlexSource
	{
		function get sourceCode(): String;
		function get fullClassName(): String;
		function exportFile(sourceHome: String): String;
	}
}