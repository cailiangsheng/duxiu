package sigma.app.duxiu
{
	import flash.filesystem.File;
	
	import sigma.app.duxiu.data.EnumTab;
	import sigma.app.duxiu.model.DuxiuDownModel;
	import sigma.app.duxiu.utils.BookPageRename;
	import sigma.lib.utils.FileUtil;

	public class DuxiuBaseController
	{
		protected var m_model: DuxiuDownModel;
		
		public function DuxiuBaseController()
		{
		}
		
		public function initialize(model: DuxiuDownModel): void
		{
			m_model = model;
		}
		
		public function finalize(): void
		{
			m_model = null;
		}
		
		public function alert(message: String): void
		{
			throw(new Error("to be overrided"));
		}
		
		//-----------------------------------------
		public function onWakeUp(): void
		{
			m_model.acitvate();
		}
		
		public function onSleep(): void
		{
			m_model.deactivate();
		}
		
		public function onBrowse(url: String): void
		{
			m_model.browseModel.location = url;
			m_model.activeTab = EnumTab.TAB_BROWSE;
		}
		
		public function onFetchParams(): void
		{
			if (!m_model.taskModel.fetchParams(m_model.browseModel.location))
			{
				alert("无法获取参数!");
			}
		}
		
		public function onStartDownload(): void
		{
			if (!m_model.taskModel.startDownload())
			{
				alert("无法开始下载!");
			}
		}
		
		public function onStopDownload(): void
		{
			if (!m_model.taskModel.stopDownload())
			{
				alert("无法停止下载!");
			}
		}
		
		public function onStopAll(): void
		{
			if (!m_model.taskModel.stopDownload() && 
				!m_model.taskModel.stopExport())
			{
				alert("无操作可停止!");
			}
		}
		
		public function onOpenDir(): void
		{
			if (!FileUtil.exploreDir(m_model.taskModel.bookHome) && 
				!FileUtil.exploreDir(m_model.taskModel.saveHome))
			{
				alert("无法打开目录!");
			}
		}
		
		public function onOpenPDF(): void
		{
			if (!FileUtil.exploreFile(m_model.taskModel.exportModel.defaultPdfPath))
			{
				alert("无法打开PDF!");
			}
		}
		
		public function onStartExport(): void
		{
			if (!m_model.taskModel.startExport())
			{
				alert("无法开始导出PDF!");
			}
		}
		
		public function onStopExport(): void
		{
			if (!m_model.taskModel.stopExport())
			{
				alert("无法取消导出PDF!");
			}
		}
		
		public function onSelectDir(): void
		{
			FileUtil.selectDirectroy(m_model.taskModel.bookHome, "选择打开图书目录 (以便对书页进行重命名)", onSelectDirFile);
		}
		
		public function onSelectDirFile(dirFile: File): void
		{
			if (dirFile.exists && dirFile.isDirectory)
			{
				m_model.taskModel.saveHome = dirFile.parent.nativePath;
				m_model.taskModel.bookSTR = null;
				m_model.taskModel.startPage = Number.NaN;
				m_model.taskModel.endPage = Number.NaN;
				m_model.taskModel.bookTitle = dirFile.name;
				m_model.taskModel.bookSSNo = null;
			}
		}
		
		public function onOrderRename(): void
		{
			if (BookPageRename.orderRenamePages(m_model.taskModel.bookHome))
			{
				alert("书页顺序命名成功!");
			}
			else
			{
				alert("书页顺序命名失败!");
			}
			m_model.taskModel.countModel.update();
		}
		
		public function onOrginRename(): void
		{
			if (BookPageRename.originRenamePages(m_model.taskModel.bookHome))
			{
				alert("书页原始命名成功!");
			}
			else
			{
				alert("书页原始命名失败!");
			}
			m_model.taskModel.countModel.update();
		}
		
		//-----------------------------------------
		public function onBookTitleEdit(title: String): void
		{
			m_model.taskModel.bookTitle = title;
		}
		
		public function onPageTypeEdit(pageType: String): void
		{
			m_model.taskModel.pageType = pageType;
		}
		
		public function onBookSPageEdit(startPage: Number): void
		{
			m_model.taskModel.startPage = startPage;
		}
		
		public function onBookEPageEdit(endPage: Number): void
		{
			m_model.taskModel.endPage = endPage;
		}
		
		public function onPageZoomEdit(pageZoom: String): void
		{
			m_model.taskModel.pageZoom = pageZoom;
		}
		
		public function onSaveHomeEdit(saveHome: String): void
		{
			m_model.taskModel.saveHome = saveHome;
		}
	}
}