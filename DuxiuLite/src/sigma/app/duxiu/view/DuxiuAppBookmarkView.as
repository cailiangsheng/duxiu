package sigma.app.duxiu.view
{
	import feathers.data.ListCollection;
	
	import sigma.app.duxiu.DuxiuAppController;
	import sigma.app.duxiu.data.BrowseItem;
	import sigma.app.duxiu.model.DuxiuDownBrowseModel;
	import sigma.app.duxiu.view.screens.BookmarkScreen;
	
	import starling.events.Event;

	public class DuxiuAppBookmarkView
	{
		private var m_model: DuxiuDownBrowseModel;
		private var m_controller: DuxiuAppController;
		
		private var m_ui: BookmarkScreen;
		
		public function DuxiuAppBookmarkView()
		{
		}
		
		public function initialize(model: DuxiuDownBrowseModel, controller: DuxiuAppController, ui: BookmarkScreen): void
		{
			m_model = model;
			m_controller = controller;
			m_ui = ui;
		}
		
		public function finalize(): void
		{
			m_model = null;
			m_controller = null;
			m_ui = null;
		}
		
		public function activate(): void
		{
			initBookmarkList();
			m_ui.list.addEventListener(Event.CHANGE, onListChange);
		}
		
		public function deactivate(): void
		{
			m_ui.list.removeEventListener(Event.CHANGE, onListChange);
		}
		
		private function initBookmarkList(): void
		{
			var data: ListCollection = new ListCollection();
			for each (var item: BrowseItem in m_model.bookmarks)
			{
				if (item)
				{
					var url: String = String(item.httpURL.split("\n")[0]);
					data.push({label: item.name, detail: url});
				}
			}
			
			m_ui.list.itemRendererProperties.labelField = "label";
			m_ui.list.itemRendererProperties.accessoryLabelField = "detail";
			m_ui.list.isSelectable = true;
			m_ui.list.dataProvider = data;
		}
		
		private function onListChange(e: Event): void
		{
			if (m_ui.list.selectedItem)
			{
				m_controller.onBrowse(m_ui.list.selectedItem.detail);
				
				m_ui.hide();
				m_ui.list.selectedItem = null;
			}
		}
	}
}