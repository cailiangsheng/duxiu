package sigma.app.duxiu.view
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	
	import sigma.app.duxiu.DuxiuAppManager;
	import sigma.app.duxiu.view.screens.BookmarkScreen;
	import sigma.app.duxiu.view.screens.BrowseScreen;
	import sigma.app.duxiu.view.screens.HistoryScreen;
	import sigma.app.duxiu.view.screens.TaskScreen;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		private var m_theme: *;
		
		private var m_navigator: ScreenNavigator;
		private var m_transitionManager: ScreenSlidingStackTransitionManager;
		
		public static const ID_TASK: String = "task";
		public static const ID_BOOKMARK: String = "bookmark";
		public static const ID_BROWSE: String = "browse";
		public static const ID_HISTORY: String = "history";
		
		private var m_webView: NativeWebView;
		
		private var m_browseScreen: BrowseScreen;
		private var m_taskScreen: TaskScreen;
		private var m_bookmarkScreen: BookmarkScreen;
		private var m_historyScreen: HistoryScreen;
		
		private var m_duxiu: DuxiuAppManager;
		
		public function Main()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e: starling.events.Event): void
		{
			m_theme = new MetalWorksMobileTheme(this.stage);
			
			m_navigator = new ScreenNavigator();
			this.addChild(m_navigator);
			
			m_webView = new NativeWebView();
			
			m_browseScreen = new BrowseScreen(m_webView);
			m_navigator.addScreen(ID_BROWSE, new ScreenNavigatorItem(m_browseScreen, 
				{
					complete: ID_BROWSE,
					showTask: ID_TASK,
					showBookmark: ID_BOOKMARK
				}));
			
			m_taskScreen = new TaskScreen();
			m_navigator.addScreen(ID_TASK, new ScreenNavigatorItem(m_taskScreen, 
				{
					complete: ID_BROWSE,
					showHistory: ID_HISTORY
				}));
			
			m_bookmarkScreen = new BookmarkScreen();
			m_navigator.addScreen(ID_BOOKMARK, new ScreenNavigatorItem(m_bookmarkScreen, 
				{
					complete: ID_BROWSE
				}));
			
			m_historyScreen = new HistoryScreen(m_taskScreen);
			m_navigator.addScreen(ID_HISTORY, new ScreenNavigatorItem(m_historyScreen, 
				{
					complete: ID_TASK
				}));
			
			m_transitionManager = new ScreenSlidingStackTransitionManager(m_navigator);
			m_transitionManager.duration = 0.4;
			
			startup();
			
			m_navigator.showScreen(ID_BROWSE);
		}
		
		private function startup(): void
		{
			m_duxiu = new DuxiuAppManager();
			m_duxiu.intialize(this);
			m_duxiu.activate();
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.EXITING, onApplicationExiting);
		}
		
		private function onApplicationExiting(e: flash.events.Event): void
		{
			NativeApplication.nativeApplication.removeEventListener(flash.events.Event.EXITING, onApplicationExiting);
			
			m_duxiu.deactivate();
			m_duxiu.finalize();
		}
		
		public function get navigator(): ScreenNavigator
		{
			return m_navigator;
		}
		
		public function get webView(): NativeWebView
		{
			return m_webView;
		}
		
		public function get browseScreen(): BrowseScreen
		{
			return m_browseScreen;
		}
		
		public function get taskScreen(): TaskScreen
		{
			return m_taskScreen;
		}
		
		public function get bookmarkScreen(): BookmarkScreen
		{
			return m_bookmarkScreen;
		}
		
		public function get historyScreen(): HistoryScreen
		{
			return m_historyScreen;
		}
	}
}