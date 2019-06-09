package sigma.lib.tools.html
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	
	import sigma.lib.utils.BrowserUtil;
	import sigma.lib.utils.SystemUtil;

	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.ErrorEvent", name="error")]
	public class MobileHtmlVarSearcher extends BaseHtmlVarSearcher implements IHtmlVarSearcher
	{
		private var m_homeLoader: StageWebView;
		private var m_searchLoader: StageWebView;
		
		public function MobileHtmlVarSearcher(homeLoader: StageWebView)
		{
			m_homeLoader = homeLoader ? homeLoader : new StageWebView();
			m_searchLoader = new StageWebView();
		}
		
		public static function get isSupported(): Boolean
		{
			return StageWebView.isSupported && !SystemUtil.isIOS;
		}
		
		public function searchVar(url: String, ...varNames): Boolean
		{
			if (isSupported && m_homeLoader && url)
			{
				m_searchVarNames = Vector.<String>(varNames);
				
				if (m_defaultWindow && m_homeLoader.location == url)
				{
					doSearchVar();
				}
				else
				{
					m_defaultWindow = null;
					m_homeLoader.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onWindowDataFetched);
					m_homeLoader.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onDocumentDataFetched);
					
					var requestURL: String = BrowserUtil.getHttpURL(url);
					m_homeLoader.addEventListener(Event.COMPLETE, onHomePageLoaded);
					m_homeLoader.addEventListener(ErrorEvent.ERROR, onHomePageFailed);
					m_homeLoader.loadURL(requestURL);
				}
				return true;
			}
			return false;
		}
		
		private function onHomePageLoaded(e: Event): void
		{
			m_homeLoader.removeEventListener(Event.COMPLETE, onHomePageLoaded);
			m_homeLoader.removeEventListener(ErrorEvent.ERROR, onHomePageFailed);
			
			fetchHomeLoaderWindowData();
		}
		
		private function onHomePageFailed(e: Event): void
		{
			m_homeLoader.removeEventListener(Event.COMPLETE, onHomePageLoaded);
			m_homeLoader.removeEventListener(ErrorEvent.ERROR, onHomePageFailed);
			
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
		
		//----------------------------------------------------
		private function getJavascriptURL(target: String = "window"): String
		{
			var script: String = 
				"var s = '';" +
				"for (var i in " + target + ")" +
				"{" +
					"var t = typeof(" + target + "[i]);" +
					"if (t != 'object' && t != 'function')" +
					"{" +
						"s += '&' + i + '=' +" + target + "[i];" + 
					"}" +
				"}" +
				"window.location.href = 'data:' + s;";
				
//				"var s = '';";
//			for each (var varName: String in m_searchVarNames)
//			{
//				script += "if (" + target + ".hasOwnProperty('" + varName + "'))" +
//								"s += '&' + '" + varName + "' + '=' +" + target + "['" + varName + "'];";
//			}
//			script += "window.location.href = 'data:' + s;";
				
				"window.location.href='data:'+window.str";
			
			var url: String = "javascript:eval(\"" + script + "\");";
			return url;
		}
		
		private static function parseData(location: String): Object
		{
			var data: Object = {};
			if (location.substr(0, 6) == "data:&")
			{
				var text: String = location.substr(6);
				var vars: Array = text.split("&");
				for each (var item: String in vars)
				{
					var v: Array = item.split("=");
					var varName: String = v[0];
					var varValue: String = v[1];
					try { varValue = decodeURIComponent(varValue); }
					catch (e: Error) { trace(item); }
					
					// StageWebView BUG: javascript variable name is mistaken with '_' prefix
					if (varName.charAt(0) == "_")
						varName = varName.substr(1);
					
					if (varValue == "undefined")
						data[varName] = undefined;
					if (varValue == "true" || varValue == "false")
						data[varName] = Boolean(varValue);
					else if (Number(varValue).toString() == varValue)
						data[varName] = Number(varValue);
					else
						data[varName] = varValue;
				}
			}
			return data;
		}
		
		private function fetchHomeLoaderWindowData(): void
		{
			m_homeLoader.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onWindowDataFetched);
			m_homeLoader.loadURL(getJavascriptURL("window"));
		}
		
		private function onWindowDataFetched(e: LocationChangeEvent): void
		{
			m_homeLoader.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onWindowDataFetched);
			e.preventDefault();
			
			m_defaultWindow = parseData(e.location);
			fetchHomeLoaderDocumentData();
		}
		
		private function fetchHomeLoaderDocumentData(): void
		{
			m_homeLoader.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onDocumentDataFetched);
			m_homeLoader.loadURL(getJavascriptURL("window.document"));
		}
		
		private function onDocumentDataFetched(e: LocationChangeEvent): void
		{
			m_homeLoader.removeEventListener(LocationChangeEvent.LOCATION_CHANGING, onDocumentDataFetched);
			e.preventDefault();
			
			m_defaultWindow["document"] = parseData(e.location);
			doSearchVar();
		}

		//----------------------------------------------------
		protected override function stopSearch(): void
		{
			m_searchLoader.stop();
		}
	}
}