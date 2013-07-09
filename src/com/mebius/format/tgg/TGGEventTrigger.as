package com.mebius.format.tgg
{
	
	public class TGGEventTrigger
	{
		private static var tgg:TGGManage;
		
		public function TGGEventTrigger(tggm:TGGManage)
		{
			tgg = tggm;
		}
		
		public static function disEvent(eventType:String, info:String):void
		{
			var evt:TGGErrorEvent = new TGGErrorEvent(eventType);
			evt.errorInfo = info + " file path:" + tgg.readFilePath;
			tgg.dispatchEvent( evt );
		}
	}
}