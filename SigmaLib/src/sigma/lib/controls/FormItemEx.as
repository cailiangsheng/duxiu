package sigma.lib.controls
{
	import mx.containers.FormItem;
	
	/**
	 *  Vertical alignment of label in the FormItem.
	 *  Possible values are <code>"top"</code>, <code>"middle"</code>,
	 *  and <code>"bottom"</code>.
	 *
	 *  @default "top"
	 */
	[Style(name="verticalAlign", type="String", enumeration="top,middle,bottom", inherit="no")]
	
	public class FormItemEx extends FormItem
	{
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var verticalAlign:String = getStyle("verticalAlign");
			if (verticalAlign == "middle")
			{   
				itemLabel.y = Math.max(0, (unscaledHeight - itemLabel.height) / 2);
			}
			else if (verticalAlign == "bottom")
			{
				var padBottom: Number = getStyle("paddingBottom");
				itemLabel.y = Math.max(0, unscaledHeight - itemLabel.height - padBottom);
			}
		}
	}
}