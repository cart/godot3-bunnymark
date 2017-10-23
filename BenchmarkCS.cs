using Godot;
using System;
using System.Collections.Generic;

public class BenchmarkCS : Node2D
{
    private class Pair
    {
        public Sprite Sprite;
        public Vector2 Vector;
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
            var position = bunny.Sprite.Position;
            var newPosition = bunny.Vector;

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

            bunny.Sprite.Position = position;
            bunny.Vector = newPosition;
        }
    }

    public void AddBunny()
    {
        var bunny = new Sprite();
        bunny.SetTexture(TBunny);
        AddChild(bunny);
        bunny.Position = new Vector2(screenSize.x / 2, screenSize.y / 2);
        bunnies.Add(new Pair() { Sprite = bunny, Vector = new Vector2(random.Next() % 200 + 50, random.Next() % 200 + 50) });
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
