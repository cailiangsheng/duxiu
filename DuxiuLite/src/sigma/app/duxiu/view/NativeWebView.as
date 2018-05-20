package sigma.app.duxiu.view
{
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.NativeDialogListEvent;
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeListDialog;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextField;
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
	import pl.mateuszmackowiak.nativeANE.progress.NativeProgress;
	
	import sigma.lib.utils.BrowserUtil;
	import sigma.lib.utils.SystemUtil;

	[Event(name="focusIn", type="flash.events.FocusEvent")]
	[Event(name="locationChange", type="flash.events.LocationChangeEvent")]
	public class NativeWebView extends EventDispatcher
	{
		private var m_view: StageWebView;
		private var m_loadingURL: String;
		private var m_targetURL: String;
		
		private var m_checkingURL: String;
		
		private var m_progress: NativeProgress;
		private var m_menu: NativeListDialog;
		
		private var m_dialog: NativeTextInputDialog;
		private var m_textFields: Vector.<NativeTextField>;
		
		public function get isLoading(): Boolean
		{
			return m_loadingURL != null;
		}
		
		public function get targetURL(): String
		{
			return m_targetURL;
		}
		
		public function get currentURL(): String
		{
			return m_view.location;
		}
		
		public function get loadingURL(): String
		{
			return m_loadingURL;
		}
		
		public function NativeWebView()
		{
			m_view = new StageWebView();
			m_view.addEventListener(ErrorEvent.ERROR, onWebViewError);
			m_view.addEventListener(Event.COMPLETE, onWebViewComplete);
			m_view.addEventListener(LocationChangeEvent.LOCATION_CHANGING, onWebViewLocationChanging);
			
			m_view.addEventListener(FocusEvent.FOCUS_IN, onWebViewEvent);
			m_view.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onWebViewEvent);
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onApplicationExiting);
		}
		
		private function onWebViewEvent(e: Event): void
		{
			this.dispatchEvent(e.clone());
		}
		
		public function navigateToURL(url: String): void
		{
			url = BrowserUtil.getHttpURL(url);
			
			if (this.targetURL != url && this.currentURL != url && this.loadingURL != url)
			{
				m_targetURL = url;
				
				beginLoading(url);
				m_view.loadURL(url);
			}
		}
		
		private function onWebViewComplete(e: Event): void
		{
			endLoading(false);
		}
		
		private function onWebViewError(e: Event): void
		{
			endLoading(true);
		}
		
		private function onWebViewLocationChanging(e: LocationChangeEvent): void
		{
			if (!BrowserUtil.compareURL(e.location, this.currentURL))
			{
				beginLoading(e.location);
			}
		}
		
		private function beginLoading(loading: String): void
		{
			m_loadingURL = loading;
			showProgress();
		}
		
		private function endLoading(error: Boolean): void
		{
			m_loadingURL = null;
			showProgress(error);
		}
		
		private function stopLoading(): void
		{
			m_loadingURL = null;
			hideProgress(null, false);
		}
		
		private function get progress(): NativeProgress
		{
			if (m_progress == null)
			{
				m_progress = new NativeProgress(NativeProgress.STYLE_SPINNER);
				m_progress.androidTheme = NativeProgress.ANDROID_DEVICE_DEFAULT_DARK_THEME;
				m_progress.iosTheme = NativeProgress.IOS_SVHUD_BLACK_BACKGROUND_THEME;
			}
			return m_progress;
		}
		
		public function show(stage: Stage): void
		{
			m_view.stage = stage;
			
			if (this.isLoading)
				showProgress();
		}
		
		public function hide(): void
		{
			hideProgress(null, false);
			
			if (m_view)
				m_view.stage = null;
		}
		
		public function resize(x: Number, y: Number, width: Number, height: Number): void
		{
			m_view.viewPort = new Rectangle(x, y, width, height);
		}
		
		private function hideProgress(message: String, error: Boolean): void
		{
			if (m_progress)
			{
				m_progress.hide(message, error);
				
				if (SystemUtil.isAndroid)
				{
					m_progress.dispose();
					m_progress = null;
				}
			}
		}
		
		private function get isProgressShowing(): Boolean
		{
			if (SystemUtil.isAndroid)
				return this.progress.isShowing();
			else
				return false;
		}
		
		private function showProgress(error: Boolean = false): void
		{
			if (error)
			{
				hideProgress("加载出错", true);
			}
			else if (this.isLoading)
			{
				if (!this.isProgressShowing)
				{
					if (SystemUtil.isIOS)
						this.progress.setMessage("正在加载...");
					else
					{
						this.progress.setTitle("正在加载");
						this.progress.setMessage(this.loadingURL);
					}
					
					this.progress.show(true, true);
				}
			}
			else
			{
				hideProgress("加载完毕", false);
			}
		}
		
		private function get menu(): NativeListDialog
		{
			if (m_menu == null)
			{
				m_menu = new NativeListDialog();
				m_menu.setTitle("浏览历史");
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
			var options: Vector.<String> = new <String>["刷新"];
			
			if (this.isLoading)
				options.push("停止");
			
			if (m_view.isHistoryBackEnabled)
				options.push("后退");
			
			if (m_view.isHistoryForwardEnabled)
				options.push("前进");
			
			this.menu.showSingleChoice(SystemUtil.isIOS ? options.reverse() : options, -1, new <String>["取消"]);
			
//			NativeAlert.show(null, "历史浏览", "取消", options.join(","), function(e: NativeDialogEvent): void
//			{
//				var index: int = int(e.index) - 1;
//				if (index >= 0 && index < options.length)
//				{
//					executeOption(options[index]);
//				}
//			});
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
		
		private function onEnterFrame(e: Event): void
		{
			if (m_checkingURL != this.currentURL)
			{
				m_view.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				m_checkingURL = null;
				
				var event: LocationChangeEvent = new LocationChangeEvent(LocationChangeEvent.LOCATION_CHANGE);
				event.location = this.currentURL;
				m_view.dispatchEvent(event);
			}
		}
		
		private function listenToLocationChange(): void
		{
			m_checkingURL = this.currentURL;
			m_view.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function executeOption(option: String): void
		{
			// StageWebView BUG: when history natigation is done, no LocationChangeEvent dispatched
			listenToLocationChange();
			
			stopLoading();
			switch (option)
			{
				case "刷新":
					beginLoading(this.currentURL);
					m_view.reload();
					break;
				case "停止":
					m_view.stop();
					break;
				case "后退":
					m_view.historyBack();
					break;
				case "前进":
					m_view.historyForward();
					break;
			}
			hideMenu();
		}
		
		private function onApplicationExiting(e: flash.events.Event): void
		{
			NativeAlert.dispose();
		}
		
		private function get dialogTextField(): NativeTextField
		{
			return this.textFields[0];
		}
		
		private function get textFields(): Vector.<NativeTextField>
		{
			if (m_textFields == null)
			{
				var textField: NativeTextField = new NativeTextField("url");
				textField.prompText = "编辑前往此地址";
				textField.softKeyboardType = SoftKeyboardType.URL;
				textField.returnKeyLabel = ReturnKeyLabel.DONE;
				
				m_textFields = new Vector.<NativeTextField>();
				m_textFields.push(textField);
			}
			return m_textFields;
		}
		
		private function get dialog(): NativeTextInputDialog
		{
			if (m_dialog == null)
			{
				m_dialog = new NativeTextInputDialog();
				m_dialog.setTitle("浏览地址");
				m_dialog.setCancelable(true);
				m_dialog.addEventListener(NativeDialogEvent.CLOSED, onTextInputClose);
			}
			return m_dialog;
		}
		
		private function onTextInputClose(e: NativeDialogEvent): void
		{
			var index: int = int(e.index);
			if (index >= 0)
			{
				switch (this.dialog.buttons[index])
				{
					case "确定":
						this.navigateToURL(this.dialogTextField.text);
						break;
					case "更多":
						this.showMenu();
						break;
				}
			}
		}
		
		public function showTextInput(): void
		{
			this.dialogTextField.text = this.currentURL;
			this.dialog.show(this.textFields, new <String>["取消", "前往", "更多"], true);
		}
	}
}