package sigma.app.duxiu.data
{
	import sigma.lib.utils.BrowserUtil;

	public class BrowseItem
	{
		public var name: String;
		public var url: String;
		
		public function BrowseItem(name: String, url: String)
		{
			this.name = name;
			this.url = url;
		}
		
		public function get httpURL(): String
		{
			return BrowserUtil.getHttpURL(this.url);
		}
	}
}