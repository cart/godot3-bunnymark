use euclid;
use gdnative::*;
use rand;

#[derive(NativeClass)]
#[inherit(Node2D)]
pub struct BunnymarkV2 {
    bunnies: Node2D,
    bunny_speeds: Vec<Vector2>,
    bunny_texture: Texture,
    gravity: f32,
    screen_size: euclid::Size2D<f32>,
    label: Label,
}

#[methods]
impl BunnymarkV2 {
    fn _init(_owner: Node2D) -> Self {
        // NOTE: Direct load call crashes with "handle_crash: Program crashed with signal 11"
        let bunny_texture = unsafe {
            ResourceLoader::godot_singleton()
                /*.load("res://images/godot_bunny.png".into(), "".into(), false)
                .unwrap()
                .cast::<Texture>()
                .unwrap()*/
                .call(
                    "load".into(),
                    &[
                        "res://images/godot_bunny.png".into(),
                        "".into(),
                        false.into(),
                    ],
                )
                .try_to_object::<Texture>()
                .unwrap()
        };
        BunnymarkV2 {
            bunnies: Node2D::new(),
            bunny_speeds: vec![],
            bunny_texture,
            gravity: 500.,
            screen_size: euclid::size2(0., 0.),
            label: Label::new(),
        }
    }

    #[export]
    unsafe fn _ready(&mut self, mut owner: Node2D) {
        owner.set_process(true);
        owner.add_child(Some(self.bunnies.to_object()), false);

        self.label.set_position(Vector2::new(0., 20.));
        owner.add_child(Some(self.label.to_object()), false);
    }

    #[export]
    fn _process(&mut self, owner: Node2D, delta: f32) {
        unsafe {
            self.screen_size = owner.get_viewport_rect().size;
            self.label
                .set_text(format!("Bunnies: {}", self.bunnies.get_child_count()).into());
        }

        let mut bunny_children = unsafe { self.bunnies.get_children() };
        for i in 0..bunny_children.len() as usize {
            if let Some(mut bunny) = bunny_children
                .get_mut_ref(i as i32)
                .try_to_object::<Node2D>()
            {
                let mut position = unsafe { bunny.get_position() };
                let mut speed = self.bunny_speeds[i];

                position.x += speed.x * delta;
                position.y += speed.y * delta;

                speed.y += self.gravity * delta;

                if position.x > self.screen_size.width {
                    speed.x *= -1.;
                    position.x = self.screen_size.width;
                }
                if position.x < 0. {
                    speed.x *= -1.;
                    position.x = 0.;
                }

                if position.y > self.screen_size.height {
                    position.y = self.screen_size.height;
                    if rand::random::<f32>() > 0.5 {
                        speed.y = -((rand::random::<u32>() % 1100 + 50) as f32);
                    } else {
                        speed.y *= -0.85;
                    }
                }

                if position.y < 0. {
                    speed.y = 0.;
                    position.y = 0.;
                }

                unsafe { bunny.set_position(position) };
                self.bunny_speeds[i] = speed;
            }
        }
    }

    #[export]
    unsafe fn add_bunny(&mut self, _owner: Node2D) {
        let mut bunny = Sprite::new();
        bunny.set_texture(Some(self.bunny_texture.clone()));
        self.bunnies.add_child(Some(bunny.to_object()), false);
        bunny.set_position(Vector2::new(
            self.screen_size.width / 2.,
            self.screen_size.height / 2.,
        ));
        self.bunny_speeds.push(Vector2::new(
            (rand::random::<i32>() % 200 + 50) as f32,
            (rand::random::<i32>() % 200 + 50) as f32,
        ));
    }

    #[export]
    unsafe fn remove_bunny(&mut self, _owner: Node2D) {
        let child_count = self.bunnies.get_child_count();
        if child_count == 0 {
            return;
        };
        let bunny = self.bunnies.get_child(child_count - 1);
        if let Some(bunny) = bunny {
            self.bunnies.remove_child(Some(bunny.to_object()));
        }
        self.bunny_speeds.pop();
    }

    #[export]
    unsafe fn finish(&self, mut owner: Node2D) {
        owner.emit_signal(
            "benchmark_finished".into(),
            &[self.bunnies.get_child_count().into()],
        );
    }
}
