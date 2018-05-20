package sigma.app.duxiu.view.screens
{
	import feathers.controls.GroupedList;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.HierarchicalCollection;
	import feathers.events.FeathersEventType;
	
	import starling.events.Event;
	
	internal class GroupedListEx extends GroupedList
	{
		public function GroupedListEx()
		{
			// BUG: when scrolling, some item accessory will disappear (removed from stage)
			this.addEventListener(Event.SCROLL, onScroll);
			this.addEventListener(FeathersEventType.SCROLL_COMPLETE, onScroll);
		}
		
		private function onScroll(e: Event): void
		{
			showAccessory();
		}
		
		private function showAccessory(): void
		{
			if (super.dataViewPort == null)
				return;
			
			for (var i: int = 0, n: int = super.dataViewPort.numChildren; i < n; i++)
			{
				var item: IGroupedListItemRenderer = super.dataViewPort.getChildAt(i) as IGroupedListItemRenderer;
				var container: FeathersControl = item as FeathersControl;
				if (item && container && container.visible)
				{
					var accessory: FeathersControl = item.data.accessory;
					if (accessory && accessory.parent != container)
					{
						if (accessory.parent == null)
						{
							trace(item.data.label, " needs to show");
							container.addChild(accessory);
						}
						else
						{
							trace(item.data.label, " needs to hide");
							container.visible = false;
						}
					}
				}
			}
		}
	}
}