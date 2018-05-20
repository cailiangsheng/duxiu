package sigma.app.duxiu
{
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;
	
	import sigma.ane.utils.FileUtil;

	public class DuxiuAppController extends DuxiuBaseController
	{
		public function DuxiuAppController()
		{
		}
		
		override public function alert(message:String):void
		{
			NativeAlert.show(message, "读秀下载", "确定");
		}
		
		override public function onOpenPDF():void
		{
			if (!exploreFile(m_model.taskModel.exportModel.defaultPdfPath))
			{
				alert("无法打开PDF!");
			}
		}
		
		public function onOpenFile(filePath: String): void
		{
			if (!exploreFile(filePath))
			{
				alert("无法打开文件!");
			}
		}
		
		private static function exploreFile(filePath: String): Boolean
		{
			return FileUtil.exploreFile(filePath);
		}
	}
}