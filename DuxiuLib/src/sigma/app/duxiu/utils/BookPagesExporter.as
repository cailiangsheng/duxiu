package sigma.app.duxiu.utils
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sigma.app.duxiu.data.BookPageType;
	import sigma.app.duxiu.events.DataEvent;
	import sigma.lib.utils.FileUtil;
	
	[Event(type="sigma.app.duxiu.events.DataEvent", name="start")]
	[Event(type="sigma.app.duxiu.events.DataEvent", name="step")]
	[Event(type="sigma.app.duxiu.events.DataEvent", name="complete")]
	[Event(type="sigma.app.duxiu.events.DataEvent", name="error")]
	[Event(type="sigma.app.duxiu.events.DataEvent", name="failed")]
	[Event(type="sigma.app.duxiu.events.DataEvent", name="stop")]
	public class BookPagesExporter extends EventDispatcher
	{
		private static const EXPORT_DELAY: int = 1;
		
		private var m_homeFile: File;
		private var m_exportList: Array;
		
		private var m_exportPath: String;
		private var m_exportImpl: IPagesExporter;
		private var m_timeoutId: int;
		
		public function BookPagesExporter()
		{
			m_exportList = [];
			m_exportPath = null;
			m_exportImpl = new PurePdfExporter();//new AlivePdfExporter();
			m_timeoutId = 0;
		}
		
		public function get isExporting(): Boolean
		{
			return m_exportPath != null;
		}
		
		public function cancel(): Boolean
		{
			if (this.isExporting)
			{
				if (m_timeoutId)
				{
					clearTimeout(m_timeoutId);
					m_timeoutId = 0;
				}
				
				m_exportList.length = 0;
				m_exportPath = null;
				m_exportImpl.dispose();
				
				this.dispatchEvent(new DataEvent(DataEvent.STOP));
				return true;
			}
			return false;
		}
		
		public function exportPDF(pagesHome: String, pdfPath: String = null): Boolean
		{
			if (!this.isExporting)
			{
				return initPages(pagesHome) && beginExportPDF(pdfPath);
			}
			return false;
		}
		
		private function initPages(pagesHome: String): Boolean
		{
			try
			{
				var homeFile: File = new File(pagesHome);
				if (homeFile.exists && homeFile.isDirectory)
				{
					m_homeFile = null;
					m_exportList.length = 0;
					
					var files: Array = homeFile.getDirectoryListing();
					for each (var file: File in files)
					{
						var pageType: BookPageType = BookPageDefine.getPageTypeEx(file.name);
						if (pageType)
						{
							var pageTypeName: String = pageType.typeName;
							var pageNo: int = BookPageDefine.getPageNo(file.name);
							var item: ExportItem = new ExportItem();
							item.orderName = BookPageDefine.getPageOrderName(pageTypeName, pageNo);
							item.pageFile = file;
							m_exportList.push(item);
						}
					}
					
					if (m_exportList.length > 0)
					{
						m_homeFile = homeFile;
						m_exportList.sortOn("orderName");
						return true;
					}
				}
			}
			catch (e: Error)
			{}
			return false;
		}
		
		public static function getPdfPath(pagesHome: String): String
		{
			try
			{
				var homeFile: File = new File(pagesHome);
				var pdfPath: String = homeFile.parent.nativePath + File.separator + homeFile.name + ".pdf";
				return pdfPath;
			}
			catch (e: Error)
			{}
			return null;
		}
		
		private function beginExportPDF(pdfPath: String = null): Boolean
		{
			if (m_homeFile)
			{
				if (pdfPath == null)
				{
					pdfPath = getPdfPath(m_homeFile.nativePath);
				}
				
				if (FileUtil.checkOverwritable(pdfPath))
				{
					m_exportPath = pdfPath;
					m_exportImpl.beginDocument();
					
					this.dispatchEvent(new DataEvent(DataEvent.START));
					
					doExportPDF();
					return true;
				}
			}
			return false;
		}
		
		private function endExportPDF(): void
		{
			var pdfBytes: ByteArray = m_exportImpl.endDocument();
			var isExported: Boolean = FileUtil.writeBytes(m_exportPath, pdfBytes);
			
			var event: DataEvent = new DataEvent(isExported ? DataEvent.COMPLETE : DataEvent.FAILED);
			event.data = m_exportPath;
			this.dispatchEvent(event);
			
			m_timeoutId = 0;
			m_exportList.length = 0;
			m_exportPath = null;
			m_exportImpl.dispose();
		}
		
		private function doExportPDF(): void
		{
			var item: ExportItem = m_exportList.shift();
			if (item)
			{
				try
				{
					var bytes: ByteArray = FileUtil.readBytes(item.pageFile.nativePath);
					m_exportImpl.addPageImage(bytes);
					
					var event: DataEvent = new DataEvent(DataEvent.STEP);
					event.data = item.pageFile.name;
					this.dispatchEvent(event);
					
					trace("Export Step:", item.pageFile.name);
				}
				catch (e: Error)
				{
					event = new DataEvent(DataEvent.ERROR);
					event.data = item.pageFile.name + "  [" + e.message + "]";
					this.dispatchEvent(event);
					
					trace("Export Error:", item.pageFile.name, e.message);
				}
				
				m_timeoutId = setTimeout(doExportPDF, EXPORT_DELAY);
			}
			else
			{
				endExportPDF();
			}
		}
	}
}

