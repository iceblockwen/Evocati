package Evocati.particle
{
	import Evocati.Interface.IObj3D;

	public class ParticleLink implements IObj3D
	{
		public var posX:Number;
		public var posY:Number;
		public var posZ:Number;
		public var texId:String;
		
		public var nodeNum:int;
		
		public var vertexArray:Array;
		public function ParticleLink()
		{
			vertexArray = [];
		}
		public function step(time:Number):void
		{
			getTwoVectex();
			for each(var arr:Array in vertexArray)
			{
				arr[3] += time; 
			}
		}
		
		private function getTwoVectex():void
		{
			nodeNum++;
			vertexArray.push([posX-10,posY-10,posZ,0,0]);
			vertexArray.push([posX+10,posY+10,posZ,0,0]);
		}
		public function move(x:Number,y:Number,z:Number):void
		{
			posX = x;
			posY = y   //在shader里反向了
			posZ = z;
		}
		
		public function moveBy(x:Number,y:Number,z:Number):void
		{
			posX += x;
			posY += -y;
			posZ += z;
		}
		public function rotate(x:Number,y:Number,z:Number):void
		{
			
		}
	}
	
	
}