#include <core/Godot.hpp>
#include "benchmarks/BunnymarkV1Sprites/cpp/BunnymarkV1Sprites.cpp"
#include "benchmarks/BunnymarkV1DrawTexture/cpp/BunnymarkV1DrawTexture.cpp"
#include "benchmarks/BunnymarkV2/cpp/BunnymarkV2.cpp"

using namespace godot;

/** GDNative Initialize **/
extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o)
{
    Godot::gdnative_init(o);
}

/** GDNative Terminate **/
extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *o)
{
    Godot::gdnative_terminate(o);
}

/** NativeScript Initialize **/
extern "C" void GDN_EXPORT godot_nativescript_init(void *handle)
{
    Godot::nativescript_init(handle);

    register_class<BunnymarkV1Sprites>();
    register_class<BunnymarkV1DrawTexture>();
    register_class<BunnymarkV2>();
}