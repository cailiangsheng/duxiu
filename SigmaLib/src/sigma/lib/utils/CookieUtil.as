package sigma.lib.utils
{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.Dictionary;

	public class CookieUtil
	{
		private static var ms_soMap: Dictionary = new Dictionary();
		
		public static function openCookie(objName: String): Object
		{
			if (objName)
			{
				var so: SharedObject = SharedObject.getLocal(objName);
				ms_soMap[so.data] = so;
				return so.data;
			}
			return null;
		}
		
		public static function clearCookie(object: Object): Boolean
		{
			if (object)
			{
				var so: SharedObject = ms_soMap[object];
				if (so)
				{
					so.clear();
					return true;
				}
			}
			return false;
		}
		
		public static function closeCookie(object: Object): Boolean
		{
			if (object)
			{
				var so: SharedObject = ms_soMap[object];
				if (so)
				{
					try
					{
						var status: String = so.flush();
						return (status == SharedObjectFlushStatus.FLUSHED);
					}
					catch (e: Error)
					{}
				}
			}
			return false;
		}
	}
}