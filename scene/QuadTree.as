package Evocati.scene
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import Evocati.object.BaseRigidBody;

	public class QuadTree
	{
		private var _depth:int
		private var _root:QuadTreeNode;
		public var objMap:Dictionary;
		public var leafArray:Array;
		public function QuadTree()
		{
			objMap = new Dictionary();
			leafArray = [];
		}
		
		public function build(depth:int,rect:Rectangle):void
		{
			_depth = depth;
			/*创建分支，root树的根，depth深度，rect根节点代表的矩形区域*/
			if(!_root) _root = new QuadTreeNode(depth == 1);
			_root.rect = rect;
			createBranch (_root, depth);
		}
		public function createBranch(node:QuadTreeNode,depth:int):void
		{
			if ( depth!=1 )
			{
				node.UR = new QuadTreeNode((depth-1) == 1);
				node.UL = new QuadTreeNode((depth-1) == 1);
				node.LL = new QuadTreeNode((depth-1) == 1);
				node.LR = new QuadTreeNode((depth-1) == 1);
				if((depth-1) == 1)
				{
					leafArray.push(node.UR);
					leafArray.push(node.UL);
					leafArray.push(node.LL);
					leafArray.push(node.LR);
				}
				//将rect划成四份 rect[UR], rect[UL], rect[LL], rect[LR];
				var arr:Array = sliceRect(node.rect);
				node.UR.rect = arr[0]; 
				node.UL.rect = arr[1]; 
				node.LL.rect = arr[2]; 
				node.LR.rect = arr[3];
				/*创建各孩子分支*/
				createBranch( node.UR, depth-1);
				createBranch( node.UL, depth-1);
				createBranch( node.LL, depth-1);
				createBranch( node.LR, depth-1);
			}
		}
		private function sliceRect(rect:Rectangle):Array
		{
			var halfWidth:int = rect.width/2;
			var halfHeight:int = rect.height/2;
			var UR:Rectangle = new Rectangle(rect.x+halfWidth,rect.y,halfWidth,halfHeight);
			var UL:Rectangle = new Rectangle(rect.x,rect.y,halfWidth,halfHeight);
			var LL:Rectangle = new Rectangle(rect.x,rect.y+halfHeight,halfWidth,halfHeight);
			var LR:Rectangle = new Rectangle(rect.x+halfWidth,rect.y+halfHeight,halfWidth,halfHeight);
			return [UR,UL,LL,LR];
		}
		public function insertObject(obj:BaseRigidBody,pos:Point,node:QuadTreeNode = null):Boolean
		{
			if(!node) node = _root;
			if(node.rect.containsPoint(pos))
			{
				if(node.isLeaf)
				{
					node.data[obj.id] = obj;
					objMap[obj.id] = [node,obj];
					return true;
				}
				else
				{
					if(insertObject(obj,pos,node.UR)) return true;
					else if(insertObject(obj,pos,node.UL)) return true;
					else if(insertObject(obj,pos,node.LL))  return true;
					else if(insertObject(obj,pos,node.LR)) return true;
				}
			}
			return false;
		}
	}
}