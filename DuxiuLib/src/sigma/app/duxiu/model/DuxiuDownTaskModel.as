package sigma.app.duxiu.model
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.app.duxiu.utils.BookPageDefine;
	import sigma.lib.tools.html.HtmlVarSearcher;
	import sigma.lib.utils.CookieUtil;
	import sigma.lib.utils.StringUtil;
	import sigma.lib.utils.SystemUtil;

	[Event(type="sigma.app.duxiu.events.ModelEvent", name="bookTitleChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="bookSsnoChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="bookNameChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="bookStrChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="bookSpageChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="bookEpageChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="pageTypeChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="fromPageChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="toPageChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="pageZoomChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="saveHomeChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="bookHomeChange")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="logChange")]
	public class DuxiuDownTaskModel extends EventDispatcher
	{
		private static function get defaultSaveHome(): String
		{
			var home: String = File.documentsDirectory.nativePath;
			if (!SystemUtil.isIOS)
			{
				home += File.separator + "DuxiuDown";
			}
			return home;
		}
		
		private var m_cookie: Object;
		
		private var m_title: String;
		private var m_ssNo: String;
		private var m_str: String;
		private var m_startPage: Number;
		private var m_endPage: Number;
		
		private var m_pageType: String;
		private var m_pageZoom: String;
		private var m_saveHome: String;
		
		private var m_log: String;
		
		private var m_searcher: HtmlVarSearcher;
		private var m_downloadModel: DuxiuDownDownloadModel;
		private var m_countModel: DuxiuDownCountModel;
		private var m_exportModel: DuxiuDownExportModel;
		
		public function DuxiuDownTaskModel()
		{
		}
		
		public function initialize(): void
		{
			m_cookie = CookieUtil.openCookie("taskModel");
			m_title = m_cookie.title;
			m_ssNo = m_cookie.ssNo;
			m_str = m_cookie.str;
			m_startPage = NULL(m_cookie.startPage) ? NaN : m_cookie.startPage;
			m_endPage = NULL(m_cookie.endPage) ? NaN : m_cookie.endPage;
			m_pageType = NULL(m_cookie.pageType) ? BookPageDefine.PageTypeAll : m_cookie.pageType;
			m_pageZoom = NULL(m_cookie.pageZoom) ? BookPageDefine.PageZoomLarge : m_cookie.pageZoom;
			m_saveHome = SystemUtil.isIOS || NULL(m_cookie.saveHome) ? defaultSaveHome : m_cookie.saveHome;
			m_log = m_cookie.log === undefined ? "" : m_cookie.log;
			
			m_searcher = new HtmlVarSearcher();
			
			m_downloadModel = new DuxiuDownDownloadModel();
			m_downloadModel.initialize(this);
			
			m_countModel = new DuxiuDownCountModel();
			m_countModel.initialize(this);
			
			m_exportModel = new DuxiuDownExportModel();
			m_exportModel.initialize(this);
		}
		
		public function finalize(): void
		{
			m_exportModel.finalize();
			m_exportModel = null;
			
			m_countModel.finalize();
			m_countModel = null;
			
			m_downloadModel.finalize();
			m_downloadModel = null;
			
			m_searcher = null;
			
			save();
		}
		
		public function save(): void
		{
			m_cookie.title = m_title;
			m_cookie.ssNo = m_ssNo;
			m_cookie.str = m_str;
			m_cookie.startPage = m_startPage;
			m_cookie.endPage = m_endPage;
			m_cookie.pageType = m_pageType;
			m_cookie.pageZoom = m_pageZoom;
			m_cookie.saveHome = m_saveHome;
			m_cookie.log = m_log;
			CookieUtil.closeCookie(m_cookie);
		}
		
		public function set bookTitle(value: String): void
		{
			value = StringUtil.replaceAll(value, "  ", " ");
			value = StringUtil.replaceAll(value, "/", "_");
			value = StringUtil.replaceAll(value, "\\", "_");
			
			if (m_title != value)
			{
				m_title = value;
				
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_TITLE_CHANGE));
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_NAME_CHANGE));
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_HOME_CHANGE));
			}
		}
		
		public function get bookTitle(): String
		{
			return m_title;
		}
		
		public function set bookSSNo(value: String): void
		{
			if (m_ssNo != value)
			{
				m_ssNo = value;
				
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_SSNO_CHANGE));
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_NAME_CHANGE));
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_HOME_CHANGE));
			}
		}
		
		public function get bookSSNo(): String
		{
			return m_ssNo;
		}
		
		public function get bookName(): String
		{
			var n1: String = StringUtil.trim(m_title);
			var n2: String = StringUtil.trim(m_ssNo);
			
			if (n1 == "" || n1 == null)
				return n2;
			else if (n2 == "" || n2 == null)
				return n1;
			else
				return n1 + "_" + n2;
		}
		
		public function get bookHome(): String
		{
			return this.saveHome + (this.bookName ? File.separator + this.bookName : "");
		}
		
		public function set bookSTR(value: String): void
		{
			if (value != m_str)
			{
				m_str = value;
				
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_STR_CHANGE));
			}
		}
		
		public function get bookSTR(): String
		{
			return m_str;
		}
		
		public function set startPage(value: Number): void
		{
			if (value != m_startPage)
			{
				var preFromPage: Number = this.fromPage;
				var preToPage: Number = this.toPage;
				
				m_startPage = value;
				
				checkPageRangeChange(preFromPage, preToPage);
				
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_SPAGE_CHANGE));
			}
		}
		
		public function get startPage(): Number
		{
			return m_startPage;
		}
		
		public function set endPage(value: Number): void
		{
			if (value != m_endPage)
			{
				var preFromPage: Number = this.fromPage;
				var preToPage: Number = this.toPage;
				
				m_endPage = value;
				
				checkPageRangeChange(preFromPage, preToPage);
				
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_EPAGE_CHANGE));
			}
		}
		
		public function get endPage(): Number
		{
			return m_endPage;
		}
		
		public function set pageType(value: String): void
		{
			if (value != m_pageType)
			{
				var preFromPage: Number = this.fromPage;
				var preToPage: Number = this.toPage;
				
				m_pageType = value;
				
				checkPageRangeChange(preFromPage, preToPage);
				
				this.dispatchEvent(new ModelEvent(ModelEvent.PAGE_TYPE_CHANGE));
			}
		}
		
		public function get pageType(): String
		{
			return m_pageType;
		}
		
		public function set pageZoom(value: String): void
		{
			if (value != m_pageZoom)
			{
				m_pageZoom = value;
				
				this.dispatchEvent(new ModelEvent(ModelEvent.PAGE_ZOOM_CHANGE));
			}
		}
		
		public function get pageZoom(): String
		{
			return m_pageZoom;
		}
		
		public function get fromPage(): Number
		{
			return getFromPage(m_pageType);
		}
		
		public function get toPage(): Number
		{
			return getToPage(m_pageType);
		}
		
		public function getFromPage(pageType: String): Number
		{
			return BookPageDefine.isFuzzyPageType(pageType) ? NaN : getMinPageNo(pageType);
		}
		
		public function getToPage(pageType: String): Number
		{
			return BookPageDefine.isFuzzyPageType(pageType) ? NaN : getMaxPageNo(pageType);
		}
		
		private function getMinPageNo(pageType: String): int
		{
			return BookPageDefine.isContentPageType(pageType) ? Math.max(1, m_startPage) : 1;
		}
		
		private function getMaxPageNo(pageType: String): int
		{
			return BookPageDefine.isContentPageType(pageType) ? Math.min(BookPageDefine.maxPageNo(pageType), m_endPage) : BookPageDefine.maxPageNo(pageType);
		}
		
		private function checkPageRangeChange(preFromPage: Number, preToPage: Number): void
		{
			if (preFromPage != this.fromPage)
			{
				this.dispatchEvent(new ModelEvent(ModelEvent.FROM_PAGE_CHANGE));
			}
			
			if (preToPage != this.toPage)
			{
				this.dispatchEvent(new ModelEvent(ModelEvent.TO_PAGE_CHANGE));
			}
		}
		
		public function set saveHome(value: String): void
		{
			if (m_saveHome != value)
			{
				m_saveHome = value;
				
				this.dispatchEvent(new ModelEvent(ModelEvent.SAVE_HOME_CHANGE));
				this.dispatchEvent(new ModelEvent(ModelEvent.BOOK_HOME_CHANGE));
			}
		}
		
		public function get saveHome(): String
		{
			return m_saveHome;
		}
		
		public function get log(): String
		{
			return m_log;
		}
		
		public function set log(value: String): void
		{
			if (value != m_log)
			{
				m_log = value;
				this.dispatchEvent(new ModelEvent(ModelEvent.LOG_CHANGE));
			}
		}
		
		//---------------------------------------------------
		public function fetchParams(url: String): Boolean
		{
			m_searcher.addEventListener(Event.COMPLETE, onSearchComplete);
			m_searcher.addEventListener(ErrorEvent.ERROR, onSearchError);
			return m_searcher.searchVar(url, "str");
		}
		
		public function get isParamsValid(): Boolean
		{
			return this.bookSTR && this.bookTitle && this.bookSSNo && 
				!isNaN(this.startPage) && !isNaN(this.endPage);
		}
		
		private function onSearchComplete(e: Event): void
		{
			m_searcher.removeEventListener(Event.COMPLETE, onSearchComplete);
			m_searcher.removeEventListener(ErrorEvent.ERROR, onSearchError);
			
			this.bookSTR = STRING(m_searcher.getVarProp("str"));
			this.startPage = NUMBER(m_searcher.getVarProp("spage"));
			this.endPage = NUMBER(m_searcher.getVarProp("epage"));
			this.bookTitle = STRING(m_searcher.getVarProp("title", true, true));
			this.bookSSNo = STRING(m_searcher.getVarProp("ssNo"));
		}
		
		private function onSearchError(e: ErrorEvent): void
		{
			m_searcher.removeEventListener(Event.COMPLETE, onSearchComplete);
			m_searcher.removeEventListener(ErrorEvent.ERROR, onSearchError);
		}
		
		//---------------------------------------------------
		public function get downloadModel(): DuxiuDownDownloadModel
		{
			return m_downloadModel;
		}
		
		public function get countModel(): DuxiuDownCountModel
		{
			return m_countModel;
		}
		
		public function get exportModel(): DuxiuDownExportModel
		{
			return m_exportModel;
		}
		
		public function get canFetchParams(): Boolean
		{
			return !m_downloadModel.isDownloading;
		}
		
		public function get canStartDownload(): Boolean
		{
			return !m_downloadModel.isDownloading && m_downloadModel.isDownloadable && 
				!m_exportModel.isExporting;
		}
		
		public function get canStopDownload(): Boolean
		{
			return m_downloadModel.isDownloading;
		}
		
		public function get canStartExport(): Boolean
		{
			return !m_exportModel.isExporting && m_exportModel.isExportable && 
				!m_downloadModel.isDownloading;
		}
		
		public function get canStopExport(): Boolean
		{
			return m_exportModel.isExporting;
		}
		
		public function get canOpenPDF(): Boolean
		{
			return m_exportModel.defaultPdfExist;
		}
		
		internal function get canRename(): Boolean
		{
			return m_countModel.counter.numPages > 0 && m_countModel.counter.numMissings == 0;
		}
		
		public function get canOriginRename(): Boolean
		{
			return this.canRename && m_countModel.counter.numOrderRenamed > 0;
		}
		
		public function get canOrderRename(): Boolean
		{
			return this.canRename && m_countModel.counter.numOriginRenamed > 0;
		}
		
		public function startDownload(): Boolean
		{
			return m_downloadModel.execute();
		}
		
		public function stopDownload(): Boolean
		{
			return m_downloadModel.cancel();
		}
		
		public function startExport(): Boolean
		{
			return m_exportModel.export();
		}
		
		public function stopExport(): Boolean
		{
			return m_exportModel.cancel();
		}
	}
}

function STRING(value: Object): String
{
	return value === null ? null : value.toString();
}

function NUMBER(value: Object): Number
{
	return value === null ? Number.NaN : Number(value);
}

function NULL(value: *): Boolean
{
	return value === undefined || value === null || (value is Number) && isNaN(value) || value === "";
}