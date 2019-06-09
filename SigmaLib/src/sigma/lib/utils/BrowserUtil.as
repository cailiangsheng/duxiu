package sigma.lib.utils
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.net.URLRequest;

	public class BrowserUtil
	{
		public static const URL_NULL: String = "about:blank";
		public static const URL_CLIPBORAD: String = "about:clipboard";
		
		public static function getHttpURL(url: String): String
		{
			// get URL from Clipboard
			if (url && url.toLowerCase() == URL_CLIPBORAD)
			{
				if (Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT))
				{
					url = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
				}
				else
				{
					url = null;
				}
			}
			
			// validate URL
			if (url == "" || url == null)
			{
				return URL_NULL;
			}
			else
			{
				var httpURL: String = url.replace(/^\/+/, "");
				if (httpURL != URL_NULL && 
					httpURL.indexOf("http://") != 0 && 
					httpURL.indexOf("https://") != 0 && 
					httpURL.indexOf("file:") != 0 && 
					httpURL.indexOf("data:") != 0 && 
					httpURL.indexOf("javascript:") != 0)
					httpURL = "http://" + httpURL;
				
				return httpURL;
			}
		}
		
		public static function getHttpURLRequest(url: String): URLRequest
		{
			var httpURL: String = getHttpURL(url);
			return new URLRequest(httpURL);
		}
		
		public static function compareURL(url1: String, url2: String): Boolean
		{
			if (url1.length < url2.length)
			{
				var temp: String = url1;
				url1 = url2;
				url2 = temp;
			}
			var p: int = url1.indexOf(url2);
			if (p >= 0)
			{
				var suffix: String = url1.substr(p + url2.length);
				return suffix.charAt(0) == "#";
			}
			return false;
		}
	}
}