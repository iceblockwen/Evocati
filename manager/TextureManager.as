package Evocati.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import Evocati.gameData.CommonData;
	import Evocati.scene.BaseScene3D;
	import Evocati.textureUtils.TexturePacker;

	public class TextureManager
	{
		private var context3D:Context3D
		private var data:CommonData
		private var scene:BaseScene3D
		
		public var vramUse:int;
		
		/**
		 * 纹理列表[tex,size,vram]
		 */
		private var _textureList:Dictionary;
		
		/**
		 * 地图纹理缓存数量
		 */
		private var _mapTextureBufferNum:int = 100;
		/**
		 * 地图纹理缓存列表
		 */
		private var _mapTextureBufferArr:Array;
		/**
		 * 地图纹理列表
		 */
		private var _mapTextureList:Dictionary;
		
		/**
		 * 后处理纹理
		 */
		public var sceneTexture:Texture;
		public var blurTexture:Texture;
		public var blurTextureSec:Texture;
		
		public function TextureManager(ctx3d:Context3D,cdata:CommonData)
		{
			context3D = ctx3d;
			data = cdata;
		}
		
		public function setScene(scene3d:BaseScene3D):void
		{
			scene = scene3d;
		}
		
		public function initTexture():void
		{
			if(sceneTexture) sceneTexture.dispose();
			sceneTexture = context3D.createTexture(data.sceneTextureSize,data.sceneTextureSize,Context3DTextureFormat.BGRA, true);
			if(blurTexture) blurTexture.dispose();
			blurTexture = context3D.createTexture(data.blurTextureSize,data.blurTextureSize,Context3DTextureFormat.BGRA, true);
			if(blurTextureSec) blurTextureSec.dispose();
			blurTextureSec = context3D.createTexture(data.blurTextureSize,data.blurTextureSize,Context3DTextureFormat.BGRA, true);
			if(!_textureList)
				_textureList = new Dictionary();
			if(!_mapTextureList)
				_mapTextureList = new Dictionary();
			
			_mapTextureBufferArr = [];
		}
		
		/**
		 * 删除场景中单个纹理
		 */
		public function removeSingleTexture(id:int):void
		{
			if(_textureList[id])
			{
				_textureList[id][0].dispose();
				vramUse -= _textureList[id][1]*_textureList[id][1]*4/1024;
				delete _textureList[id];
			}
			
		}
		
		/**
		 * 删除场景中地图纹理
		 */
		public function removeMapTexture(id:String):void
		{
			if(_mapTextureBufferArr.length < _mapTextureBufferNum)
			{
				_mapTextureBufferArr.push(id);
			}
			else
			{
				var del:String = _mapTextureBufferArr.shift();
				if(_mapTextureList[del] && !scene.findTile(del))	
				{
					_mapTextureList[del][0].dispose();
					vramUse -= _mapTextureList[del][1]*_mapTextureList[del][1]*4/1024;
					delete _mapTextureList[del];
				}
			}
		}
		
		/**
		 * 清空地图纹理
		 */
		public function clearMapTexture():void
		{
			_mapTextureBufferArr.length = 0;
			for(var i:String in _mapTextureList)
			{
				var arr:Array = _mapTextureList[i] as Array;
				if(arr)
				{
					arr[0].dispose();
					vramUse -= arr[1]*arr[1]*4/1024;
					delete _mapTextureList[i];
				}
			}
		}
		
		/**
		 * 从位图数据得到纹理
		 */
		public function getTextureFromBitmapData(bitmapData:BitmapData,id:String,size:int):void
		{
			if(_textureList[id] != undefined)
			{
				_textureList[id][0].dispose();
				vramUse -= _textureList[id][1]*_textureList[id][1]*4/1024;
			}
			_textureList[id] = [];
			var cSize:Number = TexturePacker.getCompatibleSize(size);
			_textureList[id][0] = context3D.createTexture(cSize, cSize, Context3DTextureFormat.BGRA, false);
			_textureList[id][0].uploadFromBitmapData(bitmapData);
			_textureList[id][1] = cSize;
			vramUse += cSize*cSize*4/1024
		}
		/**
		 * 从字节流数据得到压缩的纹理
		 */
		public function getCompressedTextureFromByteArray(data:ByteArray,id:String,size:int,alpha:Boolean = false):void
		{
			if(_textureList[id] != undefined)
			{
				_textureList[id][0].dispose();
				if(_textureList[id][2])
					vramUse -= _textureList[id][2];
				else
					vramUse -= _textureList[id][1]*_textureList[id][1]*4/1024;
			}
			_textureList[id] = [];
			var cSize:Number = TexturePacker.getCompatibleSize(size);
			if(alpha)
				_textureList[id][0] = context3D.createTexture(cSize, cSize, Context3DTextureFormat.COMPRESSED_ALPHA, false);
			else
				_textureList[id][0] = context3D.createTexture(cSize, cSize, Context3DTextureFormat.COMPRESSED, false);
			
			_textureList[id][0].uploadCompressedTextureFromByteArray(data,0);
			_textureList[id][1] = cSize;
			vramUse += data.length/1024;
			_textureList[id][2] = vramUse;		
		}
		/**
		 * 从位图数据得到地图纹理
		 */
		public function getMapTextureFromBitmap(bitmap:Bitmap,id:String,size:int):void
		{
			if(_mapTextureList[id] != undefined)
			{
				//_mapTextureList[id].dispose();
				trace("已经有此纹理资源! id:"+id);
				return;
			}
			//			var data:Bitmap = TexturePacker.packSingleBitmapData(bitmap);
			_mapTextureList[id] = []
			var cSize:Number = TexturePacker.getCompatibleSize(size);
			_mapTextureList[id][1] = cSize;
			_mapTextureList[id][0] = context3D.createTexture(cSize, cSize, Context3DTextureFormat.BGRA, false);
			_mapTextureList[id][0].uploadFromBitmapData(bitmap.bitmapData);
			vramUse += cSize*cSize*4/1024
		}
		
		/**
		 * 设置地图纹理资源和
		 */
		public function setMapTexture(id:String,index:int):void
		{
			if( _mapTextureList[id] != undefined)
			{
				context3D.setTextureAt(index, _mapTextureList[id][0]);
				context3D.setTextureAt(1, null);
			}
		}
		/**
		 * 设置纹理资源和uv范围,偏移量(实际像素数据)
		 */
		public function setTexture(id:String,index:int):void
		{
			if( _textureList[id] != undefined)
			{
				context3D.setTextureAt(index, _textureList[id][0]);
				context3D.setTextureAt(1, null);
			}
		}
		
		public function getTextureSize(id:String):Number
		{
			return _textureList[id][1];
		}
	}
}