package sigma.app.duxiu.view
{
	import mx.collections.ArrayCollection;
	
	import spark.events.IndexChangeEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sigma.app.duxiu.controller.DuxiuAppBrowseEvent;
	import sigma.app.duxiu.data.BrowseItem;
	import sigma.app.duxiu.model.DuxiuAppModel;

	public class DuxiuAppBookmarkMediator extends Mediator
	{
		[Inject]
		public var view: DuxiuAppBookmarkUI;
		
		[Inject]
		public var model: DuxiuAppModel;
		
		public function DuxiuAppBookmarkMediator()
		{
		}
		
		override public function onRegister():void
		{
			// model to view
			initBookmarkList();
			
			// view to model
			eventMap.mapListener(view.lstBookmarks, IndexChangeEvent.CHANGE, onListIndexChange);
		}
		
		private function initBookmarkList(): void
		{
			var data: ArrayCollection = new ArrayCollection();
			for each (var item: BrowseItem in model.browseModel.bookmarks)
			{
				if (item)
				{
					data.addItem({label: item.name, detail: item.httpURL.split("\n")[0]});
				}
			}
			view.lstBookmarks.dataProvider = data;
		}
		
		private function onListIndexChange(e: IndexChangeEvent): void
		{
			view.hideUI();
			
			var event: DuxiuAppBrowseEvent = new DuxiuAppBrowseEvent(DuxiuAppBrowseEvent.BROWSE);
			event.location = view.lstBookmarks.dataProvider.getItemAt(e.newIndex).detail;
			eventDispatcher.dispatchEvent(event);
		}
	}
}