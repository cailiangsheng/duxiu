package sigma.lib.utils
{
	public class ObjectUtil
	{
		public static function getPropNames(object: Object): Vector.<String>
		{
			if (object)
			{
				var propNames: Vector.<String> = new Vector.<String>();
				for (var propName: String in object)
				{
					propNames.push(propName);
				}
				return propNames;
			}
			return null;
		}
		
		public static function clearProps(object: Object): Boolean
		{
			var propNames: Vector.<String> = ObjectUtil.getPropNames(object);
			if (propNames && propNames.length > 0)
			{
				for each (var propName: String in propNames)
				{
					delete object[propName];
				}
				return true;
			}
			return false;
		}
	}
}