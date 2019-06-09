package sigma.lib.utils
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	public class ImageUtil
	{
		public static const supportExtension: Array = ["png", "jpg", "gif"];
		
		public static function isSupportedImageType(extension: String): Boolean
		{
			return supportExtension.indexOf(extension.toLowerCase()) >= 0;
		}
		
		public static function isSupportedImageSize(size: Point): Boolean
		{
			if (size.x > 0 && size.y > 0)
			{
				if (FlashPlayerUtil.mainVersion >= 10 || AIRUtil.mainVersion >= 1.5)//FP10 and AIR1.5
				{
					return size.x <= 8191 && size.y <= 8191 && size.x * size.y <= 16777215; 
				}
				else if (FlashPlayerUtil.mainVersion <= 9 || AIRUtil.mainVersion <= 1.1)//FP9 and AIR1.1 earlier
				{
					return size.x <= 2880 && size.y <= 2880;
				}
				else
				{
					try
					{
						var testBmpData: BitmapData = new BitmapData(size.x, size.y);
						testBmpData.dispose();
						return true;
					}
					catch (e: Error)
					{}
				}
			}
			return false;
		}
		
		public static function checkImageComplete(url: String, onCheckImageComplete: Function): void
		{
//			var loader: Loader = new Loader();
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e: Event): void
//			{
//				onCheckImageComplete(true);
//			});
//			
//			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function onError(e: Event): void
//			{
//				onCheckImageComplete(false);
//			});
//			loader.load(new URLRequest(url));
		}
		
		public static function getImageSize(url: String, onGetImageSize: Function): void
		{
			url = StringUtil.replaceAll(url, "\\\\", "\\");
			
			//支持的图片格式为jpg/gif/png
			var request: URLRequest = new URLRequest(url);
			var parser: ImageParser = new ImageParser();
			parser.addEventListener(ImageParser.PARSE_COMPLETE, sizeComplete);
			parser.addEventListener(ImageParser.PARSE_FAILED, sizeFailed);
			parser.parse(request);
			function sizeComplete(evt: Event): void
			{
				onGetImageSize(new Point(parser.contentWidth, parser.contentHeight));
			}
			function sizeFailed(evt: Event): void
			{
				onGetImageSize(null);
			}
		}
		
		public static function getImageSizeList(urls: Vector.<String>, onGetImageSizeList: Function): void
		{
			var sizes: Vector.<Point> = new Vector.<Point>();
			getImageSizeAt(0, urls, sizes, onGetImageSizeList);
		}
		
		private static function getImageSizeAt(i: int, urls: Vector.<String>, sizes: Vector.<Point>, onGetImageSizeList: Function): void
		{
			if (i == urls.length)
			{
				onGetImageSizeList(sizes);
			}
			else
			{
				getImageSize(urls[i], function(size: Point): void
				{
					sizes.push(size);
					getImageSizeAt(i + 1, urls, sizes, onGetImageSizeList);
				});
			}
		}
	}
}

//copy from: http://bbs.blueidea.com/thread-2749287-1-1.html

/*
@Name:	ImageParser.as
@Usage:	在图片未下载完成前获取图像的图片,支持jpg,gif,png格式。
		因为有些图像信息格式并不完全符合标准,因此不保证所有图片都能正确获取结果。
		如果问题请通知我，谢谢。
@Author:Flashlizi(www.flashrek.com)
@Date:	2007-05-18
*/
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.Endian;

class ImageParser extends URLStream
{
	/*HexTag		数据标记, 每串标记作为标记数组里的一个元素
	leapLength		跳过的字节数
	fileType		文件类型
	parseComplete	解析完成标记
	contentHeight	目标高度
	contentWidth	目标宽度
	isAPPnExist		标记JPG图片的APPn数据段是否存在, 默认为无
	*/
	protected static  const JPGHexTag: Array = [[0xFF,0xC0,0x00,0x11,0x08]];
	protected static  const PNGHexTag: Array = [[0x49,0x48,0x44,0x52]];
	protected static  const GIFHexTag: Array = [[0x21,0xF9,0x04],[0x00,0x2C]];;
	
	protected var APPnTag: Array;
	protected var HexTag: Array;
	protected var address: uint;
	protected var fileType: String;
	protected var byte: uint;
	protected var index: uint = 0;
	protected var leapLength: uint;
	private var parseComplete: Boolean = false;
	private var match: Boolean = false;
	private var isAPPnExist: Boolean = false;
	public var contentHeight: uint;
	public var contentWidth: uint;
	
