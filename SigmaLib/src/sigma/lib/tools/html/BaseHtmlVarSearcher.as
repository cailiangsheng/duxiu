package sigma.lib.tools.html
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	internal class BaseHtmlVarSearcher extends EventDispatcher
	{
		protected var m_defaultWindow: Object;
		protected var m_searchVarNames: Vector.<String>;
		protected var m_searchFrames: Object;
		protected var m_searchNumFrames: int;
		protected var m_searchedWindow: Object;
		
		public function BaseHtmlVarSearcher()
		{
		}
		
		//---------------------------------------------------------------------------------
		protected function doSearchVar(): void
		{
			m_searchFrames = null;
			m_searchNumFrames = 0;
			m_searchedWindow = null;
			
			stopSearch();
			startSearch();
		}
		
		public function getVarProp(propName: String, bReplaceFromHome: Boolean = false, bDocumentProp: Boolean = false): Object
		{
			if (m_searchedWindow)
			{
				var map: Object = m_searchedWindow;
				if (map == null && bReplaceFromHome)
					map = m_defaultWindow;
				if (map != null && bDocumentProp)
					map = map.document;
				
				if (map)
					return map[propName];
			}
			return null;
		}
		
		protected function onSearched(window: Object): void
		{
			m_searchedWindow = window;
			
			var event: Event = new Event(Event.COMPLETE);
			this.dispatchEvent(event);
		}
		
		//---------------------------------------------------------------------------------
		private function startSearch(): void
		{
			var window: Object = m_defaultWindow;
			if (window)
			{
				for each (var varName: String in m_searchVarNames)
				{
					if (window.hasOwnProperty(varName))
					{
						onSearched(window);
						return;
					}
				}
			}
			
			doSearchFrames();
		}
		
		protected function stopSearch(): void
		{
		}
		
		protected function doSearchFrames(): void
		{
			onSearched(null);
		}
	}
}