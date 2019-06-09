package sigma.lib.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class DisplayUtil
	{
		public static function calcStageOffset(displayObject: DisplayObject): Point
		{
			var ptPos: Point = new Point();
			var p: DisplayObject = displayObject;
			while (p)
			{
				ptPos.offset(p.x, p.y);
				p = p.parent;
			}
			return ptPos;
		}
	}
}