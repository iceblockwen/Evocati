package Evocati.manager
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	
	import Evocati.object.BaseObjInfo;
	import Evocati.object.Square;
	import Evocati.scene.BaseScene3D;

	public class RenderManager
	{
		private var context3D:Context3D
		private var scene:BaseScene3D
		
		public var polyNum:int;
		
		/**
		 * 单个顶点缓存和数组
		 */
		private var vertexBuffer:VertexBuffer3D;
		private var meshVertexData:Vector.<Number>;
		/**
		 * 单个顶点索引和数组
		 */
		private var indexBuffer:IndexBuffer3D;
		private var meshIndexData:Vector.<uint>;
		
		/**
		 * 全屏顶点缓存和数组
		 */
		private var wholeScreenVerticesBuffer:VertexBuffer3D;
		private var wholeScreenVerticesData:Vector.<Number>;
		
		/**
		 * 全屏顶点索引和数组
		 */
		private var wholeScreenIndexBuffer:IndexBuffer3D;
		private var wholeScreenIndexData:Vector.<uint>;
		
		/**
		 * 批处理的顶点缓存和数组
		 */
		private var batchVertexBuffer:VertexBuffer3D;
		private var batchMeshVertexData:Vector.<Number>;
		/**
		 * 批处理的顶点索引缓存和数组
		 */
		private var batchIndexBuffer:IndexBuffer3D;
		private var batchMeshIndexData:Vector.<uint>;
		/**
		 * 批处理的矩形个数
		 */
		private var batchNum:int;
		
		public function RenderManager(ctx3d:Context3D)
		{
			context3D = ctx3d;
		}
		
		public function initCommonMeshData():void
		{
			setSingleData();
			setWholeScreenData();
		}
		
		public function setScene(scene3d:BaseScene3D):void
		{
			scene = scene3d;
		}
		/**
		 * 设置混合模式
		 */
		public function setBlendmode(blendNum:int):void 
		{
			// All possible blendmodes:
			// Context3DBlendFactor.DESTINATION_ALPHA
			// Context3DBlendFactor.DESTINATION_COLOR
			// Context3DBlendFactor.ONE
			// Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA
			// Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR
			// Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA
			// Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR
			// Context3DBlendFactor.SOURCE_ALPHA
			// Context3DBlendFactor.SOURCE_COLOR
			// Context3DBlendFactor.ZERO
			switch(blendNum)
			{
				case 0:
					// the default: nice for opaque textures
					context3D.setBlendFactors(
						Context3DBlendFactor.ONE,
						Context3DBlendFactor.ZERO);
					break;
				case 1:
					// perfect for transparent textures 
					// like foliage/fences/fonts
					context3D.setBlendFactors(
						Context3DBlendFactor.SOURCE_ALPHA,
						Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
					break;
				case 2:
					// perfect to make it lighten the scene only
					// (black is not drawn)
					context3D.setBlendFactors(
						Context3DBlendFactor.SOURCE_COLOR,
						Context3DBlendFactor.ONE);
					break;
				case 3:
					// just lightens the scene - great for particles
					context3D.setBlendFactors(
						Context3DBlendFactor.ONE,
						Context3DBlendFactor.ONE);
					break;
				case 4:
					// perfect for when you want to darken only (smoke, etc)
					context3D.setBlendFactors(
						Context3DBlendFactor.DESTINATION_COLOR,
						Context3DBlendFactor.ZERO);
					break;
			}
		}
		/**
		 * 上传单一矩形数据给GPU
		 */
		protected function setSingleData():void
		{
			meshIndexData = Square.getSquareIndex();
			meshVertexData = Square.getNormalizedSquareVertex(1.0,1.0);			
			
			indexBuffer = context3D.createIndexBuffer(meshIndexData.length);
			indexBuffer.uploadFromVector(meshIndexData,0,meshIndexData.length);
			
			vertexBuffer = context3D.createVertexBuffer(meshVertexData.length/9, 9); 
			vertexBuffer.uploadFromVector(meshVertexData, 0, meshVertexData.length/9);
		}
		
		/**
		 * 上传全屏矩形数据给GPU
		 */
		protected function setWholeScreenData():void
		{
			wholeScreenIndexData = Square.getSquareIndex();
			wholeScreenVerticesData = Square.getFullScreenSquareVertex();			
			
			wholeScreenIndexBuffer = context3D.createIndexBuffer(wholeScreenIndexData.length);
			wholeScreenIndexBuffer.uploadFromVector(wholeScreenIndexData,0,wholeScreenIndexData.length);
			
			wholeScreenVerticesBuffer = context3D.createVertexBuffer(wholeScreenVerticesData.length/9, 9); 
			wholeScreenVerticesBuffer.uploadFromVector(wholeScreenVerticesData, 0, wholeScreenVerticesData.length/9);
		}
		
		/**
		 * 上传批量矩形数据给GPU
		 */
		public function setBatchData(batchId:String):Boolean
		{			
			batchMeshIndexData = Vector.<uint>([]);
			batchMeshVertexData = Vector.<Number>([]);
			
			var isEmpty:Boolean = false;
			
			var arr:Array = scene._batchObjList[batchId];
			batchNum = arr.length;
			if(batchNum <= 0) return true;
			for (var i:int = 0;i<batchNum;i++)
			{
				var obj:BaseObjInfo = arr[i] as BaseObjInfo;
				Square.addSquareIndexByNumber(batchMeshIndexData,i);
				Square.addSquareVertexPixel(batchMeshVertexData,obj);
				//				Square.addSquareVertex(
				//					batchMeshVertexData,
				//					obj.sizeX*2/_gameWidth,
				//					obj.sizeY*2/_gameHeight,    
				//					obj.getNormalizedTransformVec(_gameWidth,_gameHeight),
				//					obj.getNormalizedTextureCoodinate(_batchTextureSize)
				//				);
			}			
			if(batchMeshVertexData.length == 0) return false;
			
			if(batchIndexBuffer)
				batchIndexBuffer.dispose();
			if(batchVertexBuffer)
				batchVertexBuffer.dispose();
			batchIndexBuffer = context3D.createIndexBuffer(batchMeshIndexData.length);
			batchIndexBuffer.uploadFromVector(batchMeshIndexData,0,batchMeshIndexData.length);
			
			batchVertexBuffer = context3D.createVertexBuffer(batchMeshVertexData.length/9, 9); 
			batchVertexBuffer.uploadFromVector(batchMeshVertexData, 0, batchMeshVertexData.length/9);
			return true;
		}
		/**
		 * 画缓存中的三角形
		 */
		public function singleDraw():void
		{
			context3D.setVertexBufferAt(0, vertexBuffer, 0, 
				Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexBuffer, 3, 
				Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(2, vertexBuffer, 5, 
				Context3DVertexBufferFormat.FLOAT_4);

			context3D.drawTriangles(indexBuffer, 0, meshIndexData.length/3);
			
			polyNum += meshIndexData.length/3;
		}
		/**
		 * 画缓存中的三角形
		 */
		public function batchDraw():void
		{
			context3D.setVertexBufferAt(0, batchVertexBuffer, 0, 
				Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, batchVertexBuffer, 3, 
				Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(2, batchVertexBuffer, 5, 
				Context3DVertexBufferFormat.FLOAT_4);
			
			context3D.drawTriangles(batchIndexBuffer, 0, batchMeshIndexData.length/3);
			
			polyNum += batchMeshIndexData.length/3;
		}
		/**
		 * 画全屏
		 */
		public function wholeScreenDraw(isReset:Boolean = true):void
		{
			if(isReset)
			{
				context3D.setVertexBufferAt(0, wholeScreenVerticesBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(1, wholeScreenVerticesBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
			}
			context3D.drawTriangles(wholeScreenIndexBuffer, 0, wholeScreenIndexData.length/3);
		}
	}
}