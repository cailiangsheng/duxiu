package sigma.lib.components
{
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.html.HTMLWindowCreateOptions;
	import flash.net.URLRequest;

	internal class SingleHTMLHost extends HTMLHost
	{
		public function SingleHTMLHost(defaultBehaviors:Boolean=true)
		{
			super(defaultBehaviors);
		}

        override public function windowClose():void
        {
        	var blankRequest: URLRequest = new URLRequest("about:blank");
            htmlLoader.load(blankRequest);
        }
        
        override public function createWindow(windowCreateOptions: HTMLWindowCreateOptions):HTMLLoader
        {
            return htmlLoader;
        }
	}
}