	public static  const PARSE_FAILED: String = "PARSE_FAILED";
	public static  const PARSE_COMPLETE: String = "PARSE_COMPLETE";
	
	public function ImageParser()
	{
	}
	
	//解析对象
	public function parse(uq: URLRequest): void
	{
		addEventListener(ProgressEvent.PROGRESS, parseHandler);
		addEventListener(Event.COMPLETE, completeHandler);
		addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		fileType = uq.url.slice(uq.url.lastIndexOf(".") + 1).toLowerCase();
		switch (fileType)
		{
			case "png":
				HexTag = PNGHexTag;
				break;
			case "jpg":
				HexTag = JPGHexTag;
				APPnTag = new Array();
				break;
			case "gif":
				//gif图像数据endian是LITTLE_ENDIAN
				endian = Endian.LITTLE_ENDIAN;
				HexTag = GIFHexTag;
				leapLength = 4;
				break;
		}
		load(uq);
	}
	
	//解析数据流
	protected function parseHandler(evt: ProgressEvent): void
	{
		if (fileType == "jpg")
		{
			JPGAPPnMatch();
		}
		else
		{
			matchHexTag();
		}
		if (parseComplete)
		{
			dispatchEvent(new Event(PARSE_COMPLETE));
			removeEventListener(ProgressEvent.PROGRESS,parseHandler);
			if (connected)
			{
				close();
			}
		}
	}
	
	//解析完成
	protected function completeHandler(evt: Event): void
	{
		if (!contentWidth || !contentHeight)
		{
			dispatchEvent(new Event(PARSE_FAILED));
		}
	}
	
	protected function errorHandler(evt: Event): void
	{
		dispatchEvent(new Event(PARSE_FAILED));
	}
	
	//比较SOF0数据标签,其中包含width和height信息
	protected function matchHexTag(): void
	{
		var len:uint = HexTag.length;
		while (bytesAvailable > HexTag[0].length)
		{
			match = false;
			byte = readUnsignedByte();
			address++;
			if (byte == HexTag[0][index])
			{
				//trace(byte.toString(16).toUpperCase());
				match = true;
				if (index >= HexTag[0].length - 1 && len == 1)
				{
					getWidthAndHeight();
					parseComplete=true;
					break;
				}
				else if (index >= HexTag[0].length - 1 && len > 1)
				{
					HexTag.shift();
					index = 0;
					matchHexTag();
					break;
				}
			}
			if (match)
			{
				index++;
			}
			else
			{
				index=0;
			}
		}
	}
	
	//因为JPG图像比较复杂，有的有缩略图APPn标签里(缩略图同样有SOF0标签)，所有先查找APPn标签
	protected function JPGAPPnMatch(): void
	{
		while (bytesAvailable > leapLength)
		{
			match = false;
			byte = readUnsignedByte();
			address++;
			if (byte == 0xFF)
			{
				byte = readUnsignedByte();
				address++;
				/*如果byte在0xE1与0xEF之间，即找到一个APPn标签.
				APPn标签为(0xFF 0xE1到0xFF 0xEF)*/
				if (byte >= 225 && byte <= 239)
				{
					isAPPnExist = true;
					//trace(byte.toString(16).toUpperCase());
					leapLength = readUnsignedShort() - 2;
					leapBytes(leapLength);
					JPGAPPnMatch();
				}
			}
			//APPn标签搜索完毕后即可开始比较SOF0标签
			if (byte != 0xFF && leapLength != 0)
			{
				matchHexTag();
				break;
			}
			/*如果超过一定数据还未找到APPn,则认为此JPG无APPn,直接开始开始比较SOF0标签。
			这里我取巧选了一个100作为判断,故并不能保证100%有效,但如重新解析的话效率并不好。
			如果谁有更有效的解决办法请告诉我，谢谢。
			*/
			if (address > 100 && isAPPnExist == false)
			{
				matchHexTag();
				break;
			}
		}
	}
	
	//跳过count个字节数
	protected function leapBytes(count: uint):void
	{
		for (var i:uint = 0; i < count; i++)
		{
			readByte();
		}
		address+= count;
	}
	
	//获取加载对象的width和height
	protected function getWidthAndHeight(): void
	{
		if (fileType == "gif")
		{
			leapBytes(leapLength);
		}
		switch (fileType)
		{
			case "png" :
				contentWidth = readUnsignedInt();
				contentHeight = readUnsignedInt();
				break;
			case "gif" :
				contentWidth = readUnsignedShort();
				contentHeight = readUnsignedShort();
				break;
			case "jpg" :
				contentHeight = readUnsignedShort();
				contentWidth = readUnsignedShort();
				break;
		}
	}
}