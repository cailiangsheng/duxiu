package sigma.lib.tools.flexsrc
{
	import sigma.lib.utils.StringUtil;

	public class FlexSourceEmbedImage extends FlexSource
	{
		public var imagePath: String;
		public var imageWidth: int;
		public var imageHeight: int;
		
		public function FlexSourceEmbedImage(packageName: String, 
											 className: String, 
											 imagePath: String, 
											 imageWidth: int, 
											 imageHeight: int)
		{
			super(packageName, className);
			
			this.imagePath = imagePath;
			this.imageWidth = imageWidth;
			this.imageHeight = imageHeight;
		}
		
		public override function get sourceCode(): String
		{
			var fixImagePath: String = StringUtil.replaceAll(imagePath, '\\', '/');
			return "package" + packageName +
				"\r\n{" +
				"\r\n	import flash.display.BitmapData;" +
				"\r\n	[Embed(source='" + fixImagePath + "')]" +
				"\r\n	dynamic public class " + className + " extends BitmapData" + 
				"\r\n	{" +
				"\r\n		public function " + className + "(width: Number = " + imageWidth + ", height: Number = " + imageHeight + ")" + 
				"\r\n		{" +
				"\r\n			super(width, height);" +
				"\r\n		}" + 
				"\r\n	}" + 
				"\r\n}";
		}
	}
}