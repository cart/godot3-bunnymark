module bunnymark.v2;

import std.random;
import std.stdio;
import std.conv;

import godot.c;
import godot, godot.core;
import godot.texture, godot.node2d, godot.label, godot.sprite;
import godot.resourceloader;

class BunnymarkV2 : GodotScript!Node2D
{
    alias owner this;
    @OnReady!((){return ResourceLoader.load("res://images/godot_bunny.png").as!(Ref!Texture);})
    Ref!Texture texture;

    @OnReady!((){return Label._new();})
    Label label;

    @OnReady!((){return Node2D._new();})
    Node2D bunnies;

    private {
        Vector2 screenSize;
        Vector2[] speeds;
        const float gravity = 500.0;
        const Color white = Color(1.,1.,1.,1.);
        const Texture nullTexture = Texture();
    }


    @Method
    void _ready()
    {
        this.addChild(bunnies);

        label.setPosition(Vector2(0,20));
        this.addChild(label);

        this.setProcess(true);
    }

    @Method
    void _process(float delta)
    {
        screenSize = getViewportRect().size;
        auto count = bunnies.getChildCount();
        label.setText(text("Bunnies: ", count));

        Array children = bunnies.getChildren();
        for (int i; i < children.size(); i++)
        {
            auto bunny = children[i].as!Sprite;
            Vector2 position = bunny.getPosition();
            Vector2 speed = speeds[i];

            position.x += speed.x * delta;
            position.y += speed.y * delta;

            speed.y += gravity * delta;

            if (position.x > screenSize.x)
            {
                speed.x *= -1;
                position.x = screenSize.x;
            }
            if (position.x < 0)
            {
                speed.x *= -1;
                position.x = 0;
            }

            if (position.y > screenSize.y)
            {
                position.y = screenSize.y;
                if (uniform(0, 100.0) > 50.0)
                    speed.y = uniform(50, 1150);
                else
                    speed.y *= -0.85f;
            }

            if (position.y < 0)
            {
                speed.y = 0;
                position.y = 0;
            }

            bunny.setPosition(position);
            speeds[i] = speed;
        }
    }

    @Method @Rename("add_bunny")
    void addBunny()
    {
        Sprite bunny = Sprite._new();
        bunny.setTexture(texture);
        bunnies.addChild(bunny);
        bunny.setPosition(Vector2(screenSize.x / 2.0, screenSize.y / 2.0));
        speeds ~= Vector2(uniform(50, 250), uniform(50,200));
    }

    @Method @Rename("remove_bunny")
    void removeBunny()
    {
        immutable long count = bunnies.getChildCount();
        if (count == 0)
            return;
        bunnies.removeChild(bunnies.getChild(count - 1));
        speeds.length--;
    }

    @Method
    void finish() {
        owner.emitSignal("benchmark_finished", bunnies.getChildCount());
    }
}