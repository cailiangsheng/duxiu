package sigma.app.duxiu.controller
{
	import flash.events.Event;
	
	public class DuxiuAppBrowseEvent extends Event
	{
		public static const BROWSE: String = "browse";
		
		public var location: String;
		
		public function DuxiuAppBrowseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}