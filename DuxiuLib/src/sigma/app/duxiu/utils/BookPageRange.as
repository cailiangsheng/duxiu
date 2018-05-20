package sigma.app.duxiu.utils
{
	import sigma.app.duxiu.data.BookPageType;
	import sigma.lib.utils.StringUtil;

	internal class BookPageRange
	{
		private var m_pageTypeName: String;
		private var m_range: Array;
		
		private var m_numOriginRenamed: int;
		private var m_numOrderRenamed: int;
		
		public function BookPageRange(pageTypeName: String)
		{
			m_pageTypeName = pageTypeName;
			m_range = [];
		}
		
		public function init(): void
		{
			m_range.length = 0;
			m_numOriginRenamed = 0;
			m_numOrderRenamed = 0;
		}
		
		public function sort(): void
		{
			m_range.sort(Array.NUMERIC);
		}
		
		public function add(pageName: String): Boolean
		{
			var pageType: BookPageType = BookPageDefine.getPageTypeEx(pageName);
			if (pageType && m_pageTypeName == pageType.typeName)
			{
				var pageNo: int = BookPageDefine.getPageNo(pageName);
				if (m_range.indexOf(pageNo) < 0)
				{
					if (StringUtil.checkPrefix(pageName, pageType.originSymbol))
					{
						m_numOriginRenamed++;
					}
					else if (StringUtil.checkPrefix(pageName, pageType.orderSymbol))
					{
						m_numOrderRenamed++;
					}
					
					m_range.push(pageNo);
					return true;
				}
			}
			return false;
		}
		
		public function get pageTypeName(): String
		{
			return m_pageTypeName;
		}
		
		public function get total(): int
		{
			return m_range.length;
		}
		
		public function get minNo(): int
		{
			return m_range.length > 0 ? m_range[0] : 0;
		}
		
		public function get maxNo(): int
		{
			return m_range.length > 0 ? m_range[m_range.length - 1] : 0;
		}
		
		public function get sequential(): Boolean
		{
			return this.numMissings == 0;
		}
		
		public function get numMissings(): int
		{
			return this.total == 0 ? 0 : this.maxNo - this.minNo + 1 - this.total;
		}
		
		public function get numOriginRename(): int
		{
			return m_numOriginRenamed;
		}
		
		public function get numOrderRenamed(): int
		{
			return m_numOrderRenamed;
		}
		
		public function get missings(): Vector.<int>
		{
			var arr: Vector.<int> = new Vector.<int>();
			if (!this.sequential)
			{
				for (var i: int = this.minNo, max: int = this.maxNo; i <= max; i++)
				{
					if (m_range.indexOf(i) < 0)
					{
						arr.push(i);
					}
				}
			}
			return arr;
		}
		
		public function toString(): String
		{
			return this.total + "  [" + this.minNo + ", "  + this.maxNo + "]  " + (this.sequential ? "√" : "×");
		}
	}
}