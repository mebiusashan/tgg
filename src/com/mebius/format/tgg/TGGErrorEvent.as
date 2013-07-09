package com.mebius.format.tgg
{
	import flash.events.Event;
	
	public class TGGErrorEvent extends Event
	{
		public static const SYSTEM_IO_ERROR:String = "system_io_error_event";  //系统IO异步流错误
		public static const FILE_NOT_FOUND:String = "file_not_found_error_event";  //文件未找到错误
		public static const FILE_TYPE_ERROR:String = "file_type_error_event";  //文件类型错误
		public static const VERSION_UNRECOGNIZED_ERROR:String = "version_unrecognized_error_event";  //版本不能识别
		public static const FILE_CORRUPTION_ERROR:String = "file_corruption_error_event"; //文件损坏
		public static const DATA_NOT_FOUND:String = "data_not_found_error_event";  //指定的数据未找到
		
		public var errorInfo:String = "";
		public function TGGErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}