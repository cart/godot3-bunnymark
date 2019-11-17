class BunnymarkV2 extends godot.Node2D {
	grav = 500;
	bunny_speeds = [];
	bunnies = new godot.Node2D();
	screen_size = null;
	bunny_texture = godot.ResourceLoader.load("res://images/godot_bunny.png");
	
	constructor() {
		super();
	}

	_ready() {
		this.add_child(this.bunnies);
	}
	
	_process(delta) {
		this.screen_size = this.get_viewport_rect().size;
		let bunny_children = this.bunnies.get_children();
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
		bunny.free();
	}
	
	get_bunny_count() {
		return this.bunnies.get_child_count();
	}

	finish() {
		this.emit_signal("benchmark_finished", this.bunnies.get_child_count());
	}

};

godot.register_class(BunnymarkV2);