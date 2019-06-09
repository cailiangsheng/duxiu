package sigma.lib.utils
{
	import flash.filesystem.File;
	import flash.utils.getQualifiedClassName;
	
	public class ClassNameUtil
	{
		public static const SEPERATOR_PACKAGE: String = ".";
		public static const SEPERATOR_CLASS: String = "::";
		
		public static function getFilePathByName(className: String): String
		{
			return StringUtil.replaceAll(className, SEPERATOR_PACKAGE, File.separator).replace(SEPERATOR_CLASS, File.separator);
		}
		
		public static function getImportPathByName(className: String): String
		{
			return StringUtil.replaceAll(className, SEPERATOR_CLASS, SEPERATOR_PACKAGE);
		}
		
		public static function getClassObject(object: Object): *
		{
			return object ? object.constructor : null;
		}
		
		//----------------------------------------------------------------------
		public static function getFilePathOfPackage(classObject: *): String
		{
			return getFilePathByName(getNameOfPackage(classObject));
		}
		
		public static function getFilePathOfClass(classObject: *): String
		{
			return getFilePathByName(getNameOfClass(classObject));
		}
		
		public static function getImportPathOfPackage(classObject: *): String
		{
			return getImportPathByName(getNameOfPackage(classObject));
		}
		
		public static function getImportPathOfClass(classObject: *): String
		{
			return getImportPathByName(getNameOfClass(classObject));
		}
		
		public static function getNameOfClass(classObject: *): String
		{
			return getQualifiedClassName(classObject);
		}
		
		public static function getMainNameOfClass(classObject: *): String
		{
			var className: String = getNameOfClass(classObject);
			var index: int = className.indexOf(SEPERATOR_CLASS);
			return index >= 0 ? className.substring(index + 2) : className;
		}
		
		public static function getNameOfPackage(classObject: *): String
		{
			var className: String = getNameOfClass(classObject);
			return className.substring(0, className.indexOf(SEPERATOR_CLASS));
		}
		
		//----------------------------------------------------------------------
		public static function getFilePathOfPackageEx(object: Object): String
		{
			return getFilePathOfPackage(getClassObject(object));
		}
		
		public static function getFilePathOfClassEx(object: Object): String
		{
			return getFilePathOfClass(getClassObject(object));
		}
		
		public static function getImportPathOfPackageEx(object: Object): String
		{
			return getImportPathOfPackage(getClassObject(object));
		}
		
		public static function getImportPathOfClassEx(object: Object): String
		{
			return getImportPathOfClass(getClassObject(object));
		}
		
		public static function getNameOfClassEx(object: Object): String
		{
			return getNameOfClass(getClassObject(object));
		}
		
		public static function getMainNameOfClassEx(object: Object): String
		{
			return getMainNameOfClass(getClassObject(object));
		}
		
		public static function getNameOfPackageEx(object: Object): String
		{
			return getNameOfPackage(getClassObject(object));
		}
	}
}