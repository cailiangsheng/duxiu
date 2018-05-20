package sigma.app.duxiu.model
{
	import flash.events.EventDispatcher;
	
	import sigma.app.duxiu.events.DataEvent;
	import sigma.app.duxiu.events.ModelEvent;
	import sigma.app.duxiu.utils.BookPagesExporter;
	import sigma.lib.utils.FileUtil;
	
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="exportBegin")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="exportComplete")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="exportFailed")]
	[Event(type="sigma.app.duxiu.events.ModelEvent", name="exportStop")]
	public class DuxiuDownExportModel extends EventDispatcher
	{
		private var m_cookie: Object;
		
		private var m_taskModel: DuxiuDownTaskModel;
		
		private var m_exporting: Boolean;
		private var m_exporter: BookPagesExporter;
		
		public function DuxiuDownExportModel()
		{
		}
		
		public function initialize(taskModel: DuxiuDownTaskModel): void
		{
			m_taskModel = taskModel;
			m_exporter = new BookPagesExporter();
			
			m_exporter.addEventListener(DataEvent.COMPLETE, onExportComplete);
			m_exporter.addEventListener(DataEvent.ERROR, onExportError);
			m_exporter.addEventListener(DataEvent.FAILED, onExportFailed);
			m_exporter.addEventListener(DataEvent.START, onExportStart);
			m_exporter.addEventListener(DataEvent.STEP, onExportStep);
			m_exporter.addEventListener(DataEvent.STOP, onExportStop);
		}
		
		public function finalize(): void
		{
			m_taskModel = null;
			
			m_exporter.cancel();
			m_exporter.removeEventListener(DataEvent.COMPLETE, onExportComplete);
			m_exporter.removeEventListener(DataEvent.ERROR, onExportError);
			m_exporter.removeEventListener(DataEvent.FAILED, onExportFailed);
			m_exporter.removeEventListener(DataEvent.START, onExportStart);
			m_exporter.removeEventListener(DataEvent.STEP, onExportStep);
			m_exporter.removeEventListener(DataEvent.STOP, onExportStop);
			
			m_exporter = null;
		}
		
		//------------------------------------------------------
		private function onExportComplete(e: DataEvent): void
		{
			m_taskModel.log += "\nEnd Exporting.";
			
			var event: ModelEvent = new ModelEvent(ModelEvent.EXPORT_COMPLETE);
			event.data = e.data;
			this.dispatchEvent(event);
		}
		
		private function onExportError(e: DataEvent): void
		{
			m_taskModel.log += "\nExport Error:  " + e.data.toString();
		}
		
		private function onExportFailed(e: DataEvent): void
		{
			m_taskModel.log += "\nExport Failed.";
			
			this.dispatchEvent(new ModelEvent(ModelEvent.EXPORT_FAILED));
		}
		
		private function onExportStart(e: DataEvent): void
		{
			m_taskModel.log = "Begin Exporting...";
			
			this.dispatchEvent(new ModelEvent(ModelEvent.EXPORT_BEGIN));
		}
		
		private function onExportStep(e: DataEvent): void
		{
			m_taskModel.log += "\nExport Step:  " + e.data.toString();
		}
		
		private function onExportStop(e: DataEvent): void
		{
			m_taskModel.log += "\nStop Exporting.";
			
			this.dispatchEvent(new ModelEvent(ModelEvent.EXPORT_STOP));
		}
		
		//------------------------------------------------------
		public function get isExportable(): Boolean
		{
			return m_taskModel.canRename;
		}
		
		public function get isExporting(): Boolean
		{
			return m_exporter.isExporting;
		}
		
		//------------------------------------------------------
		public function get defaultPdfPath(): String
		{
			return BookPagesExporter.getPdfPath(m_taskModel.bookHome);
		}
		
		public function get defaultPdfExist(): Boolean
		{
			return FileUtil.checkExist(this.defaultPdfPath);
		}
		
		public function export(): Boolean
		{
			return m_exporter.exportPDF(m_taskModel.bookHome);
		}
		
		public function cancel(): Boolean
		{
			return m_exporter.cancel();
		}
	}
}