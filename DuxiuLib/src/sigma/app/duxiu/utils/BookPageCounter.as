package sigma.app.duxiu.utils
{
	import flash.filesystem.File;

	public class BookPageCounter
	{
		private var m_ranges: Vector.<BookPageRange> = 
			Vector.<BookPageRange>([
				new BookPageRange("正文"), 
				new BookPageRange("封面"), 
				new BookPageRange("书名"),	
				new BookPageRange("版权"),	
				new BookPageRange("前言"),	
				new BookPageRange("目录"), 
				new BookPageRange("附录"),	
				new BookPageRange("封底"), 
				new BookPageRange("插页")
			]);
		
		public function BookPageCounter()
		{
		}
		
		//--------------------------------------------------
		private function getPageRange(pageTypeName: String): BookPageRange
		{
			for each (var range: BookPageRange in m_ranges)
			{
				if (range.pageTypeName == pageTypeName)
				{
					return range;
				}
			}
			return null;
		}
		
		public function get contentPageRange(): BookPageRange
		{
			return getPageRange("正文");
		}
		
		public function get coverPageRange(): BookPageRange
		{
			return getPageRange("封面");
		}
		
		public function get titlePageRange(): BookPageRange
		{
			return getPageRange("书名");
		}
		
		public function get copyrightPageRange(): BookPageRange
		{
			return getPageRange("版权");
		}
		
		public function get forwordPageRange(): BookPageRange
		{
			return getPageRange("前言");
		}
		
		public function get tocPageRange(): BookPageRange
		{
			return getPageRange("目录");
		}
		
		public function get attachPageRange(): BookPageRange
		{
			return getPageRange("附录");
		}
		
		public function get backPageRange(): BookPageRange
		{
			return getPageRange("封底");
		}
		
		public function get insetPageRange(): BookPageRange
		{
			return getPageRange("插页");
		}
		
		public function get numPages(): int
		{
			return this.contentPageRange.total + 
				this.coverPageRange.total + 
				this.titlePageRange.total + 
				this.copyrightPageRange.total + 
				this.forwordPageRange.total + 
				this.tocPageRange.total + 
				this.attachPageRange.total + 
				this.backPageRange.total + 
				this.insetPageRange.total;
		}
		
		public function get numMissings(): int
		{
			return this.contentPageRange.numMissings + 
				this.coverPageRange.numMissings + 
				this.titlePageRange.numMissings + 
				this.copyrightPageRange.numMissings + 
				this.forwordPageRange.numMissings + 
				this.tocPageRange.numMissings + 
				this.attachPageRange.numMissings + 
				this.backPageRange.numMissings + 
				this.insetPageRange.numMissings;
		}
		
		public function get numOriginRenamed(): int
		{
			return this.contentPageRange.numOriginRename + 
				this.coverPageRange.numOriginRename + 
				this.titlePageRange.numOriginRename + 
				this.copyrightPageRange.numOriginRename + 
				this.forwordPageRange.numOriginRename + 
				this.tocPageRange.numOriginRename + 
				this.attachPageRange.numOriginRename + 
				this.backPageRange.numOriginRename + 
				this.insetPageRange.numOriginRename;
		}
		
		public function get numOrderRenamed(): int
		{
			return this.contentPageRange.numOrderRenamed + 
				this.coverPageRange.numOrderRenamed + 
				this.titlePageRange.numOrderRenamed + 
				this.copyrightPageRange.numOrderRenamed + 
				this.forwordPageRange.numOrderRenamed + 
				this.tocPageRange.numOrderRenamed + 
				this.attachPageRange.numOrderRenamed + 
				this.backPageRange.numOrderRenamed + 
				this.insetPageRange.numOrderRenamed;
		}
		
		public function toString(): String
		{
			return "总计:  " + this.numPages + 
				   "\n缺页:  " + this.numMissings + 
				   "\n正文:  " + this.contentPageRange.toString() + 
				   "\n封面:  " + this.coverPageRange.toString() + 
				   "\n书名:  " + this.titlePageRange.toString() + 
				   "\n版权:  " + this.copyrightPageRange.toString() + 
				   "\n前言:  " + this.forwordPageRange.toString() + 
				   "\n目录:  " + this.tocPageRange.toString() + 
				   "\n附录:  " + this.attachPageRange.toString() + 
				   "\n封底:  " + this.backPageRange.toString() + 
				   "\n插页:  " + this.insetPageRange.toString();
		}
		
		//--------------------------------------------------
		private function beginCount(): void
		{
			for each (var range: BookPageRange in m_ranges)
			{
				range.init();
			}
		}
		
		private function endCount(): void
		{
			for each (var range: BookPageRange in m_ranges)
			{
				range.sort();
			}
		}
		
		private function countPage(pageName: String): void
		{
			for each (var range: BookPageRange in m_ranges)
			{
				if (range.add(pageName))
				{
					break;
				}
			}
		}
		
		public function count(dirPath: String): Boolean
		{
			beginCount();
			
			try
			{
				var file: File = new File(dirPath);
				if (file.exists && file.isDirectory)
				{
					
					var subFiles: Array = file.getDirectoryListing();
					for each (var subFile: File in subFiles)
					{
						if (!subFile.isDirectory)
						{
							var pageName: String = subFile.name;
							countPage(pageName);
						}
					}
					
					endCount();
					return true;
				}
			}
			catch (e: Error)
			{}
			
			endCount();
			return false;
		}
	}
}