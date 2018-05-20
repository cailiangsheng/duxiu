package sigma.app.duxiu.view
{
	import pl.mateuszmackowiak.nativeANE.NativeDialogListEvent;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeListDialog;
	import pl.mateuszmackowiak.nativeANE.toast.Toast;
	
	import sigma.app.duxiu.DuxiuAppController;
	import sigma.app.duxiu.data.BookPageType;
	import sigma.app.duxiu.data.BookPageZoom;
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.app.duxiu.model.DuxiuDownTaskModel;
	import sigma.app.duxiu.utils.BookPageDefine;
	import sigma.app.duxiu.view.screens.TaskScreen;
	import sigma.lib.utils.SystemUtil;
	
	import starling.events.Event;

	public class DuxiuAppTaskView
	{
		private var m_model: DuxiuDownTaskModel;
		private var m_controller: DuxiuAppController;
		
		private var m_ui: TaskScreen;
		
		private var m_menu: NativeListDialog;
		
		public function DuxiuAppTaskView()
		{
		}
		
		public function initialize(model: DuxiuDownTaskModel, controller: DuxiuAppController, ui: TaskScreen): void
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
		}
		
		private function initPageTypes(): void
		{
			var types: Vector.<String> = new Vector.<String>();
			for each (var type: BookPageType in BookPageDefine.pageTypes)
			{
				types.push(type.typeName);
			}
			m_ui.pageTypes = types;
		}
		
		private function initPageZooms(): void
		{
			var zooms: Vector.<String> = new Vector.<String>();
			for each (var zoom: BookPageZoom in BookPageDefine.pageZooms)
			{
				zooms.push(zoom.zoomName);
			}
			m_ui.pageZooms = zooms;
		}
		
		public function activate(): void
		{
			m_ui.txtTitle.addEventListener(Event.CHANGE, onTitleEdit);
			m_ui.lstPageType.addEventListener(Event.CHANGE, onPageTypeSelect);
			m_ui.lstPageZoom.addEventListener(Event.CHANGE, onPageZoomSelect);
			m_ui.txtSPage.addEventListener(Event.CHANGE, onSPageEdit);
			m_ui.txtEPage.addEventListener(Event.CHANGE, onEPageEdit);
			m_ui.txtSaveHome.addEventListener(Event.CHANGE, onSaveHomeEdit);
			m_ui.operateButton.addEventListener(Event.TRIGGERED, onOperateButtonTriggered);
			m_ui.stopButton.addEventListener(Event.TRIGGERED, onStopButtonTriggered);
			
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
			
			enableUI(m_model.canFetchParams || m_model.canStartDownload || m_model.canStartExport);
		}
		
		public function deactivate(): void
		{
			m_ui.txtTitle.removeEventListener(Event.CHANGE, onTitleEdit);
			m_ui.lstPageType.removeEventListener(Event.CHANGE, onPageTypeSelect);
			m_ui.lstPageZoom.removeEventListener(Event.CHANGE, onPageZoomSelect);
			m_ui.txtSPage.removeEventListener(Event.CHANGE, onSPageEdit);
			m_ui.txtEPage.removeEventListener(Event.CHANGE, onEPageEdit);
			m_ui.txtSaveHome.removeEventListener(Event.CHANGE, onSaveHomeEdit);
			m_ui.operateButton.removeEventListener(Event.TRIGGERED, onOperateButtonTriggered);
			m_ui.stopButton.removeEventListener(Event.TRIGGERED, onStopButtonTriggered);
			
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
		
		private function onOperateButtonTriggered(e: Event): void
		{
			showMenu();
		}
		
		private function onStopButtonTriggered(e: Event): void
		{
			m_controller.onStopAll();
		}
		
		private function get menu(): NativeListDialog
		{
			if (m_menu == null)
			{
				m_menu = new NativeListDialog();
				m_menu.setTitle("任务操作");
				m_menu.setCancelable(true);
				m_menu.addEventListener(NativeDialogListEvent.LIST_CHANGE, function(e: NativeDialogListEvent): void
				{
					executeOption(m_menu.selectedLabel);
				});
			}
			return m_menu;
		}
		
		public function showMenu(): void
		{
			var options: Vector.<String> = new Vector.<String>();
			
			if (m_model.canFetchParams)
				options.push("参数获取");
			
			if (m_model.canStartDownload)
				options.push("开始下载");
			
			if (m_model.canStopDownload)
				options.push("停止下载");
			
			if (m_model.canStartExport)
				options.push("导出PDF");
			
			if (m_model.canStopExport)
				options.push("取消导出");
			
			if (m_model.canOpenPDF)
				options.push("打开PDF");
			
			this.menu.showSingleChoice(SystemUtil.isIOS ? options.reverse() : options, -1, new <String>["取消"]);
		}
		
		private function hideMenu(): void
		{
			if (m_menu)
			{
				m_menu.hide();
				
				if (SystemUtil.isAndroid)
				{
					m_menu.dispose();
					m_menu = null;
				}
			}
		}
		
		public function onSearch(): void
		{
			if (m_model.canFetchParams)
				executeOption("参数获取");
		}
		
		private static function showToast(option: String): void
		{
			Toast.show(option + "中...", Toast.LENGTH_SHORT);
		}
		
		private function executeOption(value: String): void
		{
			switch (value)
			{
				case "参数获取":
					showToast(value);
					m_ui.showParamsTab();
					m_controller.onFetchParams();
					break;
				case "开始下载":
					showToast(value);
					m_ui.showLogTab();
					m_controller.onStartDownload();
					break;
				case "停止下载":
					m_controller.onStopDownload();
					break;
				case "导出PDF":
					showToast(value);
					m_ui.showLogTab();
					m_controller.onStartExport();
					break;
				case "取消导出":
					m_controller.onStopExport();
					break;
				case "打开PDF":
					m_controller.onOpenPDF();
					break;
			}
			hideMenu();
		}
		
		private function onTitleEdit(e: Event): void
		{
			m_controller.onBookTitleEdit(m_ui.txtTitle.text);
		}
		
		private function onPageTypeSelect(e: Event): void
		{
			m_controller.onPageTypeEdit(String(m_ui.lstPageType.selectedItem));
		}
		
		private function onPageZoomSelect(e: Event): void
		{
			m_controller.onPageZoomEdit(String(m_ui.lstPageZoom.selectedItem));
		}
		
		private function onSPageEdit(e: Event): void
		{
			m_controller.onBookSPageEdit(Number(m_ui.txtSPage.text));
		}
		
		private function onEPageEdit(e: Event): void
		{
			m_controller.onBookEPageEdit(Number(m_ui.txtEPage.text));
		}
		
		private function onSaveHomeEdit(e: Event): void
		{
			m_controller.onSaveHomeEdit(m_ui.txtSaveHome.text);
		}
		
		//----------------------------------------------------------------
		private static function getText(value: *, placeHolder: String = "未定义"): String
		{
			return value == undefined || value == "" || (value is Number && isNaN(value)) ? placeHolder : value.toString();
		}
		
		private function onBookTitleChange(e: ModelEvent): void
		{
			m_ui.txtTitle.text = getText(m_model.bookTitle);
		}
		
		private function onBookSSNoChange(e: ModelEvent): void
		{
			m_ui.txtSSNO.text = getText(m_model.bookSSNo);
		}
		
		private function onBookSTRChange(e: ModelEvent): void
		{
			m_ui.txtSTR.text = getText(m_model.bookSTR);
		}
		
		private function onBookSPageChange(e: ModelEvent): void
		{
			m_ui.txtSPage.text = getText(m_model.startPage);
		}
		
		private function onBookEPageChange(e: ModelEvent): void
		{
			m_ui.txtEPage.text = getText(m_model.endPage);
		}
		
		private function onPageTypeChange(e: ModelEvent): void
		{
			m_ui.lstPageType.selectedItem = m_model.pageType;
		}
		
		private function onFromPageChange(e: ModelEvent): void
		{
			if (isNaN(m_model.fromPage))
			{
				m_ui.txtFromPage.text = "";
				enableTextInput(m_ui.txtFromPage, false);
			}
			else
			{
				m_ui.txtFromPage.text = m_model.fromPage.toString();
				enableTextInput(m_ui.txtFromPage, true);
			}
		}
		
		private function onToPageChange(e: ModelEvent): void
		{
			if (isNaN(m_model.toPage))
			{
				m_ui.txtToPage.text = "";
				enableTextInput(m_ui.txtToPage, false);
			}
			else
			{
				m_ui.txtToPage.text = m_model.toPage.toString();
				enableTextInput(m_ui.txtToPage, true);
			}
		}
		
		private function onPageZoomChange(e: ModelEvent): void
		{
			m_ui.lstPageZoom.selectedItem = m_model.pageZoom;
		}
		
		private function onSaveHomeChange(e: ModelEvent): void
		{
			m_ui.txtSaveHome.text = m_model.saveHome;
		}
		
		private function onLogChange(e: ModelEvent): void
		{
			m_ui.txtLog.text = getText(m_model.log, "尚无日志");
			m_ui.txtLog.validate();
			m_ui.txtLog.verticalScrollPosition = m_ui.txtLog.maxVerticalScrollPosition;
		}
		
		private function onPageCountChange(e: ModelEvent): void
		{
			m_ui.txtStat.text = m_model.countModel.counter.toString();
		}
		
		private function onDownloadBegin(e: ModelEvent): void
		{
			enableUI(false);
		}
		
		private function onDownloadComplete(e: ModelEvent): void
		{
			m_controller.alert("下载完毕!");
			enableUI(true);
		}
		
		private function onDownloadStop(e: ModelEvent): void
		{
			m_controller.alert("下载停止!");
			enableUI(true);
		}
		
		private function enableUI(value: Boolean): void
		{
			enableTextInput(m_ui.txtTitle, value);
			enableTextInput(m_ui.txtSSNO, false);
			enableTextInput(m_ui.txtSTR, value);
			enableTextInput(m_ui.txtSPage, value);
			enableTextInput(m_ui.txtEPage, value);
			enableTextInput(m_ui.txtSaveHome, value && !SystemUtil.isIOS);
			
			m_ui.lstPageType.isEnabled = value;
			m_ui.lstPageZoom.isEnabled = value;
			m_ui.txtFromPage.isEnabled = value;
			m_ui.txtToPage.isEnabled = value;
		}
		
		private function onExportBegin(e: ModelEvent): void
		{
			enableUI(false);
		}
		
		private function onExportComplete(e: ModelEvent): void
		{
			m_controller.alert("导出完毕!");
			enableUI(true);
			
			m_controller.onOpenPDF();
		}
		
		private function onExportFailed(e: ModelEvent): void
		{
			m_controller.alert("导出失败!");
			enableUI(true);
		}
		
		private function onExportStop(e: ModelEvent): void
		{
			m_controller.alert("导出停止!");
			enableUI(true);
		}
	}
}

import feathers.controls.TextInput;

function enableTextInput(txt: TextInput, enabled: Boolean): void
{
	txt.isEnabled = txt.touchable = enabled;
}