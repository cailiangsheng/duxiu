package sigma.app.duxiu.data
{
	import flash.utils.ByteArray;

	public class BookPageData
	{
		public var pageName: String;
		public var pageBytes: ByteArray;
		
		public function BookPageData(pageName: String, pageBytes: ByteArray)
		{
			this.pageName = pageName;
			this.pageBytes = pageBytes;
		}
	}
}