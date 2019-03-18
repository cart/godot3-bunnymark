use gdnative::*;

#[derive(NativeClass)]
#[inherit(Node2D)]
pub struct BunnymarkV2 {
    bunnies: Node2D
}

#[methods]
impl BunnymarkV2 {
    fn _init(_owner: Node2D) -> Self {
        BunnymarkV2 {
            bunnies: Node2D::new()
        }
    }

    #[export]
    unsafe fn _ready(&self, mut _owner: Node2D) {
        _owner.set_process(true);
        _owner.add_child(Some(self.bunnies.to_object()), true);
        godot_print!("hello, world.");
    }

    #[export]
    fn add_bunny(&self, _owner: Node2D) {
        // godot_print!("add bunny");
    }

    #[export]
    fn remove_bunny(&self, _owner: Node2D) {
        // godot_print!("add bunny");
    }
}

