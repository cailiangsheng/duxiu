package sigma.app.duxiu.model
{
	import flash.events.EventDispatcher;
	
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.app.duxiu.utils.BookPageCounter;

	[Event(type="sigma.app.duxiu.events.ModelEvent", name="pageCountChange")]
	public class DuxiuDownCountModel extends EventDispatcher
	{
		private var m_taskModel: DuxiuDownTaskModel;
		
		private var m_counter: BookPageCounter;
		
		public function DuxiuDownCountModel()
		{
		}
		
		public function get counter(): BookPageCounter
		{
			return m_counter;
		}
		
		public function initialize(taskModel: DuxiuDownTaskModel): void
		{
			m_counter = new BookPageCounter();
			
			m_taskModel = taskModel;
			m_taskModel.addEventListener(ModelEvent.BOOK_HOME_CHANGE, onBookPageChange);
			m_taskModel.downloadModel.addEventListener(ModelEvent.DOWNLOAD_PAGE, onBookPageChange);
			m_taskModel.downloadModel.addEventListener(ModelEvent.DOWNLOAD_COMPLETE, onBookPageChange);
			
			onBookPageChange(null);
		}
		
		public function finalize(): void
		{
			m_taskModel.removeEventListener(ModelEvent.BOOK_HOME_CHANGE, onBookPageChange);
			m_taskModel.downloadModel.removeEventListener(ModelEvent.DOWNLOAD_PAGE, onBookPageChange);
			m_taskModel.downloadModel.removeEventListener(ModelEvent.DOWNLOAD_COMPLETE, onBookPageChange);
			m_taskModel = null;
			
			m_counter = null;
		}
		
		private function onBookPageChange(e: ModelEvent): void
		{
			update();
		}
		
		public function update(): void
		{
			var preNumPages: int = m_counter.numPages;
			
			m_counter.count(m_taskModel.bookHome);
			if (preNumPages != m_counter.numPages)
			{
				this.dispatchEvent(new ModelEvent(ModelEvent.PAGE_COUNT_CHANGE));
			}
		}
	}
}