package sigma.app.duxiu.view.screens
{
	import feathers.controls.Button;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HistoryScreen extends Screen
	{
		private var m_taskScreen: TaskScreen;
		
		private var m_header: Header;
		
		private var m_backButton: Button;
		
		private var m_list: GroupedList;
		
		public function get list(): GroupedList
		{
			return m_list;
		}
		
		public function get taskScreen(): TaskScreen
		{
			return m_taskScreen;
		}
		
		public function HistoryScreen(taskScreen: TaskScreen)
		{
			m_taskScreen = taskScreen;
		}
		
		override protected function initialize():void
		{
			m_header = new Header();
			m_header.title = "历史";
			m_header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			this.addChild(m_header);
			
			m_backButton = new Button();
			m_backButton.label = "完成";
			m_backButton.addEventListener(Event.TRIGGERED, backButtonTriggered);
			
			m_header.rightItems = new <DisplayObject>
				[
					m_backButton
				];
			
			m_list = new GroupedListEx();
			m_list.dataProvider = null;
			this.addChild(m_list);
		}
		
		override protected function draw(): void
		{
			m_header.width = this.actualWidth;
			m_header.validate();
			
			m_list.y = m_header.height;
			m_list.width = this.actualWidth;
			m_list.height = this.actualHeight - m_list.y;
		}
		
		public function hide(): void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}
		
		private function backButtonTriggered(e: Event): void
		{
			this.hide();
		}
	}
}