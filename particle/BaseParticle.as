package Evocati.particle
{
	import flash.geom.Vector3D;
	
	import Evocati.object.BaseObjInfo;

	public class BaseParticle extends BaseObjInfo
	{
		public var active:Boolean = true;
		public var life:Number = 0;
		public var lifeMax:Number = 1000;
		public var stepCounter:uint = 0;
		public var speed:Vector3D = new Vector3D();
		
		public var lifeScale:Vector.<Number> = new Vector.<Number>([1, 0, 1, 1]);
		public var rgbaScale:Vector.<Number> = new Vector.<Number>([1, 1, 1, 1]);
		private var startSize:Number = 0;
		private var endSize:Number = 1;
		
		private static var twoPi:Number = 2*Math.PI;
		
		public function BaseParticle(pId:String,pTextureId:String,pSizeX:Number,pSizeY:Number,pX:Number,pY:Number,pZ:Number,pTextureCoordinates:Array = null,prx:Number = 0,pry:Number = 0,prz:Number = 0,nScaleX:Number = 1,nScaleY:Number = 1)
		{
			super(pId,pTextureId,pSizeX,pSizeY,pX,pY,pZ,pTextureCoordinates,prx,pry,prz,nScaleX,nScaleY);
		}
		
		public function cloneParticle():BaseParticle
		{
			var clone:BaseParticle = new BaseParticle(id,textureId,sizeX,sizeY,originX,originY,originZ);
			return clone;
		}
		
		// returns a float from -amp to +amp in wobbles per second
		private static function wobble(ms:Number = 0, amp:Number = 1, spd:Number = 1):Number
		{
			var val:Number;
			val = amp*Math.sin((ms/1000)*spd*twoPi);
			return val;
		}
		// returns a float that oscillates from 0..1..0 each second
		private static function wobble010(ms:Number):Number
		{
			var retval:Number;
			retval = wobble(ms-250, 0.5, 1.0) + 0.5;
			return retval;
		}
		
		public function step(ms:Number):void
		{
			stepCounter++;
			life += ms;
			if (life >= lifeMax)
			{
				//trace("Particle died (" + life + "ms)");
				active = false;
				return;
			}
			// based on life, change the scale for starting pos (1..0)
			lifeScale[0] = 1 - (life / lifeMax);
			// based on life, change the scale for ending pos (0..1)
			lifeScale[1] = life / lifeMax;
			// based on life: go from 0..1..0
			lifeScale[2] = wobble010(life);
			// ensure it is within the valid range
			if (lifeScale[0] < 0) lifeScale[0] = 0;
			if (lifeScale[0] > 1) lifeScale[0] = 1;
			if (lifeScale[1] < 0) lifeScale[1] = 0;
			if (lifeScale[1] > 1) lifeScale[1] = 1;
			if (lifeScale[2] < 0) lifeScale[2] = 0;
			if (lifeScale[2] > 1) lifeScale[2] = 1;
			// fade alpha in and out
			rgbaScale[0] = lifeScale[0];
			rgbaScale[1] = lifeScale[0];
			rgbaScale[2] = lifeScale[0];
			rgbaScale[3] = lifeScale[2];
		}
		
		public function respawn(batchId:String,pos:Vector3D, pspeed:Vector3D, maxlife:Number = 1000,scale1:Number = 0, scale2:Number = 50,size:Number = 0):void
		{
			textureId = batchId;
			sizeX = sizeY = size;
			life = 0;
			speed = pspeed;
			stepCounter = 0;
			lifeMax = maxlife;
			move(pos.x,pos.y,pos.z);
			lifeScale[0] = 1;
			lifeScale[1] = 0;
			lifeScale[2] = 0;
			lifeScale[3] = 1;
			rgbaScale[0] = 1;
			rgbaScale[1] = 1;
			rgbaScale[2] = 1;
			rgbaScale[3] = 1;
			startSize = scale1;
			endSize = scale2;
			active = true;
		}
	}
}