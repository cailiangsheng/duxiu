package sigma.app.duxiu
{
	import org.robotlegs.mvcs.Context;
	
	import sigma.app.duxiu.controller.DuxiuAppBrowseCommand;
	import sigma.app.duxiu.controller.DuxiuAppBrowseEvent;
	import sigma.app.duxiu.model.DuxiuAppModel;
	import sigma.app.duxiu.view.DuxiuAppBookmarkMediator;
	import sigma.app.duxiu.view.DuxiuAppBookmarkUI;
	import sigma.app.duxiu.view.DuxiuAppBrowserMediator;
	import sigma.app.duxiu.view.DuxiuAppBrowserUI;

	public class DuxiuAppContext extends Context
	{
		public function DuxiuAppContext()
		{
		}
		
		override public function startup():void
		{
			// Controller
			commandMap.mapEvent(DuxiuAppBrowseEvent.BROWSE, DuxiuAppBrowseCommand);
			
			// Model
			injector.mapSingleton(DuxiuAppModel);
			
			// View
			mediatorMap.mapView(DuxiuAppBrowserUI, DuxiuAppBrowserMediator);
			mediatorMap.mapView(DuxiuAppBookmarkUI, DuxiuAppBookmarkMediator);
		}
	}
}