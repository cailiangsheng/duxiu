package sigma.app.duxiu.model
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import sigma.app.duxiu.data.BookPageData;
	import sigma.app.duxiu.data.BookPageType;
	import sigma.app.duxiu.data.BookPageZoom;
	import sigma.app.duxiu.events.DataEvent;
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.app.duxiu.utils.BookPageDefine;
	import sigma.app.duxiu.utils.BookPageDownloader;
	import sigma.lib.utils.FileUtil;
	
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="downlodBegin")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="downloadPage")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="downloadComplete")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="downloadStop")]
	public class DuxiuDownDownloadModel extends EventDispatcher
	{
		private var m_cookie: Object;
		
		private var m_taskModel: DuxiuDownTaskModel;
		
		private var m_downloading: Boolean;
		
		private var m_iterator: BookPageIterator;
		private var m_downloader: BookPageDownloader;
		
		public function DuxiuDownDownloadModel()
		{
		}
		
		public function initialize(taskModel: DuxiuDownTaskModel): void
		{
			m_taskModel = taskModel;
			m_downloader = new BookPageDownloader();
			m_iterator = new BookPageIterator(taskModel);
		}
		
		public function finalize(): void
		{
			m_taskModel = null;
			
			m_downloader.cancel();
			m_downloader = null;
			
			m_iterator.dispose();
			m_iterator = null;
		}
		
		//------------------------------------------------------
		private function get targetPageZoom(): BookPageZoom
		{
			return BookPageDefine.getPageZoom(m_taskModel.pageZoom);
		}
		
		public function get isDownloadable(): Boolean
		{
			return m_taskModel.isParamsValid && this.targetPageZoom && 
				(BookPageDefine.isFuzzyPageType(m_taskModel.pageType) || 
				!isNaN(m_taskModel.fromPage) && !isNaN(m_taskModel.toPage) && m_taskModel.fromPage <= m_taskModel.toPage || 
				!isNaN(m_taskModel.fromPage) && isNaN(m_taskModel.toPage));
		}
		
		public function get isDownloading(): Boolean
		{
			return m_downloading;
		}
		
		//------------------------------------------------------
		public function execute(): Boolean
		{
			if (!m_downloading && 
				m_downloader && 
				m_downloader.init(m_taskModel.bookSTR))
			{
				m_downloading = true;
				
				m_taskModel.log = "Begin Downloading...";
				
				this.dispatchEvent(new ModelEvent(ModelEvent.DOWNLOAD_BEGIN));
				
				m_downloader.addEventListener(DataEvent.START, onDownloadStart);
				m_downloader.addEventListener(DataEvent.COMPLETE, onDownloadComplete);
				m_downloader.addEventListener(DataEvent.ERROR, onDownloadError);
				
				m_iterator.init(m_taskModel.pageType);
				doExecute();
				return true;
			}
			return false;
		}
		
		public function cancel(): Boolean
		{
			if (m_downloading)
			{
				m_downloading = false;
				
				m_taskModel.log += "\nStop Downloading.";
				
				this.dispatchEvent(new ModelEvent(ModelEvent.DOWNLOAD_STOP));
				
				m_downloader.removeEventListener(DataEvent.START, onDownloadStart);
				m_downloader.removeEventListener(DataEvent.COMPLETE, onDownloadComplete);
				m_downloader.removeEventListener(DataEvent.ERROR, onDownloadError);
				m_downloader.cancel();
				return true;
			}
			return false;
		}
		
		private function stop(): Boolean
		{
			if (m_downloading)
			{
				m_downloading = false;
				
				m_taskModel.log += "\nEnd Downloading.";
				
				this.dispatchEvent(new ModelEvent(ModelEvent.DOWNLOAD_COMPLETE));
				
				m_downloader.removeEventListener(DataEvent.START, onDownloadStart);
				m_downloader.removeEventListener(DataEvent.COMPLETE, onDownloadComplete);
				m_downloader.removeEventListener(DataEvent.ERROR, onDownloadError);
				return true;
			}
			return false;
		}
		
		private function doExecute(): void
		{
			if (m_iterator.isValid)
			{
				// get current page to be downloaded
				var pageType: BookPageType = m_iterator.curPageType;
				var pageOriginName: String = BookPageDefine.getPageOriginName(pageType.typeName, m_iterator.curPageNumber);
				var pageOrderName: String = BookPageDefine.getPageOrderName(pageType.typeName, m_iterator.curPageNumber);
				
				// download current page
				if (FileUtil.checkExist(getPageFilePath(pageOriginName)))
				{
					onPageFileExist(pageOriginName);
				}
				else if (FileUtil.checkExist(getPageFilePath(pageOrderName)))
				{
					onPageFileExist(pageOriginName + " (" + pageOrderName + ")");
				}
				else
				{
					m_downloader.download(pageOriginName, this.targetPageZoom.zoomEnum);
				}
			}
			else
			{
				stop();
			}
		}
		
		//------------------------------------------------------
		private function getPageFilePath(pageName: String): String
		{
			return m_taskModel.bookHome + File.separator + pageName + ".png";
		}
		
		private function onDownloadStart(e: DataEvent): void
		{
			m_taskModel.log += "\nDownloading:  " + e.data.toString();
		}
		
		private function onDownloadComplete(e: DataEvent): void
		{
			var bytes: ByteArray = BookPageData(e.data).pageBytes;
			var filePath: String = getPageFilePath(BookPageData(e.data).pageName);
			if (FileUtil.writeBytes(filePath, bytes))
			{
				m_taskModel.log += "\nDownloaded:  " + BookPageData(e.data).pageName + "  √";
				
				this.dispatchEvent(new ModelEvent(ModelEvent.DOWNLOAD_PAGE));
				
				m_iterator.nextPageNumber();
				doExecute();
			}
			else
			{
				// make sure to add this to ???-app.xml for Android
				// <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
				m_taskModel.log += "\nFailed to save:  " + filePath + "  ×";
				this.cancel();
			}
		}
		
		private function onPageFileExist(pageName: String): void
		{
			m_taskModel.log += "\nAlready Exists:  " + pageName + "  √";
			
			m_iterator.nextPageNumber();
			doExecute();
		}
		
		private function onDownloadError(e: DataEvent): void
		{
			m_taskModel.log += "\nFailed to load:  " + e.data.toString() + "  ×";
			
			if (BookPageDefine.isContentPageType(m_iterator.curPageType.typeName))
			{
				m_iterator.nextPageNumber();
			}
			else
			{
				m_iterator.nextPageType();
			}
			doExecute();
		}
	}
}

