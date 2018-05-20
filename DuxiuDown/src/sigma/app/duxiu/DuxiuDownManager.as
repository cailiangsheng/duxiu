package sigma.app.duxiu
{
	import sigma.app.duxiu.model.DuxiuDownModel;
	import sigma.app.duxiu.view.DuxiuDownUI;
	import sigma.app.duxiu.view.DuxiuDownView;

	public class DuxiuDownManager
	{
		private var m_model: DuxiuDownModel;
		private var m_controller: DuxiuDownController;
		private var m_view: DuxiuDownView;
		
		public function DuxiuDownManager()
		{
		}
		
		public function initialize(ui: DuxiuDownUI): void
		{
			m_model = new DuxiuDownModel();
			m_model.initialize();
			
			m_controller = new DuxiuDownController();
			m_controller.initialize(m_model);
			
			m_view = new DuxiuDownView();
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