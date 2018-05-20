package sigma.app.duxiu
{
	import sigma.app.duxiu.model.DuxiuDownModel;
	import sigma.app.duxiu.view.DuxiuAppView;
	import sigma.app.duxiu.view.Main;

	public class DuxiuAppManager
	{
		private var m_model: DuxiuDownModel;
		private var m_controller: DuxiuAppController;
		private var m_view: DuxiuAppView;
		
		public function DuxiuAppManager()
		{
		}
		
		public function intialize(ui: Main): void
		{
			m_model = new DuxiuDownModel();
			m_model.initialize();
			
			m_controller = new DuxiuAppController();
			m_controller.initialize(m_model);
			
			m_view = new DuxiuAppView();
			m_view.initialize(m_model, m_controller, ui);
		}
		
		public function finalize(): void
		{
			m_model.finalize();
			m_controller.finalize();
			m_view.finalize();
		}
		
		public function activate(): void
		{
			m_view.activate();
		}
		
		public function deactivate(): void
		{
			m_view.deactive();
		}
	}
}