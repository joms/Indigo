using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Untitled
{
	public class NewNodeSwitcher: INode
	{
		List<INode> _nodes = new List<INode>();
		[Primary]
		public List<INode> Nodes { get { return _nodes; } }

		public float CurrentNodeIndex { get; set; }

		public float2 ToAbsolute(float2 f)
		{
			return f;
		}

		public float2 FromAbsolute(float2 f)
		{
			return f;
		}

		INode _parent;
		public INode Parent { get { return _parent; } }

		public void OnAdded(INode parent) { _parent = parent; }
		public void OnRemoved(INode parent) { if (_parent == parent) _parent = null; }

		public INode CurrentNode
		{
			get
			{
				if (Nodes.Count == 0) return null;

				var nodeIndex = Math.Clamp((int)CurrentNodeIndex, 0, Nodes.Count-1);

				return Nodes[nodeIndex];
			}
		}

		public void Update()
		{
			if (CurrentNode != null) CurrentNode.Update();
		}

		public void FixedUpdate()
		{
			if (CurrentNode != null) CurrentNode.FixedUpdate();
		}

		public void Initialize()
		{
			for (int i =0; i< Nodes.Count; i++)
			{
				Nodes[i].Initialize();
			}
		}

		public void Draw()
		{
			if (CurrentNode != null) CurrentNode.Draw();
		}

		public void HitTest(HitTestArgs args)
		{
			if (CurrentNode != null) CurrentNode.HitTest(args);
		}

		public void RaiseEvent(SceneEventArgs args)
		{
			if (CurrentNode != null) CurrentNode.RaiseEvent(args);
		}

		public bool Traverse(Predicate<INode> visit)
		{
			if (visit != null && visit(this)) return true;

			if (CurrentNode != null)
				if (CurrentNode.Traverse(visit))
					return true;

			return false;
		}
	}
}