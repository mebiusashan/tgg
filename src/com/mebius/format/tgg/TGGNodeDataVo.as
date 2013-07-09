package com.mebius.format.tgg
{
	internal class TGGNodeDataVo
	{
		private var _ID:uint = 0;
		private var _parent:uint = 0;
		private var _dataIndex:uint = 0;
		private var _obj:Object = null;

		public function get ID():uint
		{
			return _ID;
		}

		public function set ID(value:uint):void
		{
			_ID = value;
		}

		public function get parent():uint
		{
			return _parent;
		}

		public function set parent(value:uint):void
		{
			_parent = value;
		}

		public function get dataIndex():uint
		{
			return _dataIndex;
		}

		public function set dataIndex(value:uint):void
		{
			_dataIndex = value;
		}

		public function get obj():Object
		{
			return _obj;
		}

		public function set obj(value:Object):void
		{
			_obj = value;
		}


	}
}