module bunnymark;

import std.stdio;

import godot;
import godot.c;

public import bunnymark.v2;
public import bunnymark.v1.draw_texture;
public import bunnymark.v1.sprites;

mixin GodotNativeLibrary!
(
    "godot_",
    BunnymarkV2,
    BunnymarkV1DrawTexture,
    BunnymarkV1Sprites,
);
