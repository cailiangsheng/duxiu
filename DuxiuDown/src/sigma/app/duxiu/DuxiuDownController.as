package sigma.app.duxiu
{
	import mx.controls.Alert;

	public class DuxiuDownController extends DuxiuBaseController
	{
		public function DuxiuDownController()
		{
		}
		
		override public function alert(message:String):void
		{
			Alert.show(message, "读秀下载");
		}
	}
}