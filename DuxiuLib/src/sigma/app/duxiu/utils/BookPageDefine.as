package sigma.app.duxiu.utils
{
	import sigma.app.duxiu.data.BookPageType;
	import sigma.app.duxiu.data.BookPageZoom;
	import sigma.lib.utils.StringUtil;

	public class BookPageDefine
	{
		public static const PageTypeAll: String = "全部";
		public static const PageTypeOthers: String = "其他";
		public static const PageTypeContent: String = "正文";
		
		private static const PageOriginNameLength: uint = 6;
		
		public static const PageZoomOrigin: String = "原图";
		public static const PageZoomLarge: String = "大图";
		public static const PageZoomMedium: String = "中图";
		public static const PageZoomSmall: String = "小图";
		
		public static const pageZooms: Vector.<BookPageZoom> = 
			Vector.<BookPageZoom>([
				new BookPageZoom("原图", 3), 
				new BookPageZoom("大图", 2),
				new BookPageZoom("中图", 1),
				new BookPageZoom("小图", 0)
			]);
		
		public static const pageTypes: Vector.<BookPageType> = 
			Vector.<BookPageType>([
				new BookPageType("全部", null, null, NaN),		//?
				new BookPageType("其他", null, null, NaN),		//?
				new BookPageType("正文", "0", "F0", NaN),		//text, cnt
				new BookPageType("封面", "cov", "A000", 2),		//cover, cov
				new BookPageType("书名", "bok", "B000", 1),		//title-page, bok
				new BookPageType("版权", "leg", "C000", 3),		//copyright-page, leg
				new BookPageType("前言", "fow", "D000", NaN),	//preface: fow, dir
				new BookPageType("目录", "!", "E0", NaN),		//toc
				new BookPageType("附录", "att", "G000", NaN),	//att
				new BookPageType("封底", "bac", "H000", NaN),	//bac
				new BookPageType("插页", "ins", "I000", NaN)	//ins
			]);
		
		public static function isOriginPageZoom(pageZoomEnum: int): Boolean
		{
			return pageZoomEnum == 3;
		}
		
		public static function isContentPageType(type: String): Boolean
		{
			return type == PageTypeContent;
		}
		
		public static function isFuzzyPageType(type: String): Boolean
		{
			return type == PageTypeAll || type == PageTypeOthers;
		}
		
		public static function getRealPageTypes(type: String): Vector.<BookPageType>
		{
			switch (type)
			{
				case PageTypeAll:
					return pageTypes.slice(2);
				case PageTypeOthers:
					return pageTypes.slice(3);
				default:
					var pageType: BookPageType = getPageType(type);
					if (pageType)
					{
						return Vector.<BookPageType>([pageType]);
					}
			}
			return null;
		}
		
		public static function getPageZoom(zoom: String): BookPageZoom
		{
			for each (var pageZoom: BookPageZoom in pageZooms)
			{
				if (pageZoom.zoomName == zoom)
					return pageZoom;
			}
			return null;
		}
		
		public static function getPageType(type: String): BookPageType
		{
			for each (var pageType: BookPageType in pageTypes)
			{
				if (pageType.typeName == type)
					return pageType;
			}
			return null;
		}
		
		public static function maxPageNo(type: String): int
		{
			var pageType: BookPageType = getPageType(type);
			if (pageType)
			{
				var maxNo: Number = pageType.maxNo;
				if (isNaN(maxNo))
				{
					var originSymbol: String = pageType.originSymbol;
					return repeatNum(9, BookPageDefine.PageOriginNameLength - originSymbol.length);
				}
				else
					return maxNo;
			}
			return 0;
		}
		
		public static function getPageTypeEx(pageName: String): BookPageType
		{
			if (pageName)
			{
				for each (var pageType: BookPageType in pageTypes)
				{
					if (StringUtil.checkPrefix(pageName, pageType.originSymbol) || 
						StringUtil.checkPrefix(pageName, pageType.orderSymbol))
					{
						return pageType;
					}
				}
			}
			return null;
		}
		
		public static function getPageOriginSymbol(pageName: String): String
		{
			var pageType: BookPageType = getPageTypeEx(pageName);
			return pageType ? pageType.originSymbol : null;
		}
		
		public static function getPageOrderSymbol(pageName: String): String
		{
			var pageType: BookPageType = getPageTypeEx(pageName);
			return pageType ? pageType.orderSymbol : null;
		}
		
		public static function getPageNo(pageName: String): uint
		{
			var pageType: BookPageType = getPageTypeEx(pageName);
			if (pageType)
			{
				if (StringUtil.checkPrefix(pageName, pageType.originSymbol))
				{
					return parseInt(pageName.replace(pageType.originSymbol, ""));
				}
				else if (StringUtil.checkPrefix(pageName, pageType.orderSymbol))
				{
					return parseInt(pageName.replace(pageType.orderSymbol, ""));
				}
			}
			return NaN;
		}
		
		public static function getPageName(type: String, pageNo: uint, bOrigin: Boolean): String
		{
			var pageType: BookPageType = getPageType(type);
			if (pageType && !isNaN(pageNo))
			{
				var originSymbol: String = pageType.originSymbol;
				var no: String = pageNo.toString();
				var zeros: String = repeatChar("0", PageOriginNameLength - originSymbol.length - no.length);
				return (bOrigin ? originSymbol : pageType.orderSymbol) + zeros + no;
			}
			return null;
		}
		
		public static function getPageOriginName(type: String, pageNo: uint): String
		{
			return getPageName(type, pageNo, true);
		}
		
		public static function getPageOrderName(type: String, pageNo: uint): String
		{
			return getPageName(type, pageNo, false);
		}
	}
}

function repeatChar(char: String, count: int): String
{
	var str: String = "";
	if (count > 0)
	{
		for (var i: int = 0; i < count; i++)
			str += char;
	}
	return str;
}

function repeatNum(digit: uint, count: int): int
{
	return parseInt(repeatChar(digit.toString(), count));
}