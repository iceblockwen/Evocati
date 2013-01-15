package Evocati.tool
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class StatisticsTool extends Sprite
	{
//		public var 
			
		public var _batchUpLoadTimeText:TextField
		public var _totlePolyText:TextField;
		public var _vramUseText:TextField;
		public var _3dAPI:TextField;
		public function StatisticsTool()
		{
			initView();
		}
		
		private function initView():void
		{
			_batchUpLoadTimeText = getText();
			_totlePolyText = getText();
			_vramUseText = getText();
			_3dAPI = getText();
			
			addChild(_3dAPI);
			_3dAPI.y = 0;
			addChild(_batchUpLoadTimeText);
			_batchUpLoadTimeText.y = 30;
			addChild(_totlePolyText);
			_totlePolyText.y = 60;
			addChild(_vramUseText);
			_vramUseText.y = 90;
		}
		
		private function getText():TextField
		{
			var tf:TextField = new TextField();
			tf.textColor = 0xffffff;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.filters = [new GlowFilter(0x000000,1,2,2,500)];
			return tf;
		}
	}
}