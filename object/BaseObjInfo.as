package Evocati.object
{
	import Evocati.Interface.IObj3D;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	/**
	 * 场景物件数据(具体像素值数据)
	 */
	public class BaseObjInfo implements IObj3D
	{
		public var id:String;
		public var sizeX:Number;
		public var sizeY:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var originX:Number;
		public var originY:Number;
		public var originZ:Number;
		public var rx:Number;
		public var ry:Number;
		public var rz:Number;
		
		public var textureCoordinates:Array;
		public var textureIndex:int;
		public var textureId:String;
		
		/**
		 * 物件id，纹理id，x方向大小，y方向大小，x坐标，y坐标，z坐标，纹理位置数组，x旋转，y旋转，z旋转，x缩放，y缩放
		 * （实际像素数据）
		 */
		public function BaseObjInfo(pId:String,pTextureId:String,pSizeX:Number,pSizeY:Number,pX:Number,pY:Number,pZ:Number,pTextureCoordinates:Array = null,prx:Number = 0,pry:Number = 0,prz:Number = 0,nScaleX:Number = 1,nScaleY:Number = 1)
		{
			id = pId;
			textureId = pTextureId;
			sizeX = pSizeX;
			sizeY = pSizeY;
			scaleX = nScaleX;
			scaleY = nScaleY;
			x = pX;
			y = -pY;    //stage3D Y坐标是反的
			z = pZ;
			originX = pX;
			originY = -pY;
			originZ = pZ;
			rx = prx;
			ry = pry;
			rz = prz;
			textureCoordinates = pTextureCoordinates;
			textureIndex = 0;
		}
		public function move(mx:Number, my:Number ,mz:Number):void
		{
			originX = mx;
			originY = -my;  //stage3D Y坐标是反的
			updateActurePosition();
		}
		public function rotate(xx:Number, xy:Number,xz:Number):void
		{
			rx = xx;
			ry = xy;
			rz = xz;
		}
		
		public function setPosition(x:Number, y:Number ,z:Number):void
		{
			originX = x;
			originY = y;  
			originZ = z;  
			updateActurePosition();
		}
				
		public function setFrame(i:int):void
		{
			textureIndex = i;
			if(textureCoordinates && textureCoordinates[i])
			{
				sizeX = textureCoordinates[i].bound.width;
				sizeY = textureCoordinates[i].bound.height;
			}
			updateActurePosition();
		}
		
		private function updateActurePosition():void
		{
			//			var i:int = _hFlip?-1:1;
			var i:Number = 1;
			if(!textureCoordinates || textureCoordinates[textureIndex] == null)
			{	
				x = originX
				y = originY	
			}
			else
			{
				var _offsetX:Number = textureCoordinates[textureIndex].bound.x;
				var _offsetY:Number = textureCoordinates[textureIndex].bound.y;
				x = originX + i * (_offsetX);
				y = originY - _offsetY;
			}
		}
		
		
		public function getRotationVec():Vector3D
		{
			return new Vector3D(rx,ry,rz);
		}
		
		/**
		 * 取得当前纹理的归一化uv
		 */
		public function getNormalizedTextureCoodinate(textureSize:Number):Vector3D
		{
			if(textureCoordinates == null)
				return new Vector3D(0,0,1,1);
			else
				return new Vector3D(
					textureCoordinates[textureIndex].xOffset/textureSize,
					textureCoordinates[textureIndex].yOffset/textureSize,
					sizeX/textureSize*textureCoordinates[textureIndex].scaleX,
					sizeY/textureSize*textureCoordinates[textureIndex].scaleY
				);
		}
		/**
		 * 取得归一化的空间坐标
		 */
		public function getNormalizedTransformVec(gsizeX:Number,gsizeY:Number):Vector3D
		{
			return new Vector3D(x*2/gsizeX,y*2/gsizeY,z);
		}
	}
}