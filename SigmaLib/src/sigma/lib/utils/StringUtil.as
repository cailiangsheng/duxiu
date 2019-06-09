package sigma.lib.utils
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public class StringUtil
	{
		public static function bound(str: String, char: String = "\""): String
		{
			if (str == null)
			{
				return char + char;
			}
			else
			{
				return char + str + char;
			}
		}
		
		public static function trim(str: String): String
		{
			if (str)
			{
				var len: int = str.length;
				for (var i: int = 0; i < len; i++)
				{
					if (!isBlankChar(str.charAt(i)))
						break;
				}
				for (var j: int = len - 1; j >= 0; j--)
				{
					if (!isBlankChar(str.charAt(j)))
						break;
				}
				return str.substring(i, j + 1)
			}
			return str;
		}
		
		public static function isBlankChar(char: String): Boolean
		{
			return char == ' ' || char == '\r' || char == '\n';
		}
		
		public static function replaceAll(text: String, pattern: String, replace: String): String
		{
			return text ? text.split(pattern).join(replace) : text;
		}
		
		public static function checkPrefix(text: String, prefix: String): Boolean
		{
			if (text && prefix)
			{
				return text.substr(0, prefix.length) == prefix;
			}
			return false;
		}
		
		public static function checkSuffix(text: String, suffix: String): Boolean
		{
			if (text && suffix)
			{
				return text.substr(text.length - suffix.length) == suffix;
			}
			return false;
		}
		
		public static function readString(input: IDataInput, encoding: String = "gb2312"): String
		{
			if (input)
			{
				return input.readMultiByte(input.bytesAvailable, encoding);
			}
			return null;
		}
		
		public static function writeString(output: IDataOutput, str: String, encoding: String = "gb2312"): Boolean
		{
			if (output && str != null && str.length > 0)
			{
				output.writeMultiByte(str, encoding);
				return true;
			}
			return false;
		}
		
		public static function encodeString(text: String, encodingFrom: String, encodingTo: String): String
		{
			var data: ByteArray = new ByteArray();
			data.writeMultiByte(text, encodingFrom);
			
			data.position = 0;
			var str: String = data.readMultiByte(data.length, encodingTo);
			data.clear();
			return str;
		}
	}
}