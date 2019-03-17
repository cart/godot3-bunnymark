module bunnymark.v1.draw_texture;

import std.random;
import std.stdio;

import godot.c;
import godot, godot.core;
import godot.texture, godot.node2d;
import godot.resourceloader;

class BunnymarkV1DrawTexture : GodotScript!Node2D
{
    alias owner this;

    @OnReady!((){return ResourceLoader.load(gs!"res://images/godot_bunny.png").as!(Ref!Texture);})
    Ref!Texture texture;

    private {
        Vector2 screenSize;

        struct Pair {
            Vector2 position;
            Vector2 motion;
        }
        Pair[] bunnies;
        const float gravity = 500.0;
        const Color white = Color(1.,1.,1.,1.);
        Texture nullTexture = Texture();
    }

    @Method
    void _ready()
    {
        screenSize = getViewportRect().size;
        this.setProcess(true);
    }

    @Method
    void _draw()
    {
       for (int i = 0; i < bunnies.length; i++)
        {
            this.owner.drawTexture(texture, bunnies[i].position, white, nullTexture);
        }
    }

    @Method
    void _process(float delta)
    {
        for (int i; i < bunnies.length; i++)
        {

            Vector2 motion = bunnies[i].motion;
            Vector2 position = bunnies[i].position;

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

            bunnies[i].position = position;
            bunnies[i].motion = motion;
        }
        this.owner.update();
    }

    @Method
    void add_bunny()
    {
        bunnies ~= Pair(Vector2(screenSize.x / 2.0, screenSize.y / 2.0), Vector2(uniform(50, 250), uniform(50,200)));
    }

    @Method
    void remove_bunny()
    {
        if (bunnies.length == 0)
            return;
        bunnies.length--;
    }

    @Method
    void finish() {
        owner.emitSignal(gs!"benchmark_finished", bunnies.length);
    }
}