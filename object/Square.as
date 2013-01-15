package Evocati.object
{
	import flash.geom.Vector3D;

	public class Square
	{

		public function Square()
		{
			
		}
		
		/** 
		 * 取得一个矩形的索引数组
		 * */
		public static function getSquareIndex():Vector.<uint>
		{
			var indexdata:Vector.<uint> = Vector.<uint> 
				([
					0, 2, 3,  0, 1, 2
				]);
			return indexdata;
		}
		
		/** 
		 * 取得一个矩形的顶点数组(归一化数据)
		 * */
		public static function getNormalizedSquareVertex(nSizeX:Number,nSizeY:Number):Vector.<Number>
		{
			var vertexData:Vector.<Number> = Vector.<Number> 
				( [
					//X,  Y,  Z,          U, V,       r,  g,  b,  a
					0, 0,  0,             0, 0,     1.0,  1.0,  1.0,  1.0,
					nSizeX, 0,  0,         1, 0,     1.0,  1.0,  1.0,  1.0,
					nSizeX, -nSizeY, 0,     1, 1,     1.0,  1.0,  1.0,  1.0,
					0,   -nSizeY,  0,      0, 1,     1.0,  1.0,  1.0,  1.0
				]);
			return vertexData;
		}
		/** 
		 * 取得一个全屏矩形的顶点数组(归一化数据)
		 * */
		public static function getFullScreenSquareVertex():Vector.<Number>
		{
			var vertexData:Vector.<Number> = Vector.<Number> 
				( [
					//X,  Y,  Z,     U, V,       r,  g,  b,  a
					-1, 1,  0,      0, 0,     1.0,  1.0,  1.0,  1.0,
					1, 1,  0,      1, 0,     1.0,  1.0,  1.0,  1.0,
					1, -1, 0,     1, 1,     1.0,  1.0,  1.0,  1.0,
				-1, -1,  0,      0, 1,     1.0,  1.0,  1.0,  1.0
				]);
			return vertexData;
		}
		
		public static function addSquareIndexByNumber(vector:Vector.<uint>, n:int):void
		{
			var index:int = vector.length;
			vector[index++] = 0+4*n;
			vector[index++] = 2+4*n;
			vector[index++] = 3+4*n;
			vector[index++] = 0+4*n;
			vector[index++] = 1+4*n;
			vector[index++] = 2+4*n;
		}
		
		/** 
		 * 批处理一个矩形的顶点数组(归一化数据)
		 * */
		public static function addSquareVertex(vector:Vector.<Number>,nSizeX:Number,nSizeY:Number,nTransform:Vector3D,nUVoffset:Vector3D):void
		{
			var index:int = vector.length;
			
			/**p1*/
			//pos
			vector[index++] = nTransform.x;
			vector[index++] = nTransform.y;
			vector[index++] = nTransform.z;
			//uv
			vector[index++] = nUVoffset.x;
			vector[index++] = nUVoffset.y;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
			/**p2*/
			//pos
			vector[index++] = nSizeX+nTransform.x;
			vector[index++] = nTransform.y;
			vector[index++] = nTransform.z;
			//uv
			vector[index++] = nUVoffset.x + nUVoffset.z;
			vector[index++] = nUVoffset.y;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
			/**p3*/
			//pos
			vector[index++] = nSizeX+nTransform.x;
			vector[index++] = -nSizeY+nTransform.y;
			vector[index++] = nTransform.z;
			//uv
			vector[index++] = nUVoffset.x+ nUVoffset.z;
			vector[index++] = nUVoffset.y+ nUVoffset.w;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
			/**p4*/
			//pos
			vector[index++] = nTransform.x;
			vector[index++] = -nSizeY+nTransform.y;
			vector[index++] = nTransform.z;
			//uv
			vector[index++] = nUVoffset.x;
			vector[index++] = nUVoffset.y + nUVoffset.w;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;

		}
		
		/** 
		 * 批处理一个矩形的顶点数组(像素数据,Shader做归一化运算,略微提高性能)
		 * */
		public static function addSquareVertexPixel(vector:Vector.<Number>,obj:BaseObjInfo):void
		{
			var index:int = vector.length;
			var xoffset:int;
			var yoffset:int;
			if(obj.textureCoordinates)
			{
				xoffset = obj.textureCoordinates[obj.textureIndex].xOffset
				yoffset = obj.textureCoordinates[obj.textureIndex].yOffset
			}
			var texWidth:int = obj.sizeX
			var texHeight:int = obj.sizeY
			var px:int = obj.x;
			var py:int = obj.y;
			var pz:int = obj.z;
			/**p1*/
			//pos
			vector[index++] = px;
			vector[index++] = py;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset;
			vector[index++] = yoffset;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
			/**p2*/
			//pos
			vector[index++] = texWidth+px;
			vector[index++] = py;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset + texWidth;
			vector[index++] = yoffset;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
			/**p3*/
			//pos
			vector[index++] = texWidth + px;
			vector[index++] = -texHeight + py;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset+ texWidth;
			vector[index++] = yoffset+ texHeight;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
			/**p4*/
			//pos
			vector[index++] = px;
			vector[index++] = -texHeight+py;
			vector[index++] = pz;
			//uv
			vector[index++] = xoffset;
			vector[index++] = yoffset + texHeight;
			//color
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			vector[index++] = 1;
			
		}
		
	}
}