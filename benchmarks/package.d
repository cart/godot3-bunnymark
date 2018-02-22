module bunnymark;

import std.stdio;

import godot;
import godot.c;

public import bunnymark.v2;
public import bunnymark.v1.draw_texture;
public import bunnymark.v1.sprites;

// This is supposed to work with latest godot-d, but it doesn't work with Godot 3.0

mixin GodotNativeLibrary!
(
	"godot_", // same as the symbol_prefix in the GDNativeLibrary resource

	BunnymarkV2,
	BunnymarkV1DrawTexture,
	BunnymarkV1Sprites,

	(GodotInitOptions o){ writeln("Library initialized"); },
	(GodotTerminateOptions o){ writeln("Library terminated"); }
);