package Evocati.scene
{
	import Evocati.object.BaseObjInfo;
	import Evocati.object.GroupObjInfo;
	
	import flash.utils.Dictionary;

	public class BaseScene3D
	{
		public var _singleObjList:Array;
		public var _batchObjList:Dictionary;
		public var _totalList:Dictionary;
		public var _mapTileList:Dictionary;
		public var _groupObjList:Dictionary;
		public function BaseScene3D()
		{
			_singleObjList = [];
			_groupObjList = new Dictionary();
			_batchObjList = new Dictionary();
			_totalList = new Dictionary();
			_mapTileList = new Dictionary();
		}
		public function findObjById(id:String):Array
		{
			if(_totalList[id]!=undefined)
				return _totalList[id];
			else 
				return null;
		}
		public function addSingleObj(info:BaseObjInfo):void
		{
			_singleObjList.push(info);
			if(_totalList[info.id] != undefined)
				trace("已经有此id");
			else
				_totalList[info.id] = [info,""];
		}
		
		public function removeOneObj(id:String):void
		{
			if(_totalList[id] != undefined)
			{
				var arr:Array = _totalList[id];
				var info:BaseObjInfo = arr[0];
				if(arr[1] == "")
				{
					_singleObjList.splice(_singleObjList.indexOf(info),1);
				}
				else
				{
					var list:Array = _batchObjList[arr[1]];
					list.splice(list.indexOf(info),1);
					if(list.length == 0)
						delete  _batchObjList[arr[1]];
				}
				delete _totalList[id];
			}
			else
			{
				trace("无法删除id:"+id+"找不到此id");
			}
			
		}
		
		public function removeGroupObj(id:String):void
		{
			if(_groupObjList[id] != undefined)
			{
				for each(var child:Array in _groupObjList[id].childObjsInfo)
				{
					removeOneObj(child[0].id);
				}
				delete _groupObjList[id];
			}
		}
		
		public function addMapTile(info:BaseObjInfo):void
		{
			if(_mapTileList[info.id] != undefined)
				trace("已经有此id地图块"+info.id);
			else
				_mapTileList[info.id] = info;
		}
		
		public function findTile(id:String):BaseObjInfo
		{
			if(_mapTileList[id] != undefined)
				return _mapTileList[id];
			else
				return null;
		}		
		public function removeMapTile(id:String):void
		{
			if(_mapTileList[id] != undefined)
			{
			   	delete _mapTileList[id];
			}
			else
				trace("无法删除地图切片id:"+id+"找不到此id");
		}
		
		public function addGroupObj(info:GroupObjInfo):Boolean
		{
			for each(var child:Array in info.childObjsInfo)
			{
				addBatchObj(child[0],child[0].textureId);
			}
			_groupObjList[info.id] = info;
			return false;
		}
		
		public function addBatchObj(info:BaseObjInfo,batchId:String):Boolean
		{
			if(batchId == "")
			{
				trace("不能为空啊batchId");
				return false;
			}
			if(_batchObjList[batchId] == undefined)
				_batchObjList[batchId] = new Array();
			_batchObjList[batchId].push(info);
			
			if(_totalList[info.id] != undefined)
			{
				trace("已经有此id:"+info.id);
				return false;
			}
			else
				_totalList[info.id] = [info,batchId];
			
			return true;
		}
		
		public function moveObjById(id:String,x:Number,y:Number):void
		{
			if(_totalList[id] != undefined)
			{
				var arr:Array = _totalList[id] as Array;
				(arr[0] as BaseObjInfo).move(x,y,0);
			}
			else
				trace("找不到id:"+id);
		}
		
		public function rotateObjById(id:String,x:Number,y:Number,z:Number):void
		{
			if(_totalList[id] != undefined)
			{
				var arr:Array = _totalList[id] as Array;
				(arr[0] as BaseObjInfo).rotate(x,y,z);
			}
			else
				trace("找不到id:"+id);
		}
		
		public function isObjInBatch(id:String ,batchId:String):Boolean
		{
			if(_totalList[id] != undefined && _totalList[id][1] == batchId)
				return true;
			else
				return false;
		}
	}
}