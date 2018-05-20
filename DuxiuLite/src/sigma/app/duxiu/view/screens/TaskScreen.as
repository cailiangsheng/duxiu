package sigma.app.duxiu.view.screens
{
	import feathers.controls.Button;
	import feathers.controls.GroupedList;
	import feathers.controls.Header;
	import feathers.controls.PickerList;
	import feathers.controls.Screen;
	import feathers.controls.ScrollText;
	import feathers.controls.TabBar;
	import feathers.controls.TextInput;
	import feathers.data.HierarchicalCollection;
	import feathers.data.ListCollection;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class TaskScreen extends Screen
	{
		private static const SHOW_HISTORY: String = "showHistory";
		
		private var m_header: Header;
		private var m_tabBar: TabBar;
		
		private var m_historyButton: Button;
		private var m_operateButton: Button;
		private var m_stopButton: Button;
		private var m_backButton: Button;
		
		public function get operateButton(): Button { return m_operateButton; }
		public function get stopButton(): Button { return m_stopButton; }
		
		private var m_txtTitle: TextInput;
		private var m_txtSSNO: TextInput;
		private var m_txtSTR: TextInput;
		private var m_txtSPage: TextInput;
		private var m_txtEPage: TextInput;
		
		private var m_txtSaveHome: TextInput;
		private var m_lstPageZoom: PickerList;
		private var m_lstPageType: PickerList;
		private var m_txtFromPage: TextInput;
		private var m_txtToPage: TextInput;
		
		private var m_lstConfig: GroupedList;
		private var m_txtStat: ScrollText;
		private var m_txtLog: ScrollText;
		
		private var m_pageTypesDataProvider: ListCollection;
		private var m_pageZoomsDataProvider: ListCollection;
		
		public function set pageTypes(value: Vector.<String>): void
		{
			m_pageTypesDataProvider = new ListCollection(value);
			
			if (m_lstPageType)
				m_lstPageType.dataProvider = m_pageTypesDataProvider;
		}
		
		public function set pageZooms(value: Vector.<String>): void
		{
			m_pageZoomsDataProvider = new ListCollection(value);
			
			if (m_lstPageZoom)
				m_lstPageZoom.dataProvider = m_pageZoomsDataProvider;
		}
		
		public function get txtTitle(): TextInput { return m_txtTitle; }
		public function get txtSSNO(): TextInput { return m_txtSSNO; }
		public function get txtSTR(): TextInput { return m_txtSTR; }
		public function get txtSPage(): TextInput { return m_txtSPage; }
		public function get txtEPage(): TextInput { return m_txtEPage; }
		
		public function get lstPageZoom(): PickerList { return m_lstPageZoom; }
		public function get lstPageType(): PickerList { return m_lstPageType; }
		public function get txtFromPage(): TextInput { return m_txtFromPage; }
		public function get txtToPage(): TextInput { return m_txtToPage; }
		public function get txtSaveHome(): TextInput { return m_txtSaveHome; }
		
		public function get txtStat(): ScrollText { return m_txtStat; }
		public function get txtLog(): ScrollText { return m_txtLog; }
		
		public function TaskScreen()
		{
		}
		
		override protected function initialize():void
		{
			m_header = new Header();
			m_header.title = "任务";
			m_header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			this.addChild(m_header);
			
			m_historyButton = new Button();
			m_historyButton.label = "历史";
			m_historyButton.addEventListener(Event.TRIGGERED, historyButtonTriggered);
			
			m_operateButton = new Button();
			m_operateButton.label = "操作";
			
			m_stopButton = new Button();
			m_stopButton.label = "停止";
			
			m_backButton = new Button();
			m_backButton.label = "完成";
			m_backButton.addEventListener(Event.TRIGGERED, backButtonTriggered);
			
			m_header.gap = 2;
			m_header.rightItems = new <DisplayObject>
			[
				m_historyButton,
				m_operateButton,
				m_stopButton,
				m_backButton
			];
			
			m_tabBar = new TabBar();
			m_tabBar.dataProvider = new ListCollection(
			[
				{label: "任务配置"},
				{label: "文件统计"},
				{label: "运行日志"}
			]);
			this.addChild(m_tabBar);
			
			m_txtTitle = new TextInput();
			m_txtSSNO = new TextInput();
			m_txtSTR = new TextInput();
			m_txtSPage = new TextInput();
			m_txtEPage = new TextInput();
			
			m_lstPageZoom = new PickerList();
			m_lstPageZoom.dataProvider = m_pageZoomsDataProvider;
			
			m_lstPageType = new PickerList();
			m_lstPageType.dataProvider = m_pageTypesDataProvider;
			
			m_txtFromPage = new TextInput();
			m_txtToPage = new TextInput();
			m_txtSaveHome = new TextInput();
			
			m_lstConfig = new GroupedListEx();
			m_lstConfig.isSelectable = false;
			m_lstConfig.dataProvider = new HierarchicalCollection(
				[
					{
						header: "任务参数",
						children:
						[
							{label: "title", accessory: m_txtTitle},
							{label: "ssNo", accessory: m_txtSSNO},
							{label: "str", accessory: m_txtSTR},
							{label: "spage", accessory: m_txtSPage},
							{label: "epage", accessory: m_txtEPage}
						]
					},
					{
						header: "下载配置",
						children:
						[
							{label: "保存到", accessory: m_txtSaveHome},
							{label: "图尺寸", accessory: m_lstPageZoom},
							{label: "页类型", accessory: m_lstPageType},
							{label: "起始页", accessory: m_txtFromPage},
							{label: "结束页", accessory: m_txtToPage}
						]
					}
				]);
			
			m_txtStat = new ScrollText();
			m_txtStat.text = "尚无文件统计信息";
			
			m_txtLog = new ScrollText();
			m_txtLog.text = "尚无下载日志信息";
			
			m_tabBar.addEventListener(Event.CHANGE, onTabBarChange);
			onTabBarChange(null);
		}
		
		override protected function draw():void
		{
			m_header.width = this.actualWidth;
			m_header.validate();
			
			m_tabBar.width = this.actualWidth;
			m_tabBar.validate();
			m_tabBar.y = this.actualHeight - m_tabBar.height;
			
			m_lstConfig.y = m_header.height;
			m_lstConfig.width = this.actualWidth;
			m_lstConfig.height = m_tabBar.y - m_lstConfig.y;
			
			m_txtStat.y = m_txtLog.y = m_lstConfig.y;
			m_txtStat.width = m_txtLog.width = m_lstConfig.width;
			m_txtStat.height = m_txtLog.height = m_lstConfig.height;
			
			m_txtTitle.width = 
			m_txtSSNO.width = 
			m_txtSTR.width = 
			m_txtSPage.width = 
			m_txtEPage.width = 
			m_txtSaveHome.width = 
			m_lstPageZoom.width = 
			m_lstPageType.width = 
			m_txtFromPage.width = 
			m_txtToPage.width = this.actualWidth * 2 / 3;
			
			m_txtTitle.invalidate();
			m_txtSSNO.invalidate();
			m_txtSTR.invalidate();
			m_txtSPage.invalidate();
			m_txtEPage.invalidate();
			m_txtSaveHome.invalidate();
			m_lstPageZoom.invalidate();
			m_lstPageType.invalidate();
			m_txtFromPage.invalidate();
			m_txtToPage.invalidate();
		}
		
		private function historyButtonTriggered(e: Event): void
		{
			this.dispatchEventWith(SHOW_HISTORY);
		}
		
		private function backButtonTriggered(e: Event): void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}
		
		private function onTabBarChange(e: Event): void
		{
			showTab(m_tabBar.selectedIndex);
		}
		
		public function showParamsTab(): void
		{
			m_tabBar.selectedIndex = 0;
		}
		
		public function showStatTab(): void
		{
			m_tabBar.selectedIndex = 1;
		}
		
		public function showLogTab(): void
		{
			m_tabBar.selectedIndex = 2;
		}
		
		private function showTab(tabIndex: int): void
		{
			if (this.contains(m_lstConfig))
				this.removeChild(m_lstConfig);
			
			if (this.contains(m_txtStat))
				this.removeChild(m_txtStat);
			
			if (this.contains(m_txtLog))
				this.removeChild(m_txtLog);
			
			switch (m_tabBar.selectedIndex)
			{
				case 0:
					this.addChild(m_lstConfig);
					break;
				case 1:
					this.addChild(m_txtStat);
					break;
				case 2:
					this.addChild(m_txtLog);
					break;
			}
		}
	}
}