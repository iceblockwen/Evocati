package Evocati.particle
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import Evocati.scene.BaseScene3D;

	public class ParticleSystem
	{
		private var _poolMaxSize:int;
		private var _particlePool:Array;
		public var _particleList:Dictionary;
		
		private var _scene:BaseScene3D
		public function ParticleSystem()
		{
			_particlePool = [];
			_particleList = new Dictionary();
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
				_particlePool.push(new BaseParticle("","",0,0,0,0,0));
			}
		}
		public function addParticle(batchId:String,pos:Vector3D,maxLife:int):void
		{
			var particle:BaseParticle;
			particle = _particlePool.shift();
			if(!particle)
				particle = new BaseParticle("","",0,0,0,0,0)
			particle.respawn(batchId,pos,maxLife,0,100);
			if(batchId == "")
			{
				trace("不能为空啊batchId");
				return;
			}
			if(_particleList[batchId] == undefined)
				_particleList[batchId] = new Array();
			
			_particleList[batchId].push(particle);
		}
	}
}