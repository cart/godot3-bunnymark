module bunnymark.v1.sprites;

import std.random;
import std.stdio;

import godot.c;
import godot, godot.core;
import godot.texture, godot.node2d, godot.sprite;
import godot.resourceloader;

class BunnymarkV1Sprites : GodotScript!Node2D
{
    alias owner this;

    @OnReady!((){return ResourceLoader.load(gs!"res://images/godot_bunny.png").as!(Ref!Texture);})
    Ref!Texture texture;

    private {
        Vector2 screenSize;
        struct Pair {
            Sprite sprite;
            Vector2 motion;
        }
        Pair[] bunnies;
        const float gravity = 500.0;
    }

    @Method
    void _ready()
    {
        screenSize = getViewportRect().size;
        this.setProcess(true);
    }

    @Method
    void _process(float delta)
    {
        screenSize = getViewportRect().size;
        for (int i; i < bunnies.length; i++)
        {

            Vector2 position = bunnies[i].sprite.getPosition();
            Vector2 motion = bunnies[i].motion;

            position.x += motion.x * delta;
            position.y += motion.y * delta;

            motion.y += gravity * delta;

            if (position.x > screenSize.x)
            {
                motion.x *= -1;
                position.x = screenSize.x;
            }
            if (position.x < 0)
            {
                motion.x *= -1;
                position.x = 0;
            }

            if (position.y > screenSize.y)
            {
                position.y = screenSize.y;
                if (uniform(0, 100.0) > 50.0)
                    motion.y = uniform(50, 1150);
                else
                    motion.y *= -0.85f;
            }

            if (position.y < 0)
            {
                motion.y = 0;
                position.y = 0;
            }

            bunnies[i].sprite.setPosition(position);
            bunnies[i].motion = motion;
        }
    }

    @Method
    public void add_bunny()
    {
        Sprite bunny = Sprite._new();
        bunny.setTexture(texture);
        this.addChild(bunny);
        bunny.setPosition(Vector2(screenSize.x / 2.0, screenSize.y / 2.0));
        bunnies ~= Pair(bunny, Vector2(uniform(50, 250), uniform(50,200)));
    }

    @Method
    void remove_bunny()
    {
        if (bunnies.length == 0)
            return;
        this.removeChild(bunnies[$ - 1].sprite);
        bunnies.length--;
    }

    @Method
    void finish() {
        owner.emitSignal(gs!"benchmark_finished", bunnies.length);
    }
}