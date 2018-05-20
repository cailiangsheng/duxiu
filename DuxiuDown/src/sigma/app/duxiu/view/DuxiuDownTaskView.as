package sigma.app.duxiu.view
{
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.controls.Menu;
	import mx.events.ListEvent;
	import mx.events.MenuEvent;
	
	import sigma.app.duxiu.DuxiuDownController;
	import sigma.app.duxiu.data.BookPageType;
	import sigma.app.duxiu.data.BookPageZoom;
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.app.duxiu.model.DuxiuDownTaskModel;
	import sigma.app.duxiu.utils.BookPageDefine;
	import sigma.lib.utils.MenuUtil;

	public class DuxiuDownTaskView
	{
		private var m_model: DuxiuDownTaskModel;
		private var m_controller: DuxiuDownController;
		
		private var m_ui: DuxiuDownTaskUI;
		private var m_menu: Menu;
		private var m_menuData: Array;
		
		public function DuxiuDownTaskView()
		{
		}
		
		public function initialize(model: DuxiuDownTaskModel, controller: DuxiuDownController, ui: DuxiuDownTaskUI): void
		{
			m_model = model;
			m_controller = controller;
			m_ui = ui;
			
			initPageTypes();
			initPageZooms();
		}
		
		public function finalize(): void
		{
			m_model = null;
			m_controller = null;
			m_ui = null;
			m_menu = null;
			m_menuData = null;
		}
		
		private function initPageTypes(): void
		{
			var types: Array = [];
			for each (var type: BookPageType in BookPageDefine.pageTypes)
			{
				types.push(type.typeName);
			}
			m_ui.pageType.dataProvider = types;
			m_ui.pageType.rowCount = types.length;
		}
		
		private function initPageZooms(): void
		{
			var zooms: Array = [];
			for each (var zoom: BookPageZoom in BookPageDefine.pageZooms)
			{
				zooms.push(zoom.zoomName);
			}
			m_ui.pageZoom.dataProvider = zooms;
			m_ui.pageZoom.rowCount = zooms.length;
		}
		
		public function activate(): void
		{
			m_ui.titleValue.addEventListener(Event.CHANGE, onBookTitleEdit);
			m_ui.pageType.addEventListener(ListEvent.CHANGE, onPageTypeEdit);
			m_ui.spageValue.addEventListener(Event.CHANGE, onBookSPageEdit);
			m_ui.epageValue.addEventListener(Event.CHANGE, onBookEPageEdit);
			m_ui.pageZoom.addEventListener(ListEvent.CHANGE, onPageZoomEdit);
			m_ui.dirSave.addEventListener(Event.CHANGE, onSaveHomeEdit);
			
			m_model.addEventListener(ModelEvent.BOOK_TITLE_CHANGE, onBookTitleChange);
			m_model.addEventListener(ModelEvent.BOOK_SSNO_CHANGE, onBookSSNoChange);
			m_model.addEventListener(ModelEvent.BOOK_STR_CHANGE, onBookSTRChange);
			m_model.addEventListener(ModelEvent.BOOK_SPAGE_CHANGE, onBookSPageChange);
			m_model.addEventListener(ModelEvent.BOOK_EPAGE_CHANGE, onBookEPageChange);
			m_model.addEventListener(ModelEvent.PAGE_TYPE_CHANGE, onPageTypeChange);
			m_model.addEventListener(ModelEvent.FROM_PAGE_CHANGE, onFromPageChange);
			m_model.addEventListener(ModelEvent.TO_PAGE_CHANGE, onToPageChange);
			m_model.addEventListener(ModelEvent.PAGE_ZOOM_CHANGE, onPageZoomChange);
			m_model.addEventListener(ModelEvent.SAVE_HOME_CHANGE, onSaveHomeChange);
			m_model.addEventListener(ModelEvent.LOG_CHANGE, onLogChange);
			
			m_model.countModel.addEventListener(ModelEvent.PAGE_COUNT_CHANGE, onPageCountChange);
			
			m_model.downloadModel.addEventListener(ModelEvent.DOWNLOAD_BEGIN, onDownloadBegin);
			m_model.downloadModel.addEventListener(ModelEvent.DOWNLOAD_COMPLETE, onDownloadComplete);
			m_model.downloadModel.addEventListener(ModelEvent.DOWNLOAD_STOP, onDownloadStop);
			
			m_model.exportModel.addEventListener(ModelEvent.EXPORT_BEGIN, onExportBegin);
			m_model.exportModel.addEventListener(ModelEvent.EXPORT_COMPLETE, onExportComplete);
			m_model.exportModel.addEventListener(ModelEvent.EXPORT_FAILED, onExportFailed);
			m_model.exportModel.addEventListener(ModelEvent.EXPORT_STOP, onExportStop);
			
			onBookTitleChange(null);
			onBookSSNoChange(null);
			onBookSTRChange(null);
			onBookSPageChange(null);
			onBookEPageChange(null);
			onPageTypeChange(null);
			onFromPageChange(null);
			onToPageChange(null);
			onPageZoomChange(null);
			onSaveHomeChange(null);
			onLogChange(null);
			
			onPageCountChange(null);
		}
		
		public function deactivate(): void
		{
			m_ui.titleValue.removeEventListener(Event.CHANGE, onBookTitleEdit);
			m_ui.pageType.removeEventListener(ListEvent.CHANGE, onPageTypeEdit);
			m_ui.spageValue.removeEventListener(Event.CHANGE, onBookSPageEdit);
			m_ui.epageValue.removeEventListener(Event.CHANGE, onBookEPageEdit);
			m_ui.pageZoom.removeEventListener(ListEvent.CHANGE, onPageZoomEdit);
			m_ui.dirSave.removeEventListener(Event.CHANGE, onSaveHomeEdit);
			
			m_model.removeEventListener(ModelEvent.BOOK_TITLE_CHANGE, onBookTitleChange);
			m_model.removeEventListener(ModelEvent.BOOK_SSNO_CHANGE, onBookSSNoChange);
			m_model.removeEventListener(ModelEvent.BOOK_STR_CHANGE, onBookSTRChange);
			m_model.removeEventListener(ModelEvent.BOOK_SPAGE_CHANGE, onBookSPageChange);
			m_model.removeEventListener(ModelEvent.BOOK_EPAGE_CHANGE, onBookEPageChange);
			m_model.removeEventListener(ModelEvent.PAGE_TYPE_CHANGE, onPageTypeChange);
			m_model.removeEventListener(ModelEvent.FROM_PAGE_CHANGE, onFromPageChange);
			m_model.removeEventListener(ModelEvent.TO_PAGE_CHANGE, onToPageChange);
			m_model.removeEventListener(ModelEvent.PAGE_ZOOM_CHANGE, onPageZoomChange);
			m_model.removeEventListener(ModelEvent.SAVE_HOME_CHANGE, onSaveHomeChange);
			m_model.removeEventListener(ModelEvent.LOG_CHANGE, onLogChange);
			
			m_model.countModel.removeEventListener(ModelEvent.PAGE_COUNT_CHANGE, onPageCountChange);
			
			m_model.downloadModel.removeEventListener(ModelEvent.DOWNLOAD_BEGIN, onDownloadBegin);
			m_model.downloadModel.removeEventListener(ModelEvent.DOWNLOAD_COMPLETE, onDownloadComplete);
			m_model.downloadModel.removeEventListener(ModelEvent.DOWNLOAD_STOP, onDownloadStop);
			
			m_model.exportModel.removeEventListener(ModelEvent.EXPORT_BEGIN, onExportBegin);
			m_model.exportModel.removeEventListener(ModelEvent.EXPORT_COMPLETE, onExportComplete);
			m_model.exportModel.removeEventListener(ModelEvent.EXPORT_FAILED, onExportFailed);
			m_model.exportModel.removeEventListener(ModelEvent.EXPORT_STOP, onExportStop);
		}
		
		//----------------------------------------------------------------
		private function onBookTitleEdit(e: Event): void
		{
			m_controller.onBookTitleEdit(m_ui.titleValue.text);
		}
		
		private function onPageTypeEdit(e: ListEvent): void
		{
			m_controller.onPageTypeEdit(m_ui.pageType.selectedLabel);
		}
		
		private function onBookSPageEdit(e: Event): void
		{
			m_controller.onBookSPageEdit(Number(m_ui.spageValue.text));
		}
		
		private function onBookEPageEdit(e: Event): void
		{
			m_controller.onBookEPageEdit(Number(m_ui.epageValue.text));
		}
		
		private function onPageZoomEdit(e: ListEvent): void
		{
			m_controller.onPageZoomEdit(m_ui.pageZoom.selectedLabel);
		}
		
		private function onSaveHomeEdit(e: Event): void
		{
			m_controller.onSaveHomeEdit(m_ui.dirSave.text);
		}
		
		//----------------------------------------------------------------
		private function get menuData(): Array
		{
			if (m_menuData == null)
			{
				m_menuData = 
					[
						{label: "获取参数", handle: m_controller.onFetchParams, enabled: true},	//0
						{label: "开始下载", handle: m_controller.onStartDownload, enabled: false},	//1
						{label: "停止下载", handle: m_controller.onStopDownload, enabled: false},	//2
						MenuUtil.SEPARATOR,														//3
						
//						{label: "顺序命名", handle: m_controller.onOrderRename, enabled: true},	//4
//						{label: "原始命名", handle: m_controller.onOrginRename, enabled: true},	//5
//						MenuUtil.SEPARATOR,														//6
						
						{label: "导出PDF", handle: m_controller.onStartExport, enabled: true},	//4
						{label: "取消导出", handle: m_controller.onStopExport, enabled: true},		//5
						{label: "打开PDF", handle: m_controller.onOpenPDF, enabled: true},						//6
						MenuUtil.SEPARATOR,														//7
						{label: "选择目录", handle: m_controller.onSelectDir, enabled: true},		//8
						{label: "打开目录", handle: m_controller.onOpenDir, enabled: true},		//9
					];
			}
			return m_menuData;
		}
		
		private function get paramsMenuItem(): Object
		{
			return this.menuData[0];
		}
		
		private function get startDownloadMenuItem(): Object
		{
			return this.menuData[1];
		}
		private function get stopDownloadMenuItem(): Object
		{
			return this.menuData[2];
		}
		
//		private function get orderRenameMenuItem(): Object
//		{
//			return m_menuData[4];
//		}
//		private function get originRenameMenuItem(): Object
//		{
//			return m_menuData[5];
//		}
//		private function get startExportMenuItem(): Object
//		{
//			return m_menuData[7];
//		}
//		private function get stopExportMenuItem(): Object
//		{
//			return m_menuData[8];
//		}
		
		private function get startExportMenuItem(): Object
		{
			return this.menuData[4];
		}
		private function get stopExportMenuItem(): Object
		{
			return this.menuData[5];
		}
		private function get openPdfMenuItem(): Object
		{
			return this.menuData[6];
		}
		
		public function get menu(): Menu
		{
			if (m_menu == null)
			{
				m_menu = MenuUtil.createMenu(m_ui, this.menuData, false);
				m_menu.addEventListener(MenuEvent.ITEM_CLICK, function(e: MenuEvent): void
				{
					if (e.item.handle as Function)
						e.item.handle();
				});
			}
			
			this.paramsMenuItem.enabled = m_model.canFetchParams;
			this.startDownloadMenuItem.enabled = m_model.canStartDownload;
			this.stopDownloadMenuItem.enabled = m_model.canStopDownload;
//			this.orderRenameMenuItem.enabled = m_model.canOrderRename;
//			this.originRenameMenuItem.enabled = m_model.canOriginRename;
			this.startExportMenuItem.enabled = m_model.canStartExport;
			this.stopExportMenuItem.enabled = m_model.canStopExport;
			this.openPdfMenuItem.enabled = m_model.canOpenPDF;
			return m_menu;
		}
		
		//----------------------------------------------------------------
		private static function getText(value: *): String
		{
			return value == undefined || (value is Number && isNaN(value)) ? "未定义" : value.toString();
		}
		
		private function onBookTitleChange(e: ModelEvent): void
		{
			m_ui.titleValue.text = getText(m_model.bookTitle);
		}
		
		private function onBookSSNoChange(e: ModelEvent): void
		{
			m_ui.ssNoValue.text = getText(m_model.bookSSNo);
		}
		
		private function onBookSTRChange(e: ModelEvent): void
		{
			m_ui.STR.text = getText(m_model.bookSTR);
		}
		
		private function onBookSPageChange(e: ModelEvent): void
		{
			m_ui.spageValue.text = getText(m_model.startPage);
		}
		
		private function onBookEPageChange(e: ModelEvent): void
		{
			m_ui.epageValue.text = getText(m_model.endPage);
		}
		
		private function onPageTypeChange(e: ModelEvent): void
		{
			m_ui.pageType.selectedItem = m_model.pageType;
		}
		
		private function onFromPageChange(e: ModelEvent): void
		{
			if (isNaN(m_model.fromPage))
			{
				m_ui.fromPage.text = "";
				enableTextInput(m_ui.fromPage, false);
			}
			else
			{
				m_ui.fromPage.text = m_model.fromPage.toString();
				enableTextInput(m_ui.fromPage, true);
			}
		}
		
		private function onToPageChange(e: ModelEvent): void
		{
			if (isNaN(m_model.toPage))
			{
				m_ui.toPage.text = "";
				enableTextInput(m_ui.toPage, false);
			}
			else
			{
				m_ui.toPage.text = m_model.toPage.toString();
				enableTextInput(m_ui.toPage, true);
			}
		}
		
		private function onPageZoomChange(e: ModelEvent): void
		{
			m_ui.pageZoom.selectedItem = m_model.pageZoom;
		}
		
		private function onSaveHomeChange(e: ModelEvent): void
		{
			m_ui.dirSave.text = m_model.saveHome;
		}
		
		private function onLogChange(e: ModelEvent): void
		{
			m_ui.logText.text = m_model.log;
			m_ui.logText.validateNow();
			m_ui.logText.verticalScrollPosition = m_ui.logText.maxVerticalScrollPosition;
		}
		
		private function onPageCountChange(e: ModelEvent): void
		{
			m_ui.statText.text = m_model.countModel.counter.toString();
		}
		
		private function onDownloadBegin(e: ModelEvent): void
		{
			enableUI(false);
		}
		
		private function onDownloadComplete(e: ModelEvent): void
		{
			Alert.show("下载完毕!");
			enableUI(true);
		}
		
		private function onDownloadStop(e: ModelEvent): void
		{
			Alert.show("下载停止!");
			enableUI(true);
		}
		
		private function enableUI(value: Boolean): void
		{
			enableTextInput(m_ui.titleValue, value);
			enableTextInput(m_ui.STR, value);
			enableTextInput(m_ui.spageValue, value);
			enableTextInput(m_ui.epageValue, value);
			enableTextInput(m_ui.dirSave, value);
			
			m_ui.pageType.enabled = value;
			m_ui.pageZoom.enabled = value;
			m_ui.fromPage.enabled = value;
			m_ui.toPage.enabled = value;
		}
		
		private function onExportBegin(e: ModelEvent): void
		{
			enableUI(false);
		}
		
		private function onExportComplete(e: ModelEvent): void
		{
			Alert.show("导出完毕!");
			enableUI(true);
			
			m_controller.onOpenPDF();
		}
		
		private function onExportFailed(e: ModelEvent): void
		{
			Alert.show("导出失败!");
			enableUI(true);
		}
		
		private function onExportStop(e: ModelEvent): void
		{
			Alert.show("导出停止!");
			enableUI(true);
		}
	}
}

import mx.controls.TextInput;

function enableTextInput(txt: TextInput, enabled: Boolean): void
{
	if (enabled)
	{
		txt.styleName = null;
		txt.editable = true;
	}
	else
	{
		txt.styleName = "readOnly";
		txt.editable = false;
	}
}