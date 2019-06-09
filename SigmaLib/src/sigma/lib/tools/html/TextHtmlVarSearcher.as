package sigma.lib.tools.html
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.System;
	
	import sigma.lib.utils.BrowserUtil;
	import sigma.lib.utils.SystemUtil;

	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.ErrorEvent", name="error")]
	public class TextHtmlVarSearcher extends BaseHtmlVarSearcher implements IHtmlVarSearcher
	{
		private var m_url: String;
		
//		private var m_homeLoader: URLLoader;
//		private var m_searchLoader: URLLoader;
//		
//		public function TextHtmlVarSearcher(url: String = null)
//		{
//			// it doesn't work for string-decoding on iOS
//			System.useCodePage = true;	
//			
//			m_homeLoader = new URLLoader(url ? new URLRequest(url) : null);
//			m_searchLoader = new URLLoader();
//		}
		
		private var m_homeLoader: URLStream;
		private var m_searchLoader: URLStream;
		
		public function TextHtmlVarSearcher()
		{
			m_homeLoader = new URLStream();
			m_searchLoader = new URLStream();
		}
		
		public static function get isSupported(): Boolean
		{
			return !SystemUtil.isAndroid;
		}
		
		public function searchVar(url: String, ...varNames): Boolean
		{
			if (isSupported && m_homeLoader && url)
			{
				m_searchVarNames = Vector.<String>(varNames);
				
				m_url = url;
				if (m_defaultWindow && m_url == url)
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
			
//			var text: String = m_homeLoader.data;
			var text: String = m_homeLoader.readMultiByte(m_homeLoader.bytesAvailable, "gb2312");
			m_defaultWindow = fetchHomeLoaderWindowData(text);
			m_defaultWindow["document"] = fetchHomeLoaderDocumentData(text);
			doSearchVar();
		}
		
		private function onHomePageFailed(e: Event): void
		{
			m_homeLoader.removeEventListener(Event.COMPLETE, onHomePageLoaded);
			m_homeLoader.removeEventListener(IOErrorEvent.IO_ERROR, onHomePageFailed);
			
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
	}
}

function fetchHomeLoaderWindowData(text: String): Object
{
	var window: Object = {};
	collectHomeLoaderData(text, window, new RegExp("(\\w+)\\s*=\\s*(\\d+|true|false)\s*[,;]", "g"), 1, 2);
	collectHomeLoaderData(text, window, new RegExp("(\\w+)\\s*=\\s*\"(([^\\\\\"]|(\\\\\")|(\\\\')|(\\\\\\\\))+)\"\s*[,;]", "g"), 1, 2);
	collectHomeLoaderData(text, window, new RegExp("(\\w+)\\s*=\\s*'(([^\\\\']|(\\\\\")|(\\\\')|(\\\\\\\\))+)'\s*[,;]", "g"), 1, 2);
	return window;
}

function fetchHomeLoaderDocumentData(text: String): Object
{
	var document: Object = {};
	collectHomeLoaderData(text, document, new RegExp("<(title)>(.*)</title>", "g"), 1, 2);
	return document;
}

function collectHomeLoaderData(text: String, object: Object, pattern: RegExp, nameIndex: int, valueIndex: int): void
{
	var result: Array = null;
	while (result = pattern.exec(text))
	{
		var varName: String = result[nameIndex];
		var varValue: String = result[valueIndex];
		object[varName] = varValue;
	}
}