package sigma.app.duxiu.model
{
	import flash.events.EventDispatcher;
	
	import sigma.app.duxiu.data.BrowseItem;
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.lib.utils.BrowserUtil;
	import sigma.lib.utils.CookieUtil;

	[Event(type="sigma.app.duxiu.events.ModelEvent", name="browseLocationChange")]
	public class DuxiuDownBrowseModel extends EventDispatcher
	{
		private var m_cookie: Object;
		
		private var m_bookmarks: Vector.<BrowseItem>;
		private var m_location: String;
		
		public function DuxiuDownBrowseModel()
		{
		}
		
		public function initialize(): void
		{
			m_bookmarks = 
				Vector.<BrowseItem>([
					new BrowseItem("读秀首页", "www.duxiu.com"),
					new BrowseItem("指针首页", "www.zhizhen.com"),
					new BrowseItem("超星首页", "www.sslibrary.com"),
					null,
					new BrowseItem("QQ邮箱", "mail.qq.com"),
					new BrowseItem("网易邮箱", "mail.163.com"),
					new BrowseItem("21CN邮箱", "mail.21cn.com"),
					null,
					new BrowseItem("粘贴打开", BrowserUtil.URL_CLIPBORAD)
				]);
			
			m_cookie = CookieUtil.openCookie("browseModel");
			m_location = m_cookie.location === undefined ? m_bookmarks[0].url : m_cookie.location;
		}
		
		public function finalize(): void
		{
			save();
		}
		
		public function save(): void
		{
			m_cookie.location = m_location;
			CookieUtil.closeCookie(m_cookie);
		}
		
		public function get bookmarks(): Vector.<BrowseItem>
		{
			return m_bookmarks;
		}
		
		public function set location(value: String): void
		{
			if (value != m_location)
			{
				m_location = value;
				
				var event: ModelEvent = new ModelEvent(ModelEvent.BROWSE_LOCATION_CHANGE);
				this.dispatchEvent(event);
			}
		}
		
		public function get location(): String
		{
			return m_location;
		}
	}
}