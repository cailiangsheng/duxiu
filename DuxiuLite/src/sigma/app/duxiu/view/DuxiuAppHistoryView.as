package sigma.app.duxiu.view
{
	import flash.filesystem.File;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.data.HierarchicalCollection;
	import feathers.skins.StandardIcons;
	
	import sigma.app.duxiu.DuxiuAppController;
	import sigma.app.duxiu.model.DuxiuDownTaskModel;
	import sigma.app.duxiu.view.screens.HistoryScreen;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class DuxiuAppHistoryView
	{
		private var m_model: DuxiuDownTaskModel;
		private var m_controller: DuxiuAppController;
		
		private var m_ui: HistoryScreen;
		
		public function DuxiuAppHistoryView()
		{
		}
		
		public function initialize(model: DuxiuDownTaskModel, controller: DuxiuAppController, ui: HistoryScreen): void
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
			initHistoryList();
			m_ui.list.addEventListener(Event.CHANGE, onListChange);
		}
		
		public function deactivate(): void
		{
			m_ui.list.removeEventListener(Event.CHANGE, onListChange);
		}
		
		public function update(): void
		{
			initHistoryList();
		}
		
		private function initHistoryList(): void
		{
			var dirData: Array = [];
			var fileData: Array = [];
			var file: File = new File(m_model.saveHome);
			if (file.exists && file.isDirectory)
			{
				var subFiles: Array = file.getDirectoryListing();
				for each (var subFile: File in subFiles)
				{
					var item: Object = {label:subFile.name, path: subFile.nativePath};
					subFile.isDirectory ? dirData.push(item) : fileData.push(item);
				}
			}
			
			
			m_ui.list.itemRendererProperties.labelField = "label";
			m_ui.list.itemRendererProperties.accessorySourceFunction = accessorySourceFunction;
			m_ui.list.isSelectable = true;
			
			if (dirData.length == 0)
				dirData.push({label: "尚无任务", path: null});
			
			if (fileData.length == 0)
				fileData.push({label: "尚无文件", path: null});
			
			m_ui.list.dataProvider = new HierarchicalCollection(
				[
					{header: "任务", children: dirData},
					{header: "文件", children: fileData}
				]);
		}
		
		private function accessorySourceFunction(item:Object):Texture
		{
			if (item.hasOwnProperty("path"))
			{
				return StandardIcons.listDrillDownAccessoryTexture;
			}
			return null;
		}
		
		private function onListChange(e: Event): void
		{
			if (m_ui.list.selectedItem)
			{
				var filePath: String = m_ui.list.selectedItem.path;
				if (filePath)
				{
					var file: File = new File(filePath);
					if (file.isDirectory)
					{
						m_controller.onSelectDirFile(file);
						m_ui.hide();
						m_ui.taskScreen.showParamsTab();
					}
					else
					{
						m_controller.onOpenFile(filePath);
					}
				}
				m_ui.list.selectedItem = null;
			}
		}
	}
}