package com.mebius.format.tgg
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	internal class TGGNodeData
	{
		private var _voVec:Vector.<TGGNodeDataVo>;
		
		//-----read-----
		private var _treeDic:Dictionary;
		private var _valDic:Dictionary;
		private var _ids:Vector.<uint>;
		private var _parents:Dictionary;
		private var _firstNodes:Vector.<uint>;
		
		public function TGGNodeData(nodeData:Vector.<TGGNodeDataVo>=null)
		{
			init(nodeData);
		}
		
		private function init(nodeData:Vector.<TGGNodeDataVo>=null):void
		{
			this._voVec = nodeData;
			this._treeDic = new Dictionary();
			this._valDic = new Dictionary();
			this._ids = new Vector.<uint>();
			this._parents = new Dictionary();
			this._firstNodes = new Vector.<uint>();
		}
		
		public function pushData(id:uint,parent:uint,obj:Object):void
		{
			var data:TGGNodeDataVo = new TGGNodeDataVo();
			data.ID = id;
			data.parent = parent;
			data.obj = obj;
			this._voVec.push( data );
		}
		
		public function getNodeData():ByteArray
		{
			var byte:ByteArray = new ByteArray();
			
			for( var i:int = 0; i<this._voVec.length; i++ )
			{
				var data:TGGNodeDataVo = this._voVec[i];
				
				byte.writeUnsignedInt( data.ID );
				byte.writeUnsignedInt( data.parent );
				byte.writeUnsignedInt( data.dataIndex );
				
			}
			
			return byte;
		}
		
		public function readNodeData(val:ByteArray,blockNum:uint):void
		{
			val.position = 0;
			for( var i:uint=0;i<blockNum; i++ )
			{
				var id:uint = val.readUnsignedInt();
				var parent:uint = val.readUnsignedInt();
				var dataIndex:uint = val.readUnsignedInt();
				
				this._valDic[id] = dataIndex;
				this._ids.push( id );
				this._parents[id] = parent;
				
				if( id == parent )
				{
					//顶级节点，无父集
					this._firstNodes.push( id );
				}
				else
				{
					if( !this._treeDic[parent] )
					{
						this._treeDic[parent] = new Vector.<uint>();
					}
					(this._treeDic[parent] as Vector.<uint>).push(id);
				}
				
				
			}
			
		}
		
		public function getDataIndexByID(val:uint):uint
		{
			return this._valDic[val];
		}
		
		public function getChildIDByID(parentID:uint):Vector.<uint>
		{
			
			return this._treeDic[parentID] as Vector.<uint>;
		}
		
		public function getAllID():Vector.<uint>
		{
			return this._ids;
		}
		
		public function getParentByID(id:uint):uint
		{
			if( !this._parents[id] )
			{
				TGGEventTrigger.disEvent( TGGErrorEvent.DATA_NOT_FOUND,"the data not found,id:\'"+id+"\'");
			}
				
			return this._parents[id];
		}
		public function getFirstChildID():Vector.<uint>
		{
			return this._firstNodes;
		}
	}
}