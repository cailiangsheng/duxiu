package sigma.lib.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.windowClasses.TitleBar;

	public class StaticTitleBar extends TitleBar
	{
		public function StaticTitleBar()
		{
			super();	// 原本屏蔽父类的MOUSE_DOWN事件监听器即可，但因为是在super()中添加监听器且监听器为私有，无法去掉。
			
			this.mouseEnabled = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e: Event): void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e: MouseEvent): void
		{
			if (this.closeButton.hitTestPoint(e.stageX, e.stageY) || 
				this.maximizeButton.hitTestPoint(e.stageX, e.stageY) || 
				this.minimizeButton.hitTestPoint(e.stageX, e.stageY))
			{
				this.mouseChildren = true;
			}
			else
			{
				this.mouseChildren = false;
			}
		}
	}
}