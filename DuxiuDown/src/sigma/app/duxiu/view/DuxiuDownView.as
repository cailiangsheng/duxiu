package sigma.app.duxiu.view
{
	import flash.geom.Point;
	
	import mx.controls.Menu;
	import mx.events.ItemClickEvent;
	
	import sigma.app.duxiu.DuxiuDownController;
	import sigma.app.duxiu.model.DuxiuDownModel;

	public class DuxiuDownView
	{
		private var m_model: DuxiuDownModel;
		private var m_controller: DuxiuDownController;
		
		private var m_ui: DuxiuDownUI;
		
		private var m_browseView: DuxiuDownBrowseView;
		private var m_taskView: DuxiuDownTaskView;
		
		public function DuxiuDownView()
		{
		}
		
		public function initialize(model: DuxiuDownModel, controller: DuxiuDownController, ui: DuxiuDownUI): void
		{
			m_model = model;
			m_controller = controller;
			m_ui = ui;
			
			m_browseView = new DuxiuDownBrowseView();
			m_browseView.initialize(m_model.browseModel, m_controller, m_ui.browser);
			
			m_taskView = new DuxiuDownTaskView();
			m_taskView.initialize(m_model.taskModel, m_controller, m_ui.task);
		}
		
		public function finalize(): void
		{
			m_browseView.finalize();
			m_taskView.finalize();
		}
		
		public function activate(): void
		{
			m_ui.bar.addEventListener(ItemClickEvent.ITEM_CLICK, onBarItemClick);
			
			m_browseView.activate();
			m_taskView.activate();
		}
		
		public function deactive(): void
		{
			m_ui.bar.removeEventListener(ItemClickEvent.ITEM_CLICK, onBarItemClick);
			
			m_browseView.deactivate();
			m_taskView.deactivate();
		}
		
		private function onBarItemClick(e: ItemClickEvent): void
		{
			var menu: Menu = null;
			switch (m_ui.tabs.selectedChild)
			{
				case m_ui.browser:
					menu = m_browseView.menu;
					break;
				case m_ui.task:
					menu = m_taskView.menu;
					break;
			}
			
			if (menu)
			{
				var bottom: Point = m_ui.bar.getChildAt(m_ui.bar.selectedIndex).localToGlobal(new Point(0, m_ui.bar.height));
				menu.show(bottom.x, bottom.y);
			}
		}
	}
}