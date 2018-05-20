package sigma.app.duxiu.view.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	
	import sigma.app.duxiu.view.NativeWebView;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class BrowseScreen extends Screen
	{
		private var m_header: Header;
		
		private var m_taskButton: Button;
		private var m_bookmarkButton: Button;
		private var m_browseButton: Button;
		private var m_navigateButton: Button;
		
		private static const SHOW_TASK: String = "showTask";
		private static const SHOW_BOOKMARK: String = "showBookmark";
		
		private var m_webView: NativeWebView;
		
		public function BrowseScreen(webView: NativeWebView)
		{
			m_webView = webView;
		}
		
		public function get webView(): NativeWebView
		{
			return m_webView;
		}
		
		public function navigateURL(url: String): void
		{
			if (m_webView)
				m_webView.navigateToURL(url);
		}
		
		override protected function initialize():void
		{
			m_header = new Header();
			m_header.title = "读秀下载";
			m_header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			this.addChild(m_header);
			
			m_taskButton = new Button();
			m_taskButton.label = "任务";
			m_taskButton.addEventListener(Event.TRIGGERED, taskButtonTriggered);
			
			m_bookmarkButton = new Button();
			m_bookmarkButton.label = "书签";
			m_bookmarkButton.addEventListener(Event.TRIGGERED, bookmarkButtonTriggered);
			
			m_browseButton = new Button();
			m_browseButton.label = "浏览";
			m_browseButton.addEventListener(Event.TRIGGERED, browseButtonTriggered);
			
			m_navigateButton = new Button();
			m_navigateButton.label = "▼";
			m_navigateButton.addEventListener(Event.TRIGGERED, navigateButtonTriggered);
			
			m_header.gap = 2;
			m_header.rightItems = new <DisplayObject>
			[
				m_taskButton,
				m_bookmarkButton,
				m_browseButton,
				m_navigateButton
			];
		}
		
		override protected function screen_addedToStageHandler(event:Event):void
		{
			if (m_webView)
				m_webView.show(Starling.current.nativeStage);
		}
		
		override protected function draw():void
		{
			m_header.width = this.actualWidth;
			m_header.validate();
			
			if (m_webView)
				m_webView.resize(0, m_header.height, this.actualWidth, this.actualHeight - m_header.height);
		}
		
		private function taskButtonTriggered(e: Event): void
		{
			this.dispatchEventWith(SHOW_TASK);
		}
		
		private function bookmarkButtonTriggered(e: Event): void
		{
			this.dispatchEventWith(SHOW_BOOKMARK);
		}
		
		private function browseButtonTriggered(e: Event): void
		{
			m_webView.showTextInput();
		}
		
		private function navigateButtonTriggered(e: Event): void
		{
			m_webView.showMenu();
		}
	}
}