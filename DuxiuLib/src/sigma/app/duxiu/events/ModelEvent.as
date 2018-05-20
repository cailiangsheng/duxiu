package sigma.app.duxiu.events
{
	import flash.events.Event;
	
	public class ModelEvent extends Event
	{
		public static const BROWSE_LOCATION_CHANGE: String = "browseLocationChange";
		
		public static const ACTIVE_TAB_CHANGE: String = "activeTabChange";
		
		public static const BOOK_TITLE_CHANGE: String = "bookTitleChange";
		public static const BOOK_SSNO_CHANGE: String = "bookSsnoChange";
		public static const BOOK_NAME_CHANGE: String = "bookNameChange";
		public static const BOOK_STR_CHANGE: String = "bookStrChange";
		public static const BOOK_SPAGE_CHANGE: String = "bookSpageChange";
		public static const BOOK_EPAGE_CHANGE: String = "bookEpageChange";
		public static const PAGE_TYPE_CHANGE: String = "pageTypeChange";
		public static const FROM_PAGE_CHANGE: String = "fromPageChange";
		public static const TO_PAGE_CHANGE: String = "toPageChange";
		public static const PAGE_ZOOM_CHANGE: String = "pageZoomChange";
		public static const SAVE_HOME_CHANGE: String = "saveHomeChange";
		public static const BOOK_HOME_CHANGE: String = "bookHomeChange";
		public static const LOG_CHANGE: String = "logChange";
		
		public static const DOWNLOAD_BEGIN: String = "downlodBegin";
		public static const DOWNLOAD_PAGE: String = "downloadPage";
		public static const DOWNLOAD_COMPLETE: String = "downloadComplete";
		public static const DOWNLOAD_STOP: String = "downloadStop";
		
		public static const PAGE_COUNT_CHANGE: String = "pageCountChange";
		
		public static const EXPORT_BEGIN: String = "downlodBegin";
		public static const EXPORT_COMPLETE: String = "exportComplete";
		public static const EXPORT_FAILED: String = "exportFailed";
		public static const EXPORT_STOP: String = "exportStop";
		
		public var data: Object;
		
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e: ModelEvent = new ModelEvent(this.type, this.bubbles, this.cancelable);
			e.data = this.data;
			return e;
		}
	}
}