package sigma.app.duxiu.events
{
	import flash.events.Event;

	public class DataEvent extends Event
	{
		public static const START: String = "start";
		
		public static const COMPLETE: String = "complete";
		
		public static const ERROR: String = "error";
		
		public static const STEP: String = "step";
		
		public static const FAILED: String = "failed";
		
		public static const STOP: String = "stop";
		
		public var data: Object;
		
		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}