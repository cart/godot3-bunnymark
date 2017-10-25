#include <core/Godot.hpp>
#include "benchmarks/BunnymarkV1Sprites/cpp/BunnymarkV1Sprites.cpp"
#include "benchmarks/BunnymarkV1DrawTexture/cpp/BunnymarkV1DrawTexture.cpp"
#include "benchmarks/BunnymarkV2/cpp/BunnymarkV2.cpp"

using namespace godot;

/** GDNative Initialize **/
GDNATIVE_INIT(godot_gdnative_init_options *options) {
}
    
/** GDNative Terminate **/
GDNATIVE_TERMINATE(godot_gdnative_terminate_options *options) {
}
    
/** NativeScript Initialize **/
NATIVESCRIPT_INIT() {
    register_class<BunnymarkV1Sprites>();
    register_class<BunnymarkV1DrawTexture>();
    register_class<BunnymarkV2>();
}