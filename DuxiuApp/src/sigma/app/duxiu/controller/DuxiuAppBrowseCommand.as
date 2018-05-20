package sigma.app.duxiu.controller
{
	import org.robotlegs.mvcs.Command;
	
	import sigma.app.duxiu.model.DuxiuAppModel;

	public class DuxiuAppBrowseCommand extends Command
	{
		[Inject]
		public var event: DuxiuAppBrowseEvent;
		
		[Inject]
		public var model: DuxiuAppModel;
		
		public function DuxiuAppBrowseCommand()
		{
		}
		
		override public function execute():void
		{
			model.browseModel.location = event.location;
		}
	}
}