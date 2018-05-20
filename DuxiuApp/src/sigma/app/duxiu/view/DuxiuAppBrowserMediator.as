package sigma.app.duxiu.view
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sigma.app.duxiu.controller.DuxiuAppBrowseEvent;
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.app.duxiu.model.DuxiuAppModel;

	public class DuxiuAppBrowserMediator extends Mediator
	{
		[Inject]
		public var view: DuxiuAppBrowserUI;
		
		[Inject]
		public var model: DuxiuAppModel;
		
		public function DuxiuAppBrowserMediator()
		{
		}
		
		override public function onRegister():void
		{
			// model to view
			eventMap.mapListener(model.browseModel, ModelEvent.BROWSE_LOCATION_CHANGE, onBrowseLocationChanged);
			onBrowseLocationChanged(null);
			
			// view to model
			eventMap.mapListener(view.txtURL, KeyboardEvent.KEY_DOWN, onBrowseKeyDown);
		}
		
		private function onBrowseLocationChanged(e: Event): void
		{
			view.location = model.browseModel.location;
		}
		
		private function onBrowseKeyDown(e: KeyboardEvent): void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				if (this.view.validURL)
				{
					var event: DuxiuAppBrowseEvent = new DuxiuAppBrowseEvent(DuxiuAppBrowseEvent.BROWSE);
					event.location = this.view.validURL;
					eventDispatcher.dispatchEvent(event);
				}
			}
		}
	}
}