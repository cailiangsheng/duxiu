package sigma.lib.events
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		public static const OUTPUT: String = "output";
		
		public var data: Object;
		
		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}