export default class BunnymarkV2 extends godot.Node2D {
	private grav = 500;
	private bunny_texture = godot.ResourceLoader.load("res://images/godot_bunny.png") as godot.Texture;
	private bunny_speeds = [];
	private label = new godot.Label();
	private bunnies = new godot.Node2D();
	private screen_size: godot.Vector2 = null;

	_ready() {
		this.add_child(this.bunnies);
		this.label.rect_position = new godot.Vector2(0, 20);
		this.add_child(this.label);
	}
	
	_process(delta: number) {
		this.screen_size = this.get_viewport_rect().size;
		this.label.text = "Bunnies: " + this.bunnies.get_child_count();
		let bunny_children: godot.Node2D[] = this.bunnies.get_children();
		for (let i = 0; i < bunny_children.length; i++) {
			const bunny = bunny_children[i];
			let pos = bunny.position;
			let speed = this.bunny_speeds[i];
			pos.x += speed.x * delta;
			pos.y += speed.y * delta;
			speed.y += this.grav * delta;
			
			if (pos.x > this.screen_size.x) {
				speed.x *= -1;
				pos.x = this.screen_size.x;
			}
			
			if (pos.x < 0) {
				speed.x *= -1;
				pos.x = 0;
			}
				
			if (pos.y > this.screen_size.y) {
				pos.y = this.screen_size.y;
				if (Math.random() > 0.5)
					speed.y = -(godot.randi() % 1100 + 50);
				else
					speed.y *= -0.85;
			}
				
			if (pos.y < 0) {
				speed.y = 0
				pos.y = 0
			}
			
			bunny.position = pos;
			this.bunny_speeds[i] = speed;
		}
	}
	
	add_bunny() {
		let bunny = new godot.Sprite();
		bunny.set_texture(this.bunny_texture);
		this.bunnies.add_child(bunny);
		bunny.position = new godot.Vector2(this.screen_size.x / 2, this.screen_size.y / 2);
		this.bunny_speeds.push(new godot.Vector2(godot.randi() % 200 + 50, godot.randi() % 200 + 50));
	}
	
	remove_bunny() {
		let child_count = this.bunnies.get_child_count();
		if (child_count == 0)
			return
		let bunny = this.bunnies.get_child(child_count - 1);
		this.bunny_speeds.pop();
		this.bunnies.remove_child(bunny);
	}

	finish() {
		this.emit_signal("benchmark_finished", this.bunnies.get_child_count());
	}

}

godot.register_class(BunnymarkV2, "BunnymarkV2");
