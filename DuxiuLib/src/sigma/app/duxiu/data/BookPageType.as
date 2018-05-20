package sigma.app.duxiu.data
{
	public class BookPageType
	{
		public var typeName: String;
		public var originSymbol: String;
		public var orderSymbol: String;
		public var maxNo: Number;
		
		public function BookPageType(typeName: String, originSymbol: String, orderSymbol: String, maxNo: Number)
		{
			this.typeName = typeName;
			this.originSymbol = originSymbol;
			this.orderSymbol = orderSymbol;
			this.maxNo = maxNo;
		}
	}
}