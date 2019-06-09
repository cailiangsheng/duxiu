package sigma.lib.utils
{
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Screen;
	import flash.geom.Rectangle;
	
	import mx.core.ClassFactory;
	import mx.core.IWindow;
	import mx.core.LayoutContainer;
	import mx.core.Window;
	import mx.core.WindowedApplication;
	import mx.events.AIREvent;
	
	import sigma.lib.controls.StaticTitleBar;
	
	public class WindowUtil
	{
		private static function _filterWindow(window: IWindow): *
		{
			var win: LayoutContainer = window as Window;
			if (win)
				return win;
			else
				return window as WindowedApplication;
		}
		
		//-----------------------------------------------------------
		public static function fullResize(window: IWindow): void
		{
			resize(window, Screen.mainScreen.visibleBounds);
		}
		
		public static function resize(window: IWindow, bounds: Rectangle): void
		{
			if (window.systemChrome == NativeWindowSystemChrome.NONE && 
				window.transparent == true && 
				window.maximizable == false)
			{
				var win: * = _filterWindow(window);
				if (win)
				{
					function moveToCorner(e: AIREvent): void
					{
						e.target.move(bounds.left, bounds.top);
						e.target.removeEventListener(AIREvent.WINDOW_ACTIVATE, moveToCorner);
					}
					win.x = bounds.left;			//0;
					win.y = bounds.top;				//0;
					win.width = bounds.width;		//Capabilities.screenResolutionX;
					win.height = bounds.height;		//Capabilities.screenResolutionY;
					win.addEventListener(AIREvent.WINDOW_ACTIVATE, moveToCorner);
				}
			}
			else
				throw new Error("Make sure: systemChrome=none, transparent=true, maximizable=false!");
		}
		
		//-----------------------------------------------------------
		public static function dismovable(window: IWindow): void
		{
			if (window.systemChrome == NativeWindowSystemChrome.NONE && 
				window.transparent == true)
			{
				var win: * = _filterWindow(window);
				if (win)
				{
					win.titleBarFactory = new ClassFactory(StaticTitleBar);
				}
			}
			else
				throw new Error("Make sure: systemChrome=none, transparent=true!");
		}
		
		//-----------------------------------------------------------
		public static function maximize(window: IWindow): void
		{
			fullResize(window);
			dismovable(window);
			
			if (window.resizable != false)
				throw new Error("Make sure: resizable=false!");
		}
	}
}