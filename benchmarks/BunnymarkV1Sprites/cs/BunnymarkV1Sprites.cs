using Godot;
using System;
using System.Collections.Generic;

public class BunnymarkV1Sprites : Node2D
{
    private struct Pair
    {
        public Sprite Sprite;
        public Vector2 Vector;
    }

    Pair[] bunnies = new Pair[1024];
    int count = 0;
    Vector2 screenSize;

    Texture bunnyTexture = (Texture)GD.Load("res://images/godot_bunny.png");
    Random random = new Random();
    int gravity = 500;

    public override void _Process(float delta)
    {
        screenSize = GetViewportRect().Size;

        for (int i = 0; i < count; i++)
        {
            ref var bunny = ref bunnies[i];
            var position = bunny.Sprite.Position;
            var newPosition = bunny.Vector;

            position.x += newPosition.x * delta;
            position.y += newPosition.y * delta;

            newPosition.y += gravity * delta;

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

            bunny.Sprite.Position = position;
            bunny.Vector = newPosition;
        }
    }

    public void add_bunny()
    {
        var bunny = new Sprite();
        bunny.SetTexture(bunnyTexture);
        AddChild(bunny);
        bunny.Position = new Vector2(screenSize.x / 2, screenSize.y / 2);

        if (count == bunnies.Length)
		{
			Array.Resize(ref bunnies, bunnies.Length * 2);
		}
		bunnies[count] = new Pair() { Sprite = bunny, Vector = new Vector2(random.Next() % 200 + 50, random.Next() % 200 + 50) };
		count++;
    }

    public void remove_bunny()
    {
        if (count == 0) {
			return;
		}

        count--;
        ref var bunny = bunnies[count]
        RemoveChild(bunny.Sprite);
        bunny.Sprite = null;
    }

    public void finish()
    {
        EmitSignal("benchmark_finished", count);
    }
}
