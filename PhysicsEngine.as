package Evocati
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import Evocati.object.BaseRigidBody;
	import Evocati.scene.QuadTree;
	import Evocati.scene.QuadTreeNode;

	public class PhysicsEngine
	{
		public var gravity:Number;
		public var bodyTree:QuadTree;
		public var ready:Boolean;
		public static var instance:PhysicsEngine;
		public function PhysicsEngine()
		{
		}
		public function initScene(width:int,height:int,depth:int = 2):void
		{
			bodyTree = new QuadTree();
			bodyTree.build(depth,new Rectangle(0,0,width,height));
			ready = true;
		}
		public static function getInstance():PhysicsEngine
		{
			if(!instance) instance = new PhysicsEngine();
			return instance;
		}
		public function addRigidBody(body:BaseRigidBody):void
		{
			if(bodyTree)
				bodyTree.insertObject(body,body.pos);
		}
		public function update(time:int):void
		{
			var dtime:int = getTimer();
			for each(var arr:Array in bodyTree.objMap)
			{
				var body:BaseRigidBody = arr[1] as BaseRigidBody;
				body.moveBy(time*body.velocity.x,time*body.velocity.y);
			}
			var leaf:Array = bodyTree.leafArray;
			var len:int = arr.length;
			var i:int = -1;
			while(++i<len)
			{
				checkAround(leaf[i]);
			}
			i = -1;
			while(++i<len)
			{
				reInsert(leaf[i]);
			}
			
			trace(getTimer() - dtime);
		}
		public function checkAround(node:QuadTreeNode):void
		{
			var arr:Array = [];
			var data:Dictionary = node.data;
			for each(var tmp:BaseRigidBody in data)
			{
				if(tmp)
					arr.push(tmp);
			}
			var len:int = arr.length;
			for(var i:int = 0; i < len; i++)
			{
				for(var j:int = i+1;j <len;j++)
				{
					var a:BaseRigidBody = arr[i] as BaseRigidBody;
					var b:BaseRigidBody = arr[j] as BaseRigidBody;
					if(a.testRect(b.rect))
					{
						a.velocity.x+=0.01*Math.random();
						a.velocity.y+=0.01*Math.random();
						b.velocity.x+=0.01*Math.random();
						b.velocity.y+=0.01*Math.random();
					}
				}
			}
		}
		public function reInsert(node:QuadTreeNode):void
		{
			var arr:Array = [];
			var data:Dictionary = node.data;
			for each(var tmp:BaseRigidBody in data)
			{
				if(tmp)
					arr.push(tmp);
			}
			for each(var k:BaseRigidBody in arr)
			{
				if(node.rect.containsPoint(k.pos) == false)
				{
					data[k.id] = null;
					bodyTree.insertObject(k,k.pos);
				}
			}
		}
	}
}