package Evocati.particle
{
	import flash.geom.Vector3D;
	
	import Evocati.Interface.IObj3D;

	public class ParticleEmitter implements IObj3D
	{
		public var posX:Number;
		public var posY:Number;
		public var posZ:Number;
		public var velocity:Vector3D;
		public var maxLife:Number;
		public var sizeX:int;
		public var sizeY:int;
		public var texSize:int;
		public var speed:Number;
		public var rate:int;   // n/s
		public var toggle:Boolean =true;
		public var batchId:String;
		
		private var _manager:ParticleSystem;
		private var _timeAdd:Number;
		public function ParticleEmitter(manager:ParticleSystem)
		{
			_manager = manager;
			_timeAdd = 0;
		}
		public function step(time:Number):void
		{
			if(toggle)
			{
				_timeAdd += rate*time;
				if(_timeAdd > 1)
				{
					var i:int = _timeAdd;
					_timeAdd = _timeAdd-i;
					while(i--)
					{
						if(_manager)
						{
							_manager.addParticle(batchId,new Vector3D(posX,posY,posZ),velocity,maxLife,sizeX,sizeY,texSize);
						}
					}
				}
			}
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