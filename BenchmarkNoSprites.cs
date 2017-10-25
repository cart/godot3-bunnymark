using Godot;
using System;
using System.Collections.Generic;

public class BenchmarkNoSprites : Node2D
{
	private class Pair
	{
		public Vector2 Current;
		public Vector2 Next;
	}

	[Export]
	Texture TBunny;
	List<Pair> bunnies = new List<Pair>();
	int grav = 500;
	float elapsed = 0.0f;
	Vector2 screenSize;
	Random random = new Random();

	public override void _Ready()
	{
		screenSize = GetViewportRect().Size;
		GetNode("../gui/list/add").Connect("pressed", this, "AddBunnies");

		for (var i = 0; i < 10; i++)
		{
			AddBunny();
		}
	}
	
	public override void _Draw()
	{
		for (var i = 0; i < bunnies.Count; i++)
			DrawTexture(TBunny, bunnies[i].Current);
	}
	
	public override void _Process(float delta)
	{
		elapsed = elapsed + delta;
		screenSize = GetViewportRect().Size;
		if (elapsed > 1)
		{
			((Label)GetNode("../gui/list/fps")).Text = $"FPS: {Engine.GetFramesPerSecond()}";
			elapsed = 0;
		}

		for (var i = 0; i < bunnies.Count; i++)
		{
			var bunny = bunnies[i];
			var position = bunny.Current;
			var newPosition = bunny.Next;

			position.x += newPosition.x * delta;
			position.y += newPosition.y * delta;

			newPosition.y += grav * delta;

			if (position.x > screenSize.x)
			{
				newPosition.x *= -1;
				position.x = screenSize.x;
			}

			if (position.x < 0)
			{
				newPosition.x *= -1;
				position.x = 0;
			}

			if (position.y > screenSize.y)
			{
				position.y = screenSize.y;
				if (random.NextDouble() > 0.5)
				{
					newPosition.y = (random.Next() % 1100 + 50);
				}
				else
				{
					newPosition.y *= -0.85f;
				}
			}

			if (position.y < 0)
			{
				newPosition.y = 0;
				position.y = 0;
			}
			
			bunny.Current = position;
			bunny.Next = newPosition;
		}
		Update();
	}

	public void AddBunny()
	{
		bunnies.Add(new Pair() { Current = new Vector2(screenSize.x / 2, screenSize.y / 2), Next = new Vector2(random.Next() % 200 + 50, random.Next() % 200 + 50) });
		((Label)GetNode("../gui/list/count")).Text = $"Bunny count: {bunnies.Count}";
	}

	public void AddBunnies()
	{
		for (var i = 0; i < 100; i++)
		{
			AddBunny();
		}
	}
}
