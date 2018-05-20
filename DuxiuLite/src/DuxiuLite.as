package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import sigma.app.duxiu.view.Main;
	import sigma.lib.utils.SystemUtil;
	
	import starling.core.Starling;
	
	[SWF(width="960",height="640",frameRate="60",backgroundColor="#2f2f2f")]
	public class DuxiuLite extends Sprite
	{
		private var m_starling: Starling;
		
		public function DuxiuLite()
		{
			super();
			
			if (this.stage)
			{
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
//				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			
			this.mouseEnabled = this.mouseChildren = false;
			this.loaderInfo.addEventListener(Event.COMPLETE, onLoaded);
		}
		
		private function onLoaded(e: Event): void
		{
			Starling.handleLostContext = SystemUtil.isApple ? false : true;
			Starling.multitouchEnabled = true;
			
			m_starling = new Starling(Main, this.stage);
			m_starling.enableErrorChecking = true;
			m_starling.start();
			
			this.stage.addEventListener(Event.RESIZE, onStageResize);
			this.stage.addEventListener(Event.DEACTIVATE, onStageDeactivate);
		}
		
		private function onStageResize(e: Event): void
		{
			var viewPort: Rectangle = m_starling.viewPort;
			viewPort.width = m_starling.stage.stageWidth = this.stage.stageWidth;
			viewPort.height = m_starling.stage.stageHeight = this.stage.stageHeight;
			
			try
			{
				m_starling.viewPort = viewPort;
			}
			catch (e: Error)
			{}
		}
		
		private function onStageDeactivate(e: Event): void
		{
			m_starling.stop();
			this.stage.addEventListener(Event.ACTIVATE, onStageActivate);
		}
		
		private function onStageActivate(e: Event): void
		{
			this.stage.removeEventListener(Event.ACTIVATE, onStageActivate);
			m_starling.start();
		}
	}
}