import sigma.app.duxiu.data.BookPageType;
import sigma.app.duxiu.model.DuxiuDownTaskModel;
import sigma.app.duxiu.utils.BookPageDefine;

class BookPageIterator
{
	private var m_taskModel: DuxiuDownTaskModel;
	
	private var m_targetPageTypes: Vector.<BookPageType>;
	private var m_curPageTypeIndex: int;
	private var m_curPageNumber: int;
	
	public function BookPageIterator(taskModel: DuxiuDownTaskModel)
	{
		m_taskModel = taskModel;
	}
	
	public function dispose(): void
	{
		m_taskModel = null;
	}
	
	//------------------------------------------------------
	public function get curPageType(): BookPageType
	{
		if (m_targetPageTypes && 
			m_curPageTypeIndex >= 0 && 
			m_curPageTypeIndex < m_targetPageTypes.length)
		{
			return m_targetPageTypes[m_curPageTypeIndex];
		}
		return null;
	}
	
	private function get curFromPage(): Number
	{
		if (m_taskModel && this.curPageType)
		{
			return m_taskModel.getFromPage(this.curPageType.typeName);
		}
		return NaN;
	}
	
	private function get curToPage(): Number
	{
		if (m_taskModel && this.curPageType)
		{
			return m_taskModel.getToPage(this.curPageType.typeName);
		}
		return NaN;
	}
	
	public function get curPageNumber(): int
	{
		return m_curPageNumber;
	}
	
	public function get isValid(): Boolean
	{
		return this.isValidPageType && this.isValidPageNumber;
	}
	
	private function get isValidPageType(): Boolean
	{
		return (m_targetPageTypes && m_targetPageTypes.length > 0 && 
			m_curPageTypeIndex >= 0 && m_curPageTypeIndex < m_targetPageTypes.length);
	}
	
	private function get isValidPageNumber(): Boolean
	{
		return (m_curPageNumber >= this.curFromPage && m_curPageNumber <= this.curToPage);
	}
	
	//------------------------------------------------------
	public function init(pageType: String): void
	{
		m_targetPageTypes = BookPageDefine.getRealPageTypes(pageType);
		m_curPageTypeIndex = 0;
		m_curPageNumber = this.curFromPage;
	}
	
	public function nextPageNumber(): Boolean
	{
		m_curPageNumber++;
		
		if (this.isValid)
		{
			return true;
		}
		else
		{
			return nextPageType();
		}
	}
	
	public function nextPageType(): Boolean
	{
		m_curPageTypeIndex++;
		m_curPageNumber = this.curFromPage;
		
		return this.isValid;
	}
}