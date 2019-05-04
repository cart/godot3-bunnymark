extern crate gdnative;

use gdnative::*;
pub mod bunnymarkv2;

// Function that registers all exposed classes to Godot
fn init(handle: gdnative::init::InitHandle) {
    handle.add_class::<bunnymarkv2::BunnymarkV2>();
}

// macros that create the entry-points of the dynamic library.
godot_gdnative_init!();
godot_nativescript_init!(init);
godot_gdnative_terminate!();
