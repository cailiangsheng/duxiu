package sigma.app.duxiu.model
{
	import flash.events.EventDispatcher;
	
	import sigma.app.duxiu.events.ModelEvent;

	[Event(type="sigma.app.duxiu.events.ModelEvent", name="activeTabChange")]
	public class DuxiuDownModel extends EventDispatcher
	{
		private var m_browseModel: DuxiuDownBrowseModel;
		private var m_taskModel: DuxiuDownTaskModel;
		
		private var m_activeTab: int;
		
		public function DuxiuDownModel()
		{
		}
		
		public function initialize(): void
		{
			m_browseModel = new DuxiuDownBrowseModel();
			m_browseModel.initialize();
			
			m_taskModel = new DuxiuDownTaskModel();
			m_taskModel.initialize();
		}
		
		public function finalize(): void
		{
			m_browseModel.finalize();
			m_taskModel.finalize();
		}
		
		public function acitvate(): void
		{
			m_taskModel.countModel.update();
		}
		
		public function deactivate(): void
		{
			m_browseModel.save();
			m_taskModel.save();
		}
		
		public function get browseModel(): DuxiuDownBrowseModel
		{
			return m_browseModel;
		}
		
		public function get taskModel(): DuxiuDownTaskModel
		{
			return m_taskModel;
		}
		
		public function set activeTab(value: int): void
		{
			if (m_activeTab != value)
			{
				m_activeTab = value;
				
				var event: ModelEvent = new ModelEvent(ModelEvent.ACTIVE_TAB_CHANGE);
				this.dispatchEvent(event);
			}
		}
	}
}