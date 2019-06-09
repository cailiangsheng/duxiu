package sigma.lib.tools.html
{
	import flash.events.IEventDispatcher;

	internal interface IHtmlVarSearcher extends IEventDispatcher
	{
		function searchVar(url: String, ...varNames): Boolean;
		function getVarProp(propName: String, bReplaceFromHome: Boolean = false, bDocumentProp: Boolean = false): Object;
	}
}