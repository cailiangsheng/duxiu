package sigma.lib.tools.html
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.ErrorEvent", name="error")]
	public class HtmlVarSearcher extends EventDispatcher implements IHtmlVarSearcher
	{
		private var m_searcher: IHtmlVarSearcher;
		
		public function HtmlVarSearcher(homeLoader: * = null)
		{
			if (DesktopHtmlVarSearcher.isSupported)
			{
				m_searcher = new DesktopHtmlVarSearcher(homeLoader);
			}
			else if (MobileHtmlVarSearcher.isSupported)
			{
				m_searcher = new MobileHtmlVarSearcher(homeLoader);
			}
			else if (TextHtmlVarSearcher.isSupported)
			{
				m_searcher = new TextHtmlVarSearcher();
			}
			
			if (m_searcher)
			{
				m_searcher.addEventListener(Event.COMPLETE, onEvent);
				m_searcher.addEventListener(ErrorEvent.ERROR, onEvent);
			}
		}
		
		private function onEvent(e: Event): void
		{
			this.dispatchEvent(e.clone());
		}
		
		public function searchVar(url: String, ...varNames): Boolean
		{
			var args: Array = varNames.concat();
			args.unshift(url);
			return m_searcher ? m_searcher.searchVar.apply(m_searcher, args) : false;
		}
		
		public function getVarProp(propName: String, bReplaceFromHome: Boolean = false, bDocumentProp: Boolean = false): Object
		{
			return m_searcher ? m_searcher.getVarProp(propName, bReplaceFromHome, bDocumentProp) : null;
		}
	}
}