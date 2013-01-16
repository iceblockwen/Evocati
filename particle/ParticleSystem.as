package Evocati.particle
{
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import Evocati.scene.BaseScene3D;
	import Evocati.textureUtils.TextureCoodinate;

	public class ParticleSystem
	{
		private var _poolMaxSize:int;
		private var _particlePool:Array;
		public var _particleBatchList:Dictionary;
		
		private var _scene:BaseScene3D
		public function ParticleSystem()
		{
			_particlePool = [];
			_particleBatchList = new Dictionary();
		}
		public function setScene(scene3d:BaseScene3D):void
		{
			_scene = scene3d;
		}
		public function generatePoolObjs():void
		{
			var n:int = 500;
			while(n--)
			{
				_particlePool.push(new BaseParticle("0","0",256,256,0,0,0));
			}
		}
		public function addParticle(batchId:String,pos:Vector3D,speed:Vector3D,maxLife:int,size:int):void
		{
			var particle:BaseParticle;
			particle = _particlePool.shift();
			if(!particle)
				particle = new BaseParticle("0","0",size,size,0,0,0);
			particle.respawn(batchId,pos,speed,maxLife,0,100,size);
			particle.textureCoordinates = [new TextureCoodinate(0,0,1,1,new Rectangle(0,0,size,size),size)];
			if(batchId == "")
			{
				trace("不能为空啊batchId");
				return;
			}
			if(_particleBatchList[batchId] == undefined)
				_particleBatchList[batchId] = new Array();
			
			_particleBatchList[batchId].push(particle);
		}
		
		public function update(batchId:String,time:uint):void
		{
			var arr:Array = _particleBatchList[batchId];
			for each(var i:BaseParticle in arr)
			{
				i.step(time);
				if(i.active == false)
				{	
					arr.splice(arr.indexOf(i));
					_particlePool.push(i);
				}
			}
		}
	}
}