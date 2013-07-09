package com.mebius.format.tgg
{
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	
	public class TGGManage extends EventDispatcher
	{
		private var _header:TGGHeader;
		private var _nodeData:TGGNodeData;
		private var _formtaData:TGGFormatData;
		private var _nodeDataVoVec:Vector.<TGGNodeDataVo>;
		private var _filePath:String;
		private var _eventTrigger:TGGEventTrigger;
		
		//------read-------
		private var stream:FileStream ;
		
		
		public function TGGManage()
		{
			init();
		}
		
		private function init():void
		{
			_eventTrigger = new TGGEventTrigger(this);
			this._header = new TGGHeader();
			this._nodeDataVoVec = new Vector.<TGGNodeDataVo>();
			this._formtaData = new TGGFormatData(this._nodeDataVoVec);
			this._nodeData = new TGGNodeData(this._nodeDataVoVec);
		}
		
		public function addData(id:uint,parent:uint,data:Object):void
		{
			this._nodeData.pushData(id, parent,data );
			
		}
		
		public function createTGG():ByteArray
		{
			var byte:ByteArray = new ByteArray();
			this._header.setIndexDataNumBlock( this._nodeDataVoVec.length );
			this._formtaData.createByteDataAll();
			this._nodeData.getNodeData()
			this._header.setUserDataPos( 22+this._nodeData.getNodeData().length );
			
			byte.writeBytes( this._header.headerData );
			byte.writeBytes( this._nodeData.getNodeData() );
			byte.writeBytes( this._formtaData.getByteData() );
			
			return byte;
		}
		
		/**
		 * 读取文件 
		 * @param filePath
		 * 
		 */		
		public function readTGG(filePath:String):void
		{
			_filePath = filePath;
			var file:File = new File(filePath);
			if( !file.exists )
			{
				TGGEventTrigger.disEvent( TGGErrorEvent.FILE_NOT_FOUND,"the file tgg format not found.");
			}
			else
			{
				try
				{
					stream = new FileStream();
					stream.open( file, FileMode.READ );
					
					stream.position = 0;
					var header:ByteArray = new ByteArray();
					stream.readBytes( header,0,22);
					this._header.readHeaderData( header );
					
					stream.position = 22;
					var indexdata:ByteArray = new ByteArray();
					var length:uint = this._header.getUserDataPos() - 22;
					stream.readBytes( indexdata, 0, length );
					this._nodeData.readNodeData( indexdata, this._header.getIndexDataNumBlock() );
				}
				catch(e:Error)
				{
					TGGEventTrigger.disEvent( TGGErrorEvent.FILE_CORRUPTION_ERROR,"the tgg file is error");
				}
			}
			
		}
		
		/**
		 * 根据ID和KEY来获取对应的value值 
		 * @param id
		 * @param key
		 * @return 
		 * 
		 */		
		public function getValueByIDAndKey(id:uint,key:String):String
		{
			var str:String = "";
			
			var pos:uint = this._nodeData.getDataIndexByID( id );
			this.stream.position = this._header.getUserDataPos() + pos;
			var byte:ByteArray = new ByteArray();
			var length:uint = this.stream.readUnsignedInt();
			stream.readBytes( byte,0 , length );
			var strs:String = byte.readUTFBytes(byte.bytesAvailable);
			var exp:RegExp = new RegExp(key+".+?;","s");
			
			var arr:Array = strs.match( exp );
			try
			{
				str = (arr[0] as String).substring( key.length+1,(arr[0] as String).length-1);;
				return str;
			}
			catch(e:Error)
			{
				TGGEventTrigger.disEvent( TGGErrorEvent.DATA_NOT_FOUND,"the data not found,id:\'"+id+"\' key:\'"+key+"\'.");
			}
			
			
			return null;
			
		}
		
		/**
		 * 返回对应ID的子集ID，如果不存在子集，则返回NULL 
		 * @param parentID
		 * @return 
		 * 
		 */		
		public function getChildIDByID(parentID:uint):Vector.<uint>
		{
			var data:Vector.<uint> = this._nodeData.getChildIDByID( parentID );
	//		trace(data);
			if( data == null )
			{
				TGGEventTrigger.disEvent( TGGErrorEvent.DATA_NOT_FOUND,"the data not found,id:\'"+parentID+"\'");
			}
			
			return data;
		}
		
		/**
		 * 获取顶级的节点 
		 * @return 
		 * 
		 */		
		public function getFirstChildID():Vector.<uint>
		{
			
			return this._nodeData.getFirstChildID();
		}
		
		/**
		 * 通过ID获取对应的数据 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getDataByID(id:uint):Object
		{
			var obj:Object = new Object();
			
			var pos:uint = this._nodeData.getDataIndexByID( id );
			this.stream.position = this._header.getUserDataPos() + pos;
			var byte:ByteArray = new ByteArray();
			var length:uint = this.stream.readUnsignedInt();
			stream.readBytes( byte,0 , length );
			var strs:String = byte.readUTFBytes(byte.bytesAvailable);
	//		trace(strs);
			var arr:Array = strs.split(";");
			var l:uint = arr.length;
			for( var i:int = i;i<l;i++ )
			{
				var ar:Array = String(arr[i]).split(":");
				obj[ar[0]] = ar[1];
			}
			
			return obj;
			
		}
		
		/**
		 * 获取所有ID 
		 * @return 
		 * 
		 */		
		public function getAllID():Vector.<uint>
		{
			return this._nodeData.getAllID();
		}
		
		/**
		 * 获取对应ID的父集 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getParentByID(id:uint):uint
		{
			
			return this._nodeData.getParentByID(id);
		}
		
		public function get readFilePath():String
		{
			return this._filePath;
		}
	}
}