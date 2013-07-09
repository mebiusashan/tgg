package com.mebius.format.tgg
{
	import flash.utils.ByteArray;

	internal class TGGFormatData
	{
		private var _voVec:Vector.<TGGNodeDataVo>;
		private var _byteData:ByteArray;
		
		public function TGGFormatData(nodeData:Vector.<TGGNodeDataVo>=null)
		{
			init(nodeData);
		}
		
		private function init(nodeData:Vector.<TGGNodeDataVo>=null):void
		{
			this._voVec = nodeData;
			this._byteData = new ByteArray();
		}
		
		/**
		 * 添加一组数据。并且返回数据的下标 
		 * @param index 数组中数据的下标
		 * @return      数据在数据段中的起始下标
		 * 
		 */		
		public function createByteDataAll():void
		{
			var l:uint = this._voVec.length;
			for( var index:int = 0;index<l; index++ )
			{
				var startPos:uint = this._byteData.length;
				var data:TGGNodeDataVo = this._voVec[index];
				var byte:ByteArray = new ByteArray();
				
				//写入KEY 和 VALUE
				for( var i:String in data.obj )
				{
					byte.writeUTFBytes( i+":" );
					byte.writeUTFBytes( data.obj[i]+";" );
					
				}
				var length:uint = byte.length;
				
				this._byteData.writeUnsignedInt( length );
				this._byteData.writeBytes( byte );
				
				data.dataIndex = startPos;
			}
			
		}
		
		public function getByteData():ByteArray
		{
			return this._byteData;
		}
	}
}