package sigma.app.duxiu.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sigma.app.duxiu.data.BookPageData;
	import sigma.app.duxiu.events.DataEvent;
	
	[Event(type="sigma.app.duxiu.events.DataEvent", name="start")]
	[Event(type="sigma.app.duxiu.events.DataEvent", name="complete")]
	[Event(type="sigma.app.duxiu.events.DataEvent", name="error")]
	public class BookPageDownloader extends EventDispatcher
	{
		private static const DOWNLOAD_DELAY: int = 1;
		private static const DOWNLOAD_TIMEOUT: int = 5000;
		private static const DOWNLOAD_RETRY_COUNT: int = 3;
		
		private var m_downloads: Vector.<DownloadItem>;
		private var m_downUrl: IDownUrl;
		
		public function BookPageDownloader()
		{
			m_downloads = new Vector.<DownloadItem>();
		}
		
		public function init(str: String): Boolean
		{
			if (str)
			{
				cancel();
				
				m_downUrl = new DownUrl(str);
				return true;
			}
			return false;
		}
		
		public function download(pageName: String, pageZoomEnum: int, retryCount: int = 0): Boolean
		{
			if (pageName && m_downUrl)
			{
				setTimeout(doDownload, DOWNLOAD_DELAY, pageName, pageZoomEnum, retryCount);
				return true;
			}
			return false;
		}
		
		private function doDownload(pageName: String, pageZoomEnum: int, retryCount: int = 0): void
		{
			var request: URLRequest = new URLRequest(m_downUrl.getPageURL(pageName, pageZoomEnum));
			var loader: URLLoader = new URLLoader(request);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.load(request);
			
			var timeoutId: uint = setTimeout(checkTimeout, DOWNLOAD_TIMEOUT, loader);
			m_downloads.push(new DownloadItem(loader, pageName, pageZoomEnum, timeoutId, retryCount));
			
			var event: DataEvent = new DataEvent(DataEvent.START);
			event.data = pageName;
			this.dispatchEvent(event);
			trace("Downloading:", pageName);
		}
		
		private function checkTimeout(loader: URLLoader): void
		{
			if (loader.bytesTotal == 0)
			{
				var item: DownloadItem = getDownloadItem(loader);
				retryDownload(item);
				
				loader.close();
				disposeLoader(loader);
			}
		}
		
		private function retryDownload(item: DownloadItem): void
		{
			if (item)
			{
				if (item.retryCount < DOWNLOAD_RETRY_COUNT)
				{
					download(item.pageName, item.pageZoomEnum, item.retryCount + 1);
				}
				else
				{
					var event: DataEvent = new DataEvent(DataEvent.ERROR);
					event.data = item.pageName;
					this.dispatchEvent(event);
					
					trace("Retry failed:", item.pageName);
				}
			}
		}
		
		public function cancel(): void
		{
			var downloads: Vector.<DownloadItem> = m_downloads.concat();
			for each (var item: DownloadItem in downloads)
			{
				item.loader.close();
				disposeLoader(item.loader);
			}
			m_downloads.length = 0;
		}
		
		private function getDownloadItem(loader: URLLoader): DownloadItem
		{
			for (var index: int = 0, n: int = m_downloads.length; index < n; index++)
			{
				var item: DownloadItem = m_downloads[index];
				if (item.loader == loader)
				{
					return item;
				}
			}
			return null;
		}
		
		private function disposeLoader(loader: URLLoader): void
		{
			loader.removeEventListener(Event.COMPLETE, onLoaded);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			var item: DownloadItem = getDownloadItem(loader);
			if (item)
			{
				var index: int = m_downloads.indexOf(item);
				m_downloads.splice(index, 1);
				clearTimeout(item.timeoutId);
			}
		}
		
		private function onLoaded(e: Event): void
		{
			var loader: URLLoader = e.target as URLLoader;
			var item: DownloadItem = getDownloadItem(loader);
			if (item)
			{
				var pageName: String = item.pageName;
				var bytes: ByteArray = loader.data;
				if (bytes.length > 142)
				{
					var event: DataEvent = new DataEvent(DataEvent.COMPLETE);
					event.data = new BookPageData(pageName, bytes);
					this.dispatchEvent(event);
					trace("Downloaded:", pageName);
				}
				else
				{
//					event = new DataEvent(DataEvent.ERROR);
//					event.data = pageName;
//					this.dispatchEvent(event);
//					trace("Seems failed:", pageName);
					
					retryDownload(item);
				}
			}
			disposeLoader(loader);
		}
		
		private function onError(e: Event): void
		{
			var loader: URLLoader = e.target as URLLoader;
			var item: DownloadItem = getDownloadItem(loader);
			if (item)
			{
//				var event: DataEvent = new DataEvent(DataEvent.ERROR);
//				event.data = item.pageName;
//				this.dispatchEvent(event);
//				trace("Sure failed:", item.pageName);
				
				retryDownload(item);
			}
			disposeLoader(loader);
		}
	}
}
import flash.net.URLLoader;

import sigma.app.duxiu.utils.BookPageDefine;

class DownloadItem
{
	public var loader: URLLoader;
	public var pageName: String;
	public var pageZoomEnum: int;
	public var timeoutId: uint;
	public var retryCount: int;
	
	public function DownloadItem(loader: URLLoader, pageName: String, pageZoomEnum: int, timeoutId: int, retryCount: int)
	{
		this.loader = loader;
		this.pageName = pageName;
		this.pageZoomEnum = pageZoomEnum;
		this.timeoutId = timeoutId;
		this.retryCount = retryCount;
	}
}

interface IDownUrl
{
	function getPageURL(pageName: String, pageZoomEnum: int): String;
}

class DownUrl implements IDownUrl
{
	private var m_readUrl: ReadUrl;
	private var m_saveUrl: SaveUrl;
	
	public function DownUrl(str: String)
	{
		m_readUrl = new ReadUrl(str);
		m_saveUrl = new SaveUrl(str);
	}
	
	public function getPageURL(pageName: String, pageZoomEnum: int): String
	{
		if (BookPageDefine.isOriginPageZoom(pageZoomEnum))
			return m_saveUrl.getPageURL(pageName, pageZoomEnum);
		else
			return m_readUrl.getPageURL(pageName, pageZoomEnum)
	}
}

class ReadUrl implements IDownUrl
{
	private static const HOST: String = "http://readsvr.zhizhen.com";
	
	private var m_baseURL: String;
	
	public function ReadUrl(str: String)
	{
		m_baseURL = HOST + str.substr(str.indexOf("/img"));
	}
	
	public function getPageURL(pageName: String, pageZoomEnum: int): String
	{
		return m_baseURL + pageName +"?.&uf=ssr&zoom=" + pageZoomEnum;
	}
}

class SaveUrl implements IDownUrl
{
	private static const HOST: String = "http://www.junshilei.cn";
	
	private var m_baseURL: String;
	
	public function SaveUrl(str: String)
	{
		m_baseURL = HOST + "/SaveAs?Url=http://img.duxiu.com/n/" + str;
	}
	
	public function getPageURL(pageName: String, pageZoomEnum: int): String
	{
		return m_baseURL + pageName +"?.&uf=ssr&zoom=" + pageZoomEnum;
	}
}