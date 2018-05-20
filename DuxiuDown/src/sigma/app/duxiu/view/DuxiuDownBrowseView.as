package sigma.app.duxiu.view
{
	import flash.events.Event;
	
	import mx.controls.Menu;
	import mx.events.MenuEvent;
	
	import sigma.app.duxiu.DuxiuDownController;
	import sigma.app.duxiu.data.BrowseItem;
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.app.duxiu.model.DuxiuDownBrowseModel;
	import sigma.lib.components.SingleBrowser;
	import sigma.lib.utils.MenuUtil;

	public class DuxiuDownBrowseView
	{
		private var m_model: DuxiuDownBrowseModel;
		private var m_controller: DuxiuDownController;
		
		private var m_ui: SingleBrowser;
		private var m_menu: Menu;
		
		public function DuxiuDownBrowseView()
		{
		}
		
		public function initialize(model: DuxiuDownBrowseModel, controller: DuxiuDownController, ui: SingleBrowser): void
		{
			m_model = model;
			m_controller = controller;
			m_ui = ui;
			
			m_ui.html.addEventListener(Event.LOCATION_CHANGE, onHtmlBrowse);
		}
		
		public function finalize(): void
		{
			m_ui.html.removeEventListener(Event.LOCATION_CHANGE, onHtmlBrowse);
			
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
			m_model.removeEventListener(ModelEvent.BROWSE_LOCATION_CHANGE, onLocationChange);
		}
		
		private function onHtmlBrowse(e: Event): void
		{
			m_controller.onBrowse(m_ui.html.location);
		}
		
		private function onLocationChange(e: ModelEvent): void
		{
			m_ui.location = m_model.location;
		}
		
		public function get menu(): Menu
		{
			if (m_menu == null)
			{
				if (m_model.bookmarks && m_model.bookmarks.length > 0)
				{
					var menuData: Array = [];
					for each (var item: BrowseItem in m_model.bookmarks)
					{
						menuData.push(item ? {label: item.name, url: item.url} : MenuUtil.SEPARATOR);
					}
					m_menu = MenuUtil.createMenu(m_ui, menuData, false);
					m_menu.addEventListener(MenuEvent.ITEM_CLICK, function(e: MenuEvent): void
					{
						m_controller.onBrowse(e.item.url);
					});
				}
			}
			return m_menu;
		}
	}
}