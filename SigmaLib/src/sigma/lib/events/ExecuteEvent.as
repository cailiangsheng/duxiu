package sigma.lib.events
{
	import flash.events.Event;

	public class ExecuteEvent extends Event
	{
		public static const EXECUTED: String = "executed";
		public static const ERROR: String = "error";
		
		public function ExecuteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}