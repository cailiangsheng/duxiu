package sigma.lib.utils
{
	import flash.display.DisplayObjectContainer;
	
	import mx.controls.Menu;

	public class MenuUtil
	{
		public static const SEPARATOR: Object = {type: "separator"};
		
		[Embed(source="../../../../assets/separator.png")]
		private static var separatorSkin: Class;
		
		public static function createMenu(parent: DisplayObjectContainer, mdp: Object, showRoot: Boolean = true): Menu
		{
			var menu: Menu = Menu.createMenu(parent, mdp, showRoot);
			menu.setStyle("openDuration", 0);
			menu.setStyle("separatorSkin", separatorSkin);
			menu.variableRowHeight = true;
			return menu;
		}
	}
}