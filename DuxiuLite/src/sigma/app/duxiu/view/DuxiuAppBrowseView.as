package sigma.app.duxiu.view
{
	import flash.events.LocationChangeEvent;
	
	import sigma.app.duxiu.DuxiuAppController;
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.app.duxiu.model.DuxiuDownBrowseModel;
	import sigma.app.duxiu.view.screens.BrowseScreen;

	public class DuxiuAppBrowseView
	{
		private var m_model: DuxiuDownBrowseModel;
		private var m_controller: DuxiuAppController;
		
		private var m_ui: BrowseScreen;
		
		public function DuxiuAppBrowseView()
		{
		}
		
		public function initialize(model: DuxiuDownBrowseModel, controller: DuxiuAppController, ui: BrowseScreen): void
		{
			m_model = model;
			m_controller = controller;
			m_ui = ui;
			
			m_ui.webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, onWebViewBrowse);
		}
		
		public function finalize(): void
		{
			m_ui.webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, onWebViewBrowse);
			
			m_model = null;
			m_controller = null;
			m_ui = null;
		}
		
		public function activate(): void
		{
			m_model.addEventListener(ModelEvent.BROWSE_LOCATION_CHANGE, onLocationChange);
			
			onLocationChange(null);
		}
		
		public function deactivate(): void
		{
			m_ui.webView.hide();
			
			m_model.removeEventListener(ModelEvent.BROWSE_LOCATION_CHANGE, onLocationChange);
		}
		
		private function onWebViewBrowse(e: LocationChangeEvent): void
		{
			m_controller.onBrowse(m_ui.webView.currentURL);
		}
		
		private function onLocationChange(e: ModelEvent): void
		{
			m_ui.navigateURL(m_model.location);
		}
	}
}