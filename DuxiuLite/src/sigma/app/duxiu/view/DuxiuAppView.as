package sigma.app.duxiu.view
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import sigma.app.duxiu.DuxiuAppController;
	import sigma.app.duxiu.model.DuxiuDownModel;
	
	import starling.core.Starling;
	import starling.events.Event;

	public class DuxiuAppView
	{
		private var m_model: DuxiuDownModel;
		private var m_controller: DuxiuAppController;
		
		private var m_ui: Main;
		private var m_activeView: *;
		
		private var m_browseView: DuxiuAppBrowseView;
		private var m_bookmarkView: DuxiuAppBookmarkView;
		private var m_taskView: DuxiuAppTaskView;
		private var m_historyView: DuxiuAppHistoryView;
		
		public function DuxiuAppView()
		{
		}
		
		public function initialize(model: DuxiuDownModel, controller: DuxiuAppController, ui: Main): void
		{
			m_model = model;
			m_controller = controller;
			m_ui = ui;
			
			m_browseView = new DuxiuAppBrowseView();
			m_browseView.initialize(m_model.browseModel, m_controller, m_ui.browseScreen);
			
			m_bookmarkView = new DuxiuAppBookmarkView();
			m_bookmarkView.initialize(m_model.browseModel, m_controller, m_ui.bookmarkScreen);
			
			m_taskView = new DuxiuAppTaskView();
			m_taskView.initialize(m_model.taskModel, m_controller, m_ui.taskScreen);
			
			m_historyView = new DuxiuAppHistoryView();
			m_historyView.initialize(m_model.taskModel, m_controller, m_ui.historyScreen);
		}
		
		public function finalize(): void
		{
			m_browseView.finalize();
			m_bookmarkView.finalize();
			m_taskView.finalize();
			m_historyView.finalize();
		}
		
		public function activate(): void
		{
			m_ui.navigator.addEventListener(starling.events.Event.CHANGE, onScreenChange);
			
			Starling.current.nativeStage.addEventListener(flash.events.Event.ACTIVATE, onStageActivate);
			Starling.current.nativeStage.addEventListener(flash.events.Event.DEACTIVATE, onStageDeactivate);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		private function onScreenChange(e: starling.events.Event): void
		{
			var preView: * = m_activeView;
			switch (m_ui.navigator.activeScreen)
			{
				case m_ui.browseScreen:
					m_activeView = m_browseView;
					break;
				case m_ui.bookmarkScreen:
					m_activeView = m_bookmarkView;
					break;
				case m_ui.taskScreen:
					m_activeView = m_taskView;
					break;
				case m_ui.historyScreen:
					m_activeView = m_historyView;
					break;
			}
			
			if (preView != m_activeView)
			{
				if (preView)
					preView.deactivate();
				
				m_activeView.activate();
			}
		}
		
		public function deactive(): void
		{
			if (m_activeView)
			{
				m_activeView.deactivate();
				m_activeView = null;
				
				Starling.current.nativeStage.removeEventListener(flash.events.Event.ACTIVATE, onStageActivate);
				Starling.current.nativeStage.removeEventListener(flash.events.Event.DEACTIVATE, onStageDeactivate);
				Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			}
		}
		
		private function onStageActivate(e: flash.events.Event): void
		{
			m_controller.onWakeUp();
			
			if (m_activeView == m_historyView)
				m_historyView.update();
		}
		
		private function onStageDeactivate(e: flash.events.Event): void
		{
			m_controller.onSleep();
		}
		
		private function onStageKeyDown(e: KeyboardEvent): void
		{
			switch (e.keyCode)
			{
				case Keyboard.HOME:
				case Keyboard.BACK:
					if (e.cancelable)
					{
						switch (m_ui.navigator.activeScreenID)
						{
							case Main.ID_BROWSE:
								return;
							case Main.ID_HISTORY:
								m_ui.navigator.showScreen(Main.ID_TASK);
								break;
							default:
								m_ui.navigator.showScreen(Main.ID_BROWSE);
								break;
						}
						e.preventDefault();
					}
					break;
				
				case Keyboard.SEARCH:
					switch (m_ui.navigator.activeScreenID)
					{
						case Main.ID_BROWSE:
							m_ui.webView.showTextInput();
							break;
						case Main.ID_TASK:
							m_taskView.onSearch();
							break;
					}
					break;
				
				case Keyboard.MENU:
					switch (m_ui.navigator.activeScreenID)
					{
						case Main.ID_BROWSE:
							m_ui.webView.showMenu();
							break;
						case Main.ID_TASK:
							m_taskView.showMenu();
							break;
					}
					break;
			}
		}
	}
}