package sigma.lib.tools.html
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	
	import sigma.lib.utils.BrowserUtil;

	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.ErrorEvent", name="error")]
	internal class DesktopHtmlVarSearcher extends BaseHtmlVarSearcher implements IHtmlVarSearcher
	{
		private var m_homeLoader: HTMLLoader;
		private var m_searchLoader: HTMLLoader;
		
		public function DesktopHtmlVarSearcher(homeLoader: HTMLLoader = null)
		{
			m_homeLoader = homeLoader ? homeLoader : new HTMLLoader();
			m_searchLoader = new HTMLLoader();
		}
		
		public static function get isSupported(): Boolean
		{
			return HTMLLoader.isSupported;
		}
		
		public function searchVar(url: String, ...varNames): Boolean
		{
			if (isSupported && m_homeLoader && url)
			{
				m_searchVarNames = Vector.<String>(varNames);
				
				if (m_homeLoader.loaded && m_homeLoader.location == url)
				{
					doSearchVar();
				}
				else
				{
					m_defaultWindow = null;
					
					var request: URLRequest = BrowserUtil.getHttpURLRequest(url);
					m_homeLoader.addEventListener(Event.COMPLETE, onHomePageLoaded);
					m_homeLoader.addEventListener(IOErrorEvent.IO_ERROR, onHomePageFailed);
					m_homeLoader.load(request);
				}
				return true;
			}
			return false;
		}
		
		private function onHomePageLoaded(e: Event): void
		{
			m_homeLoader.removeEventListener(Event.COMPLETE, onHomePageLoaded);
			m_homeLoader.removeEventListener(IOErrorEvent.IO_ERROR, onHomePageFailed);
			
			m_defaultWindow = m_homeLoader.window;
			doSearchVar();
		}
		
		private function onHomePageFailed(e: Event): void
		{
			m_homeLoader.removeEventListener(Event.COMPLETE, onHomePageLoaded);
			m_homeLoader.removeEventListener(IOErrorEvent.IO_ERROR, onHomePageFailed);
			
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		
		//----------------------------------------------------
		protected override function stopSearch(): void
		{
			if (!m_searchLoader.loaded)
			{
				m_searchLoader.cancelLoad();
			}
		}
		
		protected override function doSearchFrames(): void
		{
			m_searchFrames = m_defaultWindow.document.getElementsByTagName("frame");
			m_searchNumFrames = m_searchFrames.length;
			searchInNextFrame();
		}
		
		private function searchInNextFrame(): void
		{
			if (m_searchNumFrames > 0)
			{
				m_searchNumFrames--;
				
				var request: URLRequest = BrowserUtil.getHttpURLRequest(m_searchFrames[m_searchNumFrames].location);
				m_searchLoader.addEventListener(Event.COMPLETE, onFramePageLoaded);
				m_searchLoader.addEventListener(IOErrorEvent.IO_ERROR, onFramePageFailed);
				m_searchLoader.load(request);
			}
			else
			{
				onSearched(null);
			}
		};
		
		private function onFramePageLoaded(e: Event): void
		{
			m_searchLoader.removeEventListener(Event.COMPLETE, onFramePageLoaded);
			m_searchLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFramePageFailed);
			
			var frameWindow: Object = (e.target as HTMLLoader).window;
			for each (var varName: String in m_searchVarNames)
			{
				if (frameWindow.hasOwnProperty(varName))
				{
					onSearched(frameWindow);
					return;
				}
			}
			searchInNextFrame();
		}
		
		private function onFramePageFailed(e: Event): void
		{
			m_searchLoader.removeEventListener(Event.COMPLETE, onFramePageLoaded);
			m_searchLoader.removeEventListener(IOErrorEvent.IO_ERROR, onFramePageFailed);
			
			searchInNextFrame();
		}
	}
}