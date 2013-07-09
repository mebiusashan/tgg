package com.mebius.format.tgg
{
	import flash.utils.ByteArray;

	internal class TGGHeader
	{
		private var _vo:TGGHeaderVo;
		
		public function TGGHeader()
		{
			this._vo = new TGGHeaderVo();
		}
		
		public function get headerData():ByteArray
		{
			var byte:ByteArray = new ByteArray();
			
			byte.writeUnsignedInt( this._vo.fileType );
			byte.writeShort( this._vo.fileVerison );
			
			byte.writeShort( this._vo.indexDataType );
			byte.writeUnsignedInt( this._vo.indexDataPos );
			byte.writeUnsignedInt( this._vo.indexDataNumBlock );
			
			byte.writeShort( this._vo.userDataType );
			byte.writeUnsignedInt( this._vo.userDataIndexPos );
			
			return byte;
		}
		
		public function readHeaderData( val:ByteArray ):void
		{
			val.position = 0;
			var filetype:uint = val.readUnsignedInt();
			
			if( filetype != this._vo.fileType )
			{
				TGGEventTrigger.disEvent( TGGErrorEvent.FILE_TYPE_ERROR,"file is not tgg format.");
			}
			else
			{
				var version:uint = val.readShort();
				if( version == this._vo.fileVerison )
				{
					var type:int = val.readShort();
					var indexpos:uint = val.readUnsignedInt();
					this._vo.indexDataNumBlock = val.readUnsignedInt();
					
					type = val.readShort();
					this._vo.userDataIndexPos = val.readUnsignedInt();
				}
				else
				{
					TGGEventTrigger.disEvent( TGGErrorEvent.VERSION_UNRECOGNIZED_ERROR,"the tgg file version is error.");
				}
				
			}
			
			
		}
		
		
		
		//--------------------------------------------------------
		
		public function setIndexDataNumBlock(val:uint):void
		{
			this._vo.indexDataNumBlock = val;
		}
		
		public function setUserDataPos(val:uint):void
		{
			this._vo.userDataIndexPos = val;
		}
		
		public function getIndexDataNumBlock():uint
		{
			return this._vo.indexDataNumBlock;
		}
		
		public function getUserDataPos():uint
		{
			return this._vo.userDataIndexPos ;
		}
		
	}
}