import flash.filesystem.File;
import flash.utils.ByteArray;

//import org.alivepdf.display.Display;
//import org.alivepdf.display.PageMode;
//import org.alivepdf.images.ColorSpace;
//import org.alivepdf.layout.Layout;
//import org.alivepdf.layout.Mode;
//import org.alivepdf.layout.Position;
//import org.alivepdf.layout.Resize;
//import org.alivepdf.pdf.PDF;
//import org.alivepdf.saving.Method;

import org.purepdf.elements.RectangleElement;
import org.purepdf.elements.images.ImageElement;
import org.purepdf.pdf.PageSize;
import org.purepdf.pdf.PdfDocument;
import org.purepdf.pdf.PdfViewPreferences;
import org.purepdf.pdf.PdfWriter;

class ExportItem
{
	public var pageFile: File;
	public var orderName: String;
}

interface IPagesExporter
{
	function dispose(): void;
	function beginDocument(): void;
	function addPageImage(imageBytes: ByteArray): void;
	function endDocument(): ByteArray;
}

//class AlivePdfExporter implements IPagesExporter
//{
//	private static var ms_pageResizeMode: Resize = new Resize(Mode.RESIZE_PAGE, Position.CENTERED);
//	
//	private var m_exportPDF: PDF;
//	
//	public function dispose(): void
//	{
//		m_exportPDF = null;
//	}
//	
//	public function beginDocument(): void
//	{
//		m_exportPDF = new PDF();
//		m_exportPDF.setMargins(0, 0, 0, 0);
//		m_exportPDF.setDisplayMode(Display.FULL_WIDTH, Layout.ONE_COLUMN, PageMode.USE_NONE);
//	}
//	
//	public function addPageImage(imageBytes: ByteArray): void
//	{
//		if (m_exportPDF)
//		{
//			m_exportPDF.addPage();
//			m_exportPDF.addImageStream(imageBytes, ColorSpace.DEVICE_RGB, ms_pageResizeMode);
//		}
//	}
//	
//	public function endDocument(): ByteArray
//	{
//		var pdfBytes: ByteArray = null;
//		if (m_exportPDF)
//		{
//			pdfBytes = m_exportPDF.save(Method.LOCAL);
//		}
//		return pdfBytes;
//	}
//}

class PurePdfExporter implements IPagesExporter
{
	private var m_exportBytes: ByteArray;
	private var m_exportPDF: PdfDocument;
	
	public function dispose(): void
	{
		m_exportBytes = null;
		m_exportPDF = null;
	}
	
	public function beginDocument(): void
	{
		m_exportBytes = new ByteArray();
		m_exportPDF = null;
	}
	
	public function addPageImage(imageBytes: ByteArray): void
	{
		var image: ImageElement = ImageElement.getInstance(imageBytes);
		var pageSize: RectangleElement = PageSize.create(image.width, image.height);
		
		if (m_exportPDF == null)
		{
			m_exportPDF = PdfWriter.create(m_exportBytes, pageSize).pdfDocument;
			m_exportPDF.setMargins(0, 0, 0, 0);
			m_exportPDF.setViewerPreferences(
				PdfViewPreferences.FitWindow | 
				PdfViewPreferences.PageLayoutOneColumn | 
				PdfViewPreferences.PageModeUseNone);
			m_exportPDF.open();
		}
		else
		{
			m_exportPDF.pageSize = pageSize;
		}
		
		image.alignment = ImageElement.LEFT;
		image.borderWidth = 0;
		m_exportPDF.add(image);
	}
	
	public function endDocument(): ByteArray
	{
		if (m_exportPDF)
		{
			m_exportPDF.close();
		}
		return m_exportBytes;
	